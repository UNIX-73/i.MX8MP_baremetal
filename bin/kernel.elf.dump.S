
bin/kernel.elf:     file format elf64-littleaarch64


Disassembly of section .text:

0000000040000000 <_start>:
    40000000:	d5034fdf 	msr	daifset, #0xf
    40000004:	580000e0 	ldr	x0, 40000020 <hang+0x8>
    40000008:	9100001f 	mov	sp, x0
    4000000c:	580000e0 	ldr	x0, 40000028 <hang+0x10>
    40000010:	d51c4100 	msr	sp_el1, x0
    40000014:	9400000a 	bl	4000003c <kernel_entry>

0000000040000018 <hang>:
    40000018:	d503205f 	wfe
    4000001c:	17ffffff 	b	40000018 <hang>
    40000020:	40f01000 	.inst	0x40f01000 ; undefined
    40000024:	00000000 	udf	#0
    40000028:	40a01000 	.inst	0x40a01000 ; undefined
    4000002c:	00000000 	udf	#0

0000000040000030 <_currentEL>:
    40000030:	d5384240 	mrs	x0, currentel
    40000034:	d342fc00 	lsr	x0, x0, #2
    40000038:	d65f03c0 	ret

000000004000003c <kernel_entry>:
    4000003c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    40000040:	910003fd 	mov	x29, sp
    40000044:	97fffffb 	bl	40000030 <_currentEL>
    40000048:	12001c00 	and	w0, w0, #0xff
    4000004c:	1100c000 	add	w0, w0, #0x30
    40000050:	12001c00 	and	w0, w0, #0xff
    40000054:	2a0003e1 	mov	w1, w0
    40000058:	52800020 	mov	w0, #0x1                   	// #1
    4000005c:	9400001a 	bl	400000c4 <UART_putc>
    40000060:	b9001fff 	str	wzr, [sp, #28]
    40000064:	14000009 	b	40000088 <kernel_entry+0x4c>
    40000068:	d503201f 	nop
    4000006c:	d503201f 	nop
    40000070:	d503201f 	nop
    40000074:	d503201f 	nop
    40000078:	d503201f 	nop
    4000007c:	b9401fe0 	ldr	w0, [sp, #28]
    40000080:	11000400 	add	w0, w0, #0x1
    40000084:	b9001fe0 	str	w0, [sp, #28]
    40000088:	b9401fe1 	ldr	w1, [sp, #28]
    4000008c:	5281a7e0 	mov	w0, #0xd3f                 	// #3391
    40000090:	72a00060 	movk	w0, #0x3, lsl #16
    40000094:	6b00003f 	cmp	w1, w0
    40000098:	54fffe8d 	b.le	40000068 <kernel_entry+0x2c>
    4000009c:	17ffffea 	b	40000044 <kernel_entry+0x8>

00000000400000a0 <UART_UTXD_write>:
    400000a0:	d10043ff 	sub	sp, sp, #0x10
    400000a4:	f90007e0 	str	x0, [sp, #8]
    400000a8:	b90003e1 	str	w1, [sp]
    400000ac:	f94007e0 	ldr	x0, [sp, #8]
    400000b0:	91010000 	add	x0, x0, #0x40
    400000b4:	b94003e1 	ldr	w1, [sp]
    400000b8:	b9000001 	str	w1, [x0]
    400000bc:	910043ff 	add	sp, sp, #0x10
    400000c0:	d65f03c0 	ret

00000000400000c4 <UART_putc>:
    400000c4:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    400000c8:	910003fd 	mov	x29, sp
    400000cc:	b9001fe0 	str	w0, [sp, #28]
    400000d0:	39006fe1 	strb	w1, [sp, #27]
    400000d4:	39406fe0 	ldrb	w0, [sp, #27]
    400000d8:	b9002be0 	str	w0, [sp, #40]
    400000dc:	90000000 	adrp	x0, 40000000 <_start>
    400000e0:	91040000 	add	x0, x0, #0x100
    400000e4:	b9401fe1 	ldr	w1, [sp, #28]
    400000e8:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    400000ec:	b9402be1 	ldr	w1, [sp, #40]
    400000f0:	97ffffec 	bl	400000a0 <UART_UTXD_write>
    400000f4:	d503201f 	nop
    400000f8:	a8c37bfd 	ldp	x29, x30, [sp], #48
    400000fc:	d65f03c0 	ret

Disassembly of section .rodata:

0000000040000100 <UART_N_BASE>:
    40000100:	30860000 	adr	x0, 3ff0c101 <_start-0xf3eff>
    40000104:	00000000 	udf	#0
    40000108:	30890000 	adr	x0, 3ff12109 <_start-0xedef7>
    4000010c:	00000000 	udf	#0
    40000110:	30880000 	adr	x0, 3ff10111 <_start-0xefeef>
    40000114:	00000000 	udf	#0
    40000118:	30a60000 	adr	x0, 3ff4c119 <_start-0xb3ee7>
    4000011c:	00000000 	udf	#0

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
