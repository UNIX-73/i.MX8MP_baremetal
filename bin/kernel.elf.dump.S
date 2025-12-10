
bin/kernel.elf:     file format elf64-littleaarch64


Disassembly of section .text:

0000000040000000 <_start>:
    40000000:	d503201f 	nop
    40000004:	d5034fdf 	msr	daifset, #0xf
    40000008:	58000100 	ldr	x0, 40000028 <hang+0x8>
    4000000c:	9100001f 	mov	sp, x0
    40000010:	58000100 	ldr	x0, 40000030 <hang+0x10>
    40000014:	d51c4100 	msr	sp_el1, x0
    40000018:	940000a2 	bl	400002a0 <_clean_bss>
    4000001c:	9400015e 	bl	40000594 <kernel_entry>

0000000040000020 <hang>:
    40000020:	d503205f 	wfe
    40000024:	17ffffff 	b	40000020 <hang>
    40000028:	40a03000 	.inst	0x40a03000 ; undefined
    4000002c:	00000000 	udf	#0
    40000030:	40503000 	.inst	0x40503000 ; undefined
    40000034:	00000000 	udf	#0

0000000040000038 <_currentEL>:
    40000038:	d5384240 	mrs	x0, currentel
    4000003c:	d342fc00 	lsr	x0, x0, #2
    40000040:	d65f03c0 	ret
	...

0000000040000050 <_memcpy>:
    40000050:	aa0003e3 	mov	x3, x0
    40000054:	f100405f 	cmp	x2, #0x10
    40000058:	5400056b 	b.lt	40000104 <tail8>  // b.tstop
    4000005c:	f2400c04 	ands	x4, x0, #0xf
    40000060:	54000340 	b.eq	400000c8 <aligned>  // b.none
    40000064:	d2800205 	mov	x5, #0x10                  	// #16
    40000068:	cb0400a4 	sub	x4, x5, x4
    4000006c:	eb02009f 	cmp	x4, x2
    40000070:	9a848044 	csel	x4, x2, x4, hi	// hi = pmore
    40000074:	cb040042 	sub	x2, x2, x4

0000000040000078 <head8>:
    40000078:	f100209f 	cmp	x4, #0x8
    4000007c:	5400008b 	b.lt	4000008c <head4>  // b.tstop
    40000080:	f8408425 	ldr	x5, [x1], #8
    40000084:	f8008405 	str	x5, [x0], #8
    40000088:	d1002084 	sub	x4, x4, #0x8

000000004000008c <head4>:
    4000008c:	f100109f 	cmp	x4, #0x4
    40000090:	5400008b 	b.lt	400000a0 <head2>  // b.tstop

0000000040000094 <h4>:
    40000094:	f8404425 	ldr	x5, [x1], #4
    40000098:	f8004405 	str	x5, [x0], #4
    4000009c:	d1001084 	sub	x4, x4, #0x4

00000000400000a0 <head2>:
    400000a0:	f100089f 	cmp	x4, #0x2
    400000a4:	5400008b 	b.lt	400000b4 <head1>  // b.tstop

00000000400000a8 <h2>:
    400000a8:	78402425 	ldrh	w5, [x1], #2
    400000ac:	78002405 	strh	w5, [x0], #2
    400000b0:	d1000884 	sub	x4, x4, #0x2

00000000400000b4 <head1>:
    400000b4:	b40000a4 	cbz	x4, 400000c8 <aligned>

00000000400000b8 <h1>:
    400000b8:	38401425 	ldrb	w5, [x1], #1
    400000bc:	38001405 	strb	w5, [x0], #1
    400000c0:	d1000484 	sub	x4, x4, #0x1
    400000c4:	b5000464 	cbnz	x4, 40000150 <hang>

00000000400000c8 <aligned>:
    400000c8:	f2400c1f 	tst	x0, #0xf
    400000cc:	54000421 	b.ne	40000150 <hang>  // b.any
    400000d0:	f101005f 	cmp	x2, #0x40
    400000d4:	540000eb 	b.lt	400000f0 <tail32>  // b.tstop

00000000400000d8 <loop>:
    400000d8:	4cdf2020 	ld1	{v0.16b-v3.16b}, [x1], #64
    400000dc:	4c9f2000 	st1	{v0.16b-v3.16b}, [x0], #64
    400000e0:	d1010042 	sub	x2, x2, #0x40
    400000e4:	f101005f 	cmp	x2, #0x40
    400000e8:	54ffff8a 	b.ge	400000d8 <loop>  // b.tcont
    400000ec:	14000006 	b	40000104 <tail8>

00000000400000f0 <tail32>:
    400000f0:	f100805f 	cmp	x2, #0x20
    400000f4:	5400008b 	b.lt	40000104 <tail8>  // b.tstop
    400000f8:	4cdfa020 	ld1	{v0.16b-v1.16b}, [x1], #32
    400000fc:	4c9fa000 	st1	{v0.16b-v1.16b}, [x0], #32
    40000100:	d1008042 	sub	x2, x2, #0x20

0000000040000104 <tail8>:
    40000104:	f100205f 	cmp	x2, #0x8
    40000108:	540000cb 	b.lt	40000120 <tail4>  // b.tstop

000000004000010c <t8>:
    4000010c:	f8408424 	ldr	x4, [x1], #8
    40000110:	f8008404 	str	x4, [x0], #8
    40000114:	d1002042 	sub	x2, x2, #0x8
    40000118:	f100205f 	cmp	x2, #0x8
    4000011c:	54ffff8a 	b.ge	4000010c <t8>  // b.tcont

0000000040000120 <tail4>:
    40000120:	f100105f 	cmp	x2, #0x4
    40000124:	5400008b 	b.lt	40000134 <tail1>  // b.tstop

0000000040000128 <t4>:
    40000128:	b8404424 	ldr	w4, [x1], #4
    4000012c:	b8004404 	str	w4, [x0], #4
    40000130:	d1001042 	sub	x2, x2, #0x4

0000000040000134 <tail1>:
    40000134:	b40000a2 	cbz	x2, 40000148 <return>

0000000040000138 <t1>:
    40000138:	38401424 	ldrb	w4, [x1], #1
    4000013c:	38001404 	strb	w4, [x0], #1
    40000140:	f1000442 	subs	x2, x2, #0x1
    40000144:	54ffffa1 	b.ne	40000138 <t1>  // b.any

0000000040000148 <return>:
    40000148:	aa0303e0 	mov	x0, x3
    4000014c:	d65f03c0 	ret

0000000040000150 <hang>:
    40000150:	d503205f 	wfe
    40000154:	17ffffff 	b	40000150 <hang>
    40000158:	d503201f 	nop
    4000015c:	d503201f 	nop

0000000040000160 <_memcpy64>:
    40000160:	aa0003e3 	mov	x3, x0
    40000164:	f101005f 	cmp	x2, #0x40
    40000168:	540000cb 	b.lt	40000180 <return64>  // b.tstop

000000004000016c <loop64>:
    4000016c:	4cdf2020 	ld1	{v0.16b-v3.16b}, [x1], #64
    40000170:	4c9f2000 	st1	{v0.16b-v3.16b}, [x0], #64
    40000174:	d1010042 	sub	x2, x2, #0x40
    40000178:	f101005f 	cmp	x2, #0x40
    4000017c:	54ffff8a 	b.ge	4000016c <loop64>  // b.tcont

0000000040000180 <return64>:
    40000180:	aa0303e0 	mov	x0, x3
    40000184:	d65f03c0 	ret
    40000188:	d503201f 	nop
    4000018c:	d503201f 	nop

0000000040000190 <_memcpy32>:
    40000190:	aa0003e3 	mov	x3, x0
    40000194:	f100805f 	cmp	x2, #0x20
    40000198:	540000cb 	b.lt	400001b0 <return32>  // b.tstop

000000004000019c <loop32>:
    4000019c:	4cdfa020 	ld1	{v0.16b-v1.16b}, [x1], #32
    400001a0:	4c9fa000 	st1	{v0.16b-v1.16b}, [x0], #32
    400001a4:	d1008042 	sub	x2, x2, #0x20
    400001a8:	f100805f 	cmp	x2, #0x20
    400001ac:	54ffff8a 	b.ge	4000019c <loop32>  // b.tcont

00000000400001b0 <return32>:
    400001b0:	aa0303e0 	mov	x0, x3
    400001b4:	d65f03c0 	ret
    400001b8:	d503201f 	nop
    400001bc:	d503201f 	nop

00000000400001c0 <_memcpy16>:
    400001c0:	aa0003e3 	mov	x3, x0
    400001c4:	f100405f 	cmp	x2, #0x10
    400001c8:	540000cb 	b.lt	400001e0 <return16>  // b.tstop

00000000400001cc <loop16>:
    400001cc:	4cdf7020 	ld1	{v0.16b}, [x1], #16
    400001d0:	4c9f7000 	st1	{v0.16b}, [x0], #16
    400001d4:	d1004042 	sub	x2, x2, #0x10
    400001d8:	f100405f 	cmp	x2, #0x10
    400001dc:	54ffff8a 	b.ge	400001cc <loop16>  // b.tcont

00000000400001e0 <return16>:
    400001e0:	aa0303e0 	mov	x0, x3
    400001e4:	d65f03c0 	ret
    400001e8:	d503201f 	nop
    400001ec:	d503201f 	nop

00000000400001f0 <_memcpy8>:
    400001f0:	aa0003e3 	mov	x3, x0
    400001f4:	f100205f 	cmp	x2, #0x8
    400001f8:	540000cb 	b.lt	40000210 <return8>  // b.tstop

00000000400001fc <loop8>:
    400001fc:	f8408424 	ldr	x4, [x1], #8
    40000200:	f8008404 	str	x4, [x0], #8
    40000204:	d1002042 	sub	x2, x2, #0x8
    40000208:	f100205f 	cmp	x2, #0x8
    4000020c:	54ffff8a 	b.ge	400001fc <loop8>  // b.tcont

0000000040000210 <return8>:
    40000210:	aa0303e0 	mov	x0, x3
    40000214:	d65f03c0 	ret
    40000218:	d503201f 	nop
    4000021c:	d503201f 	nop

0000000040000220 <_memcpy4>:
    40000220:	aa0003e3 	mov	x3, x0
    40000224:	f100105f 	cmp	x2, #0x4
    40000228:	540000cb 	b.lt	40000240 <return4>  // b.tstop

000000004000022c <loop4>:
    4000022c:	b8404424 	ldr	w4, [x1], #4
    40000230:	b8004404 	str	w4, [x0], #4
    40000234:	d1001042 	sub	x2, x2, #0x4
    40000238:	f100105f 	cmp	x2, #0x4
    4000023c:	54ffff8a 	b.ge	4000022c <loop4>  // b.tcont

0000000040000240 <return4>:
    40000240:	aa0303e0 	mov	x0, x3
    40000244:	d65f03c0 	ret
    40000248:	d503201f 	nop
    4000024c:	d503201f 	nop

0000000040000250 <_memcpy2>:
    40000250:	aa0003e3 	mov	x3, x0
    40000254:	f100085f 	cmp	x2, #0x2
    40000258:	540000cb 	b.lt	40000270 <return2>  // b.tstop

000000004000025c <loop2>:
    4000025c:	78402424 	ldrh	w4, [x1], #2
    40000260:	78002404 	strh	w4, [x0], #2
    40000264:	d1000842 	sub	x2, x2, #0x2
    40000268:	f100085f 	cmp	x2, #0x2
    4000026c:	54ffff8a 	b.ge	4000025c <loop2>  // b.tcont

0000000040000270 <return2>:
    40000270:	aa0303e0 	mov	x0, x3
    40000274:	d65f03c0 	ret
    40000278:	d503201f 	nop
    4000027c:	d503201f 	nop

0000000040000280 <_memcpy1>:
    40000280:	aa0003e3 	mov	x3, x0
    40000284:	b40000a2 	cbz	x2, 40000298 <return1>

0000000040000288 <loop1>:
    40000288:	38401424 	ldrb	w4, [x1], #1
    4000028c:	38001404 	strb	w4, [x0], #1
    40000290:	f1000442 	subs	x2, x2, #0x1
    40000294:	54ffffa1 	b.ne	40000288 <loop1>  // b.any

0000000040000298 <return1>:
    40000298:	aa0303e0 	mov	x0, x3
    4000029c:	d65f03c0 	ret

00000000400002a0 <_clean_bss>:
    400002a0:	58000240 	ldr	x0, 400002e8 <hang+0xc>
    400002a4:	58000261 	ldr	x1, 400002f0 <hang+0x14>
    400002a8:	4f00e400 	movi	v0.16b, #0x0
    400002ac:	4f00e401 	movi	v1.16b, #0x0
    400002b0:	4f00e402 	movi	v2.16b, #0x0
    400002b4:	4f00e403 	movi	v3.16b, #0x0
    400002b8:	f240141f 	tst	x0, #0x3f
    400002bc:	54000101 	b.ne	400002dc <hang>  // b.any
    400002c0:	f240143f 	tst	x1, #0x3f
    400002c4:	540000c1 	b.ne	400002dc <hang>  // b.any
    400002c8:	eb01001f 	cmp	x0, x1
    400002cc:	5400006a 	b.ge	400002d8 <_clean_bss+0x38>  // b.tcont
    400002d0:	4c9f2000 	st1	{v0.16b-v3.16b}, [x0], #64
    400002d4:	17fffffd 	b	400002c8 <_clean_bss+0x28>
    400002d8:	d65f03c0 	ret

00000000400002dc <hang>:
    400002dc:	d503205f 	wfe
    400002e0:	17ffffff 	b	400002dc <hang>
    400002e4:	00000000 	udf	#0
    400002e8:	400019c0 	.inst	0x400019c0 ; undefined
    400002ec:	00000000 	udf	#0
    400002f0:	40002e00 	.inst	0x40002e00 ; undefined
    400002f4:	00000000 	udf	#0

00000000400002f8 <init_panic>:
    400002f8:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    400002fc:	910003fd 	mov	x29, sp
    40000300:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000304:	91270000 	add	x0, x0, #0x9c0
    40000308:	d2820001 	mov	x1, #0x1000                	// #4096
    4000030c:	f9000001 	str	x1, [x0]
    40000310:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000314:	91272000 	add	x0, x0, #0x9c8
    40000318:	d2808001 	mov	x1, #0x400                 	// #1024
    4000031c:	f9000001 	str	x1, [x0]
    40000320:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000324:	91274000 	add	x0, x0, #0x9d0
    40000328:	b0000001 	adrp	x1, 40001000 <UART_UCR1_write+0x4>
    4000032c:	9127a021 	add	x1, x1, #0x9e8
    40000330:	f9000001 	str	x1, [x0]
    40000334:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000338:	91276000 	add	x0, x0, #0x9d8
    4000033c:	d0000001 	adrp	x1, 40002000 <panic_message_buffer+0x618>
    40000340:	9127a021 	add	x1, x1, #0x9e8
    40000344:	f9000001 	str	x1, [x0]
    40000348:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    4000034c:	91278000 	add	x0, x0, #0x9e0
    40000350:	b900001f 	str	wzr, [x0]
    40000354:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000358:	91279000 	add	x0, x0, #0x9e4
    4000035c:	b900001f 	str	wzr, [x0]
    40000360:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000364:	91274000 	add	x0, x0, #0x9d0
    40000368:	f9400003 	ldr	x3, [x0]
    4000036c:	d2820002 	mov	x2, #0x1000                	// #4096
    40000370:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000374:	911b0001 	add	x1, x0, #0x6c0
    40000378:	aa0303e0 	mov	x0, x3
    4000037c:	9400008b 	bl	400005a8 <strcopy>
    40000380:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000384:	91276000 	add	x0, x0, #0x9d8
    40000388:	f9400003 	ldr	x3, [x0]
    4000038c:	d2808002 	mov	x2, #0x400                 	// #1024
    40000390:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000394:	911c6001 	add	x1, x0, #0x718
    40000398:	aa0303e0 	mov	x0, x3
    4000039c:	94000083 	bl	400005a8 <strcopy>
    400003a0:	d503201f 	nop
    400003a4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    400003a8:	d65f03c0 	ret

00000000400003ac <panic>:
    400003ac:	a9b27bfd 	stp	x29, x30, [sp, #-224]!
    400003b0:	910003fd 	mov	x29, sp
    400003b4:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400003b8:	911cc001 	add	x1, x0, #0x730
    400003bc:	52800020 	mov	w0, #0x1                   	// #1
    400003c0:	94000430 	bl	40001480 <UART_puts>
    400003c4:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400003c8:	91276000 	add	x0, x0, #0x9d8
    400003cc:	f9400000 	ldr	x0, [x0]
    400003d0:	aa0003e1 	mov	x1, x0
    400003d4:	52800020 	mov	w0, #0x1                   	// #1
    400003d8:	9400042a 	bl	40001480 <UART_puts>
    400003dc:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400003e0:	911d4001 	add	x1, x0, #0x750
    400003e4:	52800020 	mov	w0, #0x1                   	// #1
    400003e8:	94000426 	bl	40001480 <UART_puts>
    400003ec:	d2800000 	mov	x0, #0x0                   	// #0
    400003f0:	b0000001 	adrp	x1, 40001000 <UART_UCR1_write+0x4>
    400003f4:	91278021 	add	x1, x1, #0x9e0
    400003f8:	b9400021 	ldr	w1, [x1]
    400003fc:	b3407c20 	bfxil	x0, x1, #0, #32
    40000400:	910063e1 	add	x1, sp, #0x18
    40000404:	52800144 	mov	w4, #0xa                   	// #10
    40000408:	d2801903 	mov	x3, #0xc8                  	// #200
    4000040c:	aa0103e2 	mov	x2, x1
    40000410:	528000a1 	mov	w1, #0x5                   	// #5
    40000414:	940000a6 	bl	400006ac <stdint_to_ascii>
    40000418:	aa0003e1 	mov	x1, x0
    4000041c:	52800020 	mov	w0, #0x1                   	// #1
    40000420:	94000418 	bl	40001480 <UART_puts>
    40000424:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000428:	91279000 	add	x0, x0, #0x9e4
    4000042c:	b9400000 	ldr	w0, [x0]
    40000430:	7100001f 	cmp	w0, #0x0
    40000434:	54000260 	b.eq	40000480 <panic+0xd4>  // b.none
    40000438:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    4000043c:	911d8001 	add	x1, x0, #0x760
    40000440:	52800020 	mov	w0, #0x1                   	// #1
    40000444:	9400040f 	bl	40001480 <UART_puts>
    40000448:	d2800000 	mov	x0, #0x0                   	// #0
    4000044c:	b0000001 	adrp	x1, 40001000 <UART_UCR1_write+0x4>
    40000450:	91279021 	add	x1, x1, #0x9e4
    40000454:	b9400021 	ldr	w1, [x1]
    40000458:	b3407c20 	bfxil	x0, x1, #0, #32
    4000045c:	910063e1 	add	x1, sp, #0x18
    40000460:	52800144 	mov	w4, #0xa                   	// #10
    40000464:	d2801903 	mov	x3, #0xc8                  	// #200
    40000468:	aa0103e2 	mov	x2, x1
    4000046c:	528000a1 	mov	w1, #0x5                   	// #5
    40000470:	9400008f 	bl	400006ac <stdint_to_ascii>
    40000474:	aa0003e1 	mov	x1, x0
    40000478:	52800020 	mov	w0, #0x1                   	// #1
    4000047c:	94000401 	bl	40001480 <UART_puts>
    40000480:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000484:	911da001 	add	x1, x0, #0x768
    40000488:	52800020 	mov	w0, #0x1                   	// #1
    4000048c:	940003fd 	bl	40001480 <UART_puts>
    40000490:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000494:	91274000 	add	x0, x0, #0x9d0
    40000498:	f9400000 	ldr	x0, [x0]
    4000049c:	aa0003e1 	mov	x1, x0
    400004a0:	52800020 	mov	w0, #0x1                   	// #1
    400004a4:	940003f7 	bl	40001480 <UART_puts>
    400004a8:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400004ac:	911e0001 	add	x1, x0, #0x780
    400004b0:	52800020 	mov	w0, #0x1                   	// #1
    400004b4:	940003f3 	bl	40001480 <UART_puts>
    400004b8:	d503201f 	nop
    400004bc:	17ffffff 	b	400004b8 <panic+0x10c>

00000000400004c0 <set_panic>:
    400004c0:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    400004c4:	910003fd 	mov	x29, sp
    400004c8:	f9000bf3 	str	x19, [sp, #16]
    400004cc:	aa0003f3 	mov	x19, x0
    400004d0:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400004d4:	91274000 	add	x0, x0, #0x9d0
    400004d8:	f9400000 	ldr	x0, [x0]
    400004dc:	f9400261 	ldr	x1, [x19]
    400004e0:	d2820002 	mov	x2, #0x1000                	// #4096
    400004e4:	94000031 	bl	400005a8 <strcopy>
    400004e8:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400004ec:	91276000 	add	x0, x0, #0x9d8
    400004f0:	f9400000 	ldr	x0, [x0]
    400004f4:	f9400661 	ldr	x1, [x19, #8]
    400004f8:	d2808002 	mov	x2, #0x400                 	// #1024
    400004fc:	9400002b 	bl	400005a8 <strcopy>
    40000500:	b9401261 	ldr	w1, [x19, #16]
    40000504:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000508:	91278000 	add	x0, x0, #0x9e0
    4000050c:	b9000001 	str	w1, [x0]
    40000510:	b9401661 	ldr	w1, [x19, #20]
    40000514:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000518:	91279000 	add	x0, x0, #0x9e4
    4000051c:	b9000001 	str	w1, [x0]
    40000520:	d503201f 	nop
    40000524:	f9400bf3 	ldr	x19, [sp, #16]
    40000528:	a8c27bfd 	ldp	x29, x30, [sp], #32
    4000052c:	d65f03c0 	ret

0000000040000530 <set_and_throw_panic>:
    40000530:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    40000534:	910003fd 	mov	x29, sp
    40000538:	f9000bf3 	str	x19, [sp, #16]
    4000053c:	aa0003f3 	mov	x19, x0
    40000540:	910083e2 	add	x2, sp, #0x20
    40000544:	aa1303e3 	mov	x3, x19
    40000548:	a9400460 	ldp	x0, x1, [x3]
    4000054c:	f9400863 	ldr	x3, [x3, #16]
    40000550:	a9000440 	stp	x0, x1, [x2]
    40000554:	f9000843 	str	x3, [x2, #16]
    40000558:	910083e0 	add	x0, sp, #0x20
    4000055c:	97ffffd9 	bl	400004c0 <set_panic>
    40000560:	97ffff93 	bl	400003ac <panic>
    40000564:	d503201f 	nop
    40000568:	f9400bf3 	ldr	x19, [sp, #16]
    4000056c:	a8c47bfd 	ldp	x29, x30, [sp], #64
    40000570:	d65f03c0 	ret

0000000040000574 <kernel_init>:
    40000574:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    40000578:	910003fd 	mov	x29, sp
    4000057c:	97ffff5f 	bl	400002f8 <init_panic>
    40000580:	52800020 	mov	w0, #0x1                   	// #1
    40000584:	940003f9 	bl	40001568 <UART_init>
    40000588:	d503201f 	nop
    4000058c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    40000590:	d65f03c0 	ret

0000000040000594 <kernel_entry>:
    40000594:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    40000598:	910003fd 	mov	x29, sp
    4000059c:	97fffff6 	bl	40000574 <kernel_init>
    400005a0:	d503201f 	nop
    400005a4:	17ffffff 	b	400005a0 <kernel_entry+0xc>

00000000400005a8 <strcopy>:
    400005a8:	d100c3ff 	sub	sp, sp, #0x30
    400005ac:	f9000fe0 	str	x0, [sp, #24]
    400005b0:	f9000be1 	str	x1, [sp, #16]
    400005b4:	f90007e2 	str	x2, [sp, #8]
    400005b8:	f90017ff 	str	xzr, [sp, #40]
    400005bc:	14000012 	b	40000604 <strcopy+0x5c>
    400005c0:	f9400be1 	ldr	x1, [sp, #16]
    400005c4:	f94017e0 	ldr	x0, [sp, #40]
    400005c8:	8b000021 	add	x1, x1, x0
    400005cc:	f9400fe2 	ldr	x2, [sp, #24]
    400005d0:	f94017e0 	ldr	x0, [sp, #40]
    400005d4:	8b000040 	add	x0, x2, x0
    400005d8:	39400021 	ldrb	w1, [x1]
    400005dc:	39000001 	strb	w1, [x0]
    400005e0:	f9400be1 	ldr	x1, [sp, #16]
    400005e4:	f94017e0 	ldr	x0, [sp, #40]
    400005e8:	8b000020 	add	x0, x1, x0
    400005ec:	39400000 	ldrb	w0, [x0]
    400005f0:	7100001f 	cmp	w0, #0x0
    400005f4:	540001e0 	b.eq	40000630 <strcopy+0x88>  // b.none
    400005f8:	f94017e0 	ldr	x0, [sp, #40]
    400005fc:	91000400 	add	x0, x0, #0x1
    40000600:	f90017e0 	str	x0, [sp, #40]
    40000604:	f94007e0 	ldr	x0, [sp, #8]
    40000608:	d1000400 	sub	x0, x0, #0x1
    4000060c:	f94017e1 	ldr	x1, [sp, #40]
    40000610:	eb00003f 	cmp	x1, x0
    40000614:	54fffd63 	b.cc	400005c0 <strcopy+0x18>  // b.lo, b.ul, b.last
    40000618:	f94007e0 	ldr	x0, [sp, #8]
    4000061c:	d1000400 	sub	x0, x0, #0x1
    40000620:	f9400fe1 	ldr	x1, [sp, #24]
    40000624:	8b000020 	add	x0, x1, x0
    40000628:	3900001f 	strb	wzr, [x0]
    4000062c:	14000002 	b	40000634 <strcopy+0x8c>
    40000630:	d503201f 	nop
    40000634:	9100c3ff 	add	sp, sp, #0x30
    40000638:	d65f03c0 	ret

000000004000063c <uint8_to_ascii_char>:
    4000063c:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    40000640:	910003fd 	mov	x29, sp
    40000644:	3900ffe0 	strb	w0, [sp, #63]
    40000648:	3940ffe0 	ldrb	w0, [sp, #63]
    4000064c:	7100241f 	cmp	w0, #0x9
    40000650:	54000249 	b.ls	40000698 <uint8_to_ascii_char+0x5c>  // b.plast
    40000654:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000658:	911e2000 	add	x0, x0, #0x788
    4000065c:	f90027e0 	str	x0, [sp, #72]
    40000660:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000664:	911f4000 	add	x0, x0, #0x7d0
    40000668:	f9002be0 	str	x0, [sp, #80]
    4000066c:	52800280 	mov	w0, #0x14                  	// #20
    40000670:	b9005be0 	str	w0, [sp, #88]
    40000674:	b9005fff 	str	wzr, [sp, #92]
    40000678:	910043e2 	add	x2, sp, #0x10
    4000067c:	910123e3 	add	x3, sp, #0x48
    40000680:	a9400460 	ldp	x0, x1, [x3]
    40000684:	f9400863 	ldr	x3, [x3, #16]
    40000688:	a9000440 	stp	x0, x1, [x2]
    4000068c:	f9000843 	str	x3, [x2, #16]
    40000690:	910043e0 	add	x0, sp, #0x10
    40000694:	97ffffa7 	bl	40000530 <set_and_throw_panic>
    40000698:	3940ffe0 	ldrb	w0, [sp, #63]
    4000069c:	1100c000 	add	w0, w0, #0x30
    400006a0:	12001c00 	and	w0, w0, #0xff
    400006a4:	a8c67bfd 	ldp	x29, x30, [sp], #96
    400006a8:	d65f03c0 	ret

00000000400006ac <stdint_to_ascii>:
    400006ac:	a9b17bfd 	stp	x29, x30, [sp, #-240]!
    400006b0:	910003fd 	mov	x29, sp
    400006b4:	f90027e0 	str	x0, [sp, #72]
    400006b8:	b90047e1 	str	w1, [sp, #68]
    400006bc:	f9001fe2 	str	x2, [sp, #56]
    400006c0:	f9001be3 	str	x3, [sp, #48]
    400006c4:	b90043e4 	str	w4, [sp, #64]
    400006c8:	f90077ff 	str	xzr, [sp, #232]
    400006cc:	b94043e0 	ldr	w0, [sp, #64]
    400006d0:	7100401f 	cmp	w0, #0x10
    400006d4:	54000220 	b.eq	40000718 <stdint_to_ascii+0x6c>  // b.none
    400006d8:	b94043e0 	ldr	w0, [sp, #64]
    400006dc:	7100401f 	cmp	w0, #0x10
    400006e0:	540002e8 	b.hi	4000073c <stdint_to_ascii+0x90>  // b.pmore
    400006e4:	b94043e0 	ldr	w0, [sp, #64]
    400006e8:	7100281f 	cmp	w0, #0xa
    400006ec:	540004c0 	b.eq	40000784 <stdint_to_ascii+0xd8>  // b.none
    400006f0:	b94043e0 	ldr	w0, [sp, #64]
    400006f4:	7100281f 	cmp	w0, #0xa
    400006f8:	54000228 	b.hi	4000073c <stdint_to_ascii+0x90>  // b.pmore
    400006fc:	b94043e0 	ldr	w0, [sp, #64]
    40000700:	7100081f 	cmp	w0, #0x2
    40000704:	54000100 	b.eq	40000724 <stdint_to_ascii+0x78>  // b.none
    40000708:	b94043e0 	ldr	w0, [sp, #64]
    4000070c:	7100201f 	cmp	w0, #0x8
    40000710:	54000100 	b.eq	40000730 <stdint_to_ascii+0x84>  // b.none
    40000714:	1400000a 	b	4000073c <stdint_to_ascii+0x90>
    40000718:	d2800040 	mov	x0, #0x2                   	// #2
    4000071c:	f90077e0 	str	x0, [sp, #232]
    40000720:	14000019 	b	40000784 <stdint_to_ascii+0xd8>
    40000724:	d2800040 	mov	x0, #0x2                   	// #2
    40000728:	f90077e0 	str	x0, [sp, #232]
    4000072c:	14000016 	b	40000784 <stdint_to_ascii+0xd8>
    40000730:	d2800020 	mov	x0, #0x1                   	// #1
    40000734:	f90077e0 	str	x0, [sp, #232]
    40000738:	14000013 	b	40000784 <stdint_to_ascii+0xd8>
    4000073c:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000740:	911fe000 	add	x0, x0, #0x7f8
    40000744:	f90037e0 	str	x0, [sp, #104]
    40000748:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    4000074c:	911f4000 	add	x0, x0, #0x7d0
    40000750:	f9003be0 	str	x0, [sp, #112]
    40000754:	52800640 	mov	w0, #0x32                  	// #50
    40000758:	b9007be0 	str	w0, [sp, #120]
    4000075c:	b9007fff 	str	wzr, [sp, #124]
    40000760:	910043e2 	add	x2, sp, #0x10
    40000764:	9101a3e3 	add	x3, sp, #0x68
    40000768:	a9400460 	ldp	x0, x1, [x3]
    4000076c:	f9400863 	ldr	x3, [x3, #16]
    40000770:	a9000440 	stp	x0, x1, [x2]
    40000774:	f9000843 	str	x3, [x2, #16]
    40000778:	910043e0 	add	x0, sp, #0x10
    4000077c:	97ffff6d 	bl	40000530 <set_and_throw_panic>
    40000780:	14000001 	b	40000784 <stdint_to_ascii+0xd8>
    40000784:	f9006fff 	str	xzr, [sp, #216]
    40000788:	f9006bff 	str	xzr, [sp, #208]
    4000078c:	b94047e0 	ldr	w0, [sp, #68]
    40000790:	71001c1f 	cmp	w0, #0x7
    40000794:	540009e0 	b.eq	400008d0 <stdint_to_ascii+0x224>  // b.none
    40000798:	b94047e0 	ldr	w0, [sp, #68]
    4000079c:	71001c1f 	cmp	w0, #0x7
    400007a0:	54000a08 	b.hi	400008e0 <stdint_to_ascii+0x234>  // b.pmore
    400007a4:	b94047e0 	ldr	w0, [sp, #68]
    400007a8:	7100181f 	cmp	w0, #0x6
    400007ac:	54000880 	b.eq	400008bc <stdint_to_ascii+0x210>  // b.none
    400007b0:	b94047e0 	ldr	w0, [sp, #68]
    400007b4:	7100181f 	cmp	w0, #0x6
    400007b8:	54000948 	b.hi	400008e0 <stdint_to_ascii+0x234>  // b.pmore
    400007bc:	b94047e0 	ldr	w0, [sp, #68]
    400007c0:	7100141f 	cmp	w0, #0x5
    400007c4:	54000720 	b.eq	400008a8 <stdint_to_ascii+0x1fc>  // b.none
    400007c8:	b94047e0 	ldr	w0, [sp, #68]
    400007cc:	7100141f 	cmp	w0, #0x5
    400007d0:	54000888 	b.hi	400008e0 <stdint_to_ascii+0x234>  // b.pmore
    400007d4:	b94047e0 	ldr	w0, [sp, #68]
    400007d8:	7100101f 	cmp	w0, #0x4
    400007dc:	540005a0 	b.eq	40000890 <stdint_to_ascii+0x1e4>  // b.none
    400007e0:	b94047e0 	ldr	w0, [sp, #68]
    400007e4:	7100101f 	cmp	w0, #0x4
    400007e8:	540007c8 	b.hi	400008e0 <stdint_to_ascii+0x234>  // b.pmore
    400007ec:	b94047e0 	ldr	w0, [sp, #68]
    400007f0:	71000c1f 	cmp	w0, #0x3
    400007f4:	54000440 	b.eq	4000087c <stdint_to_ascii+0x1d0>  // b.none
    400007f8:	b94047e0 	ldr	w0, [sp, #68]
    400007fc:	71000c1f 	cmp	w0, #0x3
    40000800:	54000708 	b.hi	400008e0 <stdint_to_ascii+0x234>  // b.pmore
    40000804:	b94047e0 	ldr	w0, [sp, #68]
    40000808:	7100081f 	cmp	w0, #0x2
    4000080c:	540002c0 	b.eq	40000864 <stdint_to_ascii+0x1b8>  // b.none
    40000810:	b94047e0 	ldr	w0, [sp, #68]
    40000814:	7100081f 	cmp	w0, #0x2
    40000818:	54000648 	b.hi	400008e0 <stdint_to_ascii+0x234>  // b.pmore
    4000081c:	b94047e0 	ldr	w0, [sp, #68]
    40000820:	7100001f 	cmp	w0, #0x0
    40000824:	540000a0 	b.eq	40000838 <stdint_to_ascii+0x18c>  // b.none
    40000828:	b94047e0 	ldr	w0, [sp, #68]
    4000082c:	7100041f 	cmp	w0, #0x1
    40000830:	54000100 	b.eq	40000850 <stdint_to_ascii+0x1a4>  // b.none
    40000834:	1400002b 	b	400008e0 <stdint_to_ascii+0x234>
    40000838:	39c123e0 	ldrsb	w0, [sp, #72]
    4000083c:	93401c00 	sxtb	x0, w0
    40000840:	f9006fe0 	str	x0, [sp, #216]
    40000844:	52800020 	mov	w0, #0x1                   	// #1
    40000848:	39039fe0 	strb	w0, [sp, #231]
    4000084c:	14000037 	b	40000928 <stdint_to_ascii+0x27c>
    40000850:	394123e0 	ldrb	w0, [sp, #72]
    40000854:	92401c00 	and	x0, x0, #0xff
    40000858:	f9006be0 	str	x0, [sp, #208]
    4000085c:	39039fff 	strb	wzr, [sp, #231]
    40000860:	14000032 	b	40000928 <stdint_to_ascii+0x27c>
    40000864:	79c093e0 	ldrsh	w0, [sp, #72]
    40000868:	93403c00 	sxth	x0, w0
    4000086c:	f9006fe0 	str	x0, [sp, #216]
    40000870:	52800020 	mov	w0, #0x1                   	// #1
    40000874:	39039fe0 	strb	w0, [sp, #231]
    40000878:	1400002c 	b	40000928 <stdint_to_ascii+0x27c>
    4000087c:	794093e0 	ldrh	w0, [sp, #72]
    40000880:	92403c00 	and	x0, x0, #0xffff
    40000884:	f9006be0 	str	x0, [sp, #208]
    40000888:	39039fff 	strb	wzr, [sp, #231]
    4000088c:	14000027 	b	40000928 <stdint_to_ascii+0x27c>
    40000890:	b9404be0 	ldr	w0, [sp, #72]
    40000894:	93407c00 	sxtw	x0, w0
    40000898:	f9006fe0 	str	x0, [sp, #216]
    4000089c:	52800020 	mov	w0, #0x1                   	// #1
    400008a0:	39039fe0 	strb	w0, [sp, #231]
    400008a4:	14000021 	b	40000928 <stdint_to_ascii+0x27c>
    400008a8:	b9404be0 	ldr	w0, [sp, #72]
    400008ac:	2a0003e0 	mov	w0, w0
    400008b0:	f9006be0 	str	x0, [sp, #208]
    400008b4:	39039fff 	strb	wzr, [sp, #231]
    400008b8:	1400001c 	b	40000928 <stdint_to_ascii+0x27c>
    400008bc:	f94027e0 	ldr	x0, [sp, #72]
    400008c0:	f9006fe0 	str	x0, [sp, #216]
    400008c4:	52800020 	mov	w0, #0x1                   	// #1
    400008c8:	39039fe0 	strb	w0, [sp, #231]
    400008cc:	14000017 	b	40000928 <stdint_to_ascii+0x27c>
    400008d0:	f94027e0 	ldr	x0, [sp, #72]
    400008d4:	f9006be0 	str	x0, [sp, #208]
    400008d8:	39039fff 	strb	wzr, [sp, #231]
    400008dc:	14000013 	b	40000928 <stdint_to_ascii+0x27c>
    400008e0:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400008e4:	91206000 	add	x0, x0, #0x818
    400008e8:	f9002be0 	str	x0, [sp, #80]
    400008ec:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400008f0:	911f4000 	add	x0, x0, #0x7d0
    400008f4:	f9002fe0 	str	x0, [sp, #88]
    400008f8:	52800b60 	mov	w0, #0x5b                  	// #91
    400008fc:	b90063e0 	str	w0, [sp, #96]
    40000900:	b90067ff 	str	wzr, [sp, #100]
    40000904:	910043e2 	add	x2, sp, #0x10
    40000908:	910143e3 	add	x3, sp, #0x50
    4000090c:	a9400460 	ldp	x0, x1, [x3]
    40000910:	f9400863 	ldr	x3, [x3, #16]
    40000914:	a9000440 	stp	x0, x1, [x2]
    40000918:	f9000843 	str	x3, [x2, #16]
    4000091c:	910043e0 	add	x0, sp, #0x10
    40000920:	97ffff04 	bl	40000530 <set_and_throw_panic>
    40000924:	14000001 	b	40000928 <stdint_to_ascii+0x27c>
    40000928:	39031fff 	strb	wzr, [sp, #199]
    4000092c:	39439fe0 	ldrb	w0, [sp, #231]
    40000930:	12000000 	and	w0, w0, #0x1
    40000934:	7100001f 	cmp	w0, #0x0
    40000938:	540001a0 	b.eq	4000096c <stdint_to_ascii+0x2c0>  // b.none
    4000093c:	f9406fe0 	ldr	x0, [sp, #216]
    40000940:	f100001f 	cmp	x0, #0x0
    40000944:	540000ea 	b.ge	40000960 <stdint_to_ascii+0x2b4>  // b.tcont
    40000948:	52800020 	mov	w0, #0x1                   	// #1
    4000094c:	39031fe0 	strb	w0, [sp, #199]
    40000950:	f9406fe0 	ldr	x0, [sp, #216]
    40000954:	cb0003e0 	neg	x0, x0
    40000958:	f90067e0 	str	x0, [sp, #200]
    4000095c:	14000006 	b	40000974 <stdint_to_ascii+0x2c8>
    40000960:	f9406fe0 	ldr	x0, [sp, #216]
    40000964:	f90067e0 	str	x0, [sp, #200]
    40000968:	14000003 	b	40000974 <stdint_to_ascii+0x2c8>
    4000096c:	f9406be0 	ldr	x0, [sp, #208]
    40000970:	f90067e0 	str	x0, [sp, #200]
    40000974:	f94067e0 	ldr	x0, [sp, #200]
    40000978:	f100001f 	cmp	x0, #0x0
    4000097c:	54000b41 	b.ne	40000ae4 <stdint_to_ascii+0x438>  // b.any
    40000980:	39431fe0 	ldrb	w0, [sp, #199]
    40000984:	52000000 	eor	w0, w0, #0x1
    40000988:	12001c00 	and	w0, w0, #0xff
    4000098c:	12000000 	and	w0, w0, #0x1
    40000990:	7100001f 	cmp	w0, #0x0
    40000994:	54000a80 	b.eq	40000ae4 <stdint_to_ascii+0x438>  // b.none
    40000998:	f94077e0 	ldr	x0, [sp, #232]
    4000099c:	91000800 	add	x0, x0, #0x2
    400009a0:	f9401be1 	ldr	x1, [sp, #48]
    400009a4:	eb00003f 	cmp	x1, x0
    400009a8:	54001bc3 	b.cc	40000d20 <stdint_to_ascii+0x674>  // b.lo, b.ul, b.last
    400009ac:	f9005fff 	str	xzr, [sp, #184]
    400009b0:	b94043e0 	ldr	w0, [sp, #64]
    400009b4:	7100401f 	cmp	w0, #0x10
    400009b8:	54000220 	b.eq	400009fc <stdint_to_ascii+0x350>  // b.none
    400009bc:	b94043e0 	ldr	w0, [sp, #64]
    400009c0:	7100401f 	cmp	w0, #0x10
    400009c4:	54000748 	b.hi	40000aac <stdint_to_ascii+0x400>  // b.pmore
    400009c8:	b94043e0 	ldr	w0, [sp, #64]
    400009cc:	7100281f 	cmp	w0, #0xa
    400009d0:	540006c0 	b.eq	40000aa8 <stdint_to_ascii+0x3fc>  // b.none
    400009d4:	b94043e0 	ldr	w0, [sp, #64]
    400009d8:	7100281f 	cmp	w0, #0xa
    400009dc:	54000688 	b.hi	40000aac <stdint_to_ascii+0x400>  // b.pmore
    400009e0:	b94043e0 	ldr	w0, [sp, #64]
    400009e4:	7100081f 	cmp	w0, #0x2
    400009e8:	540002c0 	b.eq	40000a40 <stdint_to_ascii+0x394>  // b.none
    400009ec:	b94043e0 	ldr	w0, [sp, #64]
    400009f0:	7100201f 	cmp	w0, #0x8
    400009f4:	54000480 	b.eq	40000a84 <stdint_to_ascii+0x3d8>  // b.none
    400009f8:	1400002d 	b	40000aac <stdint_to_ascii+0x400>
    400009fc:	f9405fe0 	ldr	x0, [sp, #184]
    40000a00:	91000401 	add	x1, x0, #0x1
    40000a04:	f9005fe1 	str	x1, [sp, #184]
    40000a08:	aa0003e1 	mov	x1, x0
    40000a0c:	f9401fe0 	ldr	x0, [sp, #56]
    40000a10:	8b010000 	add	x0, x0, x1
    40000a14:	52800601 	mov	w1, #0x30                  	// #48
    40000a18:	39000001 	strb	w1, [x0]
    40000a1c:	f9405fe0 	ldr	x0, [sp, #184]
    40000a20:	91000401 	add	x1, x0, #0x1
    40000a24:	f9005fe1 	str	x1, [sp, #184]
    40000a28:	aa0003e1 	mov	x1, x0
    40000a2c:	f9401fe0 	ldr	x0, [sp, #56]
    40000a30:	8b010000 	add	x0, x0, x1
    40000a34:	52800f01 	mov	w1, #0x78                  	// #120
    40000a38:	39000001 	strb	w1, [x0]
    40000a3c:	1400001c 	b	40000aac <stdint_to_ascii+0x400>
    40000a40:	f9405fe0 	ldr	x0, [sp, #184]
    40000a44:	91000401 	add	x1, x0, #0x1
    40000a48:	f9005fe1 	str	x1, [sp, #184]
    40000a4c:	aa0003e1 	mov	x1, x0
    40000a50:	f9401fe0 	ldr	x0, [sp, #56]
    40000a54:	8b010000 	add	x0, x0, x1
    40000a58:	52800601 	mov	w1, #0x30                  	// #48
    40000a5c:	39000001 	strb	w1, [x0]
    40000a60:	f9405fe0 	ldr	x0, [sp, #184]
    40000a64:	91000401 	add	x1, x0, #0x1
    40000a68:	f9005fe1 	str	x1, [sp, #184]
    40000a6c:	aa0003e1 	mov	x1, x0
    40000a70:	f9401fe0 	ldr	x0, [sp, #56]
    40000a74:	8b010000 	add	x0, x0, x1
    40000a78:	52800c41 	mov	w1, #0x62                  	// #98
    40000a7c:	39000001 	strb	w1, [x0]
    40000a80:	1400000b 	b	40000aac <stdint_to_ascii+0x400>
    40000a84:	f9405fe0 	ldr	x0, [sp, #184]
    40000a88:	91000401 	add	x1, x0, #0x1
    40000a8c:	f9005fe1 	str	x1, [sp, #184]
    40000a90:	aa0003e1 	mov	x1, x0
    40000a94:	f9401fe0 	ldr	x0, [sp, #56]
    40000a98:	8b010000 	add	x0, x0, x1
    40000a9c:	52800601 	mov	w1, #0x30                  	// #48
    40000aa0:	39000001 	strb	w1, [x0]
    40000aa4:	14000002 	b	40000aac <stdint_to_ascii+0x400>
    40000aa8:	d503201f 	nop
    40000aac:	f9405fe0 	ldr	x0, [sp, #184]
    40000ab0:	91000401 	add	x1, x0, #0x1
    40000ab4:	f9005fe1 	str	x1, [sp, #184]
    40000ab8:	aa0003e1 	mov	x1, x0
    40000abc:	f9401fe0 	ldr	x0, [sp, #56]
    40000ac0:	8b010000 	add	x0, x0, x1
    40000ac4:	52800601 	mov	w1, #0x30                  	// #48
    40000ac8:	39000001 	strb	w1, [x0]
    40000acc:	f9405fe0 	ldr	x0, [sp, #184]
    40000ad0:	f9401fe1 	ldr	x1, [sp, #56]
    40000ad4:	8b000020 	add	x0, x1, x0
    40000ad8:	3900001f 	strb	wzr, [x0]
    40000adc:	f9401fe0 	ldr	x0, [sp, #56]
    40000ae0:	140000a5 	b	40000d74 <stdint_to_ascii+0x6c8>
    40000ae4:	f9005bff 	str	xzr, [sp, #176]
    40000ae8:	1400001f 	b	40000b64 <stdint_to_ascii+0x4b8>
    40000aec:	b94043e1 	ldr	w1, [sp, #64]
    40000af0:	f94067e0 	ldr	x0, [sp, #200]
    40000af4:	9ac10802 	udiv	x2, x0, x1
    40000af8:	9b017c41 	mul	x1, x2, x1
    40000afc:	cb010000 	sub	x0, x0, x1
    40000b00:	39027be0 	strb	w0, [sp, #158]
    40000b04:	b94043e0 	ldr	w0, [sp, #64]
    40000b08:	f94067e1 	ldr	x1, [sp, #200]
    40000b0c:	9ac00820 	udiv	x0, x1, x0
    40000b10:	f90067e0 	str	x0, [sp, #200]
    40000b14:	39431fe1 	ldrb	w1, [sp, #199]
    40000b18:	f9405be0 	ldr	x0, [sp, #176]
    40000b1c:	8b000021 	add	x1, x1, x0
    40000b20:	f94077e0 	ldr	x0, [sp, #232]
    40000b24:	8b000020 	add	x0, x1, x0
    40000b28:	91000400 	add	x0, x0, #0x1
    40000b2c:	f9401be1 	ldr	x1, [sp, #48]
    40000b30:	eb00003f 	cmp	x1, x0
    40000b34:	54000fa9 	b.ls	40000d28 <stdint_to_ascii+0x67c>  // b.plast
    40000b38:	39427be3 	ldrb	w3, [sp, #158]
    40000b3c:	f9405be0 	ldr	x0, [sp, #176]
    40000b40:	91000401 	add	x1, x0, #0x1
    40000b44:	f9005be1 	str	x1, [sp, #176]
    40000b48:	f9401fe1 	ldr	x1, [sp, #56]
    40000b4c:	8b000020 	add	x0, x1, x0
    40000b50:	b0000001 	adrp	x1, 40001000 <UART_UCR1_write+0x4>
    40000b54:	911fa022 	add	x2, x1, #0x7e8
    40000b58:	93407c61 	sxtw	x1, w3
    40000b5c:	38616841 	ldrb	w1, [x2, x1]
    40000b60:	39000001 	strb	w1, [x0]
    40000b64:	f94067e0 	ldr	x0, [sp, #200]
    40000b68:	f100001f 	cmp	x0, #0x0
    40000b6c:	54fffc01 	b.ne	40000aec <stdint_to_ascii+0x440>  // b.any
    40000b70:	b94043e0 	ldr	w0, [sp, #64]
    40000b74:	7100401f 	cmp	w0, #0x10
    40000b78:	54000220 	b.eq	40000bbc <stdint_to_ascii+0x510>  // b.none
    40000b7c:	b94043e0 	ldr	w0, [sp, #64]
    40000b80:	7100401f 	cmp	w0, #0x10
    40000b84:	540006a8 	b.hi	40000c58 <stdint_to_ascii+0x5ac>  // b.pmore
    40000b88:	b94043e0 	ldr	w0, [sp, #64]
    40000b8c:	7100281f 	cmp	w0, #0xa
    40000b90:	54000620 	b.eq	40000c54 <stdint_to_ascii+0x5a8>  // b.none
    40000b94:	b94043e0 	ldr	w0, [sp, #64]
    40000b98:	7100281f 	cmp	w0, #0xa
    40000b9c:	540005e8 	b.hi	40000c58 <stdint_to_ascii+0x5ac>  // b.pmore
    40000ba0:	b94043e0 	ldr	w0, [sp, #64]
    40000ba4:	7100081f 	cmp	w0, #0x2
    40000ba8:	54000280 	b.eq	40000bf8 <stdint_to_ascii+0x54c>  // b.none
    40000bac:	b94043e0 	ldr	w0, [sp, #64]
    40000bb0:	7100201f 	cmp	w0, #0x8
    40000bb4:	54000400 	b.eq	40000c34 <stdint_to_ascii+0x588>  // b.none
    40000bb8:	14000028 	b	40000c58 <stdint_to_ascii+0x5ac>
    40000bbc:	f9405be0 	ldr	x0, [sp, #176]
    40000bc0:	91000401 	add	x1, x0, #0x1
    40000bc4:	f9005be1 	str	x1, [sp, #176]
    40000bc8:	f9401fe1 	ldr	x1, [sp, #56]
    40000bcc:	8b000020 	add	x0, x1, x0
    40000bd0:	52800f01 	mov	w1, #0x78                  	// #120
    40000bd4:	39000001 	strb	w1, [x0]
    40000bd8:	f9405be0 	ldr	x0, [sp, #176]
    40000bdc:	91000401 	add	x1, x0, #0x1
    40000be0:	f9005be1 	str	x1, [sp, #176]
    40000be4:	f9401fe1 	ldr	x1, [sp, #56]
    40000be8:	8b000020 	add	x0, x1, x0
    40000bec:	52800601 	mov	w1, #0x30                  	// #48
    40000bf0:	39000001 	strb	w1, [x0]
    40000bf4:	14000019 	b	40000c58 <stdint_to_ascii+0x5ac>
    40000bf8:	f9405be0 	ldr	x0, [sp, #176]
    40000bfc:	91000401 	add	x1, x0, #0x1
    40000c00:	f9005be1 	str	x1, [sp, #176]
    40000c04:	f9401fe1 	ldr	x1, [sp, #56]
    40000c08:	8b000020 	add	x0, x1, x0
    40000c0c:	52800c41 	mov	w1, #0x62                  	// #98
    40000c10:	39000001 	strb	w1, [x0]
    40000c14:	f9405be0 	ldr	x0, [sp, #176]
    40000c18:	91000401 	add	x1, x0, #0x1
    40000c1c:	f9005be1 	str	x1, [sp, #176]
    40000c20:	f9401fe1 	ldr	x1, [sp, #56]
    40000c24:	8b000020 	add	x0, x1, x0
    40000c28:	52800601 	mov	w1, #0x30                  	// #48
    40000c2c:	39000001 	strb	w1, [x0]
    40000c30:	1400000a 	b	40000c58 <stdint_to_ascii+0x5ac>
    40000c34:	f9405be0 	ldr	x0, [sp, #176]
    40000c38:	91000401 	add	x1, x0, #0x1
    40000c3c:	f9005be1 	str	x1, [sp, #176]
    40000c40:	f9401fe1 	ldr	x1, [sp, #56]
    40000c44:	8b000020 	add	x0, x1, x0
    40000c48:	52800601 	mov	w1, #0x30                  	// #48
    40000c4c:	39000001 	strb	w1, [x0]
    40000c50:	14000002 	b	40000c58 <stdint_to_ascii+0x5ac>
    40000c54:	d503201f 	nop
    40000c58:	39431fe0 	ldrb	w0, [sp, #199]
    40000c5c:	12000000 	and	w0, w0, #0x1
    40000c60:	7100001f 	cmp	w0, #0x0
    40000c64:	54000100 	b.eq	40000c84 <stdint_to_ascii+0x5d8>  // b.none
    40000c68:	f9405be0 	ldr	x0, [sp, #176]
    40000c6c:	91000401 	add	x1, x0, #0x1
    40000c70:	f9005be1 	str	x1, [sp, #176]
    40000c74:	f9401fe1 	ldr	x1, [sp, #56]
    40000c78:	8b000020 	add	x0, x1, x0
    40000c7c:	528005a1 	mov	w1, #0x2d                  	// #45
    40000c80:	39000001 	strb	w1, [x0]
    40000c84:	f9401fe1 	ldr	x1, [sp, #56]
    40000c88:	f9405be0 	ldr	x0, [sp, #176]
    40000c8c:	8b000020 	add	x0, x1, x0
    40000c90:	3900001f 	strb	wzr, [x0]
    40000c94:	f90057ff 	str	xzr, [sp, #168]
    40000c98:	f9405be0 	ldr	x0, [sp, #176]
    40000c9c:	d1000400 	sub	x0, x0, #0x1
    40000ca0:	f90053e0 	str	x0, [sp, #160]
    40000ca4:	14000019 	b	40000d08 <stdint_to_ascii+0x65c>
    40000ca8:	f9401fe1 	ldr	x1, [sp, #56]
    40000cac:	f94057e0 	ldr	x0, [sp, #168]
    40000cb0:	8b000020 	add	x0, x1, x0
    40000cb4:	39400000 	ldrb	w0, [x0]
    40000cb8:	39027fe0 	strb	w0, [sp, #159]
    40000cbc:	f9401fe1 	ldr	x1, [sp, #56]
    40000cc0:	f94053e0 	ldr	x0, [sp, #160]
    40000cc4:	8b000021 	add	x1, x1, x0
    40000cc8:	f9401fe2 	ldr	x2, [sp, #56]
    40000ccc:	f94057e0 	ldr	x0, [sp, #168]
    40000cd0:	8b000040 	add	x0, x2, x0
    40000cd4:	39400021 	ldrb	w1, [x1]
    40000cd8:	39000001 	strb	w1, [x0]
    40000cdc:	f9401fe1 	ldr	x1, [sp, #56]
    40000ce0:	f94053e0 	ldr	x0, [sp, #160]
    40000ce4:	8b000020 	add	x0, x1, x0
    40000ce8:	39427fe1 	ldrb	w1, [sp, #159]
    40000cec:	39000001 	strb	w1, [x0]
    40000cf0:	f94057e0 	ldr	x0, [sp, #168]
    40000cf4:	91000400 	add	x0, x0, #0x1
    40000cf8:	f90057e0 	str	x0, [sp, #168]
    40000cfc:	f94053e0 	ldr	x0, [sp, #160]
    40000d00:	d1000400 	sub	x0, x0, #0x1
    40000d04:	f90053e0 	str	x0, [sp, #160]
    40000d08:	f94057e1 	ldr	x1, [sp, #168]
    40000d0c:	f94053e0 	ldr	x0, [sp, #160]
    40000d10:	eb00003f 	cmp	x1, x0
    40000d14:	54fffca3 	b.cc	40000ca8 <stdint_to_ascii+0x5fc>  // b.lo, b.ul, b.last
    40000d18:	f9401fe0 	ldr	x0, [sp, #56]
    40000d1c:	14000016 	b	40000d74 <stdint_to_ascii+0x6c8>
    40000d20:	d503201f 	nop
    40000d24:	14000002 	b	40000d2c <stdint_to_ascii+0x680>
    40000d28:	d503201f 	nop
    40000d2c:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000d30:	91214000 	add	x0, x0, #0x850
    40000d34:	f90043e0 	str	x0, [sp, #128]
    40000d38:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000d3c:	911f4000 	add	x0, x0, #0x7d0
    40000d40:	f90047e0 	str	x0, [sp, #136]
    40000d44:	52801600 	mov	w0, #0xb0                  	// #176
    40000d48:	b90093e0 	str	w0, [sp, #144]
    40000d4c:	b90097ff 	str	wzr, [sp, #148]
    40000d50:	910043e2 	add	x2, sp, #0x10
    40000d54:	910203e3 	add	x3, sp, #0x80
    40000d58:	a9400460 	ldp	x0, x1, [x3]
    40000d5c:	f9400863 	ldr	x3, [x3, #16]
    40000d60:	a9000440 	stp	x0, x1, [x2]
    40000d64:	f9000843 	str	x3, [x2, #16]
    40000d68:	910043e0 	add	x0, sp, #0x10
    40000d6c:	97fffdf1 	bl	40000530 <set_and_throw_panic>
    40000d70:	d2800000 	mov	x0, #0x0                   	// #0
    40000d74:	a8cf7bfd 	ldp	x29, x30, [sp], #240
    40000d78:	d65f03c0 	ret

0000000040000d7c <memcpy64_aligned>:
    40000d7c:	a9b67bfd 	stp	x29, x30, [sp, #-160]!
    40000d80:	910003fd 	mov	x29, sp
    40000d84:	f90027e0 	str	x0, [sp, #72]
    40000d88:	f90023e1 	str	x1, [sp, #64]
    40000d8c:	f9001fe2 	str	x2, [sp, #56]
    40000d90:	f9401fe0 	ldr	x0, [sp, #56]
    40000d94:	f100001f 	cmp	x0, #0x0
    40000d98:	54000061 	b.ne	40000da4 <memcpy64_aligned+0x28>  // b.any
    40000d9c:	f94027e0 	ldr	x0, [sp, #72]
    40000da0:	14000044 	b	40000eb0 <memcpy64_aligned+0x134>
    40000da4:	f94027e0 	ldr	x0, [sp, #72]
    40000da8:	92401400 	and	x0, x0, #0x3f
    40000dac:	f100001f 	cmp	x0, #0x0
    40000db0:	54000240 	b.eq	40000df8 <memcpy64_aligned+0x7c>  // b.none
    40000db4:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000db8:	91228000 	add	x0, x0, #0x8a0
    40000dbc:	f90047e0 	str	x0, [sp, #136]
    40000dc0:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000dc4:	91234000 	add	x0, x0, #0x8d0
    40000dc8:	f9004be0 	str	x0, [sp, #144]
    40000dcc:	528002c0 	mov	w0, #0x16                  	// #22
    40000dd0:	b9009be0 	str	w0, [sp, #152]
    40000dd4:	b9009fff 	str	wzr, [sp, #156]
    40000dd8:	910043e2 	add	x2, sp, #0x10
    40000ddc:	910223e3 	add	x3, sp, #0x88
    40000de0:	a9400460 	ldp	x0, x1, [x3]
    40000de4:	f9400863 	ldr	x3, [x3, #16]
    40000de8:	a9000440 	stp	x0, x1, [x2]
    40000dec:	f9000843 	str	x3, [x2, #16]
    40000df0:	910043e0 	add	x0, sp, #0x10
    40000df4:	97fffdcf 	bl	40000530 <set_and_throw_panic>
    40000df8:	f94023e0 	ldr	x0, [sp, #64]
    40000dfc:	92401400 	and	x0, x0, #0x3f
    40000e00:	f100001f 	cmp	x0, #0x0
    40000e04:	54000240 	b.eq	40000e4c <memcpy64_aligned+0xd0>  // b.none
    40000e08:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000e0c:	9123c000 	add	x0, x0, #0x8f0
    40000e10:	f9003be0 	str	x0, [sp, #112]
    40000e14:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000e18:	91234000 	add	x0, x0, #0x8d0
    40000e1c:	f9003fe0 	str	x0, [sp, #120]
    40000e20:	52800320 	mov	w0, #0x19                  	// #25
    40000e24:	b90083e0 	str	w0, [sp, #128]
    40000e28:	b90087ff 	str	wzr, [sp, #132]
    40000e2c:	910043e2 	add	x2, sp, #0x10
    40000e30:	9101c3e3 	add	x3, sp, #0x70
    40000e34:	a9400460 	ldp	x0, x1, [x3]
    40000e38:	f9400863 	ldr	x3, [x3, #16]
    40000e3c:	a9000440 	stp	x0, x1, [x2]
    40000e40:	f9000843 	str	x3, [x2, #16]
    40000e44:	910043e0 	add	x0, sp, #0x10
    40000e48:	97fffdba 	bl	40000530 <set_and_throw_panic>
    40000e4c:	f9401fe0 	ldr	x0, [sp, #56]
    40000e50:	92401400 	and	x0, x0, #0x3f
    40000e54:	f100001f 	cmp	x0, #0x0
    40000e58:	54000240 	b.eq	40000ea0 <memcpy64_aligned+0x124>  // b.none
    40000e5c:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000e60:	91248000 	add	x0, x0, #0x920
    40000e64:	f9002fe0 	str	x0, [sp, #88]
    40000e68:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000e6c:	91234000 	add	x0, x0, #0x8d0
    40000e70:	f90033e0 	str	x0, [sp, #96]
    40000e74:	52800380 	mov	w0, #0x1c                  	// #28
    40000e78:	b9006be0 	str	w0, [sp, #104]
    40000e7c:	b9006fff 	str	wzr, [sp, #108]
    40000e80:	910043e2 	add	x2, sp, #0x10
    40000e84:	910163e3 	add	x3, sp, #0x58
    40000e88:	a9400460 	ldp	x0, x1, [x3]
    40000e8c:	f9400863 	ldr	x3, [x3, #16]
    40000e90:	a9000440 	stp	x0, x1, [x2]
    40000e94:	f9000843 	str	x3, [x2, #16]
    40000e98:	910043e0 	add	x0, sp, #0x10
    40000e9c:	97fffda5 	bl	40000530 <set_and_throw_panic>
    40000ea0:	f9401fe2 	ldr	x2, [sp, #56]
    40000ea4:	f94023e1 	ldr	x1, [sp, #64]
    40000ea8:	f94027e0 	ldr	x0, [sp, #72]
    40000eac:	97fffcad 	bl	40000160 <_memcpy64>
    40000eb0:	a8ca7bfd 	ldp	x29, x30, [sp], #160
    40000eb4:	d65f03c0 	ret

0000000040000eb8 <memcpy64>:
    40000eb8:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    40000ebc:	910003fd 	mov	x29, sp
    40000ec0:	f90027e0 	str	x0, [sp, #72]
    40000ec4:	f90023e1 	str	x1, [sp, #64]
    40000ec8:	f9001fe2 	str	x2, [sp, #56]
    40000ecc:	f9401fe0 	ldr	x0, [sp, #56]
    40000ed0:	f100001f 	cmp	x0, #0x0
    40000ed4:	54000061 	b.ne	40000ee0 <memcpy64+0x28>  // b.any
    40000ed8:	f94027e0 	ldr	x0, [sp, #72]
    40000edc:	1400001a 	b	40000f44 <memcpy64+0x8c>
    40000ee0:	f9401fe0 	ldr	x0, [sp, #56]
    40000ee4:	92401400 	and	x0, x0, #0x3f
    40000ee8:	f100001f 	cmp	x0, #0x0
    40000eec:	54000240 	b.eq	40000f34 <memcpy64+0x7c>  // b.none
    40000ef0:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000ef4:	91254000 	add	x0, x0, #0x950
    40000ef8:	f9002fe0 	str	x0, [sp, #88]
    40000efc:	b0000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40000f00:	91234000 	add	x0, x0, #0x8d0
    40000f04:	f90033e0 	str	x0, [sp, #96]
    40000f08:	528004a0 	mov	w0, #0x25                  	// #37
    40000f0c:	b9006be0 	str	w0, [sp, #104]
    40000f10:	b9006fff 	str	wzr, [sp, #108]
    40000f14:	910043e2 	add	x2, sp, #0x10
    40000f18:	910163e3 	add	x3, sp, #0x58
    40000f1c:	a9400460 	ldp	x0, x1, [x3]
    40000f20:	f9400863 	ldr	x3, [x3, #16]
    40000f24:	a9000440 	stp	x0, x1, [x2]
    40000f28:	f9000843 	str	x3, [x2, #16]
    40000f2c:	910043e0 	add	x0, sp, #0x10
    40000f30:	97fffd80 	bl	40000530 <set_and_throw_panic>
    40000f34:	f9401fe2 	ldr	x2, [sp, #56]
    40000f38:	f94023e1 	ldr	x1, [sp, #64]
    40000f3c:	f94027e0 	ldr	x0, [sp, #72]
    40000f40:	97fffc88 	bl	40000160 <_memcpy64>
    40000f44:	a8c77bfd 	ldp	x29, x30, [sp], #112
    40000f48:	d65f03c0 	ret

0000000040000f4c <UART_UBIR_write>:
    40000f4c:	d10043ff 	sub	sp, sp, #0x10
    40000f50:	f90007e0 	str	x0, [sp, #8]
    40000f54:	b90003e1 	str	w1, [sp]
    40000f58:	f94007e0 	ldr	x0, [sp, #8]
    40000f5c:	91029000 	add	x0, x0, #0xa4
    40000f60:	aa0003e1 	mov	x1, x0
    40000f64:	b94003e0 	ldr	w0, [sp]
    40000f68:	b9000020 	str	w0, [x1]
    40000f6c:	910043ff 	add	sp, sp, #0x10
    40000f70:	d65f03c0 	ret

0000000040000f74 <UART_UBIR_BF_set_INC>:
    40000f74:	d10043ff 	sub	sp, sp, #0x10
    40000f78:	f90007e0 	str	x0, [sp, #8]
    40000f7c:	79000fe1 	strh	w1, [sp, #6]
    40000f80:	f94007e0 	ldr	x0, [sp, #8]
    40000f84:	b9400000 	ldr	w0, [x0]
    40000f88:	12103c01 	and	w1, w0, #0xffff0000
    40000f8c:	79400fe0 	ldrh	w0, [sp, #6]
    40000f90:	2a000021 	orr	w1, w1, w0
    40000f94:	f94007e0 	ldr	x0, [sp, #8]
    40000f98:	b9000001 	str	w1, [x0]
    40000f9c:	910043ff 	add	sp, sp, #0x10
    40000fa0:	d65f03c0 	ret

0000000040000fa4 <UART_UBMR_write>:
    40000fa4:	d10043ff 	sub	sp, sp, #0x10
    40000fa8:	f90007e0 	str	x0, [sp, #8]
    40000fac:	b90003e1 	str	w1, [sp]
    40000fb0:	f94007e0 	ldr	x0, [sp, #8]
    40000fb4:	9102a000 	add	x0, x0, #0xa8
    40000fb8:	aa0003e1 	mov	x1, x0
    40000fbc:	b94003e0 	ldr	w0, [sp]
    40000fc0:	b9000020 	str	w0, [x1]
    40000fc4:	910043ff 	add	sp, sp, #0x10
    40000fc8:	d65f03c0 	ret

0000000040000fcc <UART_UBMR_BF_set_MOD>:
    40000fcc:	d10043ff 	sub	sp, sp, #0x10
    40000fd0:	f90007e0 	str	x0, [sp, #8]
    40000fd4:	79000fe1 	strh	w1, [sp, #6]
    40000fd8:	f94007e0 	ldr	x0, [sp, #8]
    40000fdc:	b9400000 	ldr	w0, [x0]
    40000fe0:	12103c01 	and	w1, w0, #0xffff0000
    40000fe4:	79400fe0 	ldrh	w0, [sp, #6]
    40000fe8:	2a000021 	orr	w1, w1, w0
    40000fec:	f94007e0 	ldr	x0, [sp, #8]
    40000ff0:	b9000001 	str	w1, [x0]
    40000ff4:	910043ff 	add	sp, sp, #0x10
    40000ff8:	d65f03c0 	ret

0000000040000ffc <UART_UCR1_write>:
    40000ffc:	d10043ff 	sub	sp, sp, #0x10
    40001000:	f90007e0 	str	x0, [sp, #8]
    40001004:	b90003e1 	str	w1, [sp]
    40001008:	f94007e0 	ldr	x0, [sp, #8]
    4000100c:	91020000 	add	x0, x0, #0x80
    40001010:	aa0003e1 	mov	x1, x0
    40001014:	b94003e0 	ldr	w0, [sp]
    40001018:	b9000020 	str	w0, [x1]
    4000101c:	910043ff 	add	sp, sp, #0x10
    40001020:	d65f03c0 	ret

0000000040001024 <UART_UCR1_BF_set_UARTEN>:
    40001024:	d10043ff 	sub	sp, sp, #0x10
    40001028:	f90007e0 	str	x0, [sp, #8]
    4000102c:	39001fe1 	strb	w1, [sp, #7]
    40001030:	f94007e0 	ldr	x0, [sp, #8]
    40001034:	b9400000 	ldr	w0, [x0]
    40001038:	121f7801 	and	w1, w0, #0xfffffffe
    4000103c:	39401fe0 	ldrb	w0, [sp, #7]
    40001040:	2a000021 	orr	w1, w1, w0
    40001044:	f94007e0 	ldr	x0, [sp, #8]
    40001048:	b9000001 	str	w1, [x0]
    4000104c:	910043ff 	add	sp, sp, #0x10
    40001050:	d65f03c0 	ret

0000000040001054 <UART_UCR2_read>:
    40001054:	d10043ff 	sub	sp, sp, #0x10
    40001058:	f90007e0 	str	x0, [sp, #8]
    4000105c:	f94007e0 	ldr	x0, [sp, #8]
    40001060:	91021000 	add	x0, x0, #0x84
    40001064:	b9400000 	ldr	w0, [x0]
    40001068:	910043ff 	add	sp, sp, #0x10
    4000106c:	d65f03c0 	ret

0000000040001070 <UART_UCR2_write>:
    40001070:	d10043ff 	sub	sp, sp, #0x10
    40001074:	f90007e0 	str	x0, [sp, #8]
    40001078:	b90003e1 	str	w1, [sp]
    4000107c:	f94007e0 	ldr	x0, [sp, #8]
    40001080:	91021000 	add	x0, x0, #0x84
    40001084:	aa0003e1 	mov	x1, x0
    40001088:	b94003e0 	ldr	w0, [sp]
    4000108c:	b9000020 	str	w0, [x1]
    40001090:	910043ff 	add	sp, sp, #0x10
    40001094:	d65f03c0 	ret

0000000040001098 <UART_UCR2_BF_set_IRTS>:
    40001098:	d10043ff 	sub	sp, sp, #0x10
    4000109c:	f90007e0 	str	x0, [sp, #8]
    400010a0:	39001fe1 	strb	w1, [sp, #7]
    400010a4:	f94007e0 	ldr	x0, [sp, #8]
    400010a8:	b9400000 	ldr	w0, [x0]
    400010ac:	12117801 	and	w1, w0, #0xffffbfff
    400010b0:	39401fe0 	ldrb	w0, [sp, #7]
    400010b4:	53124400 	lsl	w0, w0, #14
    400010b8:	12120000 	and	w0, w0, #0x4000
    400010bc:	2a000021 	orr	w1, w1, w0
    400010c0:	f94007e0 	ldr	x0, [sp, #8]
    400010c4:	b9000001 	str	w1, [x0]
    400010c8:	910043ff 	add	sp, sp, #0x10
    400010cc:	d65f03c0 	ret

00000000400010d0 <UART_UCR2_BF_set_WS>:
    400010d0:	d10043ff 	sub	sp, sp, #0x10
    400010d4:	f90007e0 	str	x0, [sp, #8]
    400010d8:	39001fe1 	strb	w1, [sp, #7]
    400010dc:	f94007e0 	ldr	x0, [sp, #8]
    400010e0:	b9400000 	ldr	w0, [x0]
    400010e4:	121a7801 	and	w1, w0, #0xffffffdf
    400010e8:	39401fe0 	ldrb	w0, [sp, #7]
    400010ec:	531b6800 	lsl	w0, w0, #5
    400010f0:	121b0000 	and	w0, w0, #0x20
    400010f4:	2a000021 	orr	w1, w1, w0
    400010f8:	f94007e0 	ldr	x0, [sp, #8]
    400010fc:	b9000001 	str	w1, [x0]
    40001100:	910043ff 	add	sp, sp, #0x10
    40001104:	d65f03c0 	ret

0000000040001108 <UART_UCR2_BF_set_TXEN>:
    40001108:	d10043ff 	sub	sp, sp, #0x10
    4000110c:	f90007e0 	str	x0, [sp, #8]
    40001110:	39001fe1 	strb	w1, [sp, #7]
    40001114:	f94007e0 	ldr	x0, [sp, #8]
    40001118:	b9400000 	ldr	w0, [x0]
    4000111c:	121d7801 	and	w1, w0, #0xfffffffb
    40001120:	39401fe0 	ldrb	w0, [sp, #7]
    40001124:	531e7400 	lsl	w0, w0, #2
    40001128:	121e0000 	and	w0, w0, #0x4
    4000112c:	2a000021 	orr	w1, w1, w0
    40001130:	f94007e0 	ldr	x0, [sp, #8]
    40001134:	b9000001 	str	w1, [x0]
    40001138:	910043ff 	add	sp, sp, #0x10
    4000113c:	d65f03c0 	ret

0000000040001140 <UART_UCR2_BF_set_RXEN>:
    40001140:	d10043ff 	sub	sp, sp, #0x10
    40001144:	f90007e0 	str	x0, [sp, #8]
    40001148:	39001fe1 	strb	w1, [sp, #7]
    4000114c:	f94007e0 	ldr	x0, [sp, #8]
    40001150:	b9400000 	ldr	w0, [x0]
    40001154:	121e7801 	and	w1, w0, #0xfffffffd
    40001158:	39401fe0 	ldrb	w0, [sp, #7]
    4000115c:	0b000000 	add	w0, w0, w0
    40001160:	121f0000 	and	w0, w0, #0x2
    40001164:	2a000021 	orr	w1, w1, w0
    40001168:	f94007e0 	ldr	x0, [sp, #8]
    4000116c:	b9000001 	str	w1, [x0]
    40001170:	910043ff 	add	sp, sp, #0x10
    40001174:	d65f03c0 	ret

0000000040001178 <UART_UCR2_BF_set_SRST>:
    40001178:	d10043ff 	sub	sp, sp, #0x10
    4000117c:	f90007e0 	str	x0, [sp, #8]
    40001180:	39001fe1 	strb	w1, [sp, #7]
    40001184:	f94007e0 	ldr	x0, [sp, #8]
    40001188:	b9400000 	ldr	w0, [x0]
    4000118c:	121f7801 	and	w1, w0, #0xfffffffe
    40001190:	39401fe0 	ldrb	w0, [sp, #7]
    40001194:	2a000021 	orr	w1, w1, w0
    40001198:	f94007e0 	ldr	x0, [sp, #8]
    4000119c:	b9000001 	str	w1, [x0]
    400011a0:	910043ff 	add	sp, sp, #0x10
    400011a4:	d65f03c0 	ret

00000000400011a8 <UART_UCR3_write>:
    400011a8:	d10043ff 	sub	sp, sp, #0x10
    400011ac:	f90007e0 	str	x0, [sp, #8]
    400011b0:	b90003e1 	str	w1, [sp]
    400011b4:	f94007e0 	ldr	x0, [sp, #8]
    400011b8:	91022000 	add	x0, x0, #0x88
    400011bc:	aa0003e1 	mov	x1, x0
    400011c0:	b94003e0 	ldr	w0, [sp]
    400011c4:	b9000020 	str	w0, [x1]
    400011c8:	910043ff 	add	sp, sp, #0x10
    400011cc:	d65f03c0 	ret

00000000400011d0 <UART_UCR3_BF_set_DSR>:
    400011d0:	d10043ff 	sub	sp, sp, #0x10
    400011d4:	f90007e0 	str	x0, [sp, #8]
    400011d8:	39001fe1 	strb	w1, [sp, #7]
    400011dc:	f94007e0 	ldr	x0, [sp, #8]
    400011e0:	b9400000 	ldr	w0, [x0]
    400011e4:	12157801 	and	w1, w0, #0xfffffbff
    400011e8:	39401fe0 	ldrb	w0, [sp, #7]
    400011ec:	53165400 	lsl	w0, w0, #10
    400011f0:	12160000 	and	w0, w0, #0x400
    400011f4:	2a000021 	orr	w1, w1, w0
    400011f8:	f94007e0 	ldr	x0, [sp, #8]
    400011fc:	b9000001 	str	w1, [x0]
    40001200:	910043ff 	add	sp, sp, #0x10
    40001204:	d65f03c0 	ret

0000000040001208 <UART_UCR3_BF_set_DCD>:
    40001208:	d10043ff 	sub	sp, sp, #0x10
    4000120c:	f90007e0 	str	x0, [sp, #8]
    40001210:	39001fe1 	strb	w1, [sp, #7]
    40001214:	f94007e0 	ldr	x0, [sp, #8]
    40001218:	b9400000 	ldr	w0, [x0]
    4000121c:	12167801 	and	w1, w0, #0xfffffdff
    40001220:	39401fe0 	ldrb	w0, [sp, #7]
    40001224:	53175800 	lsl	w0, w0, #9
    40001228:	12170000 	and	w0, w0, #0x200
    4000122c:	2a000021 	orr	w1, w1, w0
    40001230:	f94007e0 	ldr	x0, [sp, #8]
    40001234:	b9000001 	str	w1, [x0]
    40001238:	910043ff 	add	sp, sp, #0x10
    4000123c:	d65f03c0 	ret

0000000040001240 <UART_UCR3_BF_set_RI>:
    40001240:	d10043ff 	sub	sp, sp, #0x10
    40001244:	f90007e0 	str	x0, [sp, #8]
    40001248:	39001fe1 	strb	w1, [sp, #7]
    4000124c:	f94007e0 	ldr	x0, [sp, #8]
    40001250:	b9400000 	ldr	w0, [x0]
    40001254:	12177801 	and	w1, w0, #0xfffffeff
    40001258:	39401fe0 	ldrb	w0, [sp, #7]
    4000125c:	53185c00 	lsl	w0, w0, #8
    40001260:	12180000 	and	w0, w0, #0x100
    40001264:	2a000021 	orr	w1, w1, w0
    40001268:	f94007e0 	ldr	x0, [sp, #8]
    4000126c:	b9000001 	str	w1, [x0]
    40001270:	910043ff 	add	sp, sp, #0x10
    40001274:	d65f03c0 	ret

0000000040001278 <UART_UCR3_BF_set_RXDMUXSEL>:
    40001278:	d10043ff 	sub	sp, sp, #0x10
    4000127c:	f90007e0 	str	x0, [sp, #8]
    40001280:	39001fe1 	strb	w1, [sp, #7]
    40001284:	f94007e0 	ldr	x0, [sp, #8]
    40001288:	b9400000 	ldr	w0, [x0]
    4000128c:	121d7801 	and	w1, w0, #0xfffffffb
    40001290:	39401fe0 	ldrb	w0, [sp, #7]
    40001294:	531e7400 	lsl	w0, w0, #2
    40001298:	121e0000 	and	w0, w0, #0x4
    4000129c:	2a000021 	orr	w1, w1, w0
    400012a0:	f94007e0 	ldr	x0, [sp, #8]
    400012a4:	b9000001 	str	w1, [x0]
    400012a8:	910043ff 	add	sp, sp, #0x10
    400012ac:	d65f03c0 	ret

00000000400012b0 <UART_UCR4_write>:
    400012b0:	d10043ff 	sub	sp, sp, #0x10
    400012b4:	f90007e0 	str	x0, [sp, #8]
    400012b8:	b90003e1 	str	w1, [sp]
    400012bc:	f94007e0 	ldr	x0, [sp, #8]
    400012c0:	91023000 	add	x0, x0, #0x8c
    400012c4:	aa0003e1 	mov	x1, x0
    400012c8:	b94003e0 	ldr	w0, [sp]
    400012cc:	b9000020 	str	w0, [x1]
    400012d0:	910043ff 	add	sp, sp, #0x10
    400012d4:	d65f03c0 	ret

00000000400012d8 <UART_UCR4_BF_set_CTSTL>:
    400012d8:	d10043ff 	sub	sp, sp, #0x10
    400012dc:	f90007e0 	str	x0, [sp, #8]
    400012e0:	39001fe1 	strb	w1, [sp, #7]
    400012e4:	f94007e0 	ldr	x0, [sp, #8]
    400012e8:	b9400000 	ldr	w0, [x0]
    400012ec:	12106401 	and	w1, w0, #0xffff03ff
    400012f0:	39401fe0 	ldrb	w0, [sp, #7]
    400012f4:	53165400 	lsl	w0, w0, #10
    400012f8:	12003c00 	and	w0, w0, #0xffff
    400012fc:	2a000021 	orr	w1, w1, w0
    40001300:	f94007e0 	ldr	x0, [sp, #8]
    40001304:	b9000001 	str	w1, [x0]
    40001308:	910043ff 	add	sp, sp, #0x10
    4000130c:	d65f03c0 	ret

0000000040001310 <UART_UFCR_write>:
    40001310:	d10043ff 	sub	sp, sp, #0x10
    40001314:	f90007e0 	str	x0, [sp, #8]
    40001318:	b90003e1 	str	w1, [sp]
    4000131c:	f94007e0 	ldr	x0, [sp, #8]
    40001320:	91024000 	add	x0, x0, #0x90
    40001324:	aa0003e1 	mov	x1, x0
    40001328:	b94003e0 	ldr	w0, [sp]
    4000132c:	b9000020 	str	w0, [x1]
    40001330:	910043ff 	add	sp, sp, #0x10
    40001334:	d65f03c0 	ret

0000000040001338 <UART_UMCR_write>:
    40001338:	d10043ff 	sub	sp, sp, #0x10
    4000133c:	f90007e0 	str	x0, [sp, #8]
    40001340:	b90003e1 	str	w1, [sp]
    40001344:	f94007e0 	ldr	x0, [sp, #8]
    40001348:	9102e000 	add	x0, x0, #0xb8
    4000134c:	aa0003e1 	mov	x1, x0
    40001350:	b94003e0 	ldr	w0, [sp]
    40001354:	b9000020 	str	w0, [x1]
    40001358:	910043ff 	add	sp, sp, #0x10
    4000135c:	d65f03c0 	ret

0000000040001360 <UART_UTS_read>:
    40001360:	d10043ff 	sub	sp, sp, #0x10
    40001364:	f90007e0 	str	x0, [sp, #8]
    40001368:	f94007e0 	ldr	x0, [sp, #8]
    4000136c:	9102d000 	add	x0, x0, #0xb4
    40001370:	b9400000 	ldr	w0, [x0]
    40001374:	910043ff 	add	sp, sp, #0x10
    40001378:	d65f03c0 	ret

000000004000137c <UART_UTS_BF_get_TXFULL>:
    4000137c:	d10043ff 	sub	sp, sp, #0x10
    40001380:	b9000be0 	str	w0, [sp, #8]
    40001384:	b9400be0 	ldr	w0, [sp, #8]
    40001388:	121c0000 	and	w0, w0, #0x10
    4000138c:	7100001f 	cmp	w0, #0x0
    40001390:	1a9f07e0 	cset	w0, ne	// ne = any
    40001394:	12001c00 	and	w0, w0, #0xff
    40001398:	910043ff 	add	sp, sp, #0x10
    4000139c:	d65f03c0 	ret

00000000400013a0 <UART_UTS_BF_get_SOFTRST>:
    400013a0:	d10043ff 	sub	sp, sp, #0x10
    400013a4:	b9000be0 	str	w0, [sp, #8]
    400013a8:	b9400be0 	ldr	w0, [sp, #8]
    400013ac:	12000000 	and	w0, w0, #0x1
    400013b0:	7100001f 	cmp	w0, #0x0
    400013b4:	1a9f07e0 	cset	w0, ne	// ne = any
    400013b8:	12001c00 	and	w0, w0, #0xff
    400013bc:	910043ff 	add	sp, sp, #0x10
    400013c0:	d65f03c0 	ret

00000000400013c4 <UART_UTXD_write>:
    400013c4:	d10043ff 	sub	sp, sp, #0x10
    400013c8:	f90007e0 	str	x0, [sp, #8]
    400013cc:	b90003e1 	str	w1, [sp]
    400013d0:	f94007e0 	ldr	x0, [sp, #8]
    400013d4:	91010000 	add	x0, x0, #0x40
    400013d8:	aa0003e1 	mov	x1, x0
    400013dc:	b94003e0 	ldr	w0, [sp]
    400013e0:	b9000020 	str	w0, [x1]
    400013e4:	910043ff 	add	sp, sp, #0x10
    400013e8:	d65f03c0 	ret

00000000400013ec <UART_tx_fifo_full>:
    400013ec:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    400013f0:	910003fd 	mov	x29, sp
    400013f4:	f9000fe0 	str	x0, [sp, #24]
    400013f8:	f9400fe0 	ldr	x0, [sp, #24]
    400013fc:	97ffffd9 	bl	40001360 <UART_UTS_read>
    40001400:	b9002be0 	str	w0, [sp, #40]
    40001404:	b9402be0 	ldr	w0, [sp, #40]
    40001408:	97ffffdd 	bl	4000137c <UART_UTS_BF_get_TXFULL>
    4000140c:	12001c00 	and	w0, w0, #0xff
    40001410:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40001414:	d65f03c0 	ret

0000000040001418 <UART_putc>:
    40001418:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    4000141c:	910003fd 	mov	x29, sp
    40001420:	b9001fe0 	str	w0, [sp, #28]
    40001424:	39006fe1 	strb	w1, [sp, #27]
    40001428:	39406fe0 	ldrb	w0, [sp, #27]
    4000142c:	b9002be0 	str	w0, [sp, #40]
    40001430:	14000002 	b	40001438 <UART_putc+0x20>
    40001434:	d503201f 	nop
    40001438:	90000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    4000143c:	9125e000 	add	x0, x0, #0x978
    40001440:	b9401fe1 	ldr	w1, [sp, #28]
    40001444:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    40001448:	97ffffe9 	bl	400013ec <UART_tx_fifo_full>
    4000144c:	12001c00 	and	w0, w0, #0xff
    40001450:	12000000 	and	w0, w0, #0x1
    40001454:	7100001f 	cmp	w0, #0x0
    40001458:	54fffee1 	b.ne	40001434 <UART_putc+0x1c>  // b.any
    4000145c:	90000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40001460:	9125e000 	add	x0, x0, #0x978
    40001464:	b9401fe1 	ldr	w1, [sp, #28]
    40001468:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    4000146c:	b9402be1 	ldr	w1, [sp, #40]
    40001470:	97ffffd5 	bl	400013c4 <UART_UTXD_write>
    40001474:	d503201f 	nop
    40001478:	a8c37bfd 	ldp	x29, x30, [sp], #48
    4000147c:	d65f03c0 	ret

0000000040001480 <UART_puts>:
    40001480:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    40001484:	910003fd 	mov	x29, sp
    40001488:	b9001fe0 	str	w0, [sp, #28]
    4000148c:	f9000be1 	str	x1, [sp, #16]
    40001490:	14000008 	b	400014b0 <UART_puts+0x30>
    40001494:	f9400be0 	ldr	x0, [sp, #16]
    40001498:	91000401 	add	x1, x0, #0x1
    4000149c:	f9000be1 	str	x1, [sp, #16]
    400014a0:	39400000 	ldrb	w0, [x0]
    400014a4:	2a0003e1 	mov	w1, w0
    400014a8:	b9401fe0 	ldr	w0, [sp, #28]
    400014ac:	97ffffdb 	bl	40001418 <UART_putc>
    400014b0:	f9400be0 	ldr	x0, [sp, #16]
    400014b4:	39400000 	ldrb	w0, [x0]
    400014b8:	7100001f 	cmp	w0, #0x0
    400014bc:	54fffec1 	b.ne	40001494 <UART_puts+0x14>  // b.any
    400014c0:	d503201f 	nop
    400014c4:	d503201f 	nop
    400014c8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    400014cc:	d65f03c0 	ret

00000000400014d0 <UART_reset>:
    400014d0:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    400014d4:	910003fd 	mov	x29, sp
    400014d8:	b9001fe0 	str	w0, [sp, #28]
    400014dc:	90000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    400014e0:	9125e000 	add	x0, x0, #0x978
    400014e4:	b9401fe1 	ldr	w1, [sp, #28]
    400014e8:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    400014ec:	f9001be0 	str	x0, [sp, #48]
    400014f0:	f9401be0 	ldr	x0, [sp, #48]
    400014f4:	97fffed8 	bl	40001054 <UART_UCR2_read>
    400014f8:	b9002be0 	str	w0, [sp, #40]
    400014fc:	9100a3e0 	add	x0, sp, #0x28
    40001500:	52800001 	mov	w1, #0x0                   	// #0
    40001504:	97ffff1d 	bl	40001178 <UART_UCR2_BF_set_SRST>
    40001508:	f9001fff 	str	xzr, [sp, #56]
    4000150c:	14000005 	b	40001520 <UART_reset+0x50>
    40001510:	d503201f 	nop
    40001514:	f9401fe0 	ldr	x0, [sp, #56]
    40001518:	91000400 	add	x0, x0, #0x1
    4000151c:	f9001fe0 	str	x0, [sp, #56]
    40001520:	f9401fe0 	ldr	x0, [sp, #56]
    40001524:	f11f3c1f 	cmp	x0, #0x7cf
    40001528:	54ffff49 	b.ls	40001510 <UART_reset+0x40>  // b.plast
    4000152c:	f9401be0 	ldr	x0, [sp, #48]
    40001530:	97ffff8c 	bl	40001360 <UART_UTS_read>
    40001534:	b90023e0 	str	w0, [sp, #32]
    40001538:	b94023e0 	ldr	w0, [sp, #32]
    4000153c:	97ffff99 	bl	400013a0 <UART_UTS_BF_get_SOFTRST>
    40001540:	12001c00 	and	w0, w0, #0xff
    40001544:	52000000 	eor	w0, w0, #0x1
    40001548:	12001c00 	and	w0, w0, #0xff
    4000154c:	12000000 	and	w0, w0, #0x1
    40001550:	7100001f 	cmp	w0, #0x0
    40001554:	54000041 	b.ne	4000155c <UART_reset+0x8c>  // b.any
    40001558:	17ffffec 	b	40001508 <UART_reset+0x38>
    4000155c:	d503201f 	nop
    40001560:	a8c47bfd 	ldp	x29, x30, [sp], #64
    40001564:	d65f03c0 	ret

0000000040001568 <UART_init>:
    40001568:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    4000156c:	910003fd 	mov	x29, sp
    40001570:	b9001fe0 	str	w0, [sp, #28]
    40001574:	90000000 	adrp	x0, 40001000 <UART_UCR1_write+0x4>
    40001578:	9125e000 	add	x0, x0, #0x978
    4000157c:	b9401fe1 	ldr	w1, [sp, #28]
    40001580:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    40001584:	f90037e0 	str	x0, [sp, #104]
    40001588:	b90063ff 	str	wzr, [sp, #96]
    4000158c:	910183e0 	add	x0, sp, #0x60
    40001590:	52800021 	mov	w1, #0x1                   	// #1
    40001594:	97fffea4 	bl	40001024 <UART_UCR1_BF_set_UARTEN>
    40001598:	b94063e1 	ldr	w1, [sp, #96]
    4000159c:	f94037e0 	ldr	x0, [sp, #104]
    400015a0:	97fffe97 	bl	40000ffc <UART_UCR1_write>
    400015a4:	b9005bff 	str	wzr, [sp, #88]
    400015a8:	910163e0 	add	x0, sp, #0x58
    400015ac:	52800021 	mov	w1, #0x1                   	// #1
    400015b0:	97fffef2 	bl	40001178 <UART_UCR2_BF_set_SRST>
    400015b4:	910163e0 	add	x0, sp, #0x58
    400015b8:	52800021 	mov	w1, #0x1                   	// #1
    400015bc:	97fffee1 	bl	40001140 <UART_UCR2_BF_set_RXEN>
    400015c0:	910163e0 	add	x0, sp, #0x58
    400015c4:	52800021 	mov	w1, #0x1                   	// #1
    400015c8:	97fffed0 	bl	40001108 <UART_UCR2_BF_set_TXEN>
    400015cc:	910163e0 	add	x0, sp, #0x58
    400015d0:	52800021 	mov	w1, #0x1                   	// #1
    400015d4:	97fffebf 	bl	400010d0 <UART_UCR2_BF_set_WS>
    400015d8:	910163e0 	add	x0, sp, #0x58
    400015dc:	52800021 	mov	w1, #0x1                   	// #1
    400015e0:	97fffeae 	bl	40001098 <UART_UCR2_BF_set_IRTS>
    400015e4:	b9405be1 	ldr	w1, [sp, #88]
    400015e8:	f94037e0 	ldr	x0, [sp, #104]
    400015ec:	97fffea1 	bl	40001070 <UART_UCR2_write>
    400015f0:	b90053ff 	str	wzr, [sp, #80]
    400015f4:	910143e0 	add	x0, sp, #0x50
    400015f8:	52800021 	mov	w1, #0x1                   	// #1
    400015fc:	97ffff1f 	bl	40001278 <UART_UCR3_BF_set_RXDMUXSEL>
    40001600:	910143e0 	add	x0, sp, #0x50
    40001604:	52800021 	mov	w1, #0x1                   	// #1
    40001608:	97ffff0e 	bl	40001240 <UART_UCR3_BF_set_RI>
    4000160c:	910143e0 	add	x0, sp, #0x50
    40001610:	52800021 	mov	w1, #0x1                   	// #1
    40001614:	97fffefd 	bl	40001208 <UART_UCR3_BF_set_DCD>
    40001618:	910143e0 	add	x0, sp, #0x50
    4000161c:	52800021 	mov	w1, #0x1                   	// #1
    40001620:	97fffeec 	bl	400011d0 <UART_UCR3_BF_set_DSR>
    40001624:	b94053e1 	ldr	w1, [sp, #80]
    40001628:	f94037e0 	ldr	x0, [sp, #104]
    4000162c:	97fffedf 	bl	400011a8 <UART_UCR3_write>
    40001630:	b9004bff 	str	wzr, [sp, #72]
    40001634:	910123e0 	add	x0, sp, #0x48
    40001638:	528003e1 	mov	w1, #0x1f                  	// #31
    4000163c:	97ffff27 	bl	400012d8 <UART_UCR4_BF_set_CTSTL>
    40001640:	b9404be1 	ldr	w1, [sp, #72]
    40001644:	f94037e0 	ldr	x0, [sp, #104]
    40001648:	97ffff1a 	bl	400012b0 <UART_UCR4_write>
    4000164c:	52814020 	mov	w0, #0xa01                 	// #2561
    40001650:	b90043e0 	str	w0, [sp, #64]
    40001654:	b94043e1 	ldr	w1, [sp, #64]
    40001658:	f94037e0 	ldr	x0, [sp, #104]
    4000165c:	97ffff2d 	bl	40001310 <UART_UFCR_write>
    40001660:	b9003bff 	str	wzr, [sp, #56]
    40001664:	9100e3e0 	add	x0, sp, #0x38
    40001668:	528001e1 	mov	w1, #0xf                   	// #15
    4000166c:	97fffe42 	bl	40000f74 <UART_UBIR_BF_set_INC>
    40001670:	b9403be1 	ldr	w1, [sp, #56]
    40001674:	f94037e0 	ldr	x0, [sp, #104]
    40001678:	97fffe35 	bl	40000f4c <UART_UBIR_write>
    4000167c:	b90033ff 	str	wzr, [sp, #48]
    40001680:	9100c3e0 	add	x0, sp, #0x30
    40001684:	52800d01 	mov	w1, #0x68                  	// #104
    40001688:	97fffe51 	bl	40000fcc <UART_UBMR_BF_set_MOD>
    4000168c:	b94033e1 	ldr	w1, [sp, #48]
    40001690:	f94037e0 	ldr	x0, [sp, #104]
    40001694:	97fffe44 	bl	40000fa4 <UART_UBMR_write>
    40001698:	b9002bff 	str	wzr, [sp, #40]
    4000169c:	b9402be1 	ldr	w1, [sp, #40]
    400016a0:	f94037e0 	ldr	x0, [sp, #104]
    400016a4:	97ffff25 	bl	40001338 <UART_UMCR_write>
    400016a8:	d503201f 	nop
    400016ac:	a8c77bfd 	ldp	x29, x30, [sp], #112
    400016b0:	d65f03c0 	ret
	...

Disassembly of section .rodata:

00000000400016c0 <STDINT_REPR_CHARS-0x128>:
    400016c0:	696e6150 	ldpsw	x16, x24, [x10, #-144]
    400016c4:	656d2063 	fmls	z3.h, p0/m, z3.h, z13.h
    400016c8:	67617373 	.inst	0x67617373 ; undefined
    400016cc:	6f6e2065 	umlal2	v5.4s, v3.8h, v14.h[2]
    400016d0:	65642074 	fmls	z20.h, p0/m, z3.h, z4.h
    400016d4:	656e6966 	fnmls	z6.h, p2/m, z11.h, z14.h
    400016d8:	6e612064 	usubl2	v4.4s, v3.8h, v1.8h
    400016dc:	6f6e2064 	umlal2	v4.4s, v3.8h, v14.h[2]
    400016e0:	68632074 	.inst	0x68632074 ; undefined
    400016e4:	65676e61 	fnmls	z1.h, p3/m, z19.h, z7.h
    400016e8:	72662064 	.inst	0x72662064 ; undefined
    400016ec:	69206d6f 	stgp	x15, x27, [x11, #-1024]
    400016f0:	5f74696e 	.inst	0x5f74696e ; undefined
    400016f4:	696e6170 	ldpsw	x16, x24, [x11, #-144]
    400016f8:	20292863 	.inst	0x20292863 ; undefined
    400016fc:	74696e69 	.inst	0x74696e69 ; undefined
    40001700:	696c6169 	ldpsw	x9, x24, [x11, #-160]
    40001704:	6974617a 	ldpsw	x26, x24, [x11, #-96]
    40001708:	73206e6f 	.inst	0x73206e6f ; undefined
    4000170c:	65676174 	fnmls	z20.h, p0/m, z11.h, z7.h
    40001710:	0000002e 	udf	#46
    40001714:	00000000 	udf	#0
    40001718:	696e6150 	ldpsw	x16, x24, [x10, #-144]
    4000171c:	69662063 	ldpsw	x3, x8, [x3, #-208]
    40001720:	6e20656c 	umax	v12.16b, v11.16b, v0.16b
    40001724:	6420746f 	.inst	0x6420746f ; undefined
    40001728:	6e696665 	umax	v5.8h, v19.8h, v9.8h
    4000172c:	00006465 	udf	#25701
    40001730:	505b0d0a 	adr	x10, 400b78d2 <__stack_el1_bottom+0xb48d2>
    40001734:	43494e41 	.inst	0x43494e41 ; undefined
    40001738:	0d0a5d21 	.inst	0x0d0a5d21 ; undefined
    4000173c:	696e6150 	ldpsw	x16, x24, [x10, #-144]
    40001740:	69662063 	ldpsw	x3, x8, [x3, #-208]
    40001744:	093a656c 	.inst	0x093a656c ; undefined
	...
    40001750:	20746120 	.inst	0x20746120 ; undefined
    40001754:	656e696c 	fnmls	z12.h, p2/m, z11.h, z14.h
    40001758:	00000020 	udf	#32
    4000175c:	00000000 	udf	#0
    40001760:	0000003a 	udf	#58
    40001764:	00000000 	udf	#0
    40001768:	61500d0a 	.inst	0x61500d0a ; undefined
    4000176c:	2063696e 	.inst	0x2063696e ; undefined
    40001770:	7373656d 	.inst	0x7373656d ; undefined
    40001774:	3a656761 	.inst	0x3a656761 ; undefined
    40001778:	00000009 	udf	#9
    4000177c:	00000000 	udf	#0
    40001780:	00000d0a 	udf	#3338
    40001784:	00000000 	udf	#0
    40001788:	746e6975 	.inst	0x746e6975 ; undefined
    4000178c:	6f745f38 	.inst	0x6f745f38 ; undefined
    40001790:	6373615f 	.inst	0x6373615f ; undefined
    40001794:	635f6969 	.inst	0x635f6969 ; undefined
    40001798:	3a726168 	.inst	0x3a726168 ; undefined
    4000179c:	71657220 	subs	w0, w17, #0x95c, lsl #12
    400017a0:	65726975 	fnmls	z21.h, p2/m, z11.h, z18.h
    400017a4:	68742073 	.inst	0x68742073 ; undefined
    400017a8:	6e692065 	usubl2	v5.4s, v3.8h, v9.8h
    400017ac:	20747570 	.inst	0x20747570 ; undefined
    400017b0:	626d756e 	.inst	0x626d756e ; undefined
    400017b4:	74207265 	.inst	0x74207265 ; undefined
    400017b8:	6562206f 	fmls	z15.h, p0/m, z3.h, z2.h
    400017bc:	74656220 	.inst	0x74656220 ; undefined
    400017c0:	6e656577 	umax	v23.8h, v11.8h, v5.8h
    400017c4:	61203020 	.inst	0x61203020 ; undefined
    400017c8:	3920646e 	strb	w14, [x3, #2073]
    400017cc:	00000000 	udf	#0
    400017d0:	6372735f 	.inst	0x6372735f ; undefined
    400017d4:	62696c2f 	.inst	0x62696c2f ; undefined
    400017d8:	7274732f 	.inst	0x7274732f ; undefined
    400017dc:	2e676e69 	umin	v9.4h, v19.4h, v7.4h
    400017e0:	00000063 	udf	#99
    400017e4:	00000000 	udf	#0

00000000400017e8 <STDINT_REPR_CHARS>:
    400017e8:	33323130 	.inst	0x33323130 ; undefined
    400017ec:	37363534 	tbnz	w20, #6, 3fffde90 <_start-0x2170>
    400017f0:	42413938 	.inst	0x42413938 ; undefined
    400017f4:	46454443 	.inst	0x46454443 ; undefined
    400017f8:	78656e55 	.inst	0x78656e55 ; undefined
    400017fc:	74636570 	.inst	0x74636570 ; undefined
    40001800:	76206465 	.inst	0x76206465 ; undefined
    40001804:	65756c61 	fnmls	z1.h, p3/m, z3.h, z21.h
    40001808:	20666f20 	.inst	0x20666f20 ; undefined
    4000180c:	72706572 	.inst	0x72706572 ; undefined
	...
    40001818:	69647473 	ldpsw	x19, x29, [x3, #-224]
    4000181c:	745f746e 	.inst	0x745f746e ; undefined
    40001820:	73615f6f 	.inst	0x73615f6f ; undefined
    40001824:	3a696963 	.inst	0x3a696963 ; undefined
    40001828:	44545320 	smlslb	z0.h, z25.b, z20.b
    4000182c:	5f544e49 	.inst	0x5f544e49 ; undefined
    40001830:	45505954 	usubwb	z20.h, z10.h, z16.b
    40001834:	61632053 	.inst	0x61632053 ; undefined
    40001838:	6e206573 	umax	v19.16b, v11.16b, v0.16b
    4000183c:	7320746f 	.inst	0x7320746f ; undefined
    40001840:	6f707075 	fcmla	v21.8h, v3.8h, v16.h[1], #270
    40001844:	64657472 	.inst	0x64657472 ; undefined
	...
    40001850:	69647473 	ldpsw	x19, x29, [x3, #-224]
    40001854:	745f746e 	.inst	0x745f746e ; undefined
    40001858:	73615f6f 	.inst	0x73615f6f ; undefined
    4000185c:	3a696963 	.inst	0x3a696963 ; undefined
    40001860:	6f727020 	fcmla	v0.8h, v1.8h, v18.h[1], #270
    40001864:	65646976 	fnmls	z22.h, p2/m, z11.h, z4.h
    40001868:	75622064 	.inst	0x75622064 ; undefined
    4000186c:	72656666 	.inst	0x72656666 ; undefined
    40001870:	20736920 	.inst	0x20736920 ; undefined
    40001874:	6c616d73 	ldnp	d19, d27, [x11, #-496]
    40001878:	2072656c 	.inst	0x2072656c ; undefined
    4000187c:	6e616874 	fcvtxn2	v20.4s, v3.2d
    40001880:	71657220 	subs	w0, w17, #0x95c, lsl #12
    40001884:	64656975 	.inst	0x64656975 ; undefined
    40001888:	726f6620 	.inst	0x726f6620 ; undefined
    4000188c:	6f727020 	fcmla	v0.8h, v1.8h, v18.h[1], #270
    40001890:	65646976 	fnmls	z22.h, p2/m, z11.h, z4.h
    40001894:	74732064 	.inst	0x74732064 ; undefined
    40001898:	746e6964 	.inst	0x746e6964 ; undefined
    4000189c:	00000000 	udf	#0
    400018a0:	636d656d 	.inst	0x636d656d ; undefined
    400018a4:	34367970 	cbz	w16, 4006e7d0 <__stack_el1_bottom+0x6b7d0>
    400018a8:	696c615f 	ldpsw	xzr, x24, [x10, #-160]
    400018ac:	64656e67 	.inst	0x64656e67 ; undefined
    400018b0:	7364203a 	.inst	0x7364203a ; undefined
    400018b4:	6f6e2074 	umlal2	v20.4s, v3.8h, v14.h[2]
    400018b8:	6c612074 	ldnp	d20, d8, [x3, #-496]
    400018bc:	656e6769 	fnmls	z9.h, p1/m, z27.h, z14.h
    400018c0:	6f742064 	umlal2	v4.4s, v3.8h, v4.h[3]
    400018c4:	20343620 	.inst	0x20343620 ; undefined
    400018c8:	65747962 	fnmls	z2.h, p6/m, z11.h, z20.h
    400018cc:	00000073 	udf	#115
    400018d0:	6372735f 	.inst	0x6372735f ; undefined
    400018d4:	62696c2f 	.inst	0x62696c2f ; undefined
    400018d8:	6d656d2f 	ldp	d15, d27, [x9, #-432]
    400018dc:	2f797063 	fcmla	v3.4h, v3.4h, v25.h[1], #270
    400018e0:	636d656d 	.inst	0x636d656d ; undefined
    400018e4:	632e7970 	.inst	0x632e7970 ; undefined
	...
    400018f0:	636d656d 	.inst	0x636d656d ; undefined
    400018f4:	34367970 	cbz	w16, 4006e820 <__stack_el1_bottom+0x6b820>
    400018f8:	696c615f 	ldpsw	xzr, x24, [x10, #-160]
    400018fc:	64656e67 	.inst	0x64656e67 ; undefined
    40001900:	7273203a 	.inst	0x7273203a ; undefined
    40001904:	6f6e2063 	umlal2	v3.4s, v3.8h, v14.h[2]
    40001908:	6c612074 	ldnp	d20, d8, [x3, #-496]
    4000190c:	656e6769 	fnmls	z9.h, p1/m, z27.h, z14.h
    40001910:	6f742064 	umlal2	v4.4s, v3.8h, v4.h[3]
    40001914:	20343620 	.inst	0x20343620 ; undefined
    40001918:	65747962 	fnmls	z2.h, p6/m, z11.h, z20.h
    4000191c:	00000073 	udf	#115
    40001920:	636d656d 	.inst	0x636d656d ; undefined
    40001924:	34367970 	cbz	w16, 4006e850 <__stack_el1_bottom+0x6b850>
    40001928:	696c615f 	ldpsw	xzr, x24, [x10, #-160]
    4000192c:	64656e67 	.inst	0x64656e67 ; undefined
    40001930:	6973203a 	ldpsw	x26, x8, [x1, #-104]
    40001934:	6920657a 	stgp	x26, x25, [x11, #-1024]
    40001938:	6f6e2073 	umlal2	v19.4s, v3.8h, v14.h[2]
    4000193c:	20612074 	.inst	0x20612074 ; undefined
    40001940:	746c756d 	.inst	0x746c756d ; undefined
    40001944:	656c7069 	fnmls	z9.h, p4/m, z3.h, z12.h
    40001948:	20666f20 	.inst	0x20666f20 ; undefined
    4000194c:	00003436 	udf	#13366
    40001950:	636d656d 	.inst	0x636d656d ; undefined
    40001954:	34367970 	cbz	w16, 4006e880 <__stack_el1_bottom+0x6b880>
    40001958:	6973203a 	ldpsw	x26, x8, [x1, #-104]
    4000195c:	6920657a 	stgp	x26, x25, [x11, #-1024]
    40001960:	6f6e2073 	umlal2	v19.4s, v3.8h, v14.h[2]
    40001964:	20612074 	.inst	0x20612074 ; undefined
    40001968:	746c756d 	.inst	0x746c756d ; undefined
    4000196c:	656c7069 	fnmls	z9.h, p4/m, z3.h, z12.h
    40001970:	20666f20 	.inst	0x20666f20 ; undefined
    40001974:	00003436 	udf	#13366

0000000040001978 <UART_N_BASE>:
    40001978:	30860000 	adr	x0, 3ff0d979 <_start-0xf2687>
    4000197c:	00000000 	udf	#0
    40001980:	30890000 	adr	x0, 3ff13981 <_start-0xec67f>
    40001984:	00000000 	udf	#0
    40001988:	30880000 	adr	x0, 3ff11989 <_start-0xee677>
    4000198c:	00000000 	udf	#0
    40001990:	30a60000 	adr	x0, 3ff4d991 <_start-0xb266f>
	...

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	3a434347 	ccmn	w26, w3, #0x7, mi	// mi = first
   4:	72412820 	.inst	0x72412820 ; undefined
   8:	4e47206d 	luti4	v13.16b, {v3.16b}, v7[0]
   c:	6f542055 	umlal2	v21.4s, v2.8h, v4.h[1]
  10:	68636c6f 	.inst	0x68636c6f ; undefined
  14:	206e6961 	.inst	0x206e6961 ; undefined
  18:	322e3431 	orr	w17, w1, #0xfffc0000
  1c:	6c65522e 	ldnp	d14, d20, [x17, #-432]
  20:	42282031 	.inst	0x42282031 ; undefined
  24:	646c6975 	.inst	0x646c6975 ; undefined
  28:	6d726120 	ldp	d0, d24, [x9, #-224]
  2c:	2e34312d 	usubw	v13.8h, v9.8h, v20.8b
  30:	29293235 	stp	w21, w12, [x17, #-184]
  34:	2e343120 	usubw	v0.8h, v9.8h, v20.8b
  38:	20312e32 	.inst	0x20312e32 ; undefined
  3c:	34323032 	cbz	w18, 64640 <_start-0x3ff9b9c0>
  40:	39313131 	strb	w17, [x9, #3148]
	...
