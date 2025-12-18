
bin/kernel.elf:     file format elf64-littleaarch64


Disassembly of section .text:

0000000040000000 <_start>:
.section .text.boot
.global _start

_start:
    nop
    40000000:	d503201f 	nop
    //  disable DAIF exceptions
   // msr daifset, #0xf

#ifdef TEST
    mrs x0, CurrentEL
    40000004:	d5384240 	mrs	x0, currentel
    lsr x0, x0, #2 // x0 = x0 >> 2
    40000008:	d342fc00 	lsr	x0, x0, #2
    cmp x0, #2
    4000000c:	f100081f 	cmp	x0, #0x2
    b.ne hang
    40000010:	54000101 	b.ne	40000030 <hang>  // b.any
#endif

    //  Init EL2 stack
    ldr x0, =__stack_el2_top
    40000014:	58000120 	ldr	x0, 40000038 <hang+0x8>
    mov sp, x0
    40000018:	9100001f 	mov	sp, x0
    
    //  Init El1 stack
    ldr x0, =__stack_el1_top
    4000001c:	58000120 	ldr	x0, 40000040 <hang+0x10>
    msr SP_EL1, x0
    40000020:	d51c4100 	msr	sp_el1, x0

    //  Set EL2 vector table
    bl  _el2_init_vector
    40000024:	94000013 	bl	40000070 <_el2_init_vector>

    bl _clean_bss
    40000028:	94000306 	bl	40000c40 <_clean_bss>

    bl kernel_entry
    4000002c:	94000435 	bl	40001100 <kernel_entry>

0000000040000030 <hang>:

hang:
    wfe
    40000030:	d503205f 	wfe
    40000034:	17ffffff 	b	40000030 <hang>
    40000038:	41607000 	.inst	0x41607000 ; undefined
    4000003c:	00000000 	udf	#0
    40000040:	41107000 	.inst	0x41107000 ; undefined
    40000044:	00000000 	udf	#0

0000000040000048 <_ARM_currentEL>:
.section .text
.align 2

.global _ARM_currentEL
_ARM_currentEL:
    mrs x0, CurrentEL
    40000048:	d5384240 	mrs	x0, currentel
    lsr x0, x0, #2
    4000004c:	d342fc00 	lsr	x0, x0, #2
    ret
    40000050:	d65f03c0 	ret

0000000040000054 <_ARM_MPIDR_EL1>:

.global _ARM_MPIDR_EL1
_ARM_MPIDR_EL1:
    mrs x0, MPIDR_EL1
    40000054:	d53800a0 	mrs	x0, mpidr_el1
    ret
    40000058:	d65f03c0 	ret

000000004000005c <_ARM_ICC_SRE_EL2>:

.global _ARM_ICC_SRE_EL2
_ARM_ICC_SRE_EL2:
    mrs x0, ICC_SRE_EL2
    4000005c:	d53cc9a0 	mrs	x0, icc_sre_el2
    ret
    40000060:	d65f03c0 	ret

0000000040000064 <_ARM_HCR_EL2>:

.global _ARM_HCR_EL2
_ARM_HCR_EL2:
    mrs x0, HCR_EL2
    40000064:	d53c1100 	mrs	x0, hcr_el2
    40000068:	d65f03c0 	ret
    4000006c:	00000000 	udf	#0

0000000040000070 <_el2_init_vector>:
.section .text
.global _el2_init_vector
.align 4
_el2_init_vector:
    adr     x0, _el2_vector_table
    40000070:	1001fc80 	adr	x0, 40004000 <_el2_vector_table>
    msr     VBAR_EL2, x0
    40000074:	d51cc000 	msr	vbar_el2, x0
    isb
    40000078:	d5033fdf 	isb
    ret
    4000007c:	d65f03c0 	ret

0000000040000080 <_el2_cur_sp0_sync>:
.endm

.section .text
.align 4
_el2_cur_sp0_sync:
    EL2_CALL_WITH_CONTEXT el2_cur_sp0_sync_handler
    40000080:	d10403ff 	sub	sp, sp, #0x100
    40000084:	a90007e0 	stp	x0, x1, [sp]
    40000088:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000008c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000090:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000094:	a90427e8 	stp	x8, x9, [sp, #64]
    40000098:	a9052fea 	stp	x10, x11, [sp, #80]
    4000009c:	a90637ec 	stp	x12, x13, [sp, #96]
    400000a0:	a9073fee 	stp	x14, x15, [sp, #112]
    400000a4:	a90847f0 	stp	x16, x17, [sp, #128]
    400000a8:	a9094ff2 	stp	x18, x19, [sp, #144]
    400000ac:	a90a57f4 	stp	x20, x21, [sp, #160]
    400000b0:	a90b5ff6 	stp	x22, x23, [sp, #176]
    400000b4:	a90c67f8 	stp	x24, x25, [sp, #192]
    400000b8:	a90d6ffa 	stp	x26, x27, [sp, #208]
    400000bc:	a90e77fc 	stp	x28, x29, [sp, #224]
    400000c0:	f9007bfe 	str	x30, [sp, #240]
    400000c4:	94000586 	bl	400016dc <el2_cur_sp0_sync_handler>
    400000c8:	a94007e0 	ldp	x0, x1, [sp]
    400000cc:	a9410fe2 	ldp	x2, x3, [sp, #16]
    400000d0:	a94217e4 	ldp	x4, x5, [sp, #32]
    400000d4:	a9431fe6 	ldp	x6, x7, [sp, #48]
    400000d8:	a94427e8 	ldp	x8, x9, [sp, #64]
    400000dc:	a9452fea 	ldp	x10, x11, [sp, #80]
    400000e0:	a94637ec 	ldp	x12, x13, [sp, #96]
    400000e4:	a9473fee 	ldp	x14, x15, [sp, #112]
    400000e8:	a94847f0 	ldp	x16, x17, [sp, #128]
    400000ec:	a9494ff2 	ldp	x18, x19, [sp, #144]
    400000f0:	a94a57f4 	ldp	x20, x21, [sp, #160]
    400000f4:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    400000f8:	a94c67f8 	ldp	x24, x25, [sp, #192]
    400000fc:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000100:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000104:	f9407bfe 	ldr	x30, [sp, #240]
    40000108:	910403ff 	add	sp, sp, #0x100
    4000010c:	d69f03e0 	eret

0000000040000110 <_el2_cur_sp0_irq>:

_el2_cur_sp0_irq:
    EL2_CALL_WITH_CONTEXT el2_cur_sp0_irq_handler
    40000110:	d10403ff 	sub	sp, sp, #0x100
    40000114:	a90007e0 	stp	x0, x1, [sp]
    40000118:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000011c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000120:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000124:	a90427e8 	stp	x8, x9, [sp, #64]
    40000128:	a9052fea 	stp	x10, x11, [sp, #80]
    4000012c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000130:	a9073fee 	stp	x14, x15, [sp, #112]
    40000134:	a90847f0 	stp	x16, x17, [sp, #128]
    40000138:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000013c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000140:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000144:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000148:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000014c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000150:	f9007bfe 	str	x30, [sp, #240]
    40000154:	940004a4 	bl	400013e4 <el2_cur_sp0_irq_handler>
    40000158:	a94007e0 	ldp	x0, x1, [sp]
    4000015c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000160:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000164:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000168:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000016c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000170:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000174:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000178:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000017c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000180:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000184:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000188:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000018c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000190:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000194:	f9407bfe 	ldr	x30, [sp, #240]
    40000198:	910403ff 	add	sp, sp, #0x100
    4000019c:	d69f03e0 	eret

00000000400001a0 <_el2_cur_sp0_fiq>:

_el2_cur_sp0_fiq:
    EL2_CALL_WITH_CONTEXT el2_cur_sp0_fiq_handler
    400001a0:	d10403ff 	sub	sp, sp, #0x100
    400001a4:	a90007e0 	stp	x0, x1, [sp]
    400001a8:	a9010fe2 	stp	x2, x3, [sp, #16]
    400001ac:	a90217e4 	stp	x4, x5, [sp, #32]
    400001b0:	a9031fe6 	stp	x6, x7, [sp, #48]
    400001b4:	a90427e8 	stp	x8, x9, [sp, #64]
    400001b8:	a9052fea 	stp	x10, x11, [sp, #80]
    400001bc:	a90637ec 	stp	x12, x13, [sp, #96]
    400001c0:	a9073fee 	stp	x14, x15, [sp, #112]
    400001c4:	a90847f0 	stp	x16, x17, [sp, #128]
    400001c8:	a9094ff2 	stp	x18, x19, [sp, #144]
    400001cc:	a90a57f4 	stp	x20, x21, [sp, #160]
    400001d0:	a90b5ff6 	stp	x22, x23, [sp, #176]
    400001d4:	a90c67f8 	stp	x24, x25, [sp, #192]
    400001d8:	a90d6ffa 	stp	x26, x27, [sp, #208]
    400001dc:	a90e77fc 	stp	x28, x29, [sp, #224]
    400001e0:	f9007bfe 	str	x30, [sp, #240]
    400001e4:	940004f2 	bl	400015ac <el2_cur_sp0_fiq_handler>
    400001e8:	a94007e0 	ldp	x0, x1, [sp]
    400001ec:	a9410fe2 	ldp	x2, x3, [sp, #16]
    400001f0:	a94217e4 	ldp	x4, x5, [sp, #32]
    400001f4:	a9431fe6 	ldp	x6, x7, [sp, #48]
    400001f8:	a94427e8 	ldp	x8, x9, [sp, #64]
    400001fc:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000200:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000204:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000208:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000020c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000210:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000214:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000218:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000021c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000220:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000224:	f9407bfe 	ldr	x30, [sp, #240]
    40000228:	910403ff 	add	sp, sp, #0x100
    4000022c:	d69f03e0 	eret

0000000040000230 <_el2_cur_sp0_serror>:

_el2_cur_sp0_serror:
    EL2_CALL_WITH_CONTEXT el2_cur_sp0_serror_handler
    40000230:	d10403ff 	sub	sp, sp, #0x100
    40000234:	a90007e0 	stp	x0, x1, [sp]
    40000238:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000023c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000240:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000244:	a90427e8 	stp	x8, x9, [sp, #64]
    40000248:	a9052fea 	stp	x10, x11, [sp, #80]
    4000024c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000250:	a9073fee 	stp	x14, x15, [sp, #112]
    40000254:	a90847f0 	stp	x16, x17, [sp, #128]
    40000258:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000025c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000260:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000264:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000268:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000026c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000270:	f9007bfe 	str	x30, [sp, #240]
    40000274:	9400046f 	bl	40001430 <el2_cur_sp0_serror_handler>
    40000278:	a94007e0 	ldp	x0, x1, [sp]
    4000027c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000280:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000284:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000288:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000028c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000290:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000294:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000298:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000029c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    400002a0:	a94a57f4 	ldp	x20, x21, [sp, #160]
    400002a4:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    400002a8:	a94c67f8 	ldp	x24, x25, [sp, #192]
    400002ac:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    400002b0:	a94e77fc 	ldp	x28, x29, [sp, #224]
    400002b4:	f9407bfe 	ldr	x30, [sp, #240]
    400002b8:	910403ff 	add	sp, sp, #0x100
    400002bc:	d69f03e0 	eret

00000000400002c0 <_el2_cur_spx_sync>:

_el2_cur_spx_sync:
    EL2_CALL_WITH_CONTEXT el2_cur_spx_sync_handler
    400002c0:	d10403ff 	sub	sp, sp, #0x100
    400002c4:	a90007e0 	stp	x0, x1, [sp]
    400002c8:	a9010fe2 	stp	x2, x3, [sp, #16]
    400002cc:	a90217e4 	stp	x4, x5, [sp, #32]
    400002d0:	a9031fe6 	stp	x6, x7, [sp, #48]
    400002d4:	a90427e8 	stp	x8, x9, [sp, #64]
    400002d8:	a9052fea 	stp	x10, x11, [sp, #80]
    400002dc:	a90637ec 	stp	x12, x13, [sp, #96]
    400002e0:	a9073fee 	stp	x14, x15, [sp, #112]
    400002e4:	a90847f0 	stp	x16, x17, [sp, #128]
    400002e8:	a9094ff2 	stp	x18, x19, [sp, #144]
    400002ec:	a90a57f4 	stp	x20, x21, [sp, #160]
    400002f0:	a90b5ff6 	stp	x22, x23, [sp, #176]
    400002f4:	a90c67f8 	stp	x24, x25, [sp, #192]
    400002f8:	a90d6ffa 	stp	x26, x27, [sp, #208]
    400002fc:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000300:	f9007bfe 	str	x30, [sp, #240]
    40000304:	940004d0 	bl	40001644 <el2_cur_spx_sync_handler>
    40000308:	a94007e0 	ldp	x0, x1, [sp]
    4000030c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000310:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000314:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000318:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000031c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000320:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000324:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000328:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000032c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000330:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000334:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000338:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000033c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000340:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000344:	f9407bfe 	ldr	x30, [sp, #240]
    40000348:	910403ff 	add	sp, sp, #0x100
    4000034c:	d69f03e0 	eret

0000000040000350 <_el2_cur_spx_irq>:

_el2_cur_spx_irq:
    EL2_CALL_WITH_CONTEXT el2_cur_spx_irq_handler
    40000350:	d10403ff 	sub	sp, sp, #0x100
    40000354:	a90007e0 	stp	x0, x1, [sp]
    40000358:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000035c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000360:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000364:	a90427e8 	stp	x8, x9, [sp, #64]
    40000368:	a9052fea 	stp	x10, x11, [sp, #80]
    4000036c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000370:	a9073fee 	stp	x14, x15, [sp, #112]
    40000374:	a90847f0 	stp	x16, x17, [sp, #128]
    40000378:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000037c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000380:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000384:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000388:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000038c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000390:	f9007bfe 	str	x30, [sp, #240]
    40000394:	940004e5 	bl	40001728 <el2_cur_spx_irq_handler>
    40000398:	a94007e0 	ldp	x0, x1, [sp]
    4000039c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    400003a0:	a94217e4 	ldp	x4, x5, [sp, #32]
    400003a4:	a9431fe6 	ldp	x6, x7, [sp, #48]
    400003a8:	a94427e8 	ldp	x8, x9, [sp, #64]
    400003ac:	a9452fea 	ldp	x10, x11, [sp, #80]
    400003b0:	a94637ec 	ldp	x12, x13, [sp, #96]
    400003b4:	a9473fee 	ldp	x14, x15, [sp, #112]
    400003b8:	a94847f0 	ldp	x16, x17, [sp, #128]
    400003bc:	a9494ff2 	ldp	x18, x19, [sp, #144]
    400003c0:	a94a57f4 	ldp	x20, x21, [sp, #160]
    400003c4:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    400003c8:	a94c67f8 	ldp	x24, x25, [sp, #192]
    400003cc:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    400003d0:	a94e77fc 	ldp	x28, x29, [sp, #224]
    400003d4:	f9407bfe 	ldr	x30, [sp, #240]
    400003d8:	910403ff 	add	sp, sp, #0x100
    400003dc:	d69f03e0 	eret

00000000400003e0 <_el2_cur_spx_fiq>:

_el2_cur_spx_fiq:
    EL2_CALL_WITH_CONTEXT el2_cur_spx_fiq_handler
    400003e0:	d10403ff 	sub	sp, sp, #0x100
    400003e4:	a90007e0 	stp	x0, x1, [sp]
    400003e8:	a9010fe2 	stp	x2, x3, [sp, #16]
    400003ec:	a90217e4 	stp	x4, x5, [sp, #32]
    400003f0:	a9031fe6 	stp	x6, x7, [sp, #48]
    400003f4:	a90427e8 	stp	x8, x9, [sp, #64]
    400003f8:	a9052fea 	stp	x10, x11, [sp, #80]
    400003fc:	a90637ec 	stp	x12, x13, [sp, #96]
    40000400:	a9073fee 	stp	x14, x15, [sp, #112]
    40000404:	a90847f0 	stp	x16, x17, [sp, #128]
    40000408:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000040c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000410:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000414:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000418:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000041c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000420:	f9007bfe 	str	x30, [sp, #240]
    40000424:	9400043c 	bl	40001514 <el2_cur_spx_fiq_handler>
    40000428:	a94007e0 	ldp	x0, x1, [sp]
    4000042c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000430:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000434:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000438:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000043c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000440:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000444:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000448:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000044c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000450:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000454:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000458:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000045c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000460:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000464:	f9407bfe 	ldr	x30, [sp, #240]
    40000468:	910403ff 	add	sp, sp, #0x100
    4000046c:	d69f03e0 	eret

0000000040000470 <_el2_cur_spx_serror>:

_el2_cur_spx_serror:
    EL2_CALL_WITH_CONTEXT el2_cur_spx_serror_handler
    40000470:	d10403ff 	sub	sp, sp, #0x100
    40000474:	a90007e0 	stp	x0, x1, [sp]
    40000478:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000047c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000480:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000484:	a90427e8 	stp	x8, x9, [sp, #64]
    40000488:	a9052fea 	stp	x10, x11, [sp, #80]
    4000048c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000490:	a9073fee 	stp	x14, x15, [sp, #112]
    40000494:	a90847f0 	stp	x16, x17, [sp, #128]
    40000498:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000049c:	a90a57f4 	stp	x20, x21, [sp, #160]
    400004a0:	a90b5ff6 	stp	x22, x23, [sp, #176]
    400004a4:	a90c67f8 	stp	x24, x25, [sp, #192]
    400004a8:	a90d6ffa 	stp	x26, x27, [sp, #208]
    400004ac:	a90e77fc 	stp	x28, x29, [sp, #224]
    400004b0:	f9007bfe 	str	x30, [sp, #240]
    400004b4:	94000393 	bl	40001300 <el2_cur_spx_serror_handler>
    400004b8:	a94007e0 	ldp	x0, x1, [sp]
    400004bc:	a9410fe2 	ldp	x2, x3, [sp, #16]
    400004c0:	a94217e4 	ldp	x4, x5, [sp, #32]
    400004c4:	a9431fe6 	ldp	x6, x7, [sp, #48]
    400004c8:	a94427e8 	ldp	x8, x9, [sp, #64]
    400004cc:	a9452fea 	ldp	x10, x11, [sp, #80]
    400004d0:	a94637ec 	ldp	x12, x13, [sp, #96]
    400004d4:	a9473fee 	ldp	x14, x15, [sp, #112]
    400004d8:	a94847f0 	ldp	x16, x17, [sp, #128]
    400004dc:	a9494ff2 	ldp	x18, x19, [sp, #144]
    400004e0:	a94a57f4 	ldp	x20, x21, [sp, #160]
    400004e4:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    400004e8:	a94c67f8 	ldp	x24, x25, [sp, #192]
    400004ec:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    400004f0:	a94e77fc 	ldp	x28, x29, [sp, #224]
    400004f4:	f9407bfe 	ldr	x30, [sp, #240]
    400004f8:	910403ff 	add	sp, sp, #0x100
    400004fc:	d69f03e0 	eret

0000000040000500 <_el2_low_a64_sync>:

_el2_low_a64_sync:
    EL2_CALL_WITH_CONTEXT el2_low_a64_sync_handler
    40000500:	d10403ff 	sub	sp, sp, #0x100
    40000504:	a90007e0 	stp	x0, x1, [sp]
    40000508:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000050c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000510:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000514:	a90427e8 	stp	x8, x9, [sp, #64]
    40000518:	a9052fea 	stp	x10, x11, [sp, #80]
    4000051c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000520:	a9073fee 	stp	x14, x15, [sp, #112]
    40000524:	a90847f0 	stp	x16, x17, [sp, #128]
    40000528:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000052c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000530:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000534:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000538:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000053c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000540:	f9007bfe 	str	x30, [sp, #240]
    40000544:	94000395 	bl	40001398 <el2_low_a64_sync_handler>
    40000548:	a94007e0 	ldp	x0, x1, [sp]
    4000054c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000550:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000554:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000558:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000055c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000560:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000564:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000568:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000056c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000570:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000574:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000578:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000057c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000580:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000584:	f9407bfe 	ldr	x30, [sp, #240]
    40000588:	910403ff 	add	sp, sp, #0x100
    4000058c:	d69f03e0 	eret

0000000040000590 <_el2_low_a64_irq>:

_el2_low_a64_irq:
    EL2_CALL_WITH_CONTEXT el2_low_a64_irq_handler
    40000590:	d10403ff 	sub	sp, sp, #0x100
    40000594:	a90007e0 	stp	x0, x1, [sp]
    40000598:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000059c:	a90217e4 	stp	x4, x5, [sp, #32]
    400005a0:	a9031fe6 	stp	x6, x7, [sp, #48]
    400005a4:	a90427e8 	stp	x8, x9, [sp, #64]
    400005a8:	a9052fea 	stp	x10, x11, [sp, #80]
    400005ac:	a90637ec 	stp	x12, x13, [sp, #96]
    400005b0:	a9073fee 	stp	x14, x15, [sp, #112]
    400005b4:	a90847f0 	stp	x16, x17, [sp, #128]
    400005b8:	a9094ff2 	stp	x18, x19, [sp, #144]
    400005bc:	a90a57f4 	stp	x20, x21, [sp, #160]
    400005c0:	a90b5ff6 	stp	x22, x23, [sp, #176]
    400005c4:	a90c67f8 	stp	x24, x25, [sp, #192]
    400005c8:	a90d6ffa 	stp	x26, x27, [sp, #208]
    400005cc:	a90e77fc 	stp	x28, x29, [sp, #224]
    400005d0:	f9007bfe 	str	x30, [sp, #240]
    400005d4:	940003aa 	bl	4000147c <el2_low_a64_irq_handler>
    400005d8:	a94007e0 	ldp	x0, x1, [sp]
    400005dc:	a9410fe2 	ldp	x2, x3, [sp, #16]
    400005e0:	a94217e4 	ldp	x4, x5, [sp, #32]
    400005e4:	a9431fe6 	ldp	x6, x7, [sp, #48]
    400005e8:	a94427e8 	ldp	x8, x9, [sp, #64]
    400005ec:	a9452fea 	ldp	x10, x11, [sp, #80]
    400005f0:	a94637ec 	ldp	x12, x13, [sp, #96]
    400005f4:	a9473fee 	ldp	x14, x15, [sp, #112]
    400005f8:	a94847f0 	ldp	x16, x17, [sp, #128]
    400005fc:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000600:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000604:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000608:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000060c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000610:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000614:	f9407bfe 	ldr	x30, [sp, #240]
    40000618:	910403ff 	add	sp, sp, #0x100
    4000061c:	d69f03e0 	eret

0000000040000620 <_el2_low_a64_fiq>:

_el2_low_a64_fiq:
    EL2_CALL_WITH_CONTEXT el2_low_a64_fiq_handler
    40000620:	d10403ff 	sub	sp, sp, #0x100
    40000624:	a90007e0 	stp	x0, x1, [sp]
    40000628:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000062c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000630:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000634:	a90427e8 	stp	x8, x9, [sp, #64]
    40000638:	a9052fea 	stp	x10, x11, [sp, #80]
    4000063c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000640:	a9073fee 	stp	x14, x15, [sp, #112]
    40000644:	a90847f0 	stp	x16, x17, [sp, #128]
    40000648:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000064c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000650:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000654:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000658:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000065c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000660:	f9007bfe 	str	x30, [sp, #240]
    40000664:	94000399 	bl	400014c8 <el2_low_a64_fiq_handler>
    40000668:	a94007e0 	ldp	x0, x1, [sp]
    4000066c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000670:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000674:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000678:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000067c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000680:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000684:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000688:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000068c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000690:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000694:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000698:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000069c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    400006a0:	a94e77fc 	ldp	x28, x29, [sp, #224]
    400006a4:	f9407bfe 	ldr	x30, [sp, #240]
    400006a8:	910403ff 	add	sp, sp, #0x100
    400006ac:	d69f03e0 	eret

00000000400006b0 <_el2_low_a64_serror>:

_el2_low_a64_serror:
    EL2_CALL_WITH_CONTEXT el2_low_a64_serror_handler
    400006b0:	d10403ff 	sub	sp, sp, #0x100
    400006b4:	a90007e0 	stp	x0, x1, [sp]
    400006b8:	a9010fe2 	stp	x2, x3, [sp, #16]
    400006bc:	a90217e4 	stp	x4, x5, [sp, #32]
    400006c0:	a9031fe6 	stp	x6, x7, [sp, #48]
    400006c4:	a90427e8 	stp	x8, x9, [sp, #64]
    400006c8:	a9052fea 	stp	x10, x11, [sp, #80]
    400006cc:	a90637ec 	stp	x12, x13, [sp, #96]
    400006d0:	a9073fee 	stp	x14, x15, [sp, #112]
    400006d4:	a90847f0 	stp	x16, x17, [sp, #128]
    400006d8:	a9094ff2 	stp	x18, x19, [sp, #144]
    400006dc:	a90a57f4 	stp	x20, x21, [sp, #160]
    400006e0:	a90b5ff6 	stp	x22, x23, [sp, #176]
    400006e4:	a90c67f8 	stp	x24, x25, [sp, #192]
    400006e8:	a90d6ffa 	stp	x26, x27, [sp, #208]
    400006ec:	a90e77fc 	stp	x28, x29, [sp, #224]
    400006f0:	f9007bfe 	str	x30, [sp, #240]
    400006f4:	94000316 	bl	4000134c <el2_low_a64_serror_handler>
    400006f8:	a94007e0 	ldp	x0, x1, [sp]
    400006fc:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000700:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000704:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000708:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000070c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000710:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000714:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000718:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000071c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000720:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000724:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000728:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000072c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000730:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000734:	f9407bfe 	ldr	x30, [sp, #240]
    40000738:	910403ff 	add	sp, sp, #0x100
    4000073c:	d69f03e0 	eret

0000000040000740 <_el2_low_a32_sync>:

_el2_low_a32_sync:
    EL2_CALL_WITH_CONTEXT el2_low_a32_sync_handler
    40000740:	d10403ff 	sub	sp, sp, #0x100
    40000744:	a90007e0 	stp	x0, x1, [sp]
    40000748:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000074c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000750:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000754:	a90427e8 	stp	x8, x9, [sp, #64]
    40000758:	a9052fea 	stp	x10, x11, [sp, #80]
    4000075c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000760:	a9073fee 	stp	x14, x15, [sp, #112]
    40000764:	a90847f0 	stp	x16, x17, [sp, #128]
    40000768:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000076c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000770:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000774:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000778:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000077c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000780:	f9007bfe 	str	x30, [sp, #240]
    40000784:	940003c3 	bl	40001690 <el2_low_a32_sync_handler>
    40000788:	a94007e0 	ldp	x0, x1, [sp]
    4000078c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000790:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000794:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000798:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000079c:	a9452fea 	ldp	x10, x11, [sp, #80]
    400007a0:	a94637ec 	ldp	x12, x13, [sp, #96]
    400007a4:	a9473fee 	ldp	x14, x15, [sp, #112]
    400007a8:	a94847f0 	ldp	x16, x17, [sp, #128]
    400007ac:	a9494ff2 	ldp	x18, x19, [sp, #144]
    400007b0:	a94a57f4 	ldp	x20, x21, [sp, #160]
    400007b4:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    400007b8:	a94c67f8 	ldp	x24, x25, [sp, #192]
    400007bc:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    400007c0:	a94e77fc 	ldp	x28, x29, [sp, #224]
    400007c4:	f9407bfe 	ldr	x30, [sp, #240]
    400007c8:	910403ff 	add	sp, sp, #0x100
    400007cc:	d69f03e0 	eret

00000000400007d0 <_el2_low_a32_irq>:

_el2_low_a32_irq:
    EL2_CALL_WITH_CONTEXT el2_low_a32_irq_handler
    400007d0:	d10403ff 	sub	sp, sp, #0x100
    400007d4:	a90007e0 	stp	x0, x1, [sp]
    400007d8:	a9010fe2 	stp	x2, x3, [sp, #16]
    400007dc:	a90217e4 	stp	x4, x5, [sp, #32]
    400007e0:	a9031fe6 	stp	x6, x7, [sp, #48]
    400007e4:	a90427e8 	stp	x8, x9, [sp, #64]
    400007e8:	a9052fea 	stp	x10, x11, [sp, #80]
    400007ec:	a90637ec 	stp	x12, x13, [sp, #96]
    400007f0:	a9073fee 	stp	x14, x15, [sp, #112]
    400007f4:	a90847f0 	stp	x16, x17, [sp, #128]
    400007f8:	a9094ff2 	stp	x18, x19, [sp, #144]
    400007fc:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000800:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000804:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000808:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000080c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000810:	f9007bfe 	str	x30, [sp, #240]
    40000814:	94000353 	bl	40001560 <el2_low_a32_irq_handler>
    40000818:	a94007e0 	ldp	x0, x1, [sp]
    4000081c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000820:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000824:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000828:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000082c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000830:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000834:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000838:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000083c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000840:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000844:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000848:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000084c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000850:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000854:	f9407bfe 	ldr	x30, [sp, #240]
    40000858:	910403ff 	add	sp, sp, #0x100
    4000085c:	d69f03e0 	eret

0000000040000860 <_el2_low_a32_fiq>:

_el2_low_a32_fiq:
    EL2_CALL_WITH_CONTEXT el2_low_a32_fiq_handler
    40000860:	d10403ff 	sub	sp, sp, #0x100
    40000864:	a90007e0 	stp	x0, x1, [sp]
    40000868:	a9010fe2 	stp	x2, x3, [sp, #16]
    4000086c:	a90217e4 	stp	x4, x5, [sp, #32]
    40000870:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000874:	a90427e8 	stp	x8, x9, [sp, #64]
    40000878:	a9052fea 	stp	x10, x11, [sp, #80]
    4000087c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000880:	a9073fee 	stp	x14, x15, [sp, #112]
    40000884:	a90847f0 	stp	x16, x17, [sp, #128]
    40000888:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000088c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000890:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000894:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000898:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000089c:	a90e77fc 	stp	x28, x29, [sp, #224]
    400008a0:	f9007bfe 	str	x30, [sp, #240]
    400008a4:	94000355 	bl	400015f8 <el2_low_a32_fiq_handler>
    400008a8:	a94007e0 	ldp	x0, x1, [sp]
    400008ac:	a9410fe2 	ldp	x2, x3, [sp, #16]
    400008b0:	a94217e4 	ldp	x4, x5, [sp, #32]
    400008b4:	a9431fe6 	ldp	x6, x7, [sp, #48]
    400008b8:	a94427e8 	ldp	x8, x9, [sp, #64]
    400008bc:	a9452fea 	ldp	x10, x11, [sp, #80]
    400008c0:	a94637ec 	ldp	x12, x13, [sp, #96]
    400008c4:	a9473fee 	ldp	x14, x15, [sp, #112]
    400008c8:	a94847f0 	ldp	x16, x17, [sp, #128]
    400008cc:	a9494ff2 	ldp	x18, x19, [sp, #144]
    400008d0:	a94a57f4 	ldp	x20, x21, [sp, #160]
    400008d4:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    400008d8:	a94c67f8 	ldp	x24, x25, [sp, #192]
    400008dc:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    400008e0:	a94e77fc 	ldp	x28, x29, [sp, #224]
    400008e4:	f9407bfe 	ldr	x30, [sp, #240]
    400008e8:	910403ff 	add	sp, sp, #0x100
    400008ec:	d69f03e0 	eret

00000000400008f0 <_el2_low_a32_serror>:

_el2_low_a32_serror:
    EL2_CALL_WITH_CONTEXT el2_low_a32_serror_handler
    400008f0:	d10403ff 	sub	sp, sp, #0x100
    400008f4:	a90007e0 	stp	x0, x1, [sp]
    400008f8:	a9010fe2 	stp	x2, x3, [sp, #16]
    400008fc:	a90217e4 	stp	x4, x5, [sp, #32]
    40000900:	a9031fe6 	stp	x6, x7, [sp, #48]
    40000904:	a90427e8 	stp	x8, x9, [sp, #64]
    40000908:	a9052fea 	stp	x10, x11, [sp, #80]
    4000090c:	a90637ec 	stp	x12, x13, [sp, #96]
    40000910:	a9073fee 	stp	x14, x15, [sp, #112]
    40000914:	a90847f0 	stp	x16, x17, [sp, #128]
    40000918:	a9094ff2 	stp	x18, x19, [sp, #144]
    4000091c:	a90a57f4 	stp	x20, x21, [sp, #160]
    40000920:	a90b5ff6 	stp	x22, x23, [sp, #176]
    40000924:	a90c67f8 	stp	x24, x25, [sp, #192]
    40000928:	a90d6ffa 	stp	x26, x27, [sp, #208]
    4000092c:	a90e77fc 	stp	x28, x29, [sp, #224]
    40000930:	f9007bfe 	str	x30, [sp, #240]
    40000934:	94000260 	bl	400012b4 <el2_low_a32_serror_handler>
    40000938:	a94007e0 	ldp	x0, x1, [sp]
    4000093c:	a9410fe2 	ldp	x2, x3, [sp, #16]
    40000940:	a94217e4 	ldp	x4, x5, [sp, #32]
    40000944:	a9431fe6 	ldp	x6, x7, [sp, #48]
    40000948:	a94427e8 	ldp	x8, x9, [sp, #64]
    4000094c:	a9452fea 	ldp	x10, x11, [sp, #80]
    40000950:	a94637ec 	ldp	x12, x13, [sp, #96]
    40000954:	a9473fee 	ldp	x14, x15, [sp, #112]
    40000958:	a94847f0 	ldp	x16, x17, [sp, #128]
    4000095c:	a9494ff2 	ldp	x18, x19, [sp, #144]
    40000960:	a94a57f4 	ldp	x20, x21, [sp, #160]
    40000964:	a94b5ff6 	ldp	x22, x23, [sp, #176]
    40000968:	a94c67f8 	ldp	x24, x25, [sp, #192]
    4000096c:	a94d6ffa 	ldp	x26, x27, [sp, #208]
    40000970:	a94e77fc 	ldp	x28, x29, [sp, #224]
    40000974:	f9407bfe 	ldr	x30, [sp, #240]
    40000978:	910403ff 	add	sp, sp, #0x100
    4000097c:	d69f03e0 	eret

0000000040000980 <_exceptions_get_DAIF>:
.section .text
.align 2

.global _exceptions_get_DAIF
_exceptions_get_DAIF:
    mrs x0, DAIF
    40000980:	d53b4220 	mrs	x0, daif
    ret
    40000984:	d65f03c0 	ret

0000000040000988 <_fiq_exceptions_enable>:

.global _fiq_exceptions_enable
_fiq_exceptions_enable:
    msr daifclr, #0x1
    40000988:	d50341ff 	msr	daifclr, #0x1
    isb
    4000098c:	d5033fdf 	isb
    ret
    40000990:	d65f03c0 	ret

0000000040000994 <_irq_exceptions_enable>:

.global _irq_exceptions_enable
_irq_exceptions_enable:
    msr daifclr, #0x2
    40000994:	d50342ff 	msr	daifclr, #0x2
    isb
    40000998:	d5033fdf 	isb
    ret
    4000099c:	d65f03c0 	ret

00000000400009a0 <_serror_exceptions_enable>:

.global _serror_exceptions_enable
_serror_exceptions_enable:
    msr daifclr, #0x4
    400009a0:	d50344ff 	msr	daifclr, #0x4
    isb
    400009a4:	d5033fdf 	isb
    ret
    400009a8:	d65f03c0 	ret

00000000400009ac <_debug_exceptions_enable>:

.global _debug_exceptions_enable
_debug_exceptions_enable:
    msr daifclr, #0x8
    400009ac:	d50348ff 	msr	daifclr, #0x8
    isb
    400009b0:	d5033fdf 	isb
    ret
    400009b4:	d65f03c0 	ret

00000000400009b8 <_fiq_exceptions_disable>:

.global _fiq_exceptions_disable
_fiq_exceptions_disable:
    msr daifset, #0x1
    400009b8:	d50341df 	msr	daifset, #0x1
    isb
    400009bc:	d5033fdf 	isb
    ret
    400009c0:	d65f03c0 	ret

00000000400009c4 <_irq_exceptions_disable>:

.global _irq_exceptions_disable
_irq_exceptions_disable:
    msr daifset, #0x2
    400009c4:	d50342df 	msr	daifset, #0x2
    isb
    400009c8:	d5033fdf 	isb
    ret
    400009cc:	d65f03c0 	ret

00000000400009d0 <_serror_exceptions_disable>:

.global _serror_exceptions_disable
_serror_exceptions_disable:
    msr daifset, #0x4
    400009d0:	d50344df 	msr	daifset, #0x4
    isb
    400009d4:	d5033fdf 	isb
    ret
    400009d8:	d65f03c0 	ret

00000000400009dc <_debug_exceptions_disable>:

.global _debug_exceptions_disable
_debug_exceptions_disable:
    msr daifset, #0x8
    400009dc:	d50348df 	msr	daifset, #0x8
    isb
    400009e0:	d5033fdf 	isb
    ret
    400009e4:	d65f03c0 	ret
	...

00000000400009f0 <_memcpy>:

// void *_memcpy64(void *dst, void *src, uint64 size);
.global _memcpy
.align 64
_memcpy:
    mov     x3, x0
    400009f0:	aa0003e3 	mov	x3, x0

    cmp     x2, #16
    400009f4:	f100405f 	cmp	x2, #0x10
    b.lt    tail8
    400009f8:	5400056b 	b.lt	40000aa4 <tail8>  // b.tstop

//  Alignment: x4 = misalign
    ands    x4, x0, #15     // x4 = dst % 16
    400009fc:	f2400c04 	ands	x4, x0, #0xf
    b.eq    aligned         // if (x4 == 0) goto aligned;
    40000a00:	54000340 	b.eq	40000a68 <aligned>  // b.none
    
    mov     x5, #16
    40000a04:	d2800205 	mov	x5, #0x10                  	// #16
    sub     x4, x5, x4      // x4 = 16 - x4 
    40000a08:	cb0400a4 	sub	x4, x5, x4

    cmp     x4, x2
    40000a0c:	eb02009f 	cmp	x4, x2
    csel    x4, x2, x4, hi  // x4 = min(misalign, size)
    40000a10:	9a848044 	csel	x4, x2, x4, hi	// hi = pmore

    sub     x2, x2, x4
    40000a14:	cb040042 	sub	x2, x2, x4

0000000040000a18 <head8>:

head8:
    cmp     x4, #8
    40000a18:	f100209f 	cmp	x4, #0x8
    b.lt    head4
    40000a1c:	5400008b 	b.lt	40000a2c <head4>  // b.tstop

    ldr     x5, [x1], #8
    40000a20:	f8408425 	ldr	x5, [x1], #8
    str     x5, [x0], #8
    40000a24:	f8008405 	str	x5, [x0], #8
    sub     x4, x4, #8
    40000a28:	d1002084 	sub	x4, x4, #0x8

0000000040000a2c <head4>:

head4:
    cmp     x4, #4
    40000a2c:	f100109f 	cmp	x4, #0x4
    b.lt    head2
    40000a30:	5400008b 	b.lt	40000a40 <head2>  // b.tstop

0000000040000a34 <h4>:
h4:
    ldr     x5, [x1], #4
    40000a34:	f8404425 	ldr	x5, [x1], #4
    str     x5, [x0], #4
    40000a38:	f8004405 	str	x5, [x0], #4
    sub    x4, x4, #4
    40000a3c:	d1001084 	sub	x4, x4, #0x4

0000000040000a40 <head2>:

head2:
    cmp     x4, #2
    40000a40:	f100089f 	cmp	x4, #0x2
    b.lt    head1
    40000a44:	5400008b 	b.lt	40000a54 <head1>  // b.tstop

0000000040000a48 <h2>:
h2:
    ldrh    w5, [x1], #2
    40000a48:	78402425 	ldrh	w5, [x1], #2
    strh    w5, [x0], #2
    40000a4c:	78002405 	strh	w5, [x0], #2
    sub    x4, x4, #2
    40000a50:	d1000884 	sub	x4, x4, #0x2

0000000040000a54 <head1>:

head1:
    cbz     x4, aligned
    40000a54:	b40000a4 	cbz	x4, 40000a68 <aligned>

0000000040000a58 <h1>:
h1:
    ldrb    w5, [x1], #1
    40000a58:	38401425 	ldrb	w5, [x1], #1
    strb    w5, [x0], #1
    40000a5c:	38001405 	strb	w5, [x0], #1

    sub     x4, x4, #1 // TODO: check if needed loop for head1
    40000a60:	d1000484 	sub	x4, x4, #0x1
    cbnz    x4, hang
    40000a64:	b5000464 	cbnz	x4, 40000af0 <hang>

0000000040000a68 <aligned>:

aligned:
    // TODO: delete after testing
    ands    xzr, x0, #15
    40000a68:	f2400c1f 	tst	x0, #0xf
    b.ne    hang  // only for debug, if not aligned to 16 hang, to verify with gdb
    40000a6c:	54000421 	b.ne	40000af0 <hang>  // b.any

    cmp     x2, #64
    40000a70:	f101005f 	cmp	x2, #0x40
    b.lt    tail32
    40000a74:	540000eb 	b.lt	40000a90 <tail32>  // b.tstop

0000000040000a78 <loop>:

loop:
    ld1     {v0.16b-v3.16b}, [x1], #64
    40000a78:	4cdf2020 	ld1	{v0.16b-v3.16b}, [x1], #64
    st1     {v0.16b-v3.16b}, [x0], #64
    40000a7c:	4c9f2000 	st1	{v0.16b-v3.16b}, [x0], #64

    sub     x2, x2, #64
    40000a80:	d1010042 	sub	x2, x2, #0x40
    cmp     x2, #64
    40000a84:	f101005f 	cmp	x2, #0x40
    b.ge    loop
    40000a88:	54ffff8a 	b.ge	40000a78 <loop>  // b.tcont
    b       tail8
    40000a8c:	14000006 	b	40000aa4 <tail8>

0000000040000a90 <tail32>:

tail32:
    cmp     x2, #32
    40000a90:	f100805f 	cmp	x2, #0x20
    b.lt    tail8
    40000a94:	5400008b 	b.lt	40000aa4 <tail8>  // b.tstop

    ld1     {v0.16b, v1.16b}, [x1], #32
    40000a98:	4cdfa020 	ld1	{v0.16b-v1.16b}, [x1], #32
    st1     {v0.16b, v1.16b}, [x0], #32
    40000a9c:	4c9fa000 	st1	{v0.16b-v1.16b}, [x0], #32

    sub     x2, x2, #32
    40000aa0:	d1008042 	sub	x2, x2, #0x20

0000000040000aa4 <tail8>:

tail8:      // tail8 loops as for example if the size 63 is requested 63 - 32 -> 31, and then with 8 loops the result is near for tail4 or tail1
    cmp     x2, #8
    40000aa4:	f100205f 	cmp	x2, #0x8
    b.lt    tail4
    40000aa8:	540000cb 	b.lt	40000ac0 <tail4>  // b.tstop

0000000040000aac <t8>:
t8:
    ldr     x4, [x1], #8
    40000aac:	f8408424 	ldr	x4, [x1], #8
    str     x4, [x0], #8
    40000ab0:	f8008404 	str	x4, [x0], #8

    sub     x2, x2, #8
    40000ab4:	d1002042 	sub	x2, x2, #0x8
    cmp     x2, #8
    40000ab8:	f100205f 	cmp	x2, #0x8
    b.ge    t8
    40000abc:	54ffff8a 	b.ge	40000aac <t8>  // b.tcont

0000000040000ac0 <tail4>:

tail4:
    cmp     x2, #4
    40000ac0:	f100105f 	cmp	x2, #0x4
    b.lt    tail1
    40000ac4:	5400008b 	b.lt	40000ad4 <tail1>  // b.tstop

0000000040000ac8 <t4>:
t4:
    ldr     w4, [x1], #4
    40000ac8:	b8404424 	ldr	w4, [x1], #4
    str     w4, [x0], #4
    40000acc:	b8004404 	str	w4, [x0], #4

    sub     x2, x2, #4
    40000ad0:	d1001042 	sub	x2, x2, #0x4

0000000040000ad4 <tail1>:

tail1:
    cbz     x2, return
    40000ad4:	b40000a2 	cbz	x2, 40000ae8 <return>

0000000040000ad8 <t1>:
t1:
    ldrb    w4, [x1], #1
    40000ad8:	38401424 	ldrb	w4, [x1], #1
    strb    w4, [x0], #1
    40000adc:	38001404 	strb	w4, [x0], #1

    subs    x2, x2, #1
    40000ae0:	f1000442 	subs	x2, x2, #0x1
    b.ne    t1
    40000ae4:	54ffffa1 	b.ne	40000ad8 <t1>  // b.any

0000000040000ae8 <return>:

return:
    mov     x0, x3
    40000ae8:	aa0303e0 	mov	x0, x3
    ret
    40000aec:	d65f03c0 	ret

0000000040000af0 <hang>:

hang:
    wfe
    40000af0:	d503205f 	wfe
    b hang
    40000af4:	17ffffff 	b	40000af0 <hang>
    40000af8:	d503201f 	nop
    40000afc:	d503201f 	nop

0000000040000b00 <_memcpy64>:

// void *_memcpy64(void *dst, void *src, uint64 size);
.global _memcpy64
.align 4
_memcpy64:
    mov     x3, x0      // save return value (dst)
    40000b00:	aa0003e3 	mov	x3, x0

    cmp     x2, #64
    40000b04:	f101005f 	cmp	x2, #0x40
    b.lt    return64
    40000b08:	540000cb 	b.lt	40000b20 <return64>  // b.tstop

0000000040000b0c <loop64>:
    
loop64:     
    ld1		{v0.16b-v3.16b}, [x1], #64
    40000b0c:	4cdf2020 	ld1	{v0.16b-v3.16b}, [x1], #64
    st1     {v0.16b-v3.16b}, [x0], #64
    40000b10:	4c9f2000 	st1	{v0.16b-v3.16b}, [x0], #64

    sub     x2, x2, #64
    40000b14:	d1010042 	sub	x2, x2, #0x40
    cmp     x2, #64
    40000b18:	f101005f 	cmp	x2, #0x40
    b.ge    loop64      // if (size >= 64) goto loop64;
    40000b1c:	54ffff8a 	b.ge	40000b0c <loop64>  // b.tcont

0000000040000b20 <return64>:

return64:
    mov     x0, x3
    40000b20:	aa0303e0 	mov	x0, x3
    ret
    40000b24:	d65f03c0 	ret
    40000b28:	d503201f 	nop
    40000b2c:	d503201f 	nop

0000000040000b30 <_memcpy32>:

// void *_memcpy32(void *dst, void *src, uint64 size);
.global _memcpy32
.align 4
_memcpy32:
    mov     x3, x0
    40000b30:	aa0003e3 	mov	x3, x0

    cmp     x2, #32
    40000b34:	f100805f 	cmp	x2, #0x20
    b.lt    return32
    40000b38:	540000cb 	b.lt	40000b50 <return32>  // b.tstop

0000000040000b3c <loop32>:

loop32:
    ld1     {v0.16b, v1.16b}, [x1], #32
    40000b3c:	4cdfa020 	ld1	{v0.16b-v1.16b}, [x1], #32
    st1     {v0.16b, v1.16b}, [x0], #32
    40000b40:	4c9fa000 	st1	{v0.16b-v1.16b}, [x0], #32

    sub     x2, x2, #32
    40000b44:	d1008042 	sub	x2, x2, #0x20
    cmp     x2, #32
    40000b48:	f100805f 	cmp	x2, #0x20
    b.ge    loop32
    40000b4c:	54ffff8a 	b.ge	40000b3c <loop32>  // b.tcont

0000000040000b50 <return32>:

return32:
    mov     x0, x3
    40000b50:	aa0303e0 	mov	x0, x3
    ret
    40000b54:	d65f03c0 	ret
    40000b58:	d503201f 	nop
    40000b5c:	d503201f 	nop

0000000040000b60 <_memcpy16>:

// void *_memcpy16(void *dst, void *src, uint64 size);
.global _memcpy16
.align 4
_memcpy16:
    mov     x3, x0
    40000b60:	aa0003e3 	mov	x3, x0

    cmp     x2, #16
    40000b64:	f100405f 	cmp	x2, #0x10
    b.lt    return16
    40000b68:	540000cb 	b.lt	40000b80 <return16>  // b.tstop

0000000040000b6c <loop16>:
loop16:
    ld1     {v0.16b}, [x1], #16
    40000b6c:	4cdf7020 	ld1	{v0.16b}, [x1], #16
    st1     {v0.16b}, [x0], #16
    40000b70:	4c9f7000 	st1	{v0.16b}, [x0], #16

    sub     x2, x2, #16
    40000b74:	d1004042 	sub	x2, x2, #0x10
    cmp     x2, #16
    40000b78:	f100405f 	cmp	x2, #0x10
    b.ge    loop16
    40000b7c:	54ffff8a 	b.ge	40000b6c <loop16>  // b.tcont

0000000040000b80 <return16>:

return16:
    mov     x0,x3
    40000b80:	aa0303e0 	mov	x0, x3
    ret
    40000b84:	d65f03c0 	ret
    40000b88:	d503201f 	nop
    40000b8c:	d503201f 	nop

0000000040000b90 <_memcpy8>:

// void *_memcpy8(void *dst, void *src, uint64 size);
.global _memcpy8
.align 4
_memcpy8:
    mov     x3, x0
    40000b90:	aa0003e3 	mov	x3, x0

    cmp     x2, #8
    40000b94:	f100205f 	cmp	x2, #0x8
    b.lt    return8
    40000b98:	540000cb 	b.lt	40000bb0 <return8>  // b.tstop

0000000040000b9c <loop8>:

loop8:
    ldr     x4, [x1], #8
    40000b9c:	f8408424 	ldr	x4, [x1], #8
    str     x4, [x0], #8
    40000ba0:	f8008404 	str	x4, [x0], #8

    sub     x2, x2, #8
    40000ba4:	d1002042 	sub	x2, x2, #0x8
    cmp     x2, #8
    40000ba8:	f100205f 	cmp	x2, #0x8
    b.ge    loop8
    40000bac:	54ffff8a 	b.ge	40000b9c <loop8>  // b.tcont

0000000040000bb0 <return8>:

return8:
    mov     x0, x3
    40000bb0:	aa0303e0 	mov	x0, x3
    ret
    40000bb4:	d65f03c0 	ret
    40000bb8:	d503201f 	nop
    40000bbc:	d503201f 	nop

0000000040000bc0 <_memcpy4>:

// void *_memcpy4(void *dst, void *src, uint64 size);
.global _memcpy4
.align 4
_memcpy4:
    mov     x3, x0
    40000bc0:	aa0003e3 	mov	x3, x0

    cmp     x2, #4
    40000bc4:	f100105f 	cmp	x2, #0x4
    b.lt    return4
    40000bc8:	540000cb 	b.lt	40000be0 <return4>  // b.tstop

0000000040000bcc <loop4>:

loop4:
    ldr     w4, [x1], #4
    40000bcc:	b8404424 	ldr	w4, [x1], #4
    str     w4, [x0], #4
    40000bd0:	b8004404 	str	w4, [x0], #4

    sub     x2, x2, #4
    40000bd4:	d1001042 	sub	x2, x2, #0x4
    cmp     x2, #4
    40000bd8:	f100105f 	cmp	x2, #0x4
    b.ge    loop4
    40000bdc:	54ffff8a 	b.ge	40000bcc <loop4>  // b.tcont

0000000040000be0 <return4>:

return4:
    mov     x0, x3
    40000be0:	aa0303e0 	mov	x0, x3
    ret
    40000be4:	d65f03c0 	ret
    40000be8:	d503201f 	nop
    40000bec:	d503201f 	nop

0000000040000bf0 <_memcpy2>:

// void *_memcpy2(void *dst, void *src, uint64 size);
.global _memcpy2
.align 4
_memcpy2:
    mov     x3, x0
    40000bf0:	aa0003e3 	mov	x3, x0

    cmp     x2, #2
    40000bf4:	f100085f 	cmp	x2, #0x2
    b.lt    return2
    40000bf8:	540000cb 	b.lt	40000c10 <return2>  // b.tstop

0000000040000bfc <loop2>:

loop2:
    ldrh    w4, [x1], #2
    40000bfc:	78402424 	ldrh	w4, [x1], #2
    strh    w4, [x0], #2
    40000c00:	78002404 	strh	w4, [x0], #2

    sub     x2, x2, #2
    40000c04:	d1000842 	sub	x2, x2, #0x2
    cmp     x2, #2
    40000c08:	f100085f 	cmp	x2, #0x2
    b.ge    loop2
    40000c0c:	54ffff8a 	b.ge	40000bfc <loop2>  // b.tcont

0000000040000c10 <return2>:

return2:
    mov     x0, x3
    40000c10:	aa0303e0 	mov	x0, x3
    ret
    40000c14:	d65f03c0 	ret
    40000c18:	d503201f 	nop
    40000c1c:	d503201f 	nop

0000000040000c20 <_memcpy1>:

// void *_memcpy1(void *dst, void *src, uint64 size);
.global _memcpy1
.align 4
_memcpy1:
    mov     x3, x0
    40000c20:	aa0003e3 	mov	x3, x0

    cbz     x2, return1
    40000c24:	b40000a2 	cbz	x2, 40000c38 <return1>

0000000040000c28 <loop1>:

loop1:
    ldrb    w4, [x1], #1
    40000c28:	38401424 	ldrb	w4, [x1], #1
    strb    w4, [x0], #1
    40000c2c:	38001404 	strb	w4, [x0], #1

    subs    x2, x2, #1
    40000c30:	f1000442 	subs	x2, x2, #0x1
    b.ne    loop1
    40000c34:	54ffffa1 	b.ne	40000c28 <loop1>  // b.any

0000000040000c38 <return1>:

return1:
    mov     x0, x3
    40000c38:	aa0303e0 	mov	x0, x3
    ret    
    40000c3c:	d65f03c0 	ret

0000000040000c40 <_clean_bss>:
.section .text
.global _clean_bss
.align 2

_clean_bss:
    ldr     x0, =__bss_start
    40000c40:	58000240 	ldr	x0, 40000c88 <hang+0xc>
    ldr     x1, =__bss_end
    40000c44:	58000261 	ldr	x1, 40000c90 <hang+0x14>

    movi    v0.16b, #0
    40000c48:	4f00e400 	movi	v0.16b, #0x0
    movi    v1.16b, #0
    40000c4c:	4f00e401 	movi	v1.16b, #0x0
    movi    v2.16b, #0
    40000c50:	4f00e402 	movi	v2.16b, #0x0
    movi    v3.16b, #0
    40000c54:	4f00e403 	movi	v3.16b, #0x0

//  Check 64 byte align
    ands    xzr, x0, #63
    40000c58:	f240141f 	tst	x0, #0x3f
    b.ne    hang
    40000c5c:	54000101 	b.ne	40000c7c <hang>  // b.any

    ands    xzr, x1, #63
    40000c60:	f240143f 	tst	x1, #0x3f
    b.ne    hang
    40000c64:	540000c1 	b.ne	40000c7c <hang>  // b.any

1:
    cmp     x0, x1
    40000c68:	eb01001f 	cmp	x0, x1
    b.ge    2f      // pointer of __bss_start >= __bss_end
    40000c6c:	5400006a 	b.ge	40000c78 <_clean_bss+0x38>  // b.tcont

    st1     {v0.16b, v1.16b, v2.16b, v3.16b}, [x0], #64
    40000c70:	4c9f2000 	st1	{v0.16b-v3.16b}, [x0], #64
    b       1b
    40000c74:	17fffffd 	b	40000c68 <_clean_bss+0x28>
2:
    ret
    40000c78:	d65f03c0 	ret

0000000040000c7c <hang>:

hang:
    wfe
    40000c7c:	d503205f 	wfe
    b hang
    40000c80:	17ffffff 	b	40000c7c <hang>
    40000c84:	00000000 	udf	#0
    40000c88:	40005340 	.inst	0x40005340 ; undefined
    40000c8c:	00000000 	udf	#0
    40000c90:	40c06780 	.inst	0x40c06780 ; undefined
    40000c94:	00000000 	udf	#0

0000000040000c98 <init_panic>:

_Alignas(16) static uint8 panic_message_buffer[PANIC_MESSAGE_LEN_INIT_VALUE];
_Alignas(16) static uint8 panic_file_buffer[PANIC_FILE_LEN_INIT_VALUE];

void init_panic()
{
    40000c98:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    40000c9c:	910003fd 	mov	x29, sp
	PANIC_MESSAGE_BUF_SIZE = sizeof(panic_message_buffer);
    40000ca0:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000ca4:	910d0000 	add	x0, x0, #0x340
    40000ca8:	d2820001 	mov	x1, #0x1000                	// #4096
    40000cac:	f9000001 	str	x1, [x0]
	PANIC_FILE_BUF_SIZE = sizeof(panic_file_buffer);
    40000cb0:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000cb4:	910d2000 	add	x0, x0, #0x348
    40000cb8:	d2808001 	mov	x1, #0x400                 	// #1024
    40000cbc:	f9000001 	str	x1, [x0]

	PANIC_MESSAGE_BUF_PTR = panic_message_buffer;
    40000cc0:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000cc4:	910d4000 	add	x0, x0, #0x350
    40000cc8:	b0000021 	adrp	x1, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000ccc:	910dc021 	add	x1, x1, #0x370
    40000cd0:	f9000001 	str	x1, [x0]
	PANIC_FILE_BUF_PTR = panic_file_buffer;
    40000cd4:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000cd8:	910d6000 	add	x0, x0, #0x358
    40000cdc:	d0000021 	adrp	x1, 40006000 <panic_message_buffer+0xc90>
    40000ce0:	910dc021 	add	x1, x1, #0x370
    40000ce4:	f9000001 	str	x1, [x0]

	PANIC_LINE = 0;
    40000ce8:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000cec:	910d8000 	add	x0, x0, #0x360
    40000cf0:	b900001f 	str	wzr, [x0]
	PANIC_COL = 0;
    40000cf4:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000cf8:	910d9000 	add	x0, x0, #0x364
    40000cfc:	b900001f 	str	wzr, [x0]

	strcopy((char *)PANIC_MESSAGE_BUF_PTR,
    40000d00:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000d04:	910d4000 	add	x0, x0, #0x350
    40000d08:	f9400003 	ldr	x3, [x0]
    40000d0c:	d2820002 	mov	x2, #0x1000                	// #4096
    40000d10:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000d14:	911e4001 	add	x1, x0, #0x790
    40000d18:	aa0303e0 	mov	x0, x3
    40000d1c:	9400033a 	bl	40001a04 <strcopy>
			"Panic message not defined and not changed from init_panic() "
			"initialization stage.",
			PANIC_MESSAGE_LEN_INIT_VALUE);

	strcopy((char *)PANIC_FILE_BUF_PTR, "Panic file not defined",
    40000d20:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000d24:	910d6000 	add	x0, x0, #0x358
    40000d28:	f9400003 	ldr	x3, [x0]
    40000d2c:	d2808002 	mov	x2, #0x400                 	// #1024
    40000d30:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000d34:	911fa001 	add	x1, x0, #0x7e8
    40000d38:	aa0303e0 	mov	x0, x3
    40000d3c:	94000332 	bl	40001a04 <strcopy>
			PANIC_FILE_LEN_INIT_VALUE);
}
    40000d40:	d503201f 	nop
    40000d44:	a8c17bfd 	ldp	x29, x30, [sp], #16
    40000d48:	d65f03c0 	ret

0000000040000d4c <panic>:

static void log_system_info();

// TODO: use panic via exceptions
_Noreturn void panic()
{
    40000d4c:	a9b27bfd 	stp	x29, x30, [sp, #-224]!
    40000d50:	910003fd 	mov	x29, sp
	char buf[200];
	PANIC_puts("\n\r[PANIC!]");
    40000d54:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000d58:	91200001 	add	x1, x0, #0x800
    40000d5c:	52800020 	mov	w0, #0x1                   	// #1
    40000d60:	94000a04 	bl	40003570 <UART_puts>

	PANIC_puts("\n\rPanic message:\t");
    40000d64:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000d68:	91204001 	add	x1, x0, #0x810
    40000d6c:	52800020 	mov	w0, #0x1                   	// #1
    40000d70:	94000a00 	bl	40003570 <UART_puts>
	PANIC_puts((char *)PANIC_MESSAGE_BUF_PTR);
    40000d74:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000d78:	910d4000 	add	x0, x0, #0x350
    40000d7c:	f9400000 	ldr	x0, [x0]
    40000d80:	aa0003e1 	mov	x1, x0
    40000d84:	52800020 	mov	w0, #0x1                   	// #1
    40000d88:	940009fa 	bl	40003570 <UART_puts>

	PANIC_puts("\n\rPanic file:\t");
    40000d8c:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000d90:	9120a001 	add	x1, x0, #0x828
    40000d94:	52800020 	mov	w0, #0x1                   	// #1
    40000d98:	940009f6 	bl	40003570 <UART_puts>
	PANIC_puts((char *)PANIC_FILE_BUF_PTR);
    40000d9c:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000da0:	910d6000 	add	x0, x0, #0x358
    40000da4:	f9400000 	ldr	x0, [x0]
    40000da8:	aa0003e1 	mov	x1, x0
    40000dac:	52800020 	mov	w0, #0x1                   	// #1
    40000db0:	940009f0 	bl	40003570 <UART_puts>
	PANIC_puts(" at line ");
    40000db4:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000db8:	9120e001 	add	x1, x0, #0x838
    40000dbc:	52800020 	mov	w0, #0x1                   	// #1
    40000dc0:	940009ec 	bl	40003570 <UART_puts>

	PANIC_puts(stdint_to_ascii((STDINT_UNION){.uint32 = PANIC_LINE},
    40000dc4:	d2800000 	mov	x0, #0x0                   	// #0
    40000dc8:	b0000021 	adrp	x1, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000dcc:	910d8021 	add	x1, x1, #0x360
    40000dd0:	b9400021 	ldr	w1, [x1]
    40000dd4:	b3407c20 	bfxil	x0, x1, #0, #32
    40000dd8:	910063e1 	add	x1, sp, #0x18
    40000ddc:	52800144 	mov	w4, #0xa                   	// #10
    40000de0:	d2801903 	mov	x3, #0xc8                  	// #200
    40000de4:	aa0103e2 	mov	x2, x1
    40000de8:	528000a1 	mov	w1, #0x5                   	// #5
    40000dec:	94000347 	bl	40001b08 <stdint_to_ascii>
    40000df0:	aa0003e1 	mov	x1, x0
    40000df4:	52800020 	mov	w0, #0x1                   	// #1
    40000df8:	940009de 	bl	40003570 <UART_puts>
							   STDINT_UINT32, buf, 200, STDINT_BASE_REPR_DEC));

	if (PANIC_COL != 0) {
    40000dfc:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000e00:	910d9000 	add	x0, x0, #0x364
    40000e04:	b9400000 	ldr	w0, [x0]
    40000e08:	7100001f 	cmp	w0, #0x0
    40000e0c:	54000260 	b.eq	40000e58 <panic+0x10c>  // b.none
		PANIC_puts(":");
    40000e10:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000e14:	91212001 	add	x1, x0, #0x848
    40000e18:	52800020 	mov	w0, #0x1                   	// #1
    40000e1c:	940009d5 	bl	40003570 <UART_puts>
		PANIC_puts(stdint_to_ascii((STDINT_UNION){.uint32 = PANIC_COL},
    40000e20:	d2800000 	mov	x0, #0x0                   	// #0
    40000e24:	b0000021 	adrp	x1, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000e28:	910d9021 	add	x1, x1, #0x364
    40000e2c:	b9400021 	ldr	w1, [x1]
    40000e30:	b3407c20 	bfxil	x0, x1, #0, #32
    40000e34:	910063e1 	add	x1, sp, #0x18
    40000e38:	52800144 	mov	w4, #0xa                   	// #10
    40000e3c:	d2801903 	mov	x3, #0xc8                  	// #200
    40000e40:	aa0103e2 	mov	x2, x1
    40000e44:	528000a1 	mov	w1, #0x5                   	// #5
    40000e48:	94000330 	bl	40001b08 <stdint_to_ascii>
    40000e4c:	aa0003e1 	mov	x1, x0
    40000e50:	52800020 	mov	w0, #0x1                   	// #1
    40000e54:	940009c7 	bl	40003570 <UART_puts>
								   STDINT_UINT32, buf, 200,
								   STDINT_BASE_REPR_DEC));
	}

	log_system_info();
    40000e58:	9400002c 	bl	40000f08 <log_system_info>

	loop {}	 // TODO: TUI with options
    40000e5c:	d503201f 	nop
    40000e60:	17ffffff 	b	40000e5c <panic+0x110>

0000000040000e64 <set_panic>:
}

void set_panic(PanicInfo panic_info)
{
    40000e64:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    40000e68:	910003fd 	mov	x29, sp
    40000e6c:	f9000bf3 	str	x19, [sp, #16]
    40000e70:	aa0003f3 	mov	x19, x0
	strcopy((char *)PANIC_MESSAGE_BUF_PTR, panic_info.message,
    40000e74:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000e78:	910d4000 	add	x0, x0, #0x350
    40000e7c:	f9400000 	ldr	x0, [x0]
    40000e80:	f9400261 	ldr	x1, [x19]
    40000e84:	d2820002 	mov	x2, #0x1000                	// #4096
    40000e88:	940002df 	bl	40001a04 <strcopy>
			PANIC_MESSAGE_LEN_INIT_VALUE);

	strcopy((char *)PANIC_FILE_BUF_PTR, panic_info.location.file,
    40000e8c:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000e90:	910d6000 	add	x0, x0, #0x358
    40000e94:	f9400000 	ldr	x0, [x0]
    40000e98:	f9400661 	ldr	x1, [x19, #8]
    40000e9c:	d2808002 	mov	x2, #0x400                 	// #1024
    40000ea0:	940002d9 	bl	40001a04 <strcopy>
			PANIC_FILE_LEN_INIT_VALUE);

	PANIC_LINE = panic_info.location.line;
    40000ea4:	b9401261 	ldr	w1, [x19, #16]
    40000ea8:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000eac:	910d8000 	add	x0, x0, #0x360
    40000eb0:	b9000001 	str	w1, [x0]
	PANIC_COL = panic_info.location.col;
    40000eb4:	b9401661 	ldr	w1, [x19, #20]
    40000eb8:	b0000020 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40000ebc:	910d9000 	add	x0, x0, #0x364
    40000ec0:	b9000001 	str	w1, [x0]
}
    40000ec4:	d503201f 	nop
    40000ec8:	f9400bf3 	ldr	x19, [sp, #16]
    40000ecc:	a8c27bfd 	ldp	x29, x30, [sp], #32
    40000ed0:	d65f03c0 	ret

0000000040000ed4 <set_and_throw_panic>:

_Noreturn void set_and_throw_panic(PanicInfo panic_info)
{
    40000ed4:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    40000ed8:	910003fd 	mov	x29, sp
    40000edc:	f9000bf3 	str	x19, [sp, #16]
    40000ee0:	aa0003f3 	mov	x19, x0
	set_panic(panic_info);
    40000ee4:	910083e2 	add	x2, sp, #0x20
    40000ee8:	aa1303e3 	mov	x3, x19
    40000eec:	a9400460 	ldp	x0, x1, [x3]
    40000ef0:	f9400863 	ldr	x3, [x3, #16]
    40000ef4:	a9000440 	stp	x0, x1, [x2]
    40000ef8:	f9000843 	str	x3, [x2, #16]
    40000efc:	910083e0 	add	x0, sp, #0x20
    40000f00:	97ffffd9 	bl	40000e64 <set_panic>
	panic();
    40000f04:	97ffff92 	bl	40000d4c <panic>

0000000040000f08 <log_system_info>:
}

// System info

static void log_system_info()
{
    40000f08:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    40000f0c:	910003fd 	mov	x29, sp
	EXCEPTION_STATUS status = exceptions_get_status();
    40000f10:	94000219 	bl	40001774 <exceptions_get_status>
    40000f14:	b9001be0 	str	w0, [sp, #24]

	PANIC_puts("\n\rExceptions state:\n\r");
    40000f18:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000f1c:	91214001 	add	x1, x0, #0x850
    40000f20:	52800020 	mov	w0, #0x1                   	// #1
    40000f24:	94000993 	bl	40003570 <UART_puts>

	char *enabled = "enabled\n\r";
    40000f28:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000f2c:	9121a000 	add	x0, x0, #0x868
    40000f30:	f90017e0 	str	x0, [sp, #40]
	char *disabled = "disabled\n\r";
    40000f34:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000f38:	9121e000 	add	x0, x0, #0x878
    40000f3c:	f90013e0 	str	x0, [sp, #32]

	PANIC_puts("\tFIQ:    ");
    40000f40:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000f44:	91222001 	add	x1, x0, #0x888
    40000f48:	52800020 	mov	w0, #0x1                   	// #1
    40000f4c:	94000989 	bl	40003570 <UART_puts>
	PANIC_puts(status.fiq ? enabled : disabled);
    40000f50:	394063e0 	ldrb	w0, [sp, #24]
    40000f54:	12000000 	and	w0, w0, #0x1
    40000f58:	7100001f 	cmp	w0, #0x0
    40000f5c:	54000060 	b.eq	40000f68 <log_system_info+0x60>  // b.none
    40000f60:	f94017e0 	ldr	x0, [sp, #40]
    40000f64:	14000002 	b	40000f6c <log_system_info+0x64>
    40000f68:	f94013e0 	ldr	x0, [sp, #32]
    40000f6c:	aa0003e1 	mov	x1, x0
    40000f70:	52800020 	mov	w0, #0x1                   	// #1
    40000f74:	9400097f 	bl	40003570 <UART_puts>

	PANIC_puts("\tIRQ:    ");
    40000f78:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000f7c:	91226001 	add	x1, x0, #0x898
    40000f80:	52800020 	mov	w0, #0x1                   	// #1
    40000f84:	9400097b 	bl	40003570 <UART_puts>
	PANIC_puts(status.irq ? enabled : disabled);
    40000f88:	394067e0 	ldrb	w0, [sp, #25]
    40000f8c:	12000000 	and	w0, w0, #0x1
    40000f90:	7100001f 	cmp	w0, #0x0
    40000f94:	54000060 	b.eq	40000fa0 <log_system_info+0x98>  // b.none
    40000f98:	f94017e0 	ldr	x0, [sp, #40]
    40000f9c:	14000002 	b	40000fa4 <log_system_info+0x9c>
    40000fa0:	f94013e0 	ldr	x0, [sp, #32]
    40000fa4:	aa0003e1 	mov	x1, x0
    40000fa8:	52800020 	mov	w0, #0x1                   	// #1
    40000fac:	94000971 	bl	40003570 <UART_puts>

	PANIC_puts("\tSError: ");
    40000fb0:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000fb4:	9122a001 	add	x1, x0, #0x8a8
    40000fb8:	52800020 	mov	w0, #0x1                   	// #1
    40000fbc:	9400096d 	bl	40003570 <UART_puts>
	PANIC_puts(status.serror ? enabled : disabled);
    40000fc0:	39406be0 	ldrb	w0, [sp, #26]
    40000fc4:	12000000 	and	w0, w0, #0x1
    40000fc8:	7100001f 	cmp	w0, #0x0
    40000fcc:	54000060 	b.eq	40000fd8 <log_system_info+0xd0>  // b.none
    40000fd0:	f94017e0 	ldr	x0, [sp, #40]
    40000fd4:	14000002 	b	40000fdc <log_system_info+0xd4>
    40000fd8:	f94013e0 	ldr	x0, [sp, #32]
    40000fdc:	aa0003e1 	mov	x1, x0
    40000fe0:	52800020 	mov	w0, #0x1                   	// #1
    40000fe4:	94000963 	bl	40003570 <UART_puts>

	PANIC_puts("\tDebug:  ");
    40000fe8:	90000020 	adrp	x0, 40004000 <_el2_vector_table>
    40000fec:	9122e001 	add	x1, x0, #0x8b8
    40000ff0:	52800020 	mov	w0, #0x1                   	// #1
    40000ff4:	9400095f 	bl	40003570 <UART_puts>
	PANIC_puts(status.debug ? enabled : disabled);
    40000ff8:	39406fe0 	ldrb	w0, [sp, #27]
    40000ffc:	12000000 	and	w0, w0, #0x1
    40001000:	7100001f 	cmp	w0, #0x0
    40001004:	54000060 	b.eq	40001010 <log_system_info+0x108>  // b.none
    40001008:	f94017e0 	ldr	x0, [sp, #40]
    4000100c:	14000002 	b	40001014 <log_system_info+0x10c>
    40001010:	f94013e0 	ldr	x0, [sp, #32]
    40001014:	aa0003e1 	mov	x1, x0
    40001018:	52800020 	mov	w0, #0x1                   	// #1
    4000101c:	94000955 	bl	40003570 <UART_puts>

	// TODO: log registers
    40001020:	d503201f 	nop
    40001024:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40001028:	d65f03c0 	ret

000000004000102c <GICV3_GICR_TYPER_read>:

#define GICR_TYPER_VALUE_STRUCT_NAME GicrTyper

MMIO_DECLARE_REG64_VALUE_STRUCT(GICR_TYPER_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG64_GETTER_N_BASE(GICV3, GICR_TYPER,
    4000102c:	d10043ff 	sub	sp, sp, #0x10
    40001030:	f90007e0 	str	x0, [sp, #8]
    40001034:	f94007e0 	ldr	x0, [sp, #8]
    40001038:	d36fb801 	lsl	x1, x0, #17
    4000103c:	d2800100 	mov	x0, #0x8                   	// #8
    40001040:	f2a71100 	movk	x0, #0x3888, lsl #16
    40001044:	8b000020 	add	x0, x1, x0
    40001048:	f9400000 	ldr	x0, [x0]
    4000104c:	910043ff 	add	sp, sp, #0x10
    40001050:	d65f03c0 	ret

0000000040001054 <GICV3_GICR_TYPER_BF_get_AffinityValue>:
#define AffinityValue_SHIFT 32
#define AffinityValue_MASK (0xFFFFFFFFULL << AffinityValue_SHIFT)

static inline CpuAffinity GICV3_GICR_TYPER_BF_get_AffinityValue(
	const GicrTyper r)
{
    40001054:	d10083ff 	sub	sp, sp, #0x20
    40001058:	f90007e0 	str	x0, [sp, #8]
	uint32 affinity =
		(uint32)((r.val & AffinityValue_MASK) >> AffinityValue_SHIFT);
    4000105c:	f94007e0 	ldr	x0, [sp, #8]
    40001060:	d360fc00 	lsr	x0, x0, #32
	uint32 affinity =
    40001064:	b9001fe0 	str	w0, [sp, #28]

	return CPU_AFFINITY_FROM_U32(affinity);
    40001068:	b9401fe0 	ldr	w0, [sp, #28]
    4000106c:	53187c00 	lsr	w0, w0, #24
    40001070:	12001c04 	and	w4, w0, #0xff
    40001074:	b9401fe0 	ldr	w0, [sp, #28]
    40001078:	53107c00 	lsr	w0, w0, #16
    4000107c:	12001c03 	and	w3, w0, #0xff
    40001080:	b9401fe0 	ldr	w0, [sp, #28]
    40001084:	53087c00 	lsr	w0, w0, #8
    40001088:	12001c02 	and	w2, w0, #0xff
    4000108c:	b9401fe0 	ldr	w0, [sp, #28]
    40001090:	12001c00 	and	w0, w0, #0xff
    40001094:	33001c81 	bfxil	w1, w4, #0, #8
    40001098:	33181c61 	bfi	w1, w3, #8, #8
    4000109c:	33101c41 	bfi	w1, w2, #16, #8
    400010a0:	33081c01 	bfi	w1, w0, #24, #8
    400010a4:	2a0103e0 	mov	w0, w1
}
    400010a8:	910083ff 	add	sp, sp, #0x20
    400010ac:	d65f03c0 	ret

00000000400010b0 <kernel_init>:
#include "arm/cpu.h"
#include "arm/sysregs.h"
#include "drivers/interrupts/gicv3/gicv3_raw/gicr_typer.h"

static void kernel_init()
{
    400010b0:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    400010b4:	910003fd 	mov	x29, sp
    400010b8:	f9000bf3 	str	x19, [sp, #16]
	init_panic();
    400010bc:	97fffef7 	bl	40000c98 <init_panic>
	UART_init(UART_ID_2);
    400010c0:	52800020 	mov	w0, #0x1                   	// #1
    400010c4:	94000965 	bl	40003658 <UART_init>

	exceptions_set_status((EXCEPTION_STATUS){
    400010c8:	52800020 	mov	w0, #0x1                   	// #1
    400010cc:	33001c13 	bfxil	w19, w0, #0, #8
    400010d0:	52800020 	mov	w0, #0x1                   	// #1
    400010d4:	33181c13 	bfi	w19, w0, #8, #8
    400010d8:	52800020 	mov	w0, #0x1                   	// #1
    400010dc:	33101c13 	bfi	w19, w0, #16, #8
    400010e0:	52800020 	mov	w0, #0x1                   	// #1
    400010e4:	33081c13 	bfi	w19, w0, #24, #8
    400010e8:	2a1303e0 	mov	w0, w19
    400010ec:	940001c7 	bl	40001808 <exceptions_set_status>
		.fiq = true,
		.irq = true,
		.serror = true,
		.debug = true,
	});
}
    400010f0:	d503201f 	nop
    400010f4:	f9400bf3 	ldr	x19, [sp, #16]
    400010f8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    400010fc:	d65f03c0 	ret

0000000040001100 <kernel_entry>:
extern uint64 _ARM_ICC_SRE_EL2();
extern uint64 _ARM_HCR_EL2();

// Main function of the kernel, called by the bootloader (/boot/boot.S)
_Noreturn void kernel_entry()
{
    40001100:	d10903ff 	sub	sp, sp, #0x240
    40001104:	a9007bfd 	stp	x29, x30, [sp]
    40001108:	910003fd 	mov	x29, sp
    4000110c:	f9000bf3 	str	x19, [sp, #16]
	kernel_init();
    40001110:	97ffffe8 	bl	400010b0 <kernel_init>

	UART_puts(UART_ID_2, "Hello test!\n\r");
    40001114:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001118:	91232001 	add	x1, x0, #0x8c8
    4000111c:	52800020 	mov	w0, #0x1                   	// #1
    40001120:	94000914 	bl	40003570 <UART_puts>

	char buf[500];

	for (size_t i = 0; i < 4; i++) {
    40001124:	f9011fff 	str	xzr, [sp, #568]
    40001128:	14000031 	b	400011ec <kernel_entry+0xec>
		GicrTyper r = GICV3_GICR_TYPER_read(i);
    4000112c:	f9411fe0 	ldr	x0, [sp, #568]
    40001130:	97ffffbf 	bl	4000102c <GICV3_GICR_TYPER_read>
    40001134:	f9001be0 	str	x0, [sp, #48]

		uint32 affinity =
			U32_FROM_CPU_AFFINITY(GICV3_GICR_TYPER_BF_get_AffinityValue(r));
    40001138:	f9401be0 	ldr	x0, [sp, #48]
    4000113c:	97ffffc6 	bl	40001054 <GICV3_GICR_TYPER_BF_get_AffinityValue>
    40001140:	12001c00 	and	w0, w0, #0xff
    40001144:	53081c13 	lsl	w19, w0, #24
    40001148:	f9401be0 	ldr	x0, [sp, #48]
    4000114c:	97ffffc2 	bl	40001054 <GICV3_GICR_TYPER_BF_get_AffinityValue>
    40001150:	d3483c00 	ubfx	x0, x0, #8, #8
    40001154:	12001c00 	and	w0, w0, #0xff
    40001158:	53103c00 	lsl	w0, w0, #16
    4000115c:	2a000273 	orr	w19, w19, w0
    40001160:	f9401be0 	ldr	x0, [sp, #48]
    40001164:	97ffffbc 	bl	40001054 <GICV3_GICR_TYPER_BF_get_AffinityValue>
    40001168:	d3505c00 	ubfx	x0, x0, #16, #8
    4000116c:	12001c00 	and	w0, w0, #0xff
    40001170:	53185c00 	lsl	w0, w0, #8
    40001174:	2a000273 	orr	w19, w19, w0
    40001178:	f9401be0 	ldr	x0, [sp, #48]
    4000117c:	97ffffb6 	bl	40001054 <GICV3_GICR_TYPER_BF_get_AffinityValue>
    40001180:	53187c00 	lsr	w0, w0, #24
    40001184:	12001c00 	and	w0, w0, #0xff
		uint32 affinity =
    40001188:	2a000260 	orr	w0, w19, w0
    4000118c:	b9022fe0 	str	w0, [sp, #556]

		UART_puts(UART_ID_2, "ID: ");
    40001190:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001194:	91236001 	add	x1, x0, #0x8d8
    40001198:	52800020 	mov	w0, #0x1                   	// #1
    4000119c:	940008f5 	bl	40003570 <UART_puts>
		UART_puts(UART_ID_2, stdint_to_ascii((STDINT_UNION){.uint32 = affinity},
    400011a0:	d2800000 	mov	x0, #0x0                   	// #0
    400011a4:	b9422fe1 	ldr	w1, [sp, #556]
    400011a8:	b3407c20 	bfxil	x0, x1, #0, #32
    400011ac:	9100e3e1 	add	x1, sp, #0x38
    400011b0:	52800044 	mov	w4, #0x2                   	// #2
    400011b4:	d2801903 	mov	x3, #0xc8                  	// #200
    400011b8:	aa0103e2 	mov	x2, x1
    400011bc:	528000a1 	mov	w1, #0x5                   	// #5
    400011c0:	94000252 	bl	40001b08 <stdint_to_ascii>
    400011c4:	aa0003e1 	mov	x1, x0
    400011c8:	52800020 	mov	w0, #0x1                   	// #1
    400011cc:	940008e9 	bl	40003570 <UART_puts>
											 STDINT_UINT32, buf, 200,
											 STDINT_BASE_REPR_BIN));
		UART_puts(UART_ID_2, "\n\r");
    400011d0:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400011d4:	91238001 	add	x1, x0, #0x8e0
    400011d8:	52800020 	mov	w0, #0x1                   	// #1
    400011dc:	940008e5 	bl	40003570 <UART_puts>
	for (size_t i = 0; i < 4; i++) {
    400011e0:	f9411fe0 	ldr	x0, [sp, #568]
    400011e4:	91000400 	add	x0, x0, #0x1
    400011e8:	f9011fe0 	str	x0, [sp, #568]
    400011ec:	f9411fe0 	ldr	x0, [sp, #568]
    400011f0:	f1000c1f 	cmp	x0, #0x3
    400011f4:	54fff9c9 	b.ls	4000112c <kernel_entry+0x2c>  // b.plast
	}

	uint64 icc_sre = _ARM_HCR_EL2();
    400011f8:	97fffb9b 	bl	40000064 <_ARM_HCR_EL2>
    400011fc:	f9011be0 	str	x0, [sp, #560]
	UART_puts(UART_ID_2,
			  stdint_to_ascii((STDINT_UNION){.uint64 = icc_sre}, STDINT_UINT64,
    40001200:	f9411be0 	ldr	x0, [sp, #560]
    40001204:	9100e3e1 	add	x1, sp, #0x38
    40001208:	52800044 	mov	w4, #0x2                   	// #2
    4000120c:	d2801903 	mov	x3, #0xc8                  	// #200
    40001210:	aa0103e2 	mov	x2, x1
    40001214:	528000e1 	mov	w1, #0x7                   	// #7
    40001218:	9400023c 	bl	40001b08 <stdint_to_ascii>
	UART_puts(UART_ID_2,
    4000121c:	aa0003e1 	mov	x1, x0
    40001220:	52800020 	mov	w0, #0x1                   	// #1
    40001224:	940008d3 	bl	40003570 <UART_puts>

	loop
	{
		uint8 data;

		if (UART_read(UART_ID_2, &data)) {
    40001228:	9100bfe0 	add	x0, sp, #0x2f
    4000122c:	aa0003e1 	mov	x1, x0
    40001230:	52800020 	mov	w0, #0x1                   	// #1
    40001234:	9400095c 	bl	400037a4 <UART_read>
    40001238:	12001c00 	and	w0, w0, #0xff
    4000123c:	12000000 	and	w0, w0, #0x1
    40001240:	7100001f 	cmp	w0, #0x0
    40001244:	54ffff20 	b.eq	40001228 <kernel_entry+0x128>  // b.none
			UART_putc(UART_ID_2, data);
    40001248:	3940bfe0 	ldrb	w0, [sp, #47]
    4000124c:	2a0003e1 	mov	w1, w0
    40001250:	52800020 	mov	w0, #0x1                   	// #1
    40001254:	940008ad 	bl	40003508 <UART_putc>
	{
    40001258:	17fffff4 	b	40001228 <kernel_entry+0x128>

000000004000125c <ARM_get_cpu_affinity>:
#include <arm/sysregs.h>

#include "lib/stdint.h"

CpuAffinity ARM_get_cpu_affinity()
{
    4000125c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    40001260:	910003fd 	mov	x29, sp
	uint64 v = _ARM_MPIDR_EL1();
    40001264:	97fffb7c 	bl	40000054 <_ARM_MPIDR_EL1>
    40001268:	f9000fe0 	str	x0, [sp, #24]
	CpuAffinity cpuid = {
		.aff0 = (v & 0xFFUL),
		.aff1 = ((v >> 8) & 0xFFUL),
		.aff2 = ((v >> 16) & 0xFFUL),
		.aff3 = ((v >> 32) & 0xFFUL),
    4000126c:	f9400fe0 	ldr	x0, [sp, #24]
    40001270:	d360fc00 	lsr	x0, x0, #32
	CpuAffinity cpuid = {
    40001274:	12001c00 	and	w0, w0, #0xff
    40001278:	390043e0 	strb	w0, [sp, #16]
		.aff2 = ((v >> 16) & 0xFFUL),
    4000127c:	f9400fe0 	ldr	x0, [sp, #24]
    40001280:	d350fc00 	lsr	x0, x0, #16
	CpuAffinity cpuid = {
    40001284:	12001c00 	and	w0, w0, #0xff
    40001288:	390047e0 	strb	w0, [sp, #17]
		.aff1 = ((v >> 8) & 0xFFUL),
    4000128c:	f9400fe0 	ldr	x0, [sp, #24]
    40001290:	d348fc00 	lsr	x0, x0, #8
	CpuAffinity cpuid = {
    40001294:	12001c00 	and	w0, w0, #0xff
    40001298:	39004be0 	strb	w0, [sp, #18]
    4000129c:	f9400fe0 	ldr	x0, [sp, #24]
    400012a0:	12001c00 	and	w0, w0, #0xff
    400012a4:	39004fe0 	strb	w0, [sp, #19]
	};

	return cpuid;
    400012a8:	b94013e0 	ldr	w0, [sp, #16]
}
    400012ac:	a8c27bfd 	ldp	x29, x30, [sp], #32
    400012b0:	d65f03c0 	ret

00000000400012b4 <el2_low_a32_serror_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    400012b4:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    400012b8:	910003fd 	mov	x29, sp
    400012bc:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400012c0:	9123a000 	add	x0, x0, #0x8e8
    400012c4:	f9001fe0 	str	x0, [sp, #56]
    400012c8:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400012cc:	91242000 	add	x0, x0, #0x908
    400012d0:	f90023e0 	str	x0, [sp, #64]
    400012d4:	52800060 	mov	w0, #0x3                   	// #3
    400012d8:	b9004be0 	str	w0, [sp, #72]
    400012dc:	b9004fff 	str	wzr, [sp, #76]
    400012e0:	910043e2 	add	x2, sp, #0x10
    400012e4:	9100e3e3 	add	x3, sp, #0x38
    400012e8:	a9400460 	ldp	x0, x1, [x3]
    400012ec:	f9400863 	ldr	x3, [x3, #16]
    400012f0:	a9000440 	stp	x0, x1, [x2]
    400012f4:	f9000843 	str	x3, [x2, #16]
    400012f8:	910043e0 	add	x0, sp, #0x10
    400012fc:	97fffef6 	bl	40000ed4 <set_and_throw_panic>

0000000040001300 <el2_cur_spx_serror_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    40001300:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    40001304:	910003fd 	mov	x29, sp
    40001308:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    4000130c:	91250000 	add	x0, x0, #0x940
    40001310:	f9001fe0 	str	x0, [sp, #56]
    40001314:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001318:	91258000 	add	x0, x0, #0x960
    4000131c:	f90023e0 	str	x0, [sp, #64]
    40001320:	52800060 	mov	w0, #0x3                   	// #3
    40001324:	b9004be0 	str	w0, [sp, #72]
    40001328:	b9004fff 	str	wzr, [sp, #76]
    4000132c:	910043e2 	add	x2, sp, #0x10
    40001330:	9100e3e3 	add	x3, sp, #0x38
    40001334:	a9400460 	ldp	x0, x1, [x3]
    40001338:	f9400863 	ldr	x3, [x3, #16]
    4000133c:	a9000440 	stp	x0, x1, [x2]
    40001340:	f9000843 	str	x3, [x2, #16]
    40001344:	910043e0 	add	x0, sp, #0x10
    40001348:	97fffee3 	bl	40000ed4 <set_and_throw_panic>

000000004000134c <el2_low_a64_serror_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    4000134c:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    40001350:	910003fd 	mov	x29, sp
    40001354:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001358:	91266000 	add	x0, x0, #0x998
    4000135c:	f9001fe0 	str	x0, [sp, #56]
    40001360:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001364:	9126e000 	add	x0, x0, #0x9b8
    40001368:	f90023e0 	str	x0, [sp, #64]
    4000136c:	52800060 	mov	w0, #0x3                   	// #3
    40001370:	b9004be0 	str	w0, [sp, #72]
    40001374:	b9004fff 	str	wzr, [sp, #76]
    40001378:	910043e2 	add	x2, sp, #0x10
    4000137c:	9100e3e3 	add	x3, sp, #0x38
    40001380:	a9400460 	ldp	x0, x1, [x3]
    40001384:	f9400863 	ldr	x3, [x3, #16]
    40001388:	a9000440 	stp	x0, x1, [x2]
    4000138c:	f9000843 	str	x3, [x2, #16]
    40001390:	910043e0 	add	x0, sp, #0x10
    40001394:	97fffed0 	bl	40000ed4 <set_and_throw_panic>

0000000040001398 <el2_low_a64_sync_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    40001398:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    4000139c:	910003fd 	mov	x29, sp
    400013a0:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400013a4:	9127c000 	add	x0, x0, #0x9f0
    400013a8:	f9001fe0 	str	x0, [sp, #56]
    400013ac:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400013b0:	91284000 	add	x0, x0, #0xa10
    400013b4:	f90023e0 	str	x0, [sp, #64]
    400013b8:	52800060 	mov	w0, #0x3                   	// #3
    400013bc:	b9004be0 	str	w0, [sp, #72]
    400013c0:	b9004fff 	str	wzr, [sp, #76]
    400013c4:	910043e2 	add	x2, sp, #0x10
    400013c8:	9100e3e3 	add	x3, sp, #0x38
    400013cc:	a9400460 	ldp	x0, x1, [x3]
    400013d0:	f9400863 	ldr	x3, [x3, #16]
    400013d4:	a9000440 	stp	x0, x1, [x2]
    400013d8:	f9000843 	str	x3, [x2, #16]
    400013dc:	910043e0 	add	x0, sp, #0x10
    400013e0:	97fffebd 	bl	40000ed4 <set_and_throw_panic>

00000000400013e4 <el2_cur_sp0_irq_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    400013e4:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    400013e8:	910003fd 	mov	x29, sp
    400013ec:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400013f0:	91292000 	add	x0, x0, #0xa48
    400013f4:	f9001fe0 	str	x0, [sp, #56]
    400013f8:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400013fc:	9129a000 	add	x0, x0, #0xa68
    40001400:	f90023e0 	str	x0, [sp, #64]
    40001404:	52800060 	mov	w0, #0x3                   	// #3
    40001408:	b9004be0 	str	w0, [sp, #72]
    4000140c:	b9004fff 	str	wzr, [sp, #76]
    40001410:	910043e2 	add	x2, sp, #0x10
    40001414:	9100e3e3 	add	x3, sp, #0x38
    40001418:	a9400460 	ldp	x0, x1, [x3]
    4000141c:	f9400863 	ldr	x3, [x3, #16]
    40001420:	a9000440 	stp	x0, x1, [x2]
    40001424:	f9000843 	str	x3, [x2, #16]
    40001428:	910043e0 	add	x0, sp, #0x10
    4000142c:	97fffeaa 	bl	40000ed4 <set_and_throw_panic>

0000000040001430 <el2_cur_sp0_serror_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    40001430:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    40001434:	910003fd 	mov	x29, sp
    40001438:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    4000143c:	912a8000 	add	x0, x0, #0xaa0
    40001440:	f9001fe0 	str	x0, [sp, #56]
    40001444:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001448:	912b0000 	add	x0, x0, #0xac0
    4000144c:	f90023e0 	str	x0, [sp, #64]
    40001450:	52800060 	mov	w0, #0x3                   	// #3
    40001454:	b9004be0 	str	w0, [sp, #72]
    40001458:	b9004fff 	str	wzr, [sp, #76]
    4000145c:	910043e2 	add	x2, sp, #0x10
    40001460:	9100e3e3 	add	x3, sp, #0x38
    40001464:	a9400460 	ldp	x0, x1, [x3]
    40001468:	f9400863 	ldr	x3, [x3, #16]
    4000146c:	a9000440 	stp	x0, x1, [x2]
    40001470:	f9000843 	str	x3, [x2, #16]
    40001474:	910043e0 	add	x0, sp, #0x10
    40001478:	97fffe97 	bl	40000ed4 <set_and_throw_panic>

000000004000147c <el2_low_a64_irq_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    4000147c:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    40001480:	910003fd 	mov	x29, sp
    40001484:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001488:	912be000 	add	x0, x0, #0xaf8
    4000148c:	f9001fe0 	str	x0, [sp, #56]
    40001490:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001494:	912c6000 	add	x0, x0, #0xb18
    40001498:	f90023e0 	str	x0, [sp, #64]
    4000149c:	52800060 	mov	w0, #0x3                   	// #3
    400014a0:	b9004be0 	str	w0, [sp, #72]
    400014a4:	b9004fff 	str	wzr, [sp, #76]
    400014a8:	910043e2 	add	x2, sp, #0x10
    400014ac:	9100e3e3 	add	x3, sp, #0x38
    400014b0:	a9400460 	ldp	x0, x1, [x3]
    400014b4:	f9400863 	ldr	x3, [x3, #16]
    400014b8:	a9000440 	stp	x0, x1, [x2]
    400014bc:	f9000843 	str	x3, [x2, #16]
    400014c0:	910043e0 	add	x0, sp, #0x10
    400014c4:	97fffe84 	bl	40000ed4 <set_and_throw_panic>

00000000400014c8 <el2_low_a64_fiq_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    400014c8:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    400014cc:	910003fd 	mov	x29, sp
    400014d0:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400014d4:	912d4000 	add	x0, x0, #0xb50
    400014d8:	f9001fe0 	str	x0, [sp, #56]
    400014dc:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400014e0:	912dc000 	add	x0, x0, #0xb70
    400014e4:	f90023e0 	str	x0, [sp, #64]
    400014e8:	52800060 	mov	w0, #0x3                   	// #3
    400014ec:	b9004be0 	str	w0, [sp, #72]
    400014f0:	b9004fff 	str	wzr, [sp, #76]
    400014f4:	910043e2 	add	x2, sp, #0x10
    400014f8:	9100e3e3 	add	x3, sp, #0x38
    400014fc:	a9400460 	ldp	x0, x1, [x3]
    40001500:	f9400863 	ldr	x3, [x3, #16]
    40001504:	a9000440 	stp	x0, x1, [x2]
    40001508:	f9000843 	str	x3, [x2, #16]
    4000150c:	910043e0 	add	x0, sp, #0x10
    40001510:	97fffe71 	bl	40000ed4 <set_and_throw_panic>

0000000040001514 <el2_cur_spx_fiq_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    40001514:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    40001518:	910003fd 	mov	x29, sp
    4000151c:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001520:	912ea000 	add	x0, x0, #0xba8
    40001524:	f9001fe0 	str	x0, [sp, #56]
    40001528:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    4000152c:	912f2000 	add	x0, x0, #0xbc8
    40001530:	f90023e0 	str	x0, [sp, #64]
    40001534:	52800060 	mov	w0, #0x3                   	// #3
    40001538:	b9004be0 	str	w0, [sp, #72]
    4000153c:	b9004fff 	str	wzr, [sp, #76]
    40001540:	910043e2 	add	x2, sp, #0x10
    40001544:	9100e3e3 	add	x3, sp, #0x38
    40001548:	a9400460 	ldp	x0, x1, [x3]
    4000154c:	f9400863 	ldr	x3, [x3, #16]
    40001550:	a9000440 	stp	x0, x1, [x2]
    40001554:	f9000843 	str	x3, [x2, #16]
    40001558:	910043e0 	add	x0, sp, #0x10
    4000155c:	97fffe5e 	bl	40000ed4 <set_and_throw_panic>

0000000040001560 <el2_low_a32_irq_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    40001560:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    40001564:	910003fd 	mov	x29, sp
    40001568:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    4000156c:	91300000 	add	x0, x0, #0xc00
    40001570:	f9001fe0 	str	x0, [sp, #56]
    40001574:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001578:	91308000 	add	x0, x0, #0xc20
    4000157c:	f90023e0 	str	x0, [sp, #64]
    40001580:	52800060 	mov	w0, #0x3                   	// #3
    40001584:	b9004be0 	str	w0, [sp, #72]
    40001588:	b9004fff 	str	wzr, [sp, #76]
    4000158c:	910043e2 	add	x2, sp, #0x10
    40001590:	9100e3e3 	add	x3, sp, #0x38
    40001594:	a9400460 	ldp	x0, x1, [x3]
    40001598:	f9400863 	ldr	x3, [x3, #16]
    4000159c:	a9000440 	stp	x0, x1, [x2]
    400015a0:	f9000843 	str	x3, [x2, #16]
    400015a4:	910043e0 	add	x0, sp, #0x10
    400015a8:	97fffe4b 	bl	40000ed4 <set_and_throw_panic>

00000000400015ac <el2_cur_sp0_fiq_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    400015ac:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    400015b0:	910003fd 	mov	x29, sp
    400015b4:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400015b8:	91316000 	add	x0, x0, #0xc58
    400015bc:	f9001fe0 	str	x0, [sp, #56]
    400015c0:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400015c4:	9131e000 	add	x0, x0, #0xc78
    400015c8:	f90023e0 	str	x0, [sp, #64]
    400015cc:	52800060 	mov	w0, #0x3                   	// #3
    400015d0:	b9004be0 	str	w0, [sp, #72]
    400015d4:	b9004fff 	str	wzr, [sp, #76]
    400015d8:	910043e2 	add	x2, sp, #0x10
    400015dc:	9100e3e3 	add	x3, sp, #0x38
    400015e0:	a9400460 	ldp	x0, x1, [x3]
    400015e4:	f9400863 	ldr	x3, [x3, #16]
    400015e8:	a9000440 	stp	x0, x1, [x2]
    400015ec:	f9000843 	str	x3, [x2, #16]
    400015f0:	910043e0 	add	x0, sp, #0x10
    400015f4:	97fffe38 	bl	40000ed4 <set_and_throw_panic>

00000000400015f8 <el2_low_a32_fiq_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    400015f8:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    400015fc:	910003fd 	mov	x29, sp
    40001600:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001604:	9132c000 	add	x0, x0, #0xcb0
    40001608:	f9001fe0 	str	x0, [sp, #56]
    4000160c:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001610:	91334000 	add	x0, x0, #0xcd0
    40001614:	f90023e0 	str	x0, [sp, #64]
    40001618:	52800060 	mov	w0, #0x3                   	// #3
    4000161c:	b9004be0 	str	w0, [sp, #72]
    40001620:	b9004fff 	str	wzr, [sp, #76]
    40001624:	910043e2 	add	x2, sp, #0x10
    40001628:	9100e3e3 	add	x3, sp, #0x38
    4000162c:	a9400460 	ldp	x0, x1, [x3]
    40001630:	f9400863 	ldr	x3, [x3, #16]
    40001634:	a9000440 	stp	x0, x1, [x2]
    40001638:	f9000843 	str	x3, [x2, #16]
    4000163c:	910043e0 	add	x0, sp, #0x10
    40001640:	97fffe25 	bl	40000ed4 <set_and_throw_panic>

0000000040001644 <el2_cur_spx_sync_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    40001644:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    40001648:	910003fd 	mov	x29, sp
    4000164c:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001650:	91342000 	add	x0, x0, #0xd08
    40001654:	f9001fe0 	str	x0, [sp, #56]
    40001658:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    4000165c:	9134a000 	add	x0, x0, #0xd28
    40001660:	f90023e0 	str	x0, [sp, #64]
    40001664:	52800060 	mov	w0, #0x3                   	// #3
    40001668:	b9004be0 	str	w0, [sp, #72]
    4000166c:	b9004fff 	str	wzr, [sp, #76]
    40001670:	910043e2 	add	x2, sp, #0x10
    40001674:	9100e3e3 	add	x3, sp, #0x38
    40001678:	a9400460 	ldp	x0, x1, [x3]
    4000167c:	f9400863 	ldr	x3, [x3, #16]
    40001680:	a9000440 	stp	x0, x1, [x2]
    40001684:	f9000843 	str	x3, [x2, #16]
    40001688:	910043e0 	add	x0, sp, #0x10
    4000168c:	97fffe12 	bl	40000ed4 <set_and_throw_panic>

0000000040001690 <el2_low_a32_sync_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    40001690:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    40001694:	910003fd 	mov	x29, sp
    40001698:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    4000169c:	91358000 	add	x0, x0, #0xd60
    400016a0:	f9001fe0 	str	x0, [sp, #56]
    400016a4:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400016a8:	91360000 	add	x0, x0, #0xd80
    400016ac:	f90023e0 	str	x0, [sp, #64]
    400016b0:	52800060 	mov	w0, #0x3                   	// #3
    400016b4:	b9004be0 	str	w0, [sp, #72]
    400016b8:	b9004fff 	str	wzr, [sp, #76]
    400016bc:	910043e2 	add	x2, sp, #0x10
    400016c0:	9100e3e3 	add	x3, sp, #0x38
    400016c4:	a9400460 	ldp	x0, x1, [x3]
    400016c8:	f9400863 	ldr	x3, [x3, #16]
    400016cc:	a9000440 	stp	x0, x1, [x2]
    400016d0:	f9000843 	str	x3, [x2, #16]
    400016d4:	910043e0 	add	x0, sp, #0x10
    400016d8:	97fffdff 	bl	40000ed4 <set_and_throw_panic>

00000000400016dc <el2_cur_sp0_sync_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    400016dc:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    400016e0:	910003fd 	mov	x29, sp
    400016e4:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400016e8:	9136e000 	add	x0, x0, #0xdb8
    400016ec:	f9001fe0 	str	x0, [sp, #56]
    400016f0:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400016f4:	91376000 	add	x0, x0, #0xdd8
    400016f8:	f90023e0 	str	x0, [sp, #64]
    400016fc:	52800060 	mov	w0, #0x3                   	// #3
    40001700:	b9004be0 	str	w0, [sp, #72]
    40001704:	b9004fff 	str	wzr, [sp, #76]
    40001708:	910043e2 	add	x2, sp, #0x10
    4000170c:	9100e3e3 	add	x3, sp, #0x38
    40001710:	a9400460 	ldp	x0, x1, [x3]
    40001714:	f9400863 	ldr	x3, [x3, #16]
    40001718:	a9000440 	stp	x0, x1, [x2]
    4000171c:	f9000843 	str	x3, [x2, #16]
    40001720:	910043e0 	add	x0, sp, #0x10
    40001724:	97fffdec 	bl	40000ed4 <set_and_throw_panic>

0000000040001728 <el2_cur_spx_irq_handler>:
#include <arm/exceptions/handlers/handlers_macros.h>

    40001728:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    4000172c:	910003fd 	mov	x29, sp
    40001730:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001734:	91384000 	add	x0, x0, #0xe10
    40001738:	f9001fe0 	str	x0, [sp, #56]
    4000173c:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001740:	9138c000 	add	x0, x0, #0xe30
    40001744:	f90023e0 	str	x0, [sp, #64]
    40001748:	52800060 	mov	w0, #0x3                   	// #3
    4000174c:	b9004be0 	str	w0, [sp, #72]
    40001750:	b9004fff 	str	wzr, [sp, #76]
    40001754:	910043e2 	add	x2, sp, #0x10
    40001758:	9100e3e3 	add	x3, sp, #0x38
    4000175c:	a9400460 	ldp	x0, x1, [x3]
    40001760:	f9400863 	ldr	x3, [x3, #16]
    40001764:	a9000440 	stp	x0, x1, [x2]
    40001768:	f9000843 	str	x3, [x2, #16]
    4000176c:	910043e0 	add	x0, sp, #0x10
    40001770:	97fffdd9 	bl	40000ed4 <set_and_throw_panic>

0000000040001774 <exceptions_get_status>:
extern void _serror_exceptions_disable();
extern void _debug_exceptions_disable();

// https://developer.arm.com/documentation/111107/2025-09/AArch64-Registers/DAIF--Interrupt-Mask-Bits
EXCEPTION_STATUS exceptions_get_status()
{
    40001774:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    40001778:	910003fd 	mov	x29, sp
    4000177c:	f9000bf3 	str	x19, [sp, #16]
	uint64 daif = _exceptions_get_DAIF();
    40001780:	97fffc80 	bl	40000980 <_exceptions_get_DAIF>
    40001784:	f90017e0 	str	x0, [sp, #40]

	return (EXCEPTION_STATUS){.fiq = !((daif >> 6) & 1UL),
    40001788:	f94017e0 	ldr	x0, [sp, #40]
    4000178c:	d346fc00 	lsr	x0, x0, #6
    40001790:	92400000 	and	x0, x0, #0x1
    40001794:	f100001f 	cmp	x0, #0x0
    40001798:	1a9f17e0 	cset	w0, eq	// eq = none
    4000179c:	12001c03 	and	w3, w0, #0xff
							  .irq = !((daif >> 7) & 1UL),
    400017a0:	f94017e0 	ldr	x0, [sp, #40]
    400017a4:	d347fc00 	lsr	x0, x0, #7
    400017a8:	92400000 	and	x0, x0, #0x1
    400017ac:	f100001f 	cmp	x0, #0x0
    400017b0:	1a9f17e0 	cset	w0, eq	// eq = none
    400017b4:	12001c02 	and	w2, w0, #0xff
							  .serror = !((daif >> 8) & 1UL),
    400017b8:	f94017e0 	ldr	x0, [sp, #40]
    400017bc:	d348fc00 	lsr	x0, x0, #8
    400017c0:	92400000 	and	x0, x0, #0x1
    400017c4:	f100001f 	cmp	x0, #0x0
    400017c8:	1a9f17e0 	cset	w0, eq	// eq = none
    400017cc:	12001c01 	and	w1, w0, #0xff
							  .debug = !((daif >> 9) & 1UL)};
    400017d0:	f94017e0 	ldr	x0, [sp, #40]
    400017d4:	d349fc00 	lsr	x0, x0, #9
    400017d8:	92400000 	and	x0, x0, #0x1
    400017dc:	f100001f 	cmp	x0, #0x0
    400017e0:	1a9f17e0 	cset	w0, eq	// eq = none
    400017e4:	12001c00 	and	w0, w0, #0xff
	return (EXCEPTION_STATUS){.fiq = !((daif >> 6) & 1UL),
    400017e8:	33001c73 	bfxil	w19, w3, #0, #8
    400017ec:	33181c53 	bfi	w19, w2, #8, #8
    400017f0:	33101c33 	bfi	w19, w1, #16, #8
    400017f4:	33081c13 	bfi	w19, w0, #24, #8
    400017f8:	2a1303e0 	mov	w0, w19
}
    400017fc:	f9400bf3 	ldr	x19, [sp, #16]
    40001800:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40001804:	d65f03c0 	ret

0000000040001808 <exceptions_set_status>:

void exceptions_set_status(EXCEPTION_STATUS status)
{
    40001808:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    4000180c:	910003fd 	mov	x29, sp
    40001810:	b9003be0 	str	w0, [sp, #56]
	if (status.fiq)
    40001814:	3940e3e0 	ldrb	w0, [sp, #56]
    40001818:	12000000 	and	w0, w0, #0x1
    4000181c:	7100001f 	cmp	w0, #0x0
    40001820:	54000060 	b.eq	4000182c <exceptions_set_status+0x24>  // b.none
		_fiq_exceptions_enable();
    40001824:	97fffc59 	bl	40000988 <_fiq_exceptions_enable>
    40001828:	14000002 	b	40001830 <exceptions_set_status+0x28>
	else
		_fiq_exceptions_disable();
    4000182c:	97fffc63 	bl	400009b8 <_fiq_exceptions_disable>

	if (status.irq)
    40001830:	3940e7e0 	ldrb	w0, [sp, #57]
    40001834:	12000000 	and	w0, w0, #0x1
    40001838:	7100001f 	cmp	w0, #0x0
    4000183c:	54000060 	b.eq	40001848 <exceptions_set_status+0x40>  // b.none
		_irq_exceptions_enable();
    40001840:	97fffc55 	bl	40000994 <_irq_exceptions_enable>
    40001844:	14000002 	b	4000184c <exceptions_set_status+0x44>
	else
		_irq_exceptions_disable();
    40001848:	97fffc5f 	bl	400009c4 <_irq_exceptions_disable>

	if (status.serror)
    4000184c:	3940ebe0 	ldrb	w0, [sp, #58]
    40001850:	12000000 	and	w0, w0, #0x1
    40001854:	7100001f 	cmp	w0, #0x0
    40001858:	54000060 	b.eq	40001864 <exceptions_set_status+0x5c>  // b.none
		_serror_exceptions_enable();
    4000185c:	97fffc51 	bl	400009a0 <_serror_exceptions_enable>
    40001860:	14000002 	b	40001868 <exceptions_set_status+0x60>
	else
		_serror_exceptions_disable();
    40001864:	97fffc5b 	bl	400009d0 <_serror_exceptions_disable>

	if (status.debug)
    40001868:	3940efe0 	ldrb	w0, [sp, #59]
    4000186c:	12000000 	and	w0, w0, #0x1
    40001870:	7100001f 	cmp	w0, #0x0
    40001874:	54000060 	b.eq	40001880 <exceptions_set_status+0x78>  // b.none
		_debug_exceptions_enable();
    40001878:	97fffc4d 	bl	400009ac <_debug_exceptions_enable>
    4000187c:	14000002 	b	40001884 <exceptions_set_status+0x7c>
	else
		_debug_exceptions_disable();
    40001880:	97fffc57 	bl	400009dc <_debug_exceptions_disable>

#ifdef TEST
	EXCEPTION_STATUS current = exceptions_get_status();
    40001884:	97ffffbc 	bl	40001774 <exceptions_get_status>
    40001888:	b9005be0 	str	w0, [sp, #88]

	if (current.fiq != status.fiq || current.irq != status.irq ||
    4000188c:	394163e1 	ldrb	w1, [sp, #88]
    40001890:	3940e3e0 	ldrb	w0, [sp, #56]
    40001894:	6b00003f 	cmp	w1, w0
    40001898:	540001a1 	b.ne	400018cc <exceptions_set_status+0xc4>  // b.any
    4000189c:	394167e1 	ldrb	w1, [sp, #89]
    400018a0:	3940e7e0 	ldrb	w0, [sp, #57]
    400018a4:	6b00003f 	cmp	w1, w0
    400018a8:	54000121 	b.ne	400018cc <exceptions_set_status+0xc4>  // b.any
		current.serror != status.serror || current.debug != status.debug)
    400018ac:	39416be1 	ldrb	w1, [sp, #90]
    400018b0:	3940ebe0 	ldrb	w0, [sp, #58]
	if (current.fiq != status.fiq || current.irq != status.irq ||
    400018b4:	6b00003f 	cmp	w1, w0
    400018b8:	540000a1 	b.ne	400018cc <exceptions_set_status+0xc4>  // b.any
		current.serror != status.serror || current.debug != status.debug)
    400018bc:	39416fe1 	ldrb	w1, [sp, #91]
    400018c0:	3940efe0 	ldrb	w0, [sp, #59]
    400018c4:	6b00003f 	cmp	w1, w0
    400018c8:	54000240 	b.eq	40001910 <exceptions_set_status+0x108>  // b.none
		PANIC("exceptions_set_status error");
    400018cc:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400018d0:	9139a000 	add	x0, x0, #0xe68
    400018d4:	f90023e0 	str	x0, [sp, #64]
    400018d8:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400018dc:	913a2000 	add	x0, x0, #0xe88
    400018e0:	f90027e0 	str	x0, [sp, #72]
    400018e4:	528006e0 	mov	w0, #0x37                  	// #55
    400018e8:	b90053e0 	str	w0, [sp, #80]
    400018ec:	b90057ff 	str	wzr, [sp, #84]
    400018f0:	910043e2 	add	x2, sp, #0x10
    400018f4:	910103e3 	add	x3, sp, #0x40
    400018f8:	a9400460 	ldp	x0, x1, [x3]
    400018fc:	f9400863 	ldr	x3, [x3, #16]
    40001900:	a9000440 	stp	x0, x1, [x2]
    40001904:	f9000843 	str	x3, [x2, #16]
    40001908:	910043e0 	add	x0, sp, #0x10
    4000190c:	97fffd72 	bl	40000ed4 <set_and_throw_panic>
#endif
}
    40001910:	d503201f 	nop
    40001914:	a8c67bfd 	ldp	x29, x30, [sp], #96
    40001918:	d65f03c0 	ret

000000004000191c <exceptions_enable>:

void exceptions_enable(bool fiq, bool irq, bool serror, bool debug)
{
    4000191c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    40001920:	910003fd 	mov	x29, sp
    40001924:	39007fe0 	strb	w0, [sp, #31]
    40001928:	39007be1 	strb	w1, [sp, #30]
    4000192c:	390077e2 	strb	w2, [sp, #29]
    40001930:	390073e3 	strb	w3, [sp, #28]
	if (fiq) _fiq_exceptions_enable();
    40001934:	39407fe0 	ldrb	w0, [sp, #31]
    40001938:	12000000 	and	w0, w0, #0x1
    4000193c:	7100001f 	cmp	w0, #0x0
    40001940:	54000040 	b.eq	40001948 <exceptions_enable+0x2c>  // b.none
    40001944:	97fffc11 	bl	40000988 <_fiq_exceptions_enable>

	if (irq) _irq_exceptions_enable();
    40001948:	39407be0 	ldrb	w0, [sp, #30]
    4000194c:	12000000 	and	w0, w0, #0x1
    40001950:	7100001f 	cmp	w0, #0x0
    40001954:	54000040 	b.eq	4000195c <exceptions_enable+0x40>  // b.none
    40001958:	97fffc0f 	bl	40000994 <_irq_exceptions_enable>

	if (serror) _serror_exceptions_enable();
    4000195c:	394077e0 	ldrb	w0, [sp, #29]
    40001960:	12000000 	and	w0, w0, #0x1
    40001964:	7100001f 	cmp	w0, #0x0
    40001968:	54000040 	b.eq	40001970 <exceptions_enable+0x54>  // b.none
    4000196c:	97fffc0d 	bl	400009a0 <_serror_exceptions_enable>

	if (debug) _debug_exceptions_enable();
    40001970:	394073e0 	ldrb	w0, [sp, #28]
    40001974:	12000000 	and	w0, w0, #0x1
    40001978:	7100001f 	cmp	w0, #0x0
    4000197c:	54000040 	b.eq	40001984 <exceptions_enable+0x68>  // b.none
    40001980:	97fffc0b 	bl	400009ac <_debug_exceptions_enable>
}
    40001984:	d503201f 	nop
    40001988:	a8c27bfd 	ldp	x29, x30, [sp], #32
    4000198c:	d65f03c0 	ret

0000000040001990 <exceptions_disable>:

void exceptions_disable(bool fiq, bool irq, bool serror, bool debug)
{
    40001990:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    40001994:	910003fd 	mov	x29, sp
    40001998:	39007fe0 	strb	w0, [sp, #31]
    4000199c:	39007be1 	strb	w1, [sp, #30]
    400019a0:	390077e2 	strb	w2, [sp, #29]
    400019a4:	390073e3 	strb	w3, [sp, #28]
	if (fiq) _fiq_exceptions_disable();
    400019a8:	39407fe0 	ldrb	w0, [sp, #31]
    400019ac:	12000000 	and	w0, w0, #0x1
    400019b0:	7100001f 	cmp	w0, #0x0
    400019b4:	54000040 	b.eq	400019bc <exceptions_disable+0x2c>  // b.none
    400019b8:	97fffc00 	bl	400009b8 <_fiq_exceptions_disable>

	if (irq) _irq_exceptions_disable();
    400019bc:	39407be0 	ldrb	w0, [sp, #30]
    400019c0:	12000000 	and	w0, w0, #0x1
    400019c4:	7100001f 	cmp	w0, #0x0
    400019c8:	54000040 	b.eq	400019d0 <exceptions_disable+0x40>  // b.none
    400019cc:	97fffbfe 	bl	400009c4 <_irq_exceptions_disable>

	if (serror) _serror_exceptions_disable();
    400019d0:	394077e0 	ldrb	w0, [sp, #29]
    400019d4:	12000000 	and	w0, w0, #0x1
    400019d8:	7100001f 	cmp	w0, #0x0
    400019dc:	54000040 	b.eq	400019e4 <exceptions_disable+0x54>  // b.none
    400019e0:	97fffbfc 	bl	400009d0 <_serror_exceptions_disable>

	if (debug) _debug_exceptions_disable();
    400019e4:	394073e0 	ldrb	w0, [sp, #28]
    400019e8:	12000000 	and	w0, w0, #0x1
    400019ec:	7100001f 	cmp	w0, #0x0
    400019f0:	54000040 	b.eq	400019f8 <exceptions_disable+0x68>  // b.none
    400019f4:	97fffbfa 	bl	400009dc <_debug_exceptions_disable>
    400019f8:	d503201f 	nop
    400019fc:	a8c27bfd 	ldp	x29, x30, [sp], #32
    40001a00:	d65f03c0 	ret

0000000040001a04 <strcopy>:
#include <lib/stdbool.h>
#include <lib/stdint.h>
#include <lib/string.h>

void strcopy(char *dst, char *src, uint64 max_size)
{
    40001a04:	d100c3ff 	sub	sp, sp, #0x30
    40001a08:	f9000fe0 	str	x0, [sp, #24]
    40001a0c:	f9000be1 	str	x1, [sp, #16]
    40001a10:	f90007e2 	str	x2, [sp, #8]
	for (uint64 i = 0; i < max_size - 1; i++) {
    40001a14:	f90017ff 	str	xzr, [sp, #40]
    40001a18:	14000012 	b	40001a60 <strcopy+0x5c>
		dst[i] = src[i];
    40001a1c:	f9400be1 	ldr	x1, [sp, #16]
    40001a20:	f94017e0 	ldr	x0, [sp, #40]
    40001a24:	8b000021 	add	x1, x1, x0
    40001a28:	f9400fe2 	ldr	x2, [sp, #24]
    40001a2c:	f94017e0 	ldr	x0, [sp, #40]
    40001a30:	8b000040 	add	x0, x2, x0
    40001a34:	39400021 	ldrb	w1, [x1]
    40001a38:	39000001 	strb	w1, [x0]

		if (src[i] == '\0') return;
    40001a3c:	f9400be1 	ldr	x1, [sp, #16]
    40001a40:	f94017e0 	ldr	x0, [sp, #40]
    40001a44:	8b000020 	add	x0, x1, x0
    40001a48:	39400000 	ldrb	w0, [x0]
    40001a4c:	7100001f 	cmp	w0, #0x0
    40001a50:	540001e0 	b.eq	40001a8c <strcopy+0x88>  // b.none
	for (uint64 i = 0; i < max_size - 1; i++) {
    40001a54:	f94017e0 	ldr	x0, [sp, #40]
    40001a58:	91000400 	add	x0, x0, #0x1
    40001a5c:	f90017e0 	str	x0, [sp, #40]
    40001a60:	f94007e0 	ldr	x0, [sp, #8]
    40001a64:	d1000400 	sub	x0, x0, #0x1
    40001a68:	f94017e1 	ldr	x1, [sp, #40]
    40001a6c:	eb00003f 	cmp	x1, x0
    40001a70:	54fffd63 	b.cc	40001a1c <strcopy+0x18>  // b.lo, b.ul, b.last
	}

	dst[max_size - 1] = '\0';
    40001a74:	f94007e0 	ldr	x0, [sp, #8]
    40001a78:	d1000400 	sub	x0, x0, #0x1
    40001a7c:	f9400fe1 	ldr	x1, [sp, #24]
    40001a80:	8b000020 	add	x0, x1, x0
    40001a84:	3900001f 	strb	wzr, [x0]
    40001a88:	14000002 	b	40001a90 <strcopy+0x8c>
		if (src[i] == '\0') return;
    40001a8c:	d503201f 	nop
}
    40001a90:	9100c3ff 	add	sp, sp, #0x30
    40001a94:	d65f03c0 	ret

0000000040001a98 <uint8_to_ascii_char>:

char uint8_to_ascii_char(uint8 n)
{
    40001a98:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    40001a9c:	910003fd 	mov	x29, sp
    40001aa0:	3900ffe0 	strb	w0, [sp, #63]
	if (n > 9) {
    40001aa4:	3940ffe0 	ldrb	w0, [sp, #63]
    40001aa8:	7100241f 	cmp	w0, #0x9
    40001aac:	54000249 	b.ls	40001af4 <uint8_to_ascii_char+0x5c>  // b.plast
		PANIC(
    40001ab0:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001ab4:	913ac000 	add	x0, x0, #0xeb0
    40001ab8:	f90027e0 	str	x0, [sp, #72]
    40001abc:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001ac0:	913be000 	add	x0, x0, #0xef8
    40001ac4:	f9002be0 	str	x0, [sp, #80]
    40001ac8:	52800280 	mov	w0, #0x14                  	// #20
    40001acc:	b9005be0 	str	w0, [sp, #88]
    40001ad0:	b9005fff 	str	wzr, [sp, #92]
    40001ad4:	910043e2 	add	x2, sp, #0x10
    40001ad8:	910123e3 	add	x3, sp, #0x48
    40001adc:	a9400460 	ldp	x0, x1, [x3]
    40001ae0:	f9400863 	ldr	x3, [x3, #16]
    40001ae4:	a9000440 	stp	x0, x1, [x2]
    40001ae8:	f9000843 	str	x3, [x2, #16]
    40001aec:	910043e0 	add	x0, sp, #0x10
    40001af0:	97fffcf9 	bl	40000ed4 <set_and_throw_panic>
			"uint8_to_ascii_char: requires the input number to be between 0 "
			"and 9");
	}

	return (char)(n + '0');
    40001af4:	3940ffe0 	ldrb	w0, [sp, #63]
    40001af8:	1100c000 	add	w0, w0, #0x30
    40001afc:	12001c00 	and	w0, w0, #0xff
}
    40001b00:	a8c67bfd 	ldp	x29, x30, [sp], #96
    40001b04:	d65f03c0 	ret

0000000040001b08 <stdint_to_ascii>:
	'8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
};

char *stdint_to_ascii(STDINT_UNION n, STDINT_TYPES n_type, char *buf,
					  uint64 buf_len, STDINT_BASE_REPR repr)
{
    40001b08:	a9b17bfd 	stp	x29, x30, [sp, #-240]!
    40001b0c:	910003fd 	mov	x29, sp
    40001b10:	f90027e0 	str	x0, [sp, #72]
    40001b14:	b90047e1 	str	w1, [sp, #68]
    40001b18:	f9001fe2 	str	x2, [sp, #56]
    40001b1c:	f9001be3 	str	x3, [sp, #48]
    40001b20:	b90043e4 	str	w4, [sp, #64]
	uint64 repr_len = 0;
    40001b24:	f90077ff 	str	xzr, [sp, #232]
	switch (repr) {
    40001b28:	b94043e0 	ldr	w0, [sp, #64]
    40001b2c:	7100401f 	cmp	w0, #0x10
    40001b30:	54000220 	b.eq	40001b74 <stdint_to_ascii+0x6c>  // b.none
    40001b34:	b94043e0 	ldr	w0, [sp, #64]
    40001b38:	7100401f 	cmp	w0, #0x10
    40001b3c:	540002e8 	b.hi	40001b98 <stdint_to_ascii+0x90>  // b.pmore
    40001b40:	b94043e0 	ldr	w0, [sp, #64]
    40001b44:	7100281f 	cmp	w0, #0xa
    40001b48:	540004a0 	b.eq	40001bdc <stdint_to_ascii+0xd4>  // b.none
    40001b4c:	b94043e0 	ldr	w0, [sp, #64]
    40001b50:	7100281f 	cmp	w0, #0xa
    40001b54:	54000228 	b.hi	40001b98 <stdint_to_ascii+0x90>  // b.pmore
    40001b58:	b94043e0 	ldr	w0, [sp, #64]
    40001b5c:	7100081f 	cmp	w0, #0x2
    40001b60:	54000100 	b.eq	40001b80 <stdint_to_ascii+0x78>  // b.none
    40001b64:	b94043e0 	ldr	w0, [sp, #64]
    40001b68:	7100201f 	cmp	w0, #0x8
    40001b6c:	54000100 	b.eq	40001b8c <stdint_to_ascii+0x84>  // b.none
    40001b70:	1400000a 	b	40001b98 <stdint_to_ascii+0x90>
		case STDINT_BASE_REPR_DEC:
			break;
		case STDINT_BASE_REPR_HEX:
			repr_len = 2;
    40001b74:	d2800040 	mov	x0, #0x2                   	// #2
    40001b78:	f90077e0 	str	x0, [sp, #232]
			break;
    40001b7c:	14000019 	b	40001be0 <stdint_to_ascii+0xd8>
		case STDINT_BASE_REPR_BIN:
			repr_len = 2;
    40001b80:	d2800040 	mov	x0, #0x2                   	// #2
    40001b84:	f90077e0 	str	x0, [sp, #232]
			break;
    40001b88:	14000016 	b	40001be0 <stdint_to_ascii+0xd8>
		case STDINT_BASE_REPR_OCT:
			repr_len = 1;
    40001b8c:	d2800020 	mov	x0, #0x1                   	// #1
    40001b90:	f90077e0 	str	x0, [sp, #232]
			break;
    40001b94:	14000013 	b	40001be0 <stdint_to_ascii+0xd8>
		default:
			PANIC("Unexpected value of repr");
    40001b98:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001b9c:	913c8000 	add	x0, x0, #0xf20
    40001ba0:	f90037e0 	str	x0, [sp, #104]
    40001ba4:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001ba8:	913be000 	add	x0, x0, #0xef8
    40001bac:	f9003be0 	str	x0, [sp, #112]
    40001bb0:	52800640 	mov	w0, #0x32                  	// #50
    40001bb4:	b9007be0 	str	w0, [sp, #120]
    40001bb8:	b9007fff 	str	wzr, [sp, #124]
    40001bbc:	910043e2 	add	x2, sp, #0x10
    40001bc0:	9101a3e3 	add	x3, sp, #0x68
    40001bc4:	a9400460 	ldp	x0, x1, [x3]
    40001bc8:	f9400863 	ldr	x3, [x3, #16]
    40001bcc:	a9000440 	stp	x0, x1, [x2]
    40001bd0:	f9000843 	str	x3, [x2, #16]
    40001bd4:	910043e0 	add	x0, sp, #0x10
    40001bd8:	97fffcbf 	bl	40000ed4 <set_and_throw_panic>
			break;
    40001bdc:	d503201f 	nop
	}

	bool is_signed;
	int64 signed_value = 0;
    40001be0:	f9006fff 	str	xzr, [sp, #216]
	uint64 unsigned_value = 0;
    40001be4:	f9006bff 	str	xzr, [sp, #208]

	switch (n_type) {
    40001be8:	b94047e0 	ldr	w0, [sp, #68]
    40001bec:	71001c1f 	cmp	w0, #0x7
    40001bf0:	540009e0 	b.eq	40001d2c <stdint_to_ascii+0x224>  // b.none
    40001bf4:	b94047e0 	ldr	w0, [sp, #68]
    40001bf8:	71001c1f 	cmp	w0, #0x7
    40001bfc:	54000a08 	b.hi	40001d3c <stdint_to_ascii+0x234>  // b.pmore
    40001c00:	b94047e0 	ldr	w0, [sp, #68]
    40001c04:	7100181f 	cmp	w0, #0x6
    40001c08:	54000880 	b.eq	40001d18 <stdint_to_ascii+0x210>  // b.none
    40001c0c:	b94047e0 	ldr	w0, [sp, #68]
    40001c10:	7100181f 	cmp	w0, #0x6
    40001c14:	54000948 	b.hi	40001d3c <stdint_to_ascii+0x234>  // b.pmore
    40001c18:	b94047e0 	ldr	w0, [sp, #68]
    40001c1c:	7100141f 	cmp	w0, #0x5
    40001c20:	54000720 	b.eq	40001d04 <stdint_to_ascii+0x1fc>  // b.none
    40001c24:	b94047e0 	ldr	w0, [sp, #68]
    40001c28:	7100141f 	cmp	w0, #0x5
    40001c2c:	54000888 	b.hi	40001d3c <stdint_to_ascii+0x234>  // b.pmore
    40001c30:	b94047e0 	ldr	w0, [sp, #68]
    40001c34:	7100101f 	cmp	w0, #0x4
    40001c38:	540005a0 	b.eq	40001cec <stdint_to_ascii+0x1e4>  // b.none
    40001c3c:	b94047e0 	ldr	w0, [sp, #68]
    40001c40:	7100101f 	cmp	w0, #0x4
    40001c44:	540007c8 	b.hi	40001d3c <stdint_to_ascii+0x234>  // b.pmore
    40001c48:	b94047e0 	ldr	w0, [sp, #68]
    40001c4c:	71000c1f 	cmp	w0, #0x3
    40001c50:	54000440 	b.eq	40001cd8 <stdint_to_ascii+0x1d0>  // b.none
    40001c54:	b94047e0 	ldr	w0, [sp, #68]
    40001c58:	71000c1f 	cmp	w0, #0x3
    40001c5c:	54000708 	b.hi	40001d3c <stdint_to_ascii+0x234>  // b.pmore
    40001c60:	b94047e0 	ldr	w0, [sp, #68]
    40001c64:	7100081f 	cmp	w0, #0x2
    40001c68:	540002c0 	b.eq	40001cc0 <stdint_to_ascii+0x1b8>  // b.none
    40001c6c:	b94047e0 	ldr	w0, [sp, #68]
    40001c70:	7100081f 	cmp	w0, #0x2
    40001c74:	54000648 	b.hi	40001d3c <stdint_to_ascii+0x234>  // b.pmore
    40001c78:	b94047e0 	ldr	w0, [sp, #68]
    40001c7c:	7100001f 	cmp	w0, #0x0
    40001c80:	540000a0 	b.eq	40001c94 <stdint_to_ascii+0x18c>  // b.none
    40001c84:	b94047e0 	ldr	w0, [sp, #68]
    40001c88:	7100041f 	cmp	w0, #0x1
    40001c8c:	54000100 	b.eq	40001cac <stdint_to_ascii+0x1a4>  // b.none
    40001c90:	1400002b 	b	40001d3c <stdint_to_ascii+0x234>
		case STDINT_INT8:
			signed_value = n.int8;
    40001c94:	39c123e0 	ldrsb	w0, [sp, #72]
    40001c98:	93401c00 	sxtb	x0, w0
    40001c9c:	f9006fe0 	str	x0, [sp, #216]
			is_signed = true;
    40001ca0:	52800020 	mov	w0, #0x1                   	// #1
    40001ca4:	39039fe0 	strb	w0, [sp, #231]
			break;
    40001ca8:	14000036 	b	40001d80 <stdint_to_ascii+0x278>
		case STDINT_UINT8:
			unsigned_value = n.uint8;
    40001cac:	394123e0 	ldrb	w0, [sp, #72]
    40001cb0:	92401c00 	and	x0, x0, #0xff
    40001cb4:	f9006be0 	str	x0, [sp, #208]
			is_signed = false;
    40001cb8:	39039fff 	strb	wzr, [sp, #231]
			break;
    40001cbc:	14000031 	b	40001d80 <stdint_to_ascii+0x278>
		case STDINT_INT16:
			signed_value = n.int16;
    40001cc0:	79c093e0 	ldrsh	w0, [sp, #72]
    40001cc4:	93403c00 	sxth	x0, w0
    40001cc8:	f9006fe0 	str	x0, [sp, #216]
			is_signed = true;
    40001ccc:	52800020 	mov	w0, #0x1                   	// #1
    40001cd0:	39039fe0 	strb	w0, [sp, #231]
			break;
    40001cd4:	1400002b 	b	40001d80 <stdint_to_ascii+0x278>
		case STDINT_UINT16:
			unsigned_value = n.uint16;
    40001cd8:	794093e0 	ldrh	w0, [sp, #72]
    40001cdc:	92403c00 	and	x0, x0, #0xffff
    40001ce0:	f9006be0 	str	x0, [sp, #208]
			is_signed = false;
    40001ce4:	39039fff 	strb	wzr, [sp, #231]
			break;
    40001ce8:	14000026 	b	40001d80 <stdint_to_ascii+0x278>
		case STDINT_INT32:
			signed_value = n.int32;
    40001cec:	b9404be0 	ldr	w0, [sp, #72]
    40001cf0:	93407c00 	sxtw	x0, w0
    40001cf4:	f9006fe0 	str	x0, [sp, #216]
			is_signed = true;
    40001cf8:	52800020 	mov	w0, #0x1                   	// #1
    40001cfc:	39039fe0 	strb	w0, [sp, #231]
			break;
    40001d00:	14000020 	b	40001d80 <stdint_to_ascii+0x278>
		case STDINT_UINT32:
			unsigned_value = n.uint32;
    40001d04:	b9404be0 	ldr	w0, [sp, #72]
    40001d08:	2a0003e0 	mov	w0, w0
    40001d0c:	f9006be0 	str	x0, [sp, #208]
			is_signed = false;
    40001d10:	39039fff 	strb	wzr, [sp, #231]
			break;
    40001d14:	1400001b 	b	40001d80 <stdint_to_ascii+0x278>
		case STDINT_INT64:
			signed_value = n.int64;
    40001d18:	f94027e0 	ldr	x0, [sp, #72]
    40001d1c:	f9006fe0 	str	x0, [sp, #216]
			is_signed = true;
    40001d20:	52800020 	mov	w0, #0x1                   	// #1
    40001d24:	39039fe0 	strb	w0, [sp, #231]
			break;
    40001d28:	14000016 	b	40001d80 <stdint_to_ascii+0x278>
		case STDINT_UINT64:
			unsigned_value = n.uint64;
    40001d2c:	f94027e0 	ldr	x0, [sp, #72]
    40001d30:	f9006be0 	str	x0, [sp, #208]
			is_signed = false;
    40001d34:	39039fff 	strb	wzr, [sp, #231]
			break;
    40001d38:	14000012 	b	40001d80 <stdint_to_ascii+0x278>
		default:
			PANIC("stdint_to_ascii: STDINT_TYPES case not supported");
    40001d3c:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001d40:	913d0000 	add	x0, x0, #0xf40
    40001d44:	f9002be0 	str	x0, [sp, #80]
    40001d48:	f0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40001d4c:	913be000 	add	x0, x0, #0xef8
    40001d50:	f9002fe0 	str	x0, [sp, #88]
    40001d54:	52800b60 	mov	w0, #0x5b                  	// #91
    40001d58:	b90063e0 	str	w0, [sp, #96]
    40001d5c:	b90067ff 	str	wzr, [sp, #100]
    40001d60:	910043e2 	add	x2, sp, #0x10
    40001d64:	910143e3 	add	x3, sp, #0x50
    40001d68:	a9400460 	ldp	x0, x1, [x3]
    40001d6c:	f9400863 	ldr	x3, [x3, #16]
    40001d70:	a9000440 	stp	x0, x1, [x2]
    40001d74:	f9000843 	str	x3, [x2, #16]
    40001d78:	910043e0 	add	x0, sp, #0x10
    40001d7c:	97fffc56 	bl	40000ed4 <set_and_throw_panic>
	}

	uint64 value;
	bool negative = false;
    40001d80:	39031fff 	strb	wzr, [sp, #199]

	if (is_signed) {
    40001d84:	39439fe0 	ldrb	w0, [sp, #231]
    40001d88:	12000000 	and	w0, w0, #0x1
    40001d8c:	7100001f 	cmp	w0, #0x0
    40001d90:	540001a0 	b.eq	40001dc4 <stdint_to_ascii+0x2bc>  // b.none
		if (signed_value < 0) {
    40001d94:	f9406fe0 	ldr	x0, [sp, #216]
    40001d98:	f100001f 	cmp	x0, #0x0
    40001d9c:	540000ea 	b.ge	40001db8 <stdint_to_ascii+0x2b0>  // b.tcont
			negative = true;
    40001da0:	52800020 	mov	w0, #0x1                   	// #1
    40001da4:	39031fe0 	strb	w0, [sp, #199]
			value = (uint64)-signed_value;
    40001da8:	f9406fe0 	ldr	x0, [sp, #216]
    40001dac:	cb0003e0 	neg	x0, x0
    40001db0:	f90067e0 	str	x0, [sp, #200]
    40001db4:	14000006 	b	40001dcc <stdint_to_ascii+0x2c4>
		} else {
			value = (uint64)signed_value;
    40001db8:	f9406fe0 	ldr	x0, [sp, #216]
    40001dbc:	f90067e0 	str	x0, [sp, #200]
    40001dc0:	14000003 	b	40001dcc <stdint_to_ascii+0x2c4>
		}
	} else {
		value = unsigned_value;
    40001dc4:	f9406be0 	ldr	x0, [sp, #208]
    40001dc8:	f90067e0 	str	x0, [sp, #200]
	}

	if (value == 0 && !negative) {
    40001dcc:	f94067e0 	ldr	x0, [sp, #200]
    40001dd0:	f100001f 	cmp	x0, #0x0
    40001dd4:	54000b41 	b.ne	40001f3c <stdint_to_ascii+0x434>  // b.any
    40001dd8:	39431fe0 	ldrb	w0, [sp, #199]
    40001ddc:	52000000 	eor	w0, w0, #0x1
    40001de0:	12001c00 	and	w0, w0, #0xff
    40001de4:	12000000 	and	w0, w0, #0x1
    40001de8:	7100001f 	cmp	w0, #0x0
    40001dec:	54000a80 	b.eq	40001f3c <stdint_to_ascii+0x434>  // b.none
		if (buf_len < 2 + repr_len) goto panic;
    40001df0:	f94077e0 	ldr	x0, [sp, #232]
    40001df4:	91000800 	add	x0, x0, #0x2
    40001df8:	f9401be1 	ldr	x1, [sp, #48]
    40001dfc:	eb00003f 	cmp	x1, x0
    40001e00:	54001bc3 	b.cc	40002178 <stdint_to_ascii+0x670>  // b.lo, b.ul, b.last
		int64 i = 0;
    40001e04:	f9005fff 	str	xzr, [sp, #184]
		switch (repr) {
    40001e08:	b94043e0 	ldr	w0, [sp, #64]
    40001e0c:	7100401f 	cmp	w0, #0x10
    40001e10:	54000220 	b.eq	40001e54 <stdint_to_ascii+0x34c>  // b.none
    40001e14:	b94043e0 	ldr	w0, [sp, #64]
    40001e18:	7100401f 	cmp	w0, #0x10
    40001e1c:	54000748 	b.hi	40001f04 <stdint_to_ascii+0x3fc>  // b.pmore
    40001e20:	b94043e0 	ldr	w0, [sp, #64]
    40001e24:	7100281f 	cmp	w0, #0xa
    40001e28:	540006c0 	b.eq	40001f00 <stdint_to_ascii+0x3f8>  // b.none
    40001e2c:	b94043e0 	ldr	w0, [sp, #64]
    40001e30:	7100281f 	cmp	w0, #0xa
    40001e34:	54000688 	b.hi	40001f04 <stdint_to_ascii+0x3fc>  // b.pmore
    40001e38:	b94043e0 	ldr	w0, [sp, #64]
    40001e3c:	7100081f 	cmp	w0, #0x2
    40001e40:	540002c0 	b.eq	40001e98 <stdint_to_ascii+0x390>  // b.none
    40001e44:	b94043e0 	ldr	w0, [sp, #64]
    40001e48:	7100201f 	cmp	w0, #0x8
    40001e4c:	54000480 	b.eq	40001edc <stdint_to_ascii+0x3d4>  // b.none
    40001e50:	1400002d 	b	40001f04 <stdint_to_ascii+0x3fc>
			case STDINT_BASE_REPR_DEC:
				break;
			case STDINT_BASE_REPR_HEX:
				buf[i++] = '0';
    40001e54:	f9405fe0 	ldr	x0, [sp, #184]
    40001e58:	91000401 	add	x1, x0, #0x1
    40001e5c:	f9005fe1 	str	x1, [sp, #184]
    40001e60:	aa0003e1 	mov	x1, x0
    40001e64:	f9401fe0 	ldr	x0, [sp, #56]
    40001e68:	8b010000 	add	x0, x0, x1
    40001e6c:	52800601 	mov	w1, #0x30                  	// #48
    40001e70:	39000001 	strb	w1, [x0]
				buf[i++] = 'x';
    40001e74:	f9405fe0 	ldr	x0, [sp, #184]
    40001e78:	91000401 	add	x1, x0, #0x1
    40001e7c:	f9005fe1 	str	x1, [sp, #184]
    40001e80:	aa0003e1 	mov	x1, x0
    40001e84:	f9401fe0 	ldr	x0, [sp, #56]
    40001e88:	8b010000 	add	x0, x0, x1
    40001e8c:	52800f01 	mov	w1, #0x78                  	// #120
    40001e90:	39000001 	strb	w1, [x0]
				break;
    40001e94:	1400001c 	b	40001f04 <stdint_to_ascii+0x3fc>
			case STDINT_BASE_REPR_BIN:
				buf[i++] = '0';
    40001e98:	f9405fe0 	ldr	x0, [sp, #184]
    40001e9c:	91000401 	add	x1, x0, #0x1
    40001ea0:	f9005fe1 	str	x1, [sp, #184]
    40001ea4:	aa0003e1 	mov	x1, x0
    40001ea8:	f9401fe0 	ldr	x0, [sp, #56]
    40001eac:	8b010000 	add	x0, x0, x1
    40001eb0:	52800601 	mov	w1, #0x30                  	// #48
    40001eb4:	39000001 	strb	w1, [x0]
				buf[i++] = 'b';
    40001eb8:	f9405fe0 	ldr	x0, [sp, #184]
    40001ebc:	91000401 	add	x1, x0, #0x1
    40001ec0:	f9005fe1 	str	x1, [sp, #184]
    40001ec4:	aa0003e1 	mov	x1, x0
    40001ec8:	f9401fe0 	ldr	x0, [sp, #56]
    40001ecc:	8b010000 	add	x0, x0, x1
    40001ed0:	52800c41 	mov	w1, #0x62                  	// #98
    40001ed4:	39000001 	strb	w1, [x0]
				break;
    40001ed8:	1400000b 	b	40001f04 <stdint_to_ascii+0x3fc>
			case STDINT_BASE_REPR_OCT:
				buf[i++] = '0';
    40001edc:	f9405fe0 	ldr	x0, [sp, #184]
    40001ee0:	91000401 	add	x1, x0, #0x1
    40001ee4:	f9005fe1 	str	x1, [sp, #184]
    40001ee8:	aa0003e1 	mov	x1, x0
    40001eec:	f9401fe0 	ldr	x0, [sp, #56]
    40001ef0:	8b010000 	add	x0, x0, x1
    40001ef4:	52800601 	mov	w1, #0x30                  	// #48
    40001ef8:	39000001 	strb	w1, [x0]
				break;
    40001efc:	14000002 	b	40001f04 <stdint_to_ascii+0x3fc>
				break;
    40001f00:	d503201f 	nop
		}
		buf[i++] = '0';
    40001f04:	f9405fe0 	ldr	x0, [sp, #184]
    40001f08:	91000401 	add	x1, x0, #0x1
    40001f0c:	f9005fe1 	str	x1, [sp, #184]
    40001f10:	aa0003e1 	mov	x1, x0
    40001f14:	f9401fe0 	ldr	x0, [sp, #56]
    40001f18:	8b010000 	add	x0, x0, x1
    40001f1c:	52800601 	mov	w1, #0x30                  	// #48
    40001f20:	39000001 	strb	w1, [x0]
		buf[i] = '\0';
    40001f24:	f9405fe0 	ldr	x0, [sp, #184]
    40001f28:	f9401fe1 	ldr	x1, [sp, #56]
    40001f2c:	8b000020 	add	x0, x1, x0
    40001f30:	3900001f 	strb	wzr, [x0]
		return buf;
    40001f34:	f9401fe0 	ldr	x0, [sp, #56]
    40001f38:	140000a4 	b	400021c8 <stdint_to_ascii+0x6c0>
	}

	uint64 i = 0;
    40001f3c:	f9005bff 	str	xzr, [sp, #176]
	while (value > 0) {
    40001f40:	1400001f 	b	40001fbc <stdint_to_ascii+0x4b4>
		// repr enum values represent the base
		uint8 digit = value % repr;
    40001f44:	b94043e1 	ldr	w1, [sp, #64]
    40001f48:	f94067e0 	ldr	x0, [sp, #200]
    40001f4c:	9ac10802 	udiv	x2, x0, x1
    40001f50:	9b017c41 	mul	x1, x2, x1
    40001f54:	cb010000 	sub	x0, x0, x1
    40001f58:	39027be0 	strb	w0, [sp, #158]
		value /= repr;
    40001f5c:	b94043e0 	ldr	w0, [sp, #64]
    40001f60:	f94067e1 	ldr	x1, [sp, #200]
    40001f64:	9ac00820 	udiv	x0, x1, x0
    40001f68:	f90067e0 	str	x0, [sp, #200]

		// + 1 for the \0 + negative (0 or 1) for '-'
		if (i + 1 + (uint64)negative + repr_len >= buf_len) goto panic;
    40001f6c:	39431fe1 	ldrb	w1, [sp, #199]
    40001f70:	f9405be0 	ldr	x0, [sp, #176]
    40001f74:	8b000021 	add	x1, x1, x0
    40001f78:	f94077e0 	ldr	x0, [sp, #232]
    40001f7c:	8b000020 	add	x0, x1, x0
    40001f80:	91000400 	add	x0, x0, #0x1
    40001f84:	f9401be1 	ldr	x1, [sp, #48]
    40001f88:	eb00003f 	cmp	x1, x0
    40001f8c:	54000fa9 	b.ls	40002180 <stdint_to_ascii+0x678>  // b.plast

		buf[i++] = STDINT_BASE_REPR_CHARS[digit];
    40001f90:	39427be3 	ldrb	w3, [sp, #158]
    40001f94:	f9405be0 	ldr	x0, [sp, #176]
    40001f98:	91000401 	add	x1, x0, #0x1
    40001f9c:	f9005be1 	str	x1, [sp, #176]
    40001fa0:	f9401fe1 	ldr	x1, [sp, #56]
    40001fa4:	8b000020 	add	x0, x1, x0
    40001fa8:	f0000001 	adrp	x1, 40004000 <_el2_vector_table>
    40001fac:	913c4022 	add	x2, x1, #0xf10
    40001fb0:	93407c61 	sxtw	x1, w3
    40001fb4:	38616841 	ldrb	w1, [x2, x1]
    40001fb8:	39000001 	strb	w1, [x0]
	while (value > 0) {
    40001fbc:	f94067e0 	ldr	x0, [sp, #200]
    40001fc0:	f100001f 	cmp	x0, #0x0
    40001fc4:	54fffc01 	b.ne	40001f44 <stdint_to_ascii+0x43c>  // b.any
	}

	switch (repr) {
    40001fc8:	b94043e0 	ldr	w0, [sp, #64]
    40001fcc:	7100401f 	cmp	w0, #0x10
    40001fd0:	54000220 	b.eq	40002014 <stdint_to_ascii+0x50c>  // b.none
    40001fd4:	b94043e0 	ldr	w0, [sp, #64]
    40001fd8:	7100401f 	cmp	w0, #0x10
    40001fdc:	540006a8 	b.hi	400020b0 <stdint_to_ascii+0x5a8>  // b.pmore
    40001fe0:	b94043e0 	ldr	w0, [sp, #64]
    40001fe4:	7100281f 	cmp	w0, #0xa
    40001fe8:	54000620 	b.eq	400020ac <stdint_to_ascii+0x5a4>  // b.none
    40001fec:	b94043e0 	ldr	w0, [sp, #64]
    40001ff0:	7100281f 	cmp	w0, #0xa
    40001ff4:	540005e8 	b.hi	400020b0 <stdint_to_ascii+0x5a8>  // b.pmore
    40001ff8:	b94043e0 	ldr	w0, [sp, #64]
    40001ffc:	7100081f 	cmp	w0, #0x2
    40002000:	54000280 	b.eq	40002050 <stdint_to_ascii+0x548>  // b.none
    40002004:	b94043e0 	ldr	w0, [sp, #64]
    40002008:	7100201f 	cmp	w0, #0x8
    4000200c:	54000400 	b.eq	4000208c <stdint_to_ascii+0x584>  // b.none
    40002010:	14000028 	b	400020b0 <stdint_to_ascii+0x5a8>
		case STDINT_BASE_REPR_DEC:
			break;
		case STDINT_BASE_REPR_HEX:	// Values are reversed after
			buf[i++] = 'x';
    40002014:	f9405be0 	ldr	x0, [sp, #176]
    40002018:	91000401 	add	x1, x0, #0x1
    4000201c:	f9005be1 	str	x1, [sp, #176]
    40002020:	f9401fe1 	ldr	x1, [sp, #56]
    40002024:	8b000020 	add	x0, x1, x0
    40002028:	52800f01 	mov	w1, #0x78                  	// #120
    4000202c:	39000001 	strb	w1, [x0]
			buf[i++] = '0';
    40002030:	f9405be0 	ldr	x0, [sp, #176]
    40002034:	91000401 	add	x1, x0, #0x1
    40002038:	f9005be1 	str	x1, [sp, #176]
    4000203c:	f9401fe1 	ldr	x1, [sp, #56]
    40002040:	8b000020 	add	x0, x1, x0
    40002044:	52800601 	mov	w1, #0x30                  	// #48
    40002048:	39000001 	strb	w1, [x0]
			break;
    4000204c:	14000019 	b	400020b0 <stdint_to_ascii+0x5a8>
		case STDINT_BASE_REPR_BIN:
			buf[i++] = 'b';
    40002050:	f9405be0 	ldr	x0, [sp, #176]
    40002054:	91000401 	add	x1, x0, #0x1
    40002058:	f9005be1 	str	x1, [sp, #176]
    4000205c:	f9401fe1 	ldr	x1, [sp, #56]
    40002060:	8b000020 	add	x0, x1, x0
    40002064:	52800c41 	mov	w1, #0x62                  	// #98
    40002068:	39000001 	strb	w1, [x0]
			buf[i++] = '0';
    4000206c:	f9405be0 	ldr	x0, [sp, #176]
    40002070:	91000401 	add	x1, x0, #0x1
    40002074:	f9005be1 	str	x1, [sp, #176]
    40002078:	f9401fe1 	ldr	x1, [sp, #56]
    4000207c:	8b000020 	add	x0, x1, x0
    40002080:	52800601 	mov	w1, #0x30                  	// #48
    40002084:	39000001 	strb	w1, [x0]
			break;
    40002088:	1400000a 	b	400020b0 <stdint_to_ascii+0x5a8>
		case STDINT_BASE_REPR_OCT:
			buf[i++] = '0';
    4000208c:	f9405be0 	ldr	x0, [sp, #176]
    40002090:	91000401 	add	x1, x0, #0x1
    40002094:	f9005be1 	str	x1, [sp, #176]
    40002098:	f9401fe1 	ldr	x1, [sp, #56]
    4000209c:	8b000020 	add	x0, x1, x0
    400020a0:	52800601 	mov	w1, #0x30                  	// #48
    400020a4:	39000001 	strb	w1, [x0]
			break;
    400020a8:	14000002 	b	400020b0 <stdint_to_ascii+0x5a8>
			break;
    400020ac:	d503201f 	nop
	}

	if (negative) buf[i++] = '-';
    400020b0:	39431fe0 	ldrb	w0, [sp, #199]
    400020b4:	12000000 	and	w0, w0, #0x1
    400020b8:	7100001f 	cmp	w0, #0x0
    400020bc:	54000100 	b.eq	400020dc <stdint_to_ascii+0x5d4>  // b.none
    400020c0:	f9405be0 	ldr	x0, [sp, #176]
    400020c4:	91000401 	add	x1, x0, #0x1
    400020c8:	f9005be1 	str	x1, [sp, #176]
    400020cc:	f9401fe1 	ldr	x1, [sp, #56]
    400020d0:	8b000020 	add	x0, x1, x0
    400020d4:	528005a1 	mov	w1, #0x2d                  	// #45
    400020d8:	39000001 	strb	w1, [x0]
	buf[i] = '\0';
    400020dc:	f9401fe1 	ldr	x1, [sp, #56]
    400020e0:	f9405be0 	ldr	x0, [sp, #176]
    400020e4:	8b000020 	add	x0, x1, x0
    400020e8:	3900001f 	strb	wzr, [x0]

	// Reverse created string
	uint64 start = 0;
    400020ec:	f90057ff 	str	xzr, [sp, #168]
	uint64 end = i - 1;	 // i -1 to not include the '\0'
    400020f0:	f9405be0 	ldr	x0, [sp, #176]
    400020f4:	d1000400 	sub	x0, x0, #0x1
    400020f8:	f90053e0 	str	x0, [sp, #160]
	while (start < end) {
    400020fc:	14000019 	b	40002160 <stdint_to_ascii+0x658>
		char tmp = buf[start];
    40002100:	f9401fe1 	ldr	x1, [sp, #56]
    40002104:	f94057e0 	ldr	x0, [sp, #168]
    40002108:	8b000020 	add	x0, x1, x0
    4000210c:	39400000 	ldrb	w0, [x0]
    40002110:	39027fe0 	strb	w0, [sp, #159]
		buf[start] = buf[end];
    40002114:	f9401fe1 	ldr	x1, [sp, #56]
    40002118:	f94053e0 	ldr	x0, [sp, #160]
    4000211c:	8b000021 	add	x1, x1, x0
    40002120:	f9401fe2 	ldr	x2, [sp, #56]
    40002124:	f94057e0 	ldr	x0, [sp, #168]
    40002128:	8b000040 	add	x0, x2, x0
    4000212c:	39400021 	ldrb	w1, [x1]
    40002130:	39000001 	strb	w1, [x0]
		buf[end] = tmp;
    40002134:	f9401fe1 	ldr	x1, [sp, #56]
    40002138:	f94053e0 	ldr	x0, [sp, #160]
    4000213c:	8b000020 	add	x0, x1, x0
    40002140:	39427fe1 	ldrb	w1, [sp, #159]
    40002144:	39000001 	strb	w1, [x0]
		start++;
    40002148:	f94057e0 	ldr	x0, [sp, #168]
    4000214c:	91000400 	add	x0, x0, #0x1
    40002150:	f90057e0 	str	x0, [sp, #168]
		end--;
    40002154:	f94053e0 	ldr	x0, [sp, #160]
    40002158:	d1000400 	sub	x0, x0, #0x1
    4000215c:	f90053e0 	str	x0, [sp, #160]
	while (start < end) {
    40002160:	f94057e1 	ldr	x1, [sp, #168]
    40002164:	f94053e0 	ldr	x0, [sp, #160]
    40002168:	eb00003f 	cmp	x1, x0
    4000216c:	54fffca3 	b.cc	40002100 <stdint_to_ascii+0x5f8>  // b.lo, b.ul, b.last
	}

	return buf;
    40002170:	f9401fe0 	ldr	x0, [sp, #56]
    40002174:	14000015 	b	400021c8 <stdint_to_ascii+0x6c0>
		if (buf_len < 2 + repr_len) goto panic;
    40002178:	d503201f 	nop
    4000217c:	14000002 	b	40002184 <stdint_to_ascii+0x67c>
		if (i + 1 + (uint64)negative + repr_len >= buf_len) goto panic;
    40002180:	d503201f 	nop

panic:
	PANIC(
    40002184:	d0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40002188:	913de000 	add	x0, x0, #0xf78
    4000218c:	f90043e0 	str	x0, [sp, #128]
    40002190:	d0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40002194:	913be000 	add	x0, x0, #0xef8
    40002198:	f90047e0 	str	x0, [sp, #136]
    4000219c:	52801600 	mov	w0, #0xb0                  	// #176
    400021a0:	b90093e0 	str	w0, [sp, #144]
    400021a4:	b90097ff 	str	wzr, [sp, #148]
    400021a8:	910043e2 	add	x2, sp, #0x10
    400021ac:	910203e3 	add	x3, sp, #0x80
    400021b0:	a9400460 	ldp	x0, x1, [x3]
    400021b4:	f9400863 	ldr	x3, [x3, #16]
    400021b8:	a9000440 	stp	x0, x1, [x2]
    400021bc:	f9000843 	str	x3, [x2, #16]
    400021c0:	910043e0 	add	x0, sp, #0x10
    400021c4:	97fffb44 	bl	40000ed4 <set_and_throw_panic>
		"stdint_to_ascii: provided buffer is smaller than requied "
		"for provided stdint");

	return (char *)0x0;
}
    400021c8:	a8cf7bfd 	ldp	x29, x30, [sp], #240
    400021cc:	d65f03c0 	ret

00000000400021d0 <memcpy64_aligned>:

// byte per byte
// extern void *_memcpy(void *dst, void *src, uint64 size);

void *memcpy64_aligned(void *dst, void *src, uint64 size)
{
    400021d0:	a9b67bfd 	stp	x29, x30, [sp, #-160]!
    400021d4:	910003fd 	mov	x29, sp
    400021d8:	f90027e0 	str	x0, [sp, #72]
    400021dc:	f90023e1 	str	x1, [sp, #64]
    400021e0:	f9001fe2 	str	x2, [sp, #56]
	if (size == 0) return dst;
    400021e4:	f9401fe0 	ldr	x0, [sp, #56]
    400021e8:	f100001f 	cmp	x0, #0x0
    400021ec:	54000061 	b.ne	400021f8 <memcpy64_aligned+0x28>  // b.any
    400021f0:	f94027e0 	ldr	x0, [sp, #72]
    400021f4:	14000044 	b	40002304 <memcpy64_aligned+0x134>

	if (((uintptr)dst & 15) != 0)
    400021f8:	f94027e0 	ldr	x0, [sp, #72]
    400021fc:	92400c00 	and	x0, x0, #0xf
    40002200:	f100001f 	cmp	x0, #0x0
    40002204:	54000240 	b.eq	4000224c <memcpy64_aligned+0x7c>  // b.none
		PANIC("memcpy64_aligned: dst not aligned to 16 bytes");
    40002208:	d0000000 	adrp	x0, 40004000 <_el2_vector_table>
    4000220c:	913f2000 	add	x0, x0, #0xfc8
    40002210:	f90047e0 	str	x0, [sp, #136]
    40002214:	d0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40002218:	913fe000 	add	x0, x0, #0xff8
    4000221c:	f9004be0 	str	x0, [sp, #144]
    40002220:	528002c0 	mov	w0, #0x16                  	// #22
    40002224:	b9009be0 	str	w0, [sp, #152]
    40002228:	b9009fff 	str	wzr, [sp, #156]
    4000222c:	910043e2 	add	x2, sp, #0x10
    40002230:	910223e3 	add	x3, sp, #0x88
    40002234:	a9400460 	ldp	x0, x1, [x3]
    40002238:	f9400863 	ldr	x3, [x3, #16]
    4000223c:	a9000440 	stp	x0, x1, [x2]
    40002240:	f9000843 	str	x3, [x2, #16]
    40002244:	910043e0 	add	x0, sp, #0x10
    40002248:	97fffb23 	bl	40000ed4 <set_and_throw_panic>

	if (((uintptr)src & 15) != 0)
    4000224c:	f94023e0 	ldr	x0, [sp, #64]
    40002250:	92400c00 	and	x0, x0, #0xf
    40002254:	f100001f 	cmp	x0, #0x0
    40002258:	54000240 	b.eq	400022a0 <memcpy64_aligned+0xd0>  // b.none
		PANIC("memcpy64_aligned: src not aligned to 16 bytes");
    4000225c:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002260:	91006000 	add	x0, x0, #0x18
    40002264:	f9003be0 	str	x0, [sp, #112]
    40002268:	d0000000 	adrp	x0, 40004000 <_el2_vector_table>
    4000226c:	913fe000 	add	x0, x0, #0xff8
    40002270:	f9003fe0 	str	x0, [sp, #120]
    40002274:	52800320 	mov	w0, #0x19                  	// #25
    40002278:	b90083e0 	str	w0, [sp, #128]
    4000227c:	b90087ff 	str	wzr, [sp, #132]
    40002280:	910043e2 	add	x2, sp, #0x10
    40002284:	9101c3e3 	add	x3, sp, #0x70
    40002288:	a9400460 	ldp	x0, x1, [x3]
    4000228c:	f9400863 	ldr	x3, [x3, #16]
    40002290:	a9000440 	stp	x0, x1, [x2]
    40002294:	f9000843 	str	x3, [x2, #16]
    40002298:	910043e0 	add	x0, sp, #0x10
    4000229c:	97fffb0e 	bl	40000ed4 <set_and_throw_panic>

	if ((size & 63) != 0)
    400022a0:	f9401fe0 	ldr	x0, [sp, #56]
    400022a4:	92401400 	and	x0, x0, #0x3f
    400022a8:	f100001f 	cmp	x0, #0x0
    400022ac:	54000240 	b.eq	400022f4 <memcpy64_aligned+0x124>  // b.none
		PANIC("memcpy64_aligned: size is not a multiple of 64");
    400022b0:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400022b4:	91012000 	add	x0, x0, #0x48
    400022b8:	f9002fe0 	str	x0, [sp, #88]
    400022bc:	d0000000 	adrp	x0, 40004000 <_el2_vector_table>
    400022c0:	913fe000 	add	x0, x0, #0xff8
    400022c4:	f90033e0 	str	x0, [sp, #96]
    400022c8:	52800380 	mov	w0, #0x1c                  	// #28
    400022cc:	b9006be0 	str	w0, [sp, #104]
    400022d0:	b9006fff 	str	wzr, [sp, #108]
    400022d4:	910043e2 	add	x2, sp, #0x10
    400022d8:	910163e3 	add	x3, sp, #0x58
    400022dc:	a9400460 	ldp	x0, x1, [x3]
    400022e0:	f9400863 	ldr	x3, [x3, #16]
    400022e4:	a9000440 	stp	x0, x1, [x2]
    400022e8:	f9000843 	str	x3, [x2, #16]
    400022ec:	910043e0 	add	x0, sp, #0x10
    400022f0:	97fffaf9 	bl	40000ed4 <set_and_throw_panic>

	return _memcpy64(dst, src, size);
    400022f4:	f9401fe2 	ldr	x2, [sp, #56]
    400022f8:	f94023e1 	ldr	x1, [sp, #64]
    400022fc:	f94027e0 	ldr	x0, [sp, #72]
    40002300:	97fffa00 	bl	40000b00 <_memcpy64>
}
    40002304:	a8ca7bfd 	ldp	x29, x30, [sp], #160
    40002308:	d65f03c0 	ret

000000004000230c <memcpy64>:

void *memcpy64(void *dst, void *src, uint64 size)
{
    4000230c:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    40002310:	910003fd 	mov	x29, sp
    40002314:	f90027e0 	str	x0, [sp, #72]
    40002318:	f90023e1 	str	x1, [sp, #64]
    4000231c:	f9001fe2 	str	x2, [sp, #56]
	if (size == 0) return dst;
    40002320:	f9401fe0 	ldr	x0, [sp, #56]
    40002324:	f100001f 	cmp	x0, #0x0
    40002328:	54000061 	b.ne	40002334 <memcpy64+0x28>  // b.any
    4000232c:	f94027e0 	ldr	x0, [sp, #72]
    40002330:	1400001a 	b	40002398 <memcpy64+0x8c>

	if ((size & 63) != 0) PANIC("memcpy64: size is not a multiple of 64");
    40002334:	f9401fe0 	ldr	x0, [sp, #56]
    40002338:	92401400 	and	x0, x0, #0x3f
    4000233c:	f100001f 	cmp	x0, #0x0
    40002340:	54000240 	b.eq	40002388 <memcpy64+0x7c>  // b.none
    40002344:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002348:	9101e000 	add	x0, x0, #0x78
    4000234c:	f9002fe0 	str	x0, [sp, #88]
    40002350:	d0000000 	adrp	x0, 40004000 <_el2_vector_table>
    40002354:	913fe000 	add	x0, x0, #0xff8
    40002358:	f90033e0 	str	x0, [sp, #96]
    4000235c:	528004a0 	mov	w0, #0x25                  	// #37
    40002360:	b9006be0 	str	w0, [sp, #104]
    40002364:	b9006fff 	str	wzr, [sp, #108]
    40002368:	910043e2 	add	x2, sp, #0x10
    4000236c:	910163e3 	add	x3, sp, #0x58
    40002370:	a9400460 	ldp	x0, x1, [x3]
    40002374:	f9400863 	ldr	x3, [x3, #16]
    40002378:	a9000440 	stp	x0, x1, [x2]
    4000237c:	f9000843 	str	x3, [x2, #16]
    40002380:	910043e0 	add	x0, sp, #0x10
    40002384:	97fffad4 	bl	40000ed4 <set_and_throw_panic>

	return _memcpy64(dst, src, size);
    40002388:	f9401fe2 	ldr	x2, [sp, #56]
    4000238c:	f94023e1 	ldr	x1, [sp, #64]
    40002390:	f94027e0 	ldr	x0, [sp, #72]
    40002394:	97fff9db 	bl	40000b00 <_memcpy64>
}
    40002398:	a8c77bfd 	ldp	x29, x30, [sp], #112
    4000239c:	d65f03c0 	ret

00000000400023a0 <test_memcpy>:
_Alignas(64) uint8 src[MEMCPY_TEST_SIZE];
_Alignas(64) uint8 dst[MEMCPY_TEST_SIZE];
_Alignas(64) uint8 ref[MEMCPY_TEST_SIZE];

void test_memcpy(size_t size_start)
{
    400023a0:	a9b57bfd 	stp	x29, x30, [sp, #-176]!
    400023a4:	910003fd 	mov	x29, sp
    400023a8:	f9000fe0 	str	x0, [sp, #24]
	char buf[100];

	for (size_t i = 0; i < sizeof(src); i++) {
    400023ac:	f90057ff 	str	xzr, [sp, #168]
    400023b0:	14000011 	b	400023f4 <test_memcpy+0x54>
		src[i] = (uint8)(i * 37 + 13);
    400023b4:	f94057e0 	ldr	x0, [sp, #168]
    400023b8:	12001c01 	and	w1, w0, #0xff
    400023bc:	528004a0 	mov	w0, #0x25                  	// #37
    400023c0:	1b007c20 	mul	w0, w1, w0
    400023c4:	12001c00 	and	w0, w0, #0xff
    400023c8:	11003400 	add	w0, w0, #0xd
    400023cc:	12001c02 	and	w2, w0, #0xff
    400023d0:	90000020 	adrp	x0, 40006000 <panic_message_buffer+0xc90>
    400023d4:	911e0001 	add	x1, x0, #0x780
    400023d8:	f94057e0 	ldr	x0, [sp, #168]
    400023dc:	8b000020 	add	x0, x1, x0
    400023e0:	2a0203e1 	mov	w1, w2
    400023e4:	39000001 	strb	w1, [x0]
	for (size_t i = 0; i < sizeof(src); i++) {
    400023e8:	f94057e0 	ldr	x0, [sp, #168]
    400023ec:	91000400 	add	x0, x0, #0x1
    400023f0:	f90057e0 	str	x0, [sp, #168]
    400023f4:	f94057e1 	ldr	x1, [sp, #168]
    400023f8:	b24057e0 	mov	x0, #0x3fffff              	// #4194303
    400023fc:	eb00003f 	cmp	x1, x0
    40002400:	54fffda9 	b.ls	400023b4 <test_memcpy+0x14>  // b.plast
	}

	for (size_t i = size_start; i < sizeof(src); i++) {
    40002404:	f9400fe0 	ldr	x0, [sp, #24]
    40002408:	f90053e0 	str	x0, [sp, #160]
    4000240c:	14000064 	b	4000259c <test_memcpy+0x1fc>
		for (size_t j = 0; j < sizeof(src); j++) {
    40002410:	f9004fff 	str	xzr, [sp, #152]
    40002414:	1400000a 	b	4000243c <test_memcpy+0x9c>
			dst[j] = (uint8)(0xFF);
    40002418:	90002020 	adrp	x0, 40406000 <src+0x3ff880>
    4000241c:	911e0001 	add	x1, x0, #0x780
    40002420:	f9404fe0 	ldr	x0, [sp, #152]
    40002424:	8b000020 	add	x0, x1, x0
    40002428:	12800001 	mov	w1, #0xffffffff            	// #-1
    4000242c:	39000001 	strb	w1, [x0]
		for (size_t j = 0; j < sizeof(src); j++) {
    40002430:	f9404fe0 	ldr	x0, [sp, #152]
    40002434:	91000400 	add	x0, x0, #0x1
    40002438:	f9004fe0 	str	x0, [sp, #152]
    4000243c:	f9404fe1 	ldr	x1, [sp, #152]
    40002440:	b24057e0 	mov	x0, #0x3fffff              	// #4194303
    40002444:	eb00003f 	cmp	x1, x0
    40002448:	54fffe89 	b.ls	40002418 <test_memcpy+0x78>  // b.plast
		}

		memcpy(&dst[sizeof(dst) - 1 - i], &src[sizeof(src) - 1 - i], i);
    4000244c:	b24057e1 	mov	x1, #0x3fffff              	// #4194303
    40002450:	f94053e0 	ldr	x0, [sp, #160]
    40002454:	cb000021 	sub	x1, x1, x0
    40002458:	90002020 	adrp	x0, 40406000 <src+0x3ff880>
    4000245c:	911e0000 	add	x0, x0, #0x780
    40002460:	8b000023 	add	x3, x1, x0
    40002464:	b24057e1 	mov	x1, #0x3fffff              	// #4194303
    40002468:	f94053e0 	ldr	x0, [sp, #160]
    4000246c:	cb000021 	sub	x1, x1, x0
    40002470:	90000020 	adrp	x0, 40006000 <panic_message_buffer+0xc90>
    40002474:	911e0000 	add	x0, x0, #0x780
    40002478:	8b000020 	add	x0, x1, x0
    4000247c:	f94053e2 	ldr	x2, [sp, #160]
    40002480:	aa0003e1 	mov	x1, x0
    40002484:	aa0303e0 	mov	x0, x3
    40002488:	97fff95a 	bl	400009f0 <_memcpy>

		for (size_t j = 0; j < i; j++) {
    4000248c:	f9004bff 	str	xzr, [sp, #144]
    40002490:	1400001c 	b	40002500 <test_memcpy+0x160>
			if (dst[(sizeof(dst) - 1 - i) + j] !=
    40002494:	f9404be1 	ldr	x1, [sp, #144]
    40002498:	f94053e0 	ldr	x0, [sp, #160]
    4000249c:	cb000021 	sub	x1, x1, x0
    400024a0:	b24057e0 	mov	x0, #0x3fffff              	// #4194303
    400024a4:	8b000020 	add	x0, x1, x0
    400024a8:	90002021 	adrp	x1, 40406000 <src+0x3ff880>
    400024ac:	911e0021 	add	x1, x1, #0x780
    400024b0:	38606821 	ldrb	w1, [x1, x0]
				src[(sizeof(src) - 1 - i) + j]) {
    400024b4:	f9404be2 	ldr	x2, [sp, #144]
    400024b8:	f94053e0 	ldr	x0, [sp, #160]
    400024bc:	cb000042 	sub	x2, x2, x0
    400024c0:	b24057e0 	mov	x0, #0x3fffff              	// #4194303
    400024c4:	8b000040 	add	x0, x2, x0
    400024c8:	90000022 	adrp	x2, 40006000 <panic_message_buffer+0xc90>
    400024cc:	911e0042 	add	x2, x2, #0x780
    400024d0:	38606840 	ldrb	w0, [x2, x0]
			if (dst[(sizeof(dst) - 1 - i) + j] !=
    400024d4:	6b00003f 	cmp	w1, w0
    400024d8:	540000e0 	b.eq	400024f4 <test_memcpy+0x154>  // b.none
				UART_puts(UART_ID_2, "Something went wrong");
    400024dc:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400024e0:	91028001 	add	x1, x0, #0xa0
    400024e4:	52800020 	mov	w0, #0x1                   	// #1
    400024e8:	94000422 	bl	40003570 <UART_puts>

				loop {}
    400024ec:	d503201f 	nop
    400024f0:	17ffffff 	b	400024ec <test_memcpy+0x14c>
		for (size_t j = 0; j < i; j++) {
    400024f4:	f9404be0 	ldr	x0, [sp, #144]
    400024f8:	91000400 	add	x0, x0, #0x1
    400024fc:	f9004be0 	str	x0, [sp, #144]
    40002500:	f9404be1 	ldr	x1, [sp, #144]
    40002504:	f94053e0 	ldr	x0, [sp, #160]
    40002508:	eb00003f 	cmp	x1, x0
    4000250c:	54fffc43 	b.cc	40002494 <test_memcpy+0xf4>  // b.lo, b.ul, b.last
			}
		}

		if (i % 10000 == 0) {
    40002510:	f94053e1 	ldr	x1, [sp, #160]
    40002514:	d28b2960 	mov	x0, #0x594b                	// #22859
    40002518:	f2a710c0 	movk	x0, #0x3886, lsl #16
    4000251c:	f2d8bac0 	movk	x0, #0xc5d6, lsl #32
    40002520:	f2e68da0 	movk	x0, #0x346d, lsl #48
    40002524:	9bc07c20 	umulh	x0, x1, x0
    40002528:	d34bfc00 	lsr	x0, x0, #11
    4000252c:	d284e202 	mov	x2, #0x2710                	// #10000
    40002530:	9b027c00 	mul	x0, x0, x2
    40002534:	cb000020 	sub	x0, x1, x0
    40002538:	f100001f 	cmp	x0, #0x0
    4000253c:	540002a1 	b.ne	40002590 <test_memcpy+0x1f0>  // b.any
			UART_puts(UART_ID_2, "i: ");
    40002540:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002544:	9102e001 	add	x1, x0, #0xb8
    40002548:	52800020 	mov	w0, #0x1                   	// #1
    4000254c:	94000409 	bl	40003570 <UART_puts>
			UART_puts(UART_ID_2,
					  stdint_to_ascii((STDINT_UNION){.int64 = i}, STDINT_UINT64,
    40002550:	f94053e0 	ldr	x0, [sp, #160]
    40002554:	aa0003e5 	mov	x5, x0
    40002558:	9100a3e0 	add	x0, sp, #0x28
    4000255c:	52800144 	mov	w4, #0xa                   	// #10
    40002560:	d2800c83 	mov	x3, #0x64                  	// #100
    40002564:	aa0003e2 	mov	x2, x0
    40002568:	528000e1 	mov	w1, #0x7                   	// #7
    4000256c:	aa0503e0 	mov	x0, x5
    40002570:	97fffd66 	bl	40001b08 <stdint_to_ascii>
			UART_puts(UART_ID_2,
    40002574:	aa0003e1 	mov	x1, x0
    40002578:	52800020 	mov	w0, #0x1                   	// #1
    4000257c:	940003fd 	bl	40003570 <UART_puts>
									  buf, 100, STDINT_BASE_REPR_DEC));
			UART_puts(UART_ID_2, " ok\n\r");
    40002580:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002584:	91030001 	add	x1, x0, #0xc0
    40002588:	52800020 	mov	w0, #0x1                   	// #1
    4000258c:	940003f9 	bl	40003570 <UART_puts>
	for (size_t i = size_start; i < sizeof(src); i++) {
    40002590:	f94053e0 	ldr	x0, [sp, #160]
    40002594:	91000400 	add	x0, x0, #0x1
    40002598:	f90053e0 	str	x0, [sp, #160]
    4000259c:	f94053e1 	ldr	x1, [sp, #160]
    400025a0:	b24057e0 	mov	x0, #0x3fffff              	// #4194303
    400025a4:	eb00003f 	cmp	x1, x0
    400025a8:	54fff349 	b.ls	40002410 <test_memcpy+0x70>  // b.plast
		}
	}

	UART_puts(UART_ID_2, "FINISHED without hang");
    400025ac:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400025b0:	91032001 	add	x1, x0, #0xc8
    400025b4:	52800020 	mov	w0, #0x1                   	// #1
    400025b8:	940003ee 	bl	40003570 <UART_puts>
}
    400025bc:	d503201f 	nop
    400025c0:	a8cb7bfd 	ldp	x29, x30, [sp], #176
    400025c4:	d65f03c0 	ret

00000000400025c8 <GICV3_GICD_IGROUPR_read>:

#define GICD_IGROUPR_VALUE_STRUCT_NAME GicdIgroupr

MMIO_DECLARE_REG32_VALUE_STRUCT(GICD_IGROUPR_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_N_OFFSET(GICV3, GICD_IGROUPR,
    400025c8:	d10043ff 	sub	sp, sp, #0x10
    400025cc:	f90007e0 	str	x0, [sp, #8]
    400025d0:	f94007e1 	ldr	x1, [sp, #8]
    400025d4:	d2800400 	mov	x0, #0x20                  	// #32
    400025d8:	f2a1c400 	movk	x0, #0xe20, lsl #16
    400025dc:	8b000020 	add	x0, x1, x0
    400025e0:	d37ef400 	lsl	x0, x0, #2
    400025e4:	b9400000 	ldr	w0, [x0]
    400025e8:	910043ff 	add	sp, sp, #0x10
    400025ec:	d65f03c0 	ret

00000000400025f0 <GICV3_GICD_IGROUPR_write>:
								   GICD_IGROUPR_VALUE_STRUCT_NAME,
								   GICV3_DISTRIBUTOR_BASE, GICD_IGROUPR_OFFSET);

MMIO_DECLARE_REG32_SETTER_N_OFFSET(GICV3, GICD_IGROUPR,
    400025f0:	d10043ff 	sub	sp, sp, #0x10
    400025f4:	f90007e0 	str	x0, [sp, #8]
    400025f8:	b90003e1 	str	w1, [sp]
    400025fc:	f94007e1 	ldr	x1, [sp, #8]
    40002600:	d2800400 	mov	x0, #0x20                  	// #32
    40002604:	f2a1c400 	movk	x0, #0xe20, lsl #16
    40002608:	8b000020 	add	x0, x1, x0
    4000260c:	d37ef400 	lsl	x0, x0, #2
    40002610:	aa0003e1 	mov	x1, x0
    40002614:	b94003e0 	ldr	w0, [sp]
    40002618:	b9000020 	str	w0, [x1]
    4000261c:	910043ff 	add	sp, sp, #0x10
    40002620:	d65f03c0 	ret

0000000040002624 <GICV3_GICD_IGROUPR_BF_set>:

	return (bool)((r.val >> bit) & 1UL);
}

static inline void GICV3_GICD_IGROUPR_BF_set(GICD_IGROUPR_VALUE_STRUCT_NAME *r, uint32 bit, bool v)
{
    40002624:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    40002628:	910003fd 	mov	x29, sp
    4000262c:	f9001fe0 	str	x0, [sp, #56]
    40002630:	b90037e1 	str	w1, [sp, #52]
    40002634:	3900cfe2 	strb	w2, [sp, #51]
	if (bit > 31) PANIC("GICD_IGROUPR: bit index must be <= 31");
    40002638:	b94037e0 	ldr	w0, [sp, #52]
    4000263c:	71007c1f 	cmp	w0, #0x1f
    40002640:	54000249 	b.ls	40002688 <GICV3_GICD_IGROUPR_BF_set+0x64>  // b.plast
    40002644:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002648:	91038000 	add	x0, x0, #0xe0
    4000264c:	f90027e0 	str	x0, [sp, #72]
    40002650:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002654:	91042000 	add	x0, x0, #0x108
    40002658:	f9002be0 	str	x0, [sp, #80]
    4000265c:	528004a0 	mov	w0, #0x25                  	// #37
    40002660:	b9005be0 	str	w0, [sp, #88]
    40002664:	b9005fff 	str	wzr, [sp, #92]
    40002668:	910043e2 	add	x2, sp, #0x10
    4000266c:	910123e3 	add	x3, sp, #0x48
    40002670:	a9400460 	ldp	x0, x1, [x3]
    40002674:	f9400863 	ldr	x3, [x3, #16]
    40002678:	a9000440 	stp	x0, x1, [x2]
    4000267c:	f9000843 	str	x3, [x2, #16]
    40002680:	910043e0 	add	x0, sp, #0x10
    40002684:	97fffa14 	bl	40000ed4 <set_and_throw_panic>

	r->val = (r->val & ~(1UL << bit)) | (((uint32)v & 1UL) << bit);
    40002688:	f9401fe0 	ldr	x0, [sp, #56]
    4000268c:	b9400001 	ldr	w1, [x0]
    40002690:	b94037e0 	ldr	w0, [sp, #52]
    40002694:	d2800022 	mov	x2, #0x1                   	// #1
    40002698:	9ac02040 	lsl	x0, x2, x0
    4000269c:	2a2003e0 	mvn	w0, w0
    400026a0:	0a000020 	and	w0, w1, w0
    400026a4:	3940cfe2 	ldrb	w2, [sp, #51]
    400026a8:	b94037e1 	ldr	w1, [sp, #52]
    400026ac:	9ac12041 	lsl	x1, x2, x1
    400026b0:	2a010001 	orr	w1, w0, w1
    400026b4:	f9401fe0 	ldr	x0, [sp, #56]
    400026b8:	b9000001 	str	w1, [x0]
    400026bc:	d503201f 	nop
    400026c0:	a8c67bfd 	ldp	x29, x30, [sp], #96
    400026c4:	d65f03c0 	ret

00000000400026c8 <GICV3_GICD_TYPER_read>:

#define GICD_TYPER_VALUE_STRUCT_NAME GicdTyper

MMIO_DECLARE_REG32_VALUE_STRUCT(GICD_TYPER_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER(GICV3, GICD_TYPER, GICD_TYPER_VALUE_STRUCT_NAME,
    400026c8:	d2800080 	mov	x0, #0x4                   	// #4
    400026cc:	f2a71000 	movk	x0, #0x3880, lsl #16
    400026d0:	b9400000 	ldr	w0, [x0]
    400026d4:	d65f03c0 	ret

00000000400026d8 <GICV3_GICD_TYPER_BF_get_ITLinesNumber>:

/* ================= Bits [4:0] ================= */
/* ITLinesNumber */
#define ITLinesNumber_SHIFT 0
#define ITLinesNumber_MASK (0x1FUL << ITLinesNumber_SHIFT)
GICD_TYPER_DECLARE_BIT_FIELD_GETTER(ITLinesNumber, uint8);
    400026d8:	d10043ff 	sub	sp, sp, #0x10
    400026dc:	b9000be0 	str	w0, [sp, #8]
    400026e0:	b9400be0 	ldr	w0, [sp, #8]
    400026e4:	12001c00 	and	w0, w0, #0xff
    400026e8:	12001000 	and	w0, w0, #0x1f
    400026ec:	12001c00 	and	w0, w0, #0xff
    400026f0:	910043ff 	add	sp, sp, #0x10
    400026f4:	d65f03c0 	ret

00000000400026f8 <GICV3_GICD_ICFGR_read>:

#define GICD_ICFGR_VALUE_STRUCT_NAME GicdIcfgr

MMIO_DECLARE_REG32_VALUE_STRUCT(GICD_ICFGR_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_N_OFFSET(GICV3, GICD_ICFGR,
    400026f8:	d10043ff 	sub	sp, sp, #0x10
    400026fc:	f90007e0 	str	x0, [sp, #8]
    40002700:	f94007e1 	ldr	x1, [sp, #8]
    40002704:	d2806000 	mov	x0, #0x300                 	// #768
    40002708:	f2a1c400 	movk	x0, #0xe20, lsl #16
    4000270c:	8b000020 	add	x0, x1, x0
    40002710:	d37ef400 	lsl	x0, x0, #2
    40002714:	b9400000 	ldr	w0, [x0]
    40002718:	910043ff 	add	sp, sp, #0x10
    4000271c:	d65f03c0 	ret

0000000040002720 <GICV3_GICD_ICFGR_write>:
								   GICD_ICFGR_VALUE_STRUCT_NAME,
								   GICV3_DISTRIBUTOR_BASE, GICD_ICFGR_OFFSET);

MMIO_DECLARE_REG32_SETTER_N_OFFSET(GICV3, GICD_ICFGR,
    40002720:	d10043ff 	sub	sp, sp, #0x10
    40002724:	f90007e0 	str	x0, [sp, #8]
    40002728:	b90003e1 	str	w1, [sp]
    4000272c:	f94007e1 	ldr	x1, [sp, #8]
    40002730:	d2806000 	mov	x0, #0x300                 	// #768
    40002734:	f2a1c400 	movk	x0, #0xe20, lsl #16
    40002738:	8b000020 	add	x0, x1, x0
    4000273c:	d37ef400 	lsl	x0, x0, #2
    40002740:	aa0003e1 	mov	x1, x0
    40002744:	b94003e0 	ldr	w0, [sp]
    40002748:	b9000020 	str	w0, [x1]
    4000274c:	910043ff 	add	sp, sp, #0x10
    40002750:	d65f03c0 	ret

0000000040002754 <GICV3_GICD_ICFGR_BF_set>:
	return (uint8)((r.val >> shift) & 0x3UL);
}

static inline void GICV3_GICD_ICFGR_BF_set(GICD_ICFGR_VALUE_STRUCT_NAME *r,
										   size_t slot, uint8 v)
{
    40002754:	a9b77bfd 	stp	x29, x30, [sp, #-144]!
    40002758:	910003fd 	mov	x29, sp
    4000275c:	f90027e0 	str	x0, [sp, #72]
    40002760:	f90023e1 	str	x1, [sp, #64]
    40002764:	3900ffe2 	strb	w2, [sp, #63]
	if (slot > 15) PANIC("GICD_ICFGR: slot must be <= 15");
    40002768:	f94023e0 	ldr	x0, [sp, #64]
    4000276c:	f1003c1f 	cmp	x0, #0xf
    40002770:	54000249 	b.ls	400027b8 <GICV3_GICD_ICFGR_BF_set+0x64>  // b.plast
    40002774:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002778:	91052000 	add	x0, x0, #0x148
    4000277c:	f9003be0 	str	x0, [sp, #112]
    40002780:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002784:	9105a000 	add	x0, x0, #0x168
    40002788:	f9003fe0 	str	x0, [sp, #120]
    4000278c:	52800520 	mov	w0, #0x29                  	// #41
    40002790:	b90083e0 	str	w0, [sp, #128]
    40002794:	b90087ff 	str	wzr, [sp, #132]
    40002798:	910043e2 	add	x2, sp, #0x10
    4000279c:	9101c3e3 	add	x3, sp, #0x70
    400027a0:	a9400460 	ldp	x0, x1, [x3]
    400027a4:	f9400863 	ldr	x3, [x3, #16]
    400027a8:	a9000440 	stp	x0, x1, [x2]
    400027ac:	f9000843 	str	x3, [x2, #16]
    400027b0:	910043e0 	add	x0, sp, #0x10
    400027b4:	97fff9c8 	bl	40000ed4 <set_and_throw_panic>
	if (v != 0b10 && v != 0b00) PANIC("GICD_ICFGR: value must be 0b10 or 0b00");
    400027b8:	3940ffe0 	ldrb	w0, [sp, #63]
    400027bc:	7100081f 	cmp	w0, #0x2
    400027c0:	540002a0 	b.eq	40002814 <GICV3_GICD_ICFGR_BF_set+0xc0>  // b.none
    400027c4:	3940ffe0 	ldrb	w0, [sp, #63]
    400027c8:	7100001f 	cmp	w0, #0x0
    400027cc:	54000240 	b.eq	40002814 <GICV3_GICD_ICFGR_BF_set+0xc0>  // b.none
    400027d0:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400027d4:	9106a000 	add	x0, x0, #0x1a8
    400027d8:	f9002fe0 	str	x0, [sp, #88]
    400027dc:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400027e0:	9105a000 	add	x0, x0, #0x168
    400027e4:	f90033e0 	str	x0, [sp, #96]
    400027e8:	52800540 	mov	w0, #0x2a                  	// #42
    400027ec:	b9006be0 	str	w0, [sp, #104]
    400027f0:	b9006fff 	str	wzr, [sp, #108]
    400027f4:	910043e2 	add	x2, sp, #0x10
    400027f8:	910163e3 	add	x3, sp, #0x58
    400027fc:	a9400460 	ldp	x0, x1, [x3]
    40002800:	f9400863 	ldr	x3, [x3, #16]
    40002804:	a9000440 	stp	x0, x1, [x2]
    40002808:	f9000843 	str	x3, [x2, #16]
    4000280c:	910043e0 	add	x0, sp, #0x10
    40002810:	97fff9b1 	bl	40000ed4 <set_and_throw_panic>

	uint32 shift = (slot * 2);
    40002814:	f94023e0 	ldr	x0, [sp, #64]
    40002818:	0b000000 	add	w0, w0, w0
    4000281c:	b9008fe0 	str	w0, [sp, #140]

	r->val = (r->val & ~(0x3UL << shift)) | (((uint32)v & 0x3UL) << shift);
    40002820:	f94027e0 	ldr	x0, [sp, #72]
    40002824:	b9400001 	ldr	w1, [x0]
    40002828:	b9408fe0 	ldr	w0, [sp, #140]
    4000282c:	d2800062 	mov	x2, #0x3                   	// #3
    40002830:	9ac02040 	lsl	x0, x2, x0
    40002834:	2a2003e0 	mvn	w0, w0
    40002838:	0a000020 	and	w0, w1, w0
    4000283c:	3940ffe1 	ldrb	w1, [sp, #63]
    40002840:	92400422 	and	x2, x1, #0x3
    40002844:	b9408fe1 	ldr	w1, [sp, #140]
    40002848:	9ac12041 	lsl	x1, x2, x1
    4000284c:	2a010001 	orr	w1, w0, w1
    40002850:	f94027e0 	ldr	x0, [sp, #72]
    40002854:	b9000001 	str	w1, [x0]
    40002858:	d503201f 	nop
    4000285c:	a8c97bfd 	ldp	x29, x30, [sp], #144
    40002860:	d65f03c0 	ret

0000000040002864 <GICV3_GICD_IPRIORITYR_read>:

#define GICD_IPRIORITYR_VALUE_STRUCT_NAME GicdIpriority

MMIO_DECLARE_REG32_VALUE_STRUCT(GICD_IPRIORITYR_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_N_OFFSET(GICV3, GICD_IPRIORITYR,
    40002864:	d10043ff 	sub	sp, sp, #0x10
    40002868:	f90007e0 	str	x0, [sp, #8]
    4000286c:	f94007e1 	ldr	x1, [sp, #8]
    40002870:	d2802000 	mov	x0, #0x100                 	// #256
    40002874:	f2a1c400 	movk	x0, #0xe20, lsl #16
    40002878:	8b000020 	add	x0, x1, x0
    4000287c:	d37ef400 	lsl	x0, x0, #2
    40002880:	b9400000 	ldr	w0, [x0]
    40002884:	910043ff 	add	sp, sp, #0x10
    40002888:	d65f03c0 	ret

000000004000288c <GICV3_GICD_IPRIORITYR_write>:
								   GICD_IPRIORITYR_VALUE_STRUCT_NAME,
								   GICV3_DISTRIBUTOR_BASE,
								   GICD_IPRIORITYR_OFFSET);

MMIO_DECLARE_REG32_SETTER_N_OFFSET(GICV3, GICD_IPRIORITYR,
    4000288c:	d10043ff 	sub	sp, sp, #0x10
    40002890:	f90007e0 	str	x0, [sp, #8]
    40002894:	b90003e1 	str	w1, [sp]
    40002898:	f94007e1 	ldr	x1, [sp, #8]
    4000289c:	d2802000 	mov	x0, #0x100                 	// #256
    400028a0:	f2a1c400 	movk	x0, #0xe20, lsl #16
    400028a4:	8b000020 	add	x0, x1, x0
    400028a8:	d37ef400 	lsl	x0, x0, #2
    400028ac:	aa0003e1 	mov	x1, x0
    400028b0:	b94003e0 	ldr	w0, [sp]
    400028b4:	b9000020 	str	w0, [x1]
    400028b8:	910043ff 	add	sp, sp, #0x10
    400028bc:	d65f03c0 	ret

00000000400028c0 <GICV3_GICD_IPRIORITYR_BF_set>:
	return (uint8)((r.val >> shift) & 0xFFUL);
}

static inline void GICV3_GICD_IPRIORITYR_BF_set(
	GICD_IPRIORITYR_VALUE_STRUCT_NAME *r, size_t byte_idx, uint8 priority)
{
    400028c0:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    400028c4:	910003fd 	mov	x29, sp
    400028c8:	f90027e0 	str	x0, [sp, #72]
    400028cc:	f90023e1 	str	x1, [sp, #64]
    400028d0:	3900ffe2 	strb	w2, [sp, #63]
	if (byte_idx > 3) PANIC("GICD_IPRIORITYR: byte_idx index must be <= 3");
    400028d4:	f94023e0 	ldr	x0, [sp, #64]
    400028d8:	f1000c1f 	cmp	x0, #0x3
    400028dc:	54000249 	b.ls	40002924 <GICV3_GICD_IPRIORITYR_BF_set+0x64>  // b.plast
    400028e0:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400028e4:	91074000 	add	x0, x0, #0x1d0
    400028e8:	f9002be0 	str	x0, [sp, #80]
    400028ec:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400028f0:	91080000 	add	x0, x0, #0x200
    400028f4:	f9002fe0 	str	x0, [sp, #88]
    400028f8:	52800560 	mov	w0, #0x2b                  	// #43
    400028fc:	b90063e0 	str	w0, [sp, #96]
    40002900:	b90067ff 	str	wzr, [sp, #100]
    40002904:	910043e2 	add	x2, sp, #0x10
    40002908:	910143e3 	add	x3, sp, #0x50
    4000290c:	a9400460 	ldp	x0, x1, [x3]
    40002910:	f9400863 	ldr	x3, [x3, #16]
    40002914:	a9000440 	stp	x0, x1, [x2]
    40002918:	f9000843 	str	x3, [x2, #16]
    4000291c:	910043e0 	add	x0, sp, #0x10
    40002920:	97fff96d 	bl	40000ed4 <set_and_throw_panic>

	uint32 shift = (byte_idx * 8);
    40002924:	f94023e0 	ldr	x0, [sp, #64]
    40002928:	531d7000 	lsl	w0, w0, #3
    4000292c:	b9006fe0 	str	w0, [sp, #108]

	r->val =
		(r->val & ~(0xFFUL << shift)) | (((uint32)priority & 0xFFUL) << shift);
    40002930:	f94027e0 	ldr	x0, [sp, #72]
    40002934:	b9400001 	ldr	w1, [x0]
    40002938:	b9406fe0 	ldr	w0, [sp, #108]
    4000293c:	d2801fe2 	mov	x2, #0xff                  	// #255
    40002940:	9ac02040 	lsl	x0, x2, x0
    40002944:	2a2003e0 	mvn	w0, w0
    40002948:	0a000020 	and	w0, w1, w0
    4000294c:	3940ffe2 	ldrb	w2, [sp, #63]
    40002950:	b9406fe1 	ldr	w1, [sp, #108]
    40002954:	9ac12041 	lsl	x1, x2, x1
    40002958:	2a010001 	orr	w1, w0, w1
	r->val =
    4000295c:	f94027e0 	ldr	x0, [sp, #72]
    40002960:	b9000001 	str	w1, [x0]
    40002964:	d503201f 	nop
    40002968:	a8c77bfd 	ldp	x29, x30, [sp], #112
    4000296c:	d65f03c0 	ret

0000000040002970 <GICV3_GICD_IROUTER_write>:

MMIO_DECLARE_REG64_GETTER_N_OFFSET(GICV3, GICD_IROUTER,
								   GICD_IROUTER_VALUE_STRUCT_NAME,
								   GICV3_DISTRIBUTOR_BASE, GICD_IROUTER_OFFSET);

MMIO_DECLARE_REG64_SETTER_N_OFFSET(GICV3, GICD_IROUTER,
    40002970:	d10043ff 	sub	sp, sp, #0x10
    40002974:	f90007e0 	str	x0, [sp, #8]
    40002978:	f90003e1 	str	x1, [sp]
    4000297c:	f94007e1 	ldr	x1, [sp, #8]
    40002980:	d2818000 	mov	x0, #0xc00                 	// #3072
    40002984:	f2a0e200 	movk	x0, #0x710, lsl #16
    40002988:	8b000020 	add	x0, x1, x0
    4000298c:	d37df000 	lsl	x0, x0, #3
    40002990:	aa0003e1 	mov	x1, x0
    40002994:	f94003e0 	ldr	x0, [sp]
    40002998:	f9000020 	str	x0, [x1]
    4000299c:	910043ff 	add	sp, sp, #0x10
    400029a0:	d65f03c0 	ret

00000000400029a4 <GICV3_GICD_IROUTER_BF_set_Aff3>:
								  bf_name##_SHIFT, bf_name##_MASK)

// Aff3 39:32
#define Aff3_SHIFT 32
#define Aff3_MASK (0xFFUL << Aff3_SHIFT)
GICD_IROUTER_DECLARE_BIT_FIELD_FNS(Aff3, uint8);
    400029a4:	d10043ff 	sub	sp, sp, #0x10
    400029a8:	f90007e0 	str	x0, [sp, #8]
    400029ac:	39001fe1 	strb	w1, [sp, #7]
    400029b0:	f94007e0 	ldr	x0, [sp, #8]
    400029b4:	f9400000 	ldr	x0, [x0]
    400029b8:	9258dc01 	and	x1, x0, #0xffffff00ffffffff
    400029bc:	39401fe0 	ldrb	w0, [sp, #7]
    400029c0:	d3607c00 	lsl	x0, x0, #32
    400029c4:	92601c00 	and	x0, x0, #0xff00000000
    400029c8:	aa000021 	orr	x1, x1, x0
    400029cc:	f94007e0 	ldr	x0, [sp, #8]
    400029d0:	f9000001 	str	x1, [x0]
    400029d4:	910043ff 	add	sp, sp, #0x10
    400029d8:	d65f03c0 	ret

00000000400029dc <GICV3_GICD_IROUTER_BF_set_Interrupt_Routing_Mode>:

// Interrupt_Routing_Mode 31
#define Interrupt_Routing_Mode_SHIFT 31
#define Interrupt_Routing_Mode_MASK (1UL << Interrupt_Routing_Mode_SHIFT)
GICD_IROUTER_DECLARE_BIT_FIELD_FNS(Interrupt_Routing_Mode, bool);
    400029dc:	d10043ff 	sub	sp, sp, #0x10
    400029e0:	f90007e0 	str	x0, [sp, #8]
    400029e4:	39001fe1 	strb	w1, [sp, #7]
    400029e8:	f94007e0 	ldr	x0, [sp, #8]
    400029ec:	f9400000 	ldr	x0, [x0]
    400029f0:	9260f801 	and	x1, x0, #0xffffffff7fffffff
    400029f4:	39401fe0 	ldrb	w0, [sp, #7]
    400029f8:	d3618000 	lsl	x0, x0, #31
    400029fc:	92407c00 	and	x0, x0, #0xffffffff
    40002a00:	aa000021 	orr	x1, x1, x0
    40002a04:	f94007e0 	ldr	x0, [sp, #8]
    40002a08:	f9000001 	str	x1, [x0]
    40002a0c:	910043ff 	add	sp, sp, #0x10
    40002a10:	d65f03c0 	ret

0000000040002a14 <GICV3_GICD_IROUTER_BF_set_Aff2>:

// Aff2 23:16
#define Aff2_SHIFT 16
#define Aff2_MASK (0xFFUL << Aff2_SHIFT)
GICD_IROUTER_DECLARE_BIT_FIELD_FNS(Aff2, uint8);
    40002a14:	d10043ff 	sub	sp, sp, #0x10
    40002a18:	f90007e0 	str	x0, [sp, #8]
    40002a1c:	39001fe1 	strb	w1, [sp, #7]
    40002a20:	f94007e0 	ldr	x0, [sp, #8]
    40002a24:	f9400000 	ldr	x0, [x0]
    40002a28:	9268dc01 	and	x1, x0, #0xffffffffff00ffff
    40002a2c:	39401fe0 	ldrb	w0, [sp, #7]
    40002a30:	d370bc00 	lsl	x0, x0, #16
    40002a34:	92701c00 	and	x0, x0, #0xff0000
    40002a38:	aa000021 	orr	x1, x1, x0
    40002a3c:	f94007e0 	ldr	x0, [sp, #8]
    40002a40:	f9000001 	str	x1, [x0]
    40002a44:	910043ff 	add	sp, sp, #0x10
    40002a48:	d65f03c0 	ret

0000000040002a4c <GICV3_GICD_IROUTER_BF_set_Aff1>:

// Aff1 15:8
#define Aff1_SHIFT 8
#define Aff1_MASK (0xFFUL << Aff1_SHIFT)
GICD_IROUTER_DECLARE_BIT_FIELD_FNS(Aff1, uint8);
    40002a4c:	d10043ff 	sub	sp, sp, #0x10
    40002a50:	f90007e0 	str	x0, [sp, #8]
    40002a54:	39001fe1 	strb	w1, [sp, #7]
    40002a58:	f94007e0 	ldr	x0, [sp, #8]
    40002a5c:	f9400000 	ldr	x0, [x0]
    40002a60:	9270dc01 	and	x1, x0, #0xffffffffffff00ff
    40002a64:	39401fe0 	ldrb	w0, [sp, #7]
    40002a68:	d378dc00 	lsl	x0, x0, #8
    40002a6c:	92403c00 	and	x0, x0, #0xffff
    40002a70:	aa000021 	orr	x1, x1, x0
    40002a74:	f94007e0 	ldr	x0, [sp, #8]
    40002a78:	f9000001 	str	x1, [x0]
    40002a7c:	910043ff 	add	sp, sp, #0x10
    40002a80:	d65f03c0 	ret

0000000040002a84 <GICV3_GICD_IROUTER_BF_set_Aff0>:

// Aff0 7:0
#define Aff0_SHIFT 0
#define Aff0_MASK (0xFFUL << Aff0_SHIFT)
    40002a84:	d10043ff 	sub	sp, sp, #0x10
    40002a88:	f90007e0 	str	x0, [sp, #8]
    40002a8c:	39001fe1 	strb	w1, [sp, #7]
    40002a90:	f94007e0 	ldr	x0, [sp, #8]
    40002a94:	f9400000 	ldr	x0, [x0]
    40002a98:	9278dc01 	and	x1, x0, #0xffffffffffffff00
    40002a9c:	39401fe0 	ldrb	w0, [sp, #7]
    40002aa0:	aa000021 	orr	x1, x1, x0
    40002aa4:	f94007e0 	ldr	x0, [sp, #8]
    40002aa8:	f9000001 	str	x1, [x0]
    40002aac:	910043ff 	add	sp, sp, #0x10
    40002ab0:	d65f03c0 	ret

0000000040002ab4 <GICV3_GICD_ISENABLER_set_bit>:
#include "gicv3_map.h"

#define GICD_ISENABLER_OFFSET(n) (0x100UL + (4UL * n))

static inline void GICV3_GICD_ISENABLER_set_bit(uint32 n, uint32 bit)
{
    40002ab4:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    40002ab8:	910003fd 	mov	x29, sp
    40002abc:	b9003fe0 	str	w0, [sp, #60]
    40002ac0:	b9003be1 	str	w1, [sp, #56]
	if (bit > 31) PANIC("GICD_ISENABLER: bit must be <= 31");
    40002ac4:	b9403be0 	ldr	w0, [sp, #56]
    40002ac8:	71007c1f 	cmp	w0, #0x1f
    40002acc:	54000249 	b.ls	40002b14 <GICV3_GICD_ISENABLER_set_bit+0x60>  // b.plast
    40002ad0:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002ad4:	91090000 	add	x0, x0, #0x240
    40002ad8:	f90027e0 	str	x0, [sp, #72]
    40002adc:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002ae0:	9109a000 	add	x0, x0, #0x268
    40002ae4:	f9002be0 	str	x0, [sp, #80]
    40002ae8:	52800240 	mov	w0, #0x12                  	// #18
    40002aec:	b9005be0 	str	w0, [sp, #88]
    40002af0:	b9005fff 	str	wzr, [sp, #92]
    40002af4:	910043e2 	add	x2, sp, #0x10
    40002af8:	910123e3 	add	x3, sp, #0x48
    40002afc:	a9400460 	ldp	x0, x1, [x3]
    40002b00:	f9400863 	ldr	x3, [x3, #16]
    40002b04:	a9000440 	stp	x0, x1, [x2]
    40002b08:	f9000843 	str	x3, [x2, #16]
    40002b0c:	910043e0 	add	x0, sp, #0x10
    40002b10:	97fff8f1 	bl	40000ed4 <set_and_throw_panic>

	*((reg32_ptr)(GICV3_DISTRIBUTOR_BASE + GICD_ISENABLER_OFFSET(n))) =
		(1UL << bit);
    40002b14:	b9403be0 	ldr	w0, [sp, #56]
    40002b18:	d2800021 	mov	x1, #0x1                   	// #1
    40002b1c:	9ac02022 	lsl	x2, x1, x0
	*((reg32_ptr)(GICV3_DISTRIBUTOR_BASE + GICD_ISENABLER_OFFSET(n))) =
    40002b20:	b9403fe1 	ldr	w1, [sp, #60]
    40002b24:	d2800800 	mov	x0, #0x40                  	// #64
    40002b28:	f2a1c400 	movk	x0, #0xe20, lsl #16
    40002b2c:	8b000020 	add	x0, x1, x0
    40002b30:	d37ef400 	lsl	x0, x0, #2
    40002b34:	2a0203e1 	mov	w1, w2
    40002b38:	b9000001 	str	w1, [x0]
    40002b3c:	d503201f 	nop
    40002b40:	a8c67bfd 	ldp	x29, x30, [sp], #96
    40002b44:	d65f03c0 	ret

0000000040002b48 <GICV3_GICR_WAKER_read>:

#define GICR_WAKER_VALUE_STRUCT_NAME GicrWaker

MMIO_DECLARE_REG32_VALUE_STRUCT(GICR_WAKER_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_N_BASE(GICV3, GICR_WAKER,
    40002b48:	d10043ff 	sub	sp, sp, #0x10
    40002b4c:	f90007e0 	str	x0, [sp, #8]
    40002b50:	f94007e0 	ldr	x0, [sp, #8]
    40002b54:	d36fb801 	lsl	x1, x0, #17
    40002b58:	d2800280 	mov	x0, #0x14                  	// #20
    40002b5c:	f2a71100 	movk	x0, #0x3888, lsl #16
    40002b60:	8b000020 	add	x0, x1, x0
    40002b64:	b9400000 	ldr	w0, [x0]
    40002b68:	910043ff 	add	sp, sp, #0x10
    40002b6c:	d65f03c0 	ret

0000000040002b70 <GICV3_GICR_WAKER_write>:
								 GICR_WAKER_VALUE_STRUCT_NAME,
								 GICV3_REDISTRIBUTOR_N_BASE, GICR_WAKER_OFFSET);
MMIO_DECLARE_REG32_SETTER_N_BASE(GICV3, GICR_WAKER,
    40002b70:	d10043ff 	sub	sp, sp, #0x10
    40002b74:	f90007e0 	str	x0, [sp, #8]
    40002b78:	b90003e1 	str	w1, [sp]
    40002b7c:	f94007e0 	ldr	x0, [sp, #8]
    40002b80:	d36fb801 	lsl	x1, x0, #17
    40002b84:	d2800280 	mov	x0, #0x14                  	// #20
    40002b88:	f2a71100 	movk	x0, #0x3888, lsl #16
    40002b8c:	8b000020 	add	x0, x1, x0
    40002b90:	aa0003e1 	mov	x1, x0
    40002b94:	b94003e0 	ldr	w0, [sp]
    40002b98:	b9000020 	str	w0, [x1]
    40002b9c:	910043ff 	add	sp, sp, #0x10
    40002ba0:	d65f03c0 	ret

0000000040002ba4 <GICV3_GICR_WAKER_BF_get_ChildrenAsleep>:
GICR_WAKER_DECLARE_BIT_FIELD_GETTER(GICR_WAKER_BIT31, bool);

// ChildrenAsleep 2
#define ChildrenAsleep_SHIFT 2
#define ChildrenAsleep_MASK (1UL << ChildrenAsleep_SHIFT)
GICR_WAKER_DECLARE_BIT_FIELD_GETTER(ChildrenAsleep, bool);
    40002ba4:	d10043ff 	sub	sp, sp, #0x10
    40002ba8:	b9000be0 	str	w0, [sp, #8]
    40002bac:	b9400be0 	ldr	w0, [sp, #8]
    40002bb0:	121e0000 	and	w0, w0, #0x4
    40002bb4:	7100001f 	cmp	w0, #0x0
    40002bb8:	1a9f07e0 	cset	w0, ne	// ne = any
    40002bbc:	12001c00 	and	w0, w0, #0xff
    40002bc0:	910043ff 	add	sp, sp, #0x10
    40002bc4:	d65f03c0 	ret

0000000040002bc8 <GICV3_GICR_WAKER_BF_set_ProcessorSleep>:

// ProcessorSleep
#define ProcessorSleep_SHIFT 1
#define ProcessorSleep_MASK (1UL << ProcessorSleep_SHIFT)
GICR_WAKER_DECLARE_BIT_FIELD_GETTER(ProcessorSleep, bool);
    40002bc8:	d10043ff 	sub	sp, sp, #0x10
    40002bcc:	f90007e0 	str	x0, [sp, #8]
    40002bd0:	39001fe1 	strb	w1, [sp, #7]
    40002bd4:	f94007e0 	ldr	x0, [sp, #8]
    40002bd8:	b9400000 	ldr	w0, [x0]
    40002bdc:	121e7801 	and	w1, w0, #0xfffffffd
    40002be0:	39401fe0 	ldrb	w0, [sp, #7]
    40002be4:	0b000000 	add	w0, w0, w0
    40002be8:	121f0000 	and	w0, w0, #0x2
    40002bec:	2a000021 	orr	w1, w1, w0
    40002bf0:	f94007e0 	ldr	x0, [sp, #8]
    40002bf4:	b9000001 	str	w1, [x0]
    40002bf8:	910043ff 	add	sp, sp, #0x10
    40002bfc:	d65f03c0 	ret

0000000040002c00 <GICV3_validate_spi_id>:
#include "drivers/interrupts/gicv3/gicv3_raw/gicd_isenabler.h"
#include "drivers/interrupts/gicv3/gicv3_raw/gicr_waker.h"

/// If irq number is not valid panics
static void GICV3_validate_spi_id(uint32 intid)
{
    40002c00:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    40002c04:	910003fd 	mov	x29, sp
    40002c08:	b9003fe0 	str	w0, [sp, #60]
	GicdTyper typer = GICV3_GICD_TYPER_read();
    40002c0c:	97fffeaf 	bl	400026c8 <GICV3_GICD_TYPER_read>
    40002c10:	b90063e0 	str	w0, [sp, #96]
	uint32 itlines = (uint32)GICV3_GICD_TYPER_BF_get_ITLinesNumber(typer);
    40002c14:	b94063e0 	ldr	w0, [sp, #96]
    40002c18:	97fffeb0 	bl	400026d8 <GICV3_GICD_TYPER_BF_get_ITLinesNumber>
    40002c1c:	12001c00 	and	w0, w0, #0xff
    40002c20:	b9006fe0 	str	w0, [sp, #108]

	uint32 max_spi = (32 * (itlines + 1)) - 1;
    40002c24:	b9406fe0 	ldr	w0, [sp, #108]
    40002c28:	531b6800 	lsl	w0, w0, #5
    40002c2c:	11007c00 	add	w0, w0, #0x1f
    40002c30:	b9006be0 	str	w0, [sp, #104]

	if (intid < 32 || intid > max_spi) PANIC("Invalid SPI INTID");
    40002c34:	b9403fe0 	ldr	w0, [sp, #60]
    40002c38:	71007c1f 	cmp	w0, #0x1f
    40002c3c:	540000a9 	b.ls	40002c50 <GICV3_validate_spi_id+0x50>  // b.plast
    40002c40:	b9403fe1 	ldr	w1, [sp, #60]
    40002c44:	b9406be0 	ldr	w0, [sp, #104]
    40002c48:	6b00003f 	cmp	w1, w0
    40002c4c:	54000249 	b.ls	40002c94 <GICV3_validate_spi_id+0x94>  // b.plast
    40002c50:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002c54:	910aa000 	add	x0, x0, #0x2a8
    40002c58:	f90027e0 	str	x0, [sp, #72]
    40002c5c:	f0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40002c60:	910b0000 	add	x0, x0, #0x2c0
    40002c64:	f9002be0 	str	x0, [sp, #80]
    40002c68:	52800280 	mov	w0, #0x14                  	// #20
    40002c6c:	b9005be0 	str	w0, [sp, #88]
    40002c70:	b9005fff 	str	wzr, [sp, #92]
    40002c74:	910043e2 	add	x2, sp, #0x10
    40002c78:	910123e3 	add	x3, sp, #0x48
    40002c7c:	a9400460 	ldp	x0, x1, [x3]
    40002c80:	f9400863 	ldr	x3, [x3, #16]
    40002c84:	a9000440 	stp	x0, x1, [x2]
    40002c88:	f9000843 	str	x3, [x2, #16]
    40002c8c:	910043e0 	add	x0, sp, #0x10
    40002c90:	97fff891 	bl	40000ed4 <set_and_throw_panic>
}
    40002c94:	d503201f 	nop
    40002c98:	a8c77bfd 	ldp	x29, x30, [sp], #112
    40002c9c:	d65f03c0 	ret

0000000040002ca0 <GICV3_set_spi_group1ns>:

void GICV3_set_spi_group1ns(imx8mp_irq irq, bool v)
{
    40002ca0:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    40002ca4:	910003fd 	mov	x29, sp
    40002ca8:	b9001fe0 	str	w0, [sp, #28]
    40002cac:	39006fe1 	strb	w1, [sp, #27]
	// imx8mp irqs start from 32 as 0..31 in the gic are reserved
	uint32 intid = irq + 32;
    40002cb0:	b9401fe0 	ldr	w0, [sp, #28]
    40002cb4:	11008000 	add	w0, w0, #0x20
    40002cb8:	b9002fe0 	str	w0, [sp, #44]

	GICV3_validate_spi_id(intid);
    40002cbc:	b9402fe0 	ldr	w0, [sp, #44]
    40002cc0:	97ffffd0 	bl	40002c00 <GICV3_validate_spi_id>

	uint32 n = ((uint32)intid) / 32;
    40002cc4:	b9402fe0 	ldr	w0, [sp, #44]
    40002cc8:	53057c00 	lsr	w0, w0, #5
    40002ccc:	b9002be0 	str	w0, [sp, #40]
	uint32 bit = ((uint32)intid) % 32;
    40002cd0:	b9402fe0 	ldr	w0, [sp, #44]
    40002cd4:	12001000 	and	w0, w0, #0x1f
    40002cd8:	b90027e0 	str	w0, [sp, #36]

	GicdIgroupr igroupr = GICV3_GICD_IGROUPR_read(n);
    40002cdc:	b9402be0 	ldr	w0, [sp, #40]
    40002ce0:	97fffe3a 	bl	400025c8 <GICV3_GICD_IGROUPR_read>
    40002ce4:	b90023e0 	str	w0, [sp, #32]
	GICV3_GICD_IGROUPR_BF_set(&igroupr, bit, v);
    40002ce8:	910083e0 	add	x0, sp, #0x20
    40002cec:	39406fe2 	ldrb	w2, [sp, #27]
    40002cf0:	b94027e1 	ldr	w1, [sp, #36]
    40002cf4:	97fffe4c 	bl	40002624 <GICV3_GICD_IGROUPR_BF_set>
	GICV3_GICD_IGROUPR_write(n, igroupr);
    40002cf8:	b9402be0 	ldr	w0, [sp, #40]
    40002cfc:	b94023e1 	ldr	w1, [sp, #32]
    40002d00:	97fffe3c 	bl	400025f0 <GICV3_GICD_IGROUPR_write>
}
    40002d04:	d503201f 	nop
    40002d08:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40002d0c:	d65f03c0 	ret

0000000040002d10 <GICV3_route_spi_to_cpu>:

void GICV3_route_spi_to_cpu(imx8mp_irq irq, CpuAffinity affinity)
{
    40002d10:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    40002d14:	910003fd 	mov	x29, sp
    40002d18:	b9001fe0 	str	w0, [sp, #28]
    40002d1c:	b9001be1 	str	w1, [sp, #24]
	uint32 intid = irq + 32;
    40002d20:	b9401fe0 	ldr	w0, [sp, #28]
    40002d24:	11008000 	add	w0, w0, #0x20
    40002d28:	b9002fe0 	str	w0, [sp, #44]

	GICV3_validate_spi_id(intid);
    40002d2c:	b9402fe0 	ldr	w0, [sp, #44]
    40002d30:	97ffffb4 	bl	40002c00 <GICV3_validate_spi_id>

	GicdIrouter r = {0};
    40002d34:	f90013ff 	str	xzr, [sp, #32]

	GICV3_GICD_IROUTER_BF_set_Interrupt_Routing_Mode(&r, false);
    40002d38:	910083e0 	add	x0, sp, #0x20
    40002d3c:	52800001 	mov	w1, #0x0                   	// #0
    40002d40:	97ffff27 	bl	400029dc <GICV3_GICD_IROUTER_BF_set_Interrupt_Routing_Mode>

	GICV3_GICD_IROUTER_BF_set_Aff3(&r, affinity.aff3);
    40002d44:	394063e1 	ldrb	w1, [sp, #24]
    40002d48:	910083e0 	add	x0, sp, #0x20
    40002d4c:	97ffff16 	bl	400029a4 <GICV3_GICD_IROUTER_BF_set_Aff3>
	GICV3_GICD_IROUTER_BF_set_Aff2(&r, affinity.aff2);
    40002d50:	394067e1 	ldrb	w1, [sp, #25]
    40002d54:	910083e0 	add	x0, sp, #0x20
    40002d58:	97ffff2f 	bl	40002a14 <GICV3_GICD_IROUTER_BF_set_Aff2>
	GICV3_GICD_IROUTER_BF_set_Aff1(&r, affinity.aff1);
    40002d5c:	39406be1 	ldrb	w1, [sp, #26]
    40002d60:	910083e0 	add	x0, sp, #0x20
    40002d64:	97ffff3a 	bl	40002a4c <GICV3_GICD_IROUTER_BF_set_Aff1>
	GICV3_GICD_IROUTER_BF_set_Aff0(&r, affinity.aff0);
    40002d68:	39406fe1 	ldrb	w1, [sp, #27]
    40002d6c:	910083e0 	add	x0, sp, #0x20
    40002d70:	97ffff45 	bl	40002a84 <GICV3_GICD_IROUTER_BF_set_Aff0>

	GICV3_GICD_IROUTER_write(intid, r);
    40002d74:	b9402fe0 	ldr	w0, [sp, #44]
    40002d78:	f94013e1 	ldr	x1, [sp, #32]
    40002d7c:	97fffefd 	bl	40002970 <GICV3_GICD_IROUTER_write>
}
    40002d80:	d503201f 	nop
    40002d84:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40002d88:	d65f03c0 	ret

0000000040002d8c <GICV3_route_spi_to_self>:

void GICV3_route_spi_to_self(imx8mp_irq irq)
{
    40002d8c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    40002d90:	910003fd 	mov	x29, sp
    40002d94:	b9001fe0 	str	w0, [sp, #28]
	GICV3_route_spi_to_cpu(irq, ARM_get_cpu_affinity());
    40002d98:	97fff931 	bl	4000125c <ARM_get_cpu_affinity>
    40002d9c:	2a0003e1 	mov	w1, w0
    40002da0:	b9401fe0 	ldr	w0, [sp, #28]
    40002da4:	97ffffdb 	bl	40002d10 <GICV3_route_spi_to_cpu>
}
    40002da8:	d503201f 	nop
    40002dac:	a8c27bfd 	ldp	x29, x30, [sp], #32
    40002db0:	d65f03c0 	ret

0000000040002db4 <GICV3_enable_spi>:

void GICV3_enable_spi(imx8mp_irq irq)
{
    40002db4:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    40002db8:	910003fd 	mov	x29, sp
    40002dbc:	b9001fe0 	str	w0, [sp, #28]
	uint32 intid = irq + 32;
    40002dc0:	b9401fe0 	ldr	w0, [sp, #28]
    40002dc4:	11008000 	add	w0, w0, #0x20
    40002dc8:	b9002fe0 	str	w0, [sp, #44]

	GICV3_validate_spi_id(intid);
    40002dcc:	b9402fe0 	ldr	w0, [sp, #44]
    40002dd0:	97ffff8c 	bl	40002c00 <GICV3_validate_spi_id>

	uint32 n = ((uint32)intid) / 32;
    40002dd4:	b9402fe0 	ldr	w0, [sp, #44]
    40002dd8:	53057c00 	lsr	w0, w0, #5
    40002ddc:	b9002be0 	str	w0, [sp, #40]
	uint32 bit = ((uint32)intid) % 32;
    40002de0:	b9402fe0 	ldr	w0, [sp, #44]
    40002de4:	12001000 	and	w0, w0, #0x1f
    40002de8:	b90027e0 	str	w0, [sp, #36]

	GICV3_GICD_ISENABLER_set_bit(n, bit);
    40002dec:	b94027e1 	ldr	w1, [sp, #36]
    40002df0:	b9402be0 	ldr	w0, [sp, #40]
    40002df4:	97ffff30 	bl	40002ab4 <GICV3_GICD_ISENABLER_set_bit>
}
    40002df8:	d503201f 	nop
    40002dfc:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40002e00:	d65f03c0 	ret

0000000040002e04 <GICV3_set_priority>:

void GICV3_set_priority(imx8mp_irq irq, uint8 priority)
{
    40002e04:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    40002e08:	910003fd 	mov	x29, sp
    40002e0c:	b9001fe0 	str	w0, [sp, #28]
    40002e10:	39006fe1 	strb	w1, [sp, #27]
	uint32 intid = irq + 32;
    40002e14:	b9401fe0 	ldr	w0, [sp, #28]
    40002e18:	11008000 	add	w0, w0, #0x20
    40002e1c:	b9002fe0 	str	w0, [sp, #44]

	GICV3_validate_spi_id(intid);
    40002e20:	b9402fe0 	ldr	w0, [sp, #44]
    40002e24:	97ffff77 	bl	40002c00 <GICV3_validate_spi_id>

	uint32 n = ((uint32)intid) / 4;
    40002e28:	b9402fe0 	ldr	w0, [sp, #44]
    40002e2c:	53027c00 	lsr	w0, w0, #2
    40002e30:	b9002be0 	str	w0, [sp, #40]
	uint32 byte_idx = ((uint32)intid) % 4;
    40002e34:	b9402fe0 	ldr	w0, [sp, #44]
    40002e38:	12000400 	and	w0, w0, #0x3
    40002e3c:	b90027e0 	str	w0, [sp, #36]

	GicdIpriority r = GICV3_GICD_IPRIORITYR_read(n);
    40002e40:	b9402be0 	ldr	w0, [sp, #40]
    40002e44:	97fffe88 	bl	40002864 <GICV3_GICD_IPRIORITYR_read>
    40002e48:	b90023e0 	str	w0, [sp, #32]
	GICV3_GICD_IPRIORITYR_BF_set(&r, byte_idx, priority);
    40002e4c:	b94027e1 	ldr	w1, [sp, #36]
    40002e50:	910083e0 	add	x0, sp, #0x20
    40002e54:	39406fe2 	ldrb	w2, [sp, #27]
    40002e58:	97fffe9a 	bl	400028c0 <GICV3_GICD_IPRIORITYR_BF_set>
	GICV3_GICD_IPRIORITYR_write(n, r);
    40002e5c:	b9402be0 	ldr	w0, [sp, #40]
    40002e60:	b94023e1 	ldr	w1, [sp, #32]
    40002e64:	97fffe8a 	bl	4000288c <GICV3_GICD_IPRIORITYR_write>
}
    40002e68:	d503201f 	nop
    40002e6c:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40002e70:	d65f03c0 	ret

0000000040002e74 <GICV3_set_edge_triggered>:

void GICV3_set_edge_triggered(imx8mp_irq irq)
{
    40002e74:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    40002e78:	910003fd 	mov	x29, sp
    40002e7c:	b9001fe0 	str	w0, [sp, #28]
	uint32 intid = irq + 32;
    40002e80:	b9401fe0 	ldr	w0, [sp, #28]
    40002e84:	11008000 	add	w0, w0, #0x20
    40002e88:	b9002fe0 	str	w0, [sp, #44]

	GICV3_validate_spi_id(intid);
    40002e8c:	b9402fe0 	ldr	w0, [sp, #44]
    40002e90:	97ffff5c 	bl	40002c00 <GICV3_validate_spi_id>

	uint32 n = ((uint32)intid) / 16;
    40002e94:	b9402fe0 	ldr	w0, [sp, #44]
    40002e98:	53047c00 	lsr	w0, w0, #4
    40002e9c:	b9002be0 	str	w0, [sp, #40]
	uint32 slot = ((uint32)intid) % 16;
    40002ea0:	b9402fe0 	ldr	w0, [sp, #44]
    40002ea4:	12000c00 	and	w0, w0, #0xf
    40002ea8:	b90027e0 	str	w0, [sp, #36]

	GicdIcfgr r = GICV3_GICD_ICFGR_read(n);
    40002eac:	b9402be0 	ldr	w0, [sp, #40]
    40002eb0:	97fffe12 	bl	400026f8 <GICV3_GICD_ICFGR_read>
    40002eb4:	b90023e0 	str	w0, [sp, #32]
	GICV3_GICD_ICFGR_BF_set(&r, slot, 0b10);
    40002eb8:	b94027e1 	ldr	w1, [sp, #36]
    40002ebc:	910083e0 	add	x0, sp, #0x20
    40002ec0:	52800042 	mov	w2, #0x2                   	// #2
    40002ec4:	97fffe24 	bl	40002754 <GICV3_GICD_ICFGR_BF_set>
	GICV3_GICD_ICFGR_write(n, r);
    40002ec8:	b9402be0 	ldr	w0, [sp, #40]
    40002ecc:	b94023e1 	ldr	w1, [sp, #32]
    40002ed0:	97fffe14 	bl	40002720 <GICV3_GICD_ICFGR_write>
}
    40002ed4:	d503201f 	nop
    40002ed8:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40002edc:	d65f03c0 	ret

0000000040002ee0 <GICV3_set_level_sensitive>:

void GICV3_set_level_sensitive(imx8mp_irq irq)
{
    40002ee0:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    40002ee4:	910003fd 	mov	x29, sp
    40002ee8:	b9001fe0 	str	w0, [sp, #28]
	uint32 intid = irq + 32;
    40002eec:	b9401fe0 	ldr	w0, [sp, #28]
    40002ef0:	11008000 	add	w0, w0, #0x20
    40002ef4:	b9002fe0 	str	w0, [sp, #44]

	GICV3_validate_spi_id(intid);
    40002ef8:	b9402fe0 	ldr	w0, [sp, #44]
    40002efc:	97ffff41 	bl	40002c00 <GICV3_validate_spi_id>

	uint32 n = ((uint32)intid) / 16;
    40002f00:	b9402fe0 	ldr	w0, [sp, #44]
    40002f04:	53047c00 	lsr	w0, w0, #4
    40002f08:	b9002be0 	str	w0, [sp, #40]
	uint32 slot = ((uint32)intid) % 16;
    40002f0c:	b9402fe0 	ldr	w0, [sp, #44]
    40002f10:	12000c00 	and	w0, w0, #0xf
    40002f14:	b90027e0 	str	w0, [sp, #36]

	GicdIcfgr r = GICV3_GICD_ICFGR_read(n);
    40002f18:	b9402be0 	ldr	w0, [sp, #40]
    40002f1c:	97fffdf7 	bl	400026f8 <GICV3_GICD_ICFGR_read>
    40002f20:	b90023e0 	str	w0, [sp, #32]
	GICV3_GICD_ICFGR_BF_set(&r, slot, 0b00);
    40002f24:	b94027e1 	ldr	w1, [sp, #36]
    40002f28:	910083e0 	add	x0, sp, #0x20
    40002f2c:	52800002 	mov	w2, #0x0                   	// #0
    40002f30:	97fffe09 	bl	40002754 <GICV3_GICD_ICFGR_BF_set>
	GICV3_GICD_ICFGR_write(n, r);
    40002f34:	b9402be0 	ldr	w0, [sp, #40]
    40002f38:	b94023e1 	ldr	w1, [sp, #32]
    40002f3c:	97fffdf9 	bl	40002720 <GICV3_GICD_ICFGR_write>
}
    40002f40:	d503201f 	nop
    40002f44:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40002f48:	d65f03c0 	ret

0000000040002f4c <GICV3_wake_redistributor>:

void GICV3_wake_redistributor(size_t n)
{
    40002f4c:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    40002f50:	910003fd 	mov	x29, sp
    40002f54:	f9000fe0 	str	x0, [sp, #24]
	GicrWaker w = GICV3_GICR_WAKER_read(n);
    40002f58:	f9400fe0 	ldr	x0, [sp, #24]
    40002f5c:	97fffefb 	bl	40002b48 <GICV3_GICR_WAKER_read>
    40002f60:	b9002be0 	str	w0, [sp, #40]
	GICV3_GICR_WAKER_BF_set_ProcessorSleep(&w, false);
    40002f64:	9100a3e0 	add	x0, sp, #0x28
    40002f68:	52800001 	mov	w1, #0x0                   	// #0
    40002f6c:	97ffff17 	bl	40002bc8 <GICV3_GICR_WAKER_BF_set_ProcessorSleep>
	GICV3_GICR_WAKER_write(n, w);
    40002f70:	b9402be1 	ldr	w1, [sp, #40]
    40002f74:	f9400fe0 	ldr	x0, [sp, #24]
    40002f78:	97fffefe 	bl	40002b70 <GICV3_GICR_WAKER_write>

	bool asleep = true;
    40002f7c:	52800020 	mov	w0, #0x1                   	// #1
    40002f80:	3900ffe0 	strb	w0, [sp, #63]

	while (asleep) {
    40002f84:	14000011 	b	40002fc8 <GICV3_wake_redistributor+0x7c>
		for (size_t i = 0; i < 5000; i++) asm volatile("nop");
    40002f88:	f9001bff 	str	xzr, [sp, #48]
    40002f8c:	14000005 	b	40002fa0 <GICV3_wake_redistributor+0x54>
    40002f90:	d503201f 	nop
    40002f94:	f9401be0 	ldr	x0, [sp, #48]
    40002f98:	91000400 	add	x0, x0, #0x1
    40002f9c:	f9001be0 	str	x0, [sp, #48]
    40002fa0:	f9401be1 	ldr	x1, [sp, #48]
    40002fa4:	d28270e0 	mov	x0, #0x1387                	// #4999
    40002fa8:	eb00003f 	cmp	x1, x0
    40002fac:	54ffff29 	b.ls	40002f90 <GICV3_wake_redistributor+0x44>  // b.plast

		GicrWaker r = GICV3_GICR_WAKER_read(n);
    40002fb0:	f9400fe0 	ldr	x0, [sp, #24]
    40002fb4:	97fffee5 	bl	40002b48 <GICV3_GICR_WAKER_read>
    40002fb8:	b90023e0 	str	w0, [sp, #32]
		asleep = GICV3_GICR_WAKER_BF_get_ChildrenAsleep(r);
    40002fbc:	b94023e0 	ldr	w0, [sp, #32]
    40002fc0:	97fffef9 	bl	40002ba4 <GICV3_GICR_WAKER_BF_get_ChildrenAsleep>
    40002fc4:	3900ffe0 	strb	w0, [sp, #63]
	while (asleep) {
    40002fc8:	3940ffe0 	ldrb	w0, [sp, #63]
    40002fcc:	12000000 	and	w0, w0, #0x1
    40002fd0:	7100001f 	cmp	w0, #0x0
    40002fd4:	54fffda1 	b.ne	40002f88 <GICV3_wake_redistributor+0x3c>  // b.any
	}
}
    40002fd8:	d503201f 	nop
    40002fdc:	d503201f 	nop
    40002fe0:	a8c47bfd 	ldp	x29, x30, [sp], #64
    40002fe4:	d65f03c0 	ret

0000000040002fe8 <UART_UBIR_write>:
MMIO_DECLARE_REG32_VALUE_STRUCT(UBIR_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UBIR, UBIR_VALUE_STRUCT_NAME,
									UART_UBIR_OFFSET);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UBIR, UBIR_VALUE_STRUCT_NAME,
    40002fe8:	d10043ff 	sub	sp, sp, #0x10
    40002fec:	f90007e0 	str	x0, [sp, #8]
    40002ff0:	b90003e1 	str	w1, [sp]
    40002ff4:	f94007e0 	ldr	x0, [sp, #8]
    40002ff8:	91029000 	add	x0, x0, #0xa4
    40002ffc:	aa0003e1 	mov	x1, x0
    40003000:	b94003e0 	ldr	w0, [sp]
    40003004:	b9000020 	str	w0, [x1]
    40003008:	910043ff 	add	sp, sp, #0x10
    4000300c:	d65f03c0 	ret

0000000040003010 <UART_UBIR_BF_set_INC>:
	UART_DECLARE_BIT_FIELD_SETTER(UBIR, bf_name, UBIR_VALUE_STRUCT_NAME, T, \
								  bf_name##_SHIFT, bf_name##_MASK);

#define INC_SHIFT 0
#define INC_MASK (0xFFFF << INC_SHIFT)
    40003010:	d10043ff 	sub	sp, sp, #0x10
    40003014:	f90007e0 	str	x0, [sp, #8]
    40003018:	79000fe1 	strh	w1, [sp, #6]
    4000301c:	f94007e0 	ldr	x0, [sp, #8]
    40003020:	b9400000 	ldr	w0, [x0]
    40003024:	12103c01 	and	w1, w0, #0xffff0000
    40003028:	79400fe0 	ldrh	w0, [sp, #6]
    4000302c:	2a000021 	orr	w1, w1, w0
    40003030:	f94007e0 	ldr	x0, [sp, #8]
    40003034:	b9000001 	str	w1, [x0]
    40003038:	910043ff 	add	sp, sp, #0x10
    4000303c:	d65f03c0 	ret

0000000040003040 <UART_UBMR_write>:
MMIO_DECLARE_REG32_VALUE_STRUCT(UBMR_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UBMR, UBMR_VALUE_STRUCT_NAME,
									UART_UBMR_OFFSET);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UBMR, UBMR_VALUE_STRUCT_NAME,
    40003040:	d10043ff 	sub	sp, sp, #0x10
    40003044:	f90007e0 	str	x0, [sp, #8]
    40003048:	b90003e1 	str	w1, [sp]
    4000304c:	f94007e0 	ldr	x0, [sp, #8]
    40003050:	9102a000 	add	x0, x0, #0xa8
    40003054:	aa0003e1 	mov	x1, x0
    40003058:	b94003e0 	ldr	w0, [sp]
    4000305c:	b9000020 	str	w0, [x1]
    40003060:	910043ff 	add	sp, sp, #0x10
    40003064:	d65f03c0 	ret

0000000040003068 <UART_UBMR_BF_set_MOD>:
	UART_DECLARE_BIT_FIELD_SETTER(UBMR, bf_name, UBMR_VALUE_STRUCT_NAME, T, \
								  bf_name##_SHIFT, bf_name##_MASK);

#define MOD_SHIFT 0
#define MOD_MASK (0xFFFF << MOD_SHIFT)
UBMR_DECLARE_BIT_FIELD_FNS(MOD, uint16);
    40003068:	d10043ff 	sub	sp, sp, #0x10
    4000306c:	f90007e0 	str	x0, [sp, #8]
    40003070:	79000fe1 	strh	w1, [sp, #6]
    40003074:	f94007e0 	ldr	x0, [sp, #8]
    40003078:	b9400000 	ldr	w0, [x0]
    4000307c:	12103c01 	and	w1, w0, #0xffff0000
    40003080:	79400fe0 	ldrh	w0, [sp, #6]
    40003084:	2a000021 	orr	w1, w1, w0
    40003088:	f94007e0 	ldr	x0, [sp, #8]
    4000308c:	b9000001 	str	w1, [x0]
    40003090:	910043ff 	add	sp, sp, #0x10
    40003094:	d65f03c0 	ret

0000000040003098 <UART_UCR1_write>:
MMIO_DECLARE_REG32_VALUE_STRUCT(UCR1_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UCR1, UCR1_VALUE_STRUCT_NAME,
									UART_UCR1_OFFSET);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UCR1, UCR1_VALUE_STRUCT_NAME,
    40003098:	d10043ff 	sub	sp, sp, #0x10
    4000309c:	f90007e0 	str	x0, [sp, #8]
    400030a0:	b90003e1 	str	w1, [sp]
    400030a4:	f94007e0 	ldr	x0, [sp, #8]
    400030a8:	91020000 	add	x0, x0, #0x80
    400030ac:	aa0003e1 	mov	x1, x0
    400030b0:	b94003e0 	ldr	w0, [sp]
    400030b4:	b9000020 	str	w0, [x1]
    400030b8:	910043ff 	add	sp, sp, #0x10
    400030bc:	d65f03c0 	ret

00000000400030c0 <UART_UCR1_BF_set_UARTEN>:
								  bf_name##_SHIFT, bf_name##_MASK);

// UARTEN
#define UARTEN_SHIFT 0
#define UARTEN_MASK (0b1 << UARTEN_SHIFT)
UCR1_DECLARE_BIT_FIELD_FNS(UARTEN, bool);
    400030c0:	d10043ff 	sub	sp, sp, #0x10
    400030c4:	f90007e0 	str	x0, [sp, #8]
    400030c8:	39001fe1 	strb	w1, [sp, #7]
    400030cc:	f94007e0 	ldr	x0, [sp, #8]
    400030d0:	b9400000 	ldr	w0, [x0]
    400030d4:	121f7801 	and	w1, w0, #0xfffffffe
    400030d8:	39401fe0 	ldrb	w0, [sp, #7]
    400030dc:	2a000021 	orr	w1, w1, w0
    400030e0:	f94007e0 	ldr	x0, [sp, #8]
    400030e4:	b9000001 	str	w1, [x0]
    400030e8:	910043ff 	add	sp, sp, #0x10
    400030ec:	d65f03c0 	ret

00000000400030f0 <UART_UCR2_read>:

#define UCR2_VALUE_STRUCT_NAME UartUcr2Value

MMIO_DECLARE_REG32_VALUE_STRUCT(UCR2_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UCR2, UCR2_VALUE_STRUCT_NAME,
    400030f0:	d10043ff 	sub	sp, sp, #0x10
    400030f4:	f90007e0 	str	x0, [sp, #8]
    400030f8:	f94007e0 	ldr	x0, [sp, #8]
    400030fc:	91021000 	add	x0, x0, #0x84
    40003100:	b9400000 	ldr	w0, [x0]
    40003104:	910043ff 	add	sp, sp, #0x10
    40003108:	d65f03c0 	ret

000000004000310c <UART_UCR2_write>:
									UART_UCR2_OFFSET);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UCR2, UCR2_VALUE_STRUCT_NAME,
    4000310c:	d10043ff 	sub	sp, sp, #0x10
    40003110:	f90007e0 	str	x0, [sp, #8]
    40003114:	b90003e1 	str	w1, [sp]
    40003118:	f94007e0 	ldr	x0, [sp, #8]
    4000311c:	91021000 	add	x0, x0, #0x84
    40003120:	aa0003e1 	mov	x1, x0
    40003124:	b94003e0 	ldr	w0, [sp]
    40003128:	b9000020 	str	w0, [x1]
    4000312c:	910043ff 	add	sp, sp, #0x10
    40003130:	d65f03c0 	ret

0000000040003134 <UART_UCR2_BF_set_IRTS>:
UCR2_DECLARE_BIT_FIELD_FNS(ESCI, bool);

// IRTS
#define IRTS_SHIFT 14
#define IRTS_MASK (0b1 << IRTS_SHIFT)
UCR2_DECLARE_BIT_FIELD_FNS(IRTS, bool);
    40003134:	d10043ff 	sub	sp, sp, #0x10
    40003138:	f90007e0 	str	x0, [sp, #8]
    4000313c:	39001fe1 	strb	w1, [sp, #7]
    40003140:	f94007e0 	ldr	x0, [sp, #8]
    40003144:	b9400000 	ldr	w0, [x0]
    40003148:	12117801 	and	w1, w0, #0xffffbfff
    4000314c:	39401fe0 	ldrb	w0, [sp, #7]
    40003150:	53124400 	lsl	w0, w0, #14
    40003154:	12120000 	and	w0, w0, #0x4000
    40003158:	2a000021 	orr	w1, w1, w0
    4000315c:	f94007e0 	ldr	x0, [sp, #8]
    40003160:	b9000001 	str	w1, [x0]
    40003164:	910043ff 	add	sp, sp, #0x10
    40003168:	d65f03c0 	ret

000000004000316c <UART_UCR2_BF_set_WS>:
UCR2_DECLARE_BIT_FIELD_FNS(STPB, bool);

// WS
#define WS_SHIFT 5
#define WS_MASK (0b1 << WS_SHIFT)
UCR2_DECLARE_BIT_FIELD_FNS(WS, bool);
    4000316c:	d10043ff 	sub	sp, sp, #0x10
    40003170:	f90007e0 	str	x0, [sp, #8]
    40003174:	39001fe1 	strb	w1, [sp, #7]
    40003178:	f94007e0 	ldr	x0, [sp, #8]
    4000317c:	b9400000 	ldr	w0, [x0]
    40003180:	121a7801 	and	w1, w0, #0xffffffdf
    40003184:	39401fe0 	ldrb	w0, [sp, #7]
    40003188:	531b6800 	lsl	w0, w0, #5
    4000318c:	121b0000 	and	w0, w0, #0x20
    40003190:	2a000021 	orr	w1, w1, w0
    40003194:	f94007e0 	ldr	x0, [sp, #8]
    40003198:	b9000001 	str	w1, [x0]
    4000319c:	910043ff 	add	sp, sp, #0x10
    400031a0:	d65f03c0 	ret

00000000400031a4 <UART_UCR2_BF_set_TXEN>:
UCR2_DECLARE_BIT_FIELD_FNS(ATEN, bool);

// TXEN
#define TXEN_SHIFT 2
#define TXEN_MASK (0b1 << TXEN_SHIFT)
UCR2_DECLARE_BIT_FIELD_FNS(TXEN, bool);
    400031a4:	d10043ff 	sub	sp, sp, #0x10
    400031a8:	f90007e0 	str	x0, [sp, #8]
    400031ac:	39001fe1 	strb	w1, [sp, #7]
    400031b0:	f94007e0 	ldr	x0, [sp, #8]
    400031b4:	b9400000 	ldr	w0, [x0]
    400031b8:	121d7801 	and	w1, w0, #0xfffffffb
    400031bc:	39401fe0 	ldrb	w0, [sp, #7]
    400031c0:	531e7400 	lsl	w0, w0, #2
    400031c4:	121e0000 	and	w0, w0, #0x4
    400031c8:	2a000021 	orr	w1, w1, w0
    400031cc:	f94007e0 	ldr	x0, [sp, #8]
    400031d0:	b9000001 	str	w1, [x0]
    400031d4:	910043ff 	add	sp, sp, #0x10
    400031d8:	d65f03c0 	ret

00000000400031dc <UART_UCR2_BF_set_RXEN>:

// RXEN
#define RXEN_SHIFT 1
#define RXEN_MASK (0b1 << RXEN_SHIFT)
UCR2_DECLARE_BIT_FIELD_FNS(RXEN, bool);
    400031dc:	d10043ff 	sub	sp, sp, #0x10
    400031e0:	f90007e0 	str	x0, [sp, #8]
    400031e4:	39001fe1 	strb	w1, [sp, #7]
    400031e8:	f94007e0 	ldr	x0, [sp, #8]
    400031ec:	b9400000 	ldr	w0, [x0]
    400031f0:	121e7801 	and	w1, w0, #0xfffffffd
    400031f4:	39401fe0 	ldrb	w0, [sp, #7]
    400031f8:	0b000000 	add	w0, w0, w0
    400031fc:	121f0000 	and	w0, w0, #0x2
    40003200:	2a000021 	orr	w1, w1, w0
    40003204:	f94007e0 	ldr	x0, [sp, #8]
    40003208:	b9000001 	str	w1, [x0]
    4000320c:	910043ff 	add	sp, sp, #0x10
    40003210:	d65f03c0 	ret

0000000040003214 <UART_UCR2_BF_set_SRST>:

// SRST
#define SRST_SHIFT 0
#define SRST_MASK (0b1 << SRST_SHIFT)
UCR2_DECLARE_BIT_FIELD_FNS(SRST, bool);
    40003214:	d10043ff 	sub	sp, sp, #0x10
    40003218:	f90007e0 	str	x0, [sp, #8]
    4000321c:	39001fe1 	strb	w1, [sp, #7]
    40003220:	f94007e0 	ldr	x0, [sp, #8]
    40003224:	b9400000 	ldr	w0, [x0]
    40003228:	121f7801 	and	w1, w0, #0xfffffffe
    4000322c:	39401fe0 	ldrb	w0, [sp, #7]
    40003230:	2a000021 	orr	w1, w1, w0
    40003234:	f94007e0 	ldr	x0, [sp, #8]
    40003238:	b9000001 	str	w1, [x0]
    4000323c:	910043ff 	add	sp, sp, #0x10
    40003240:	d65f03c0 	ret

0000000040003244 <UART_UCR3_write>:
MMIO_DECLARE_REG32_VALUE_STRUCT(UCR3_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UCR3, UCR3_VALUE_STRUCT_NAME,
									UART_UCR3_OFFSET);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UCR3, UCR3_VALUE_STRUCT_NAME,
    40003244:	d10043ff 	sub	sp, sp, #0x10
    40003248:	f90007e0 	str	x0, [sp, #8]
    4000324c:	b90003e1 	str	w1, [sp]
    40003250:	f94007e0 	ldr	x0, [sp, #8]
    40003254:	91022000 	add	x0, x0, #0x88
    40003258:	aa0003e1 	mov	x1, x0
    4000325c:	b94003e0 	ldr	w0, [sp]
    40003260:	b9000020 	str	w0, [x1]
    40003264:	910043ff 	add	sp, sp, #0x10
    40003268:	d65f03c0 	ret

000000004000326c <UART_UCR3_BF_set_DSR>:
UCR3_DECLARE_BIT_FIELD_FNS(FRAERREN, bool);

// DSR (unused)
#define DSR_SHIFT 10
#define DSR_MASK (0b1 << DSR_SHIFT)
UCR3_DECLARE_BIT_FIELD_FNS(DSR, bool);
    4000326c:	d10043ff 	sub	sp, sp, #0x10
    40003270:	f90007e0 	str	x0, [sp, #8]
    40003274:	39001fe1 	strb	w1, [sp, #7]
    40003278:	f94007e0 	ldr	x0, [sp, #8]
    4000327c:	b9400000 	ldr	w0, [x0]
    40003280:	12157801 	and	w1, w0, #0xfffffbff
    40003284:	39401fe0 	ldrb	w0, [sp, #7]
    40003288:	53165400 	lsl	w0, w0, #10
    4000328c:	12160000 	and	w0, w0, #0x400
    40003290:	2a000021 	orr	w1, w1, w0
    40003294:	f94007e0 	ldr	x0, [sp, #8]
    40003298:	b9000001 	str	w1, [x0]
    4000329c:	910043ff 	add	sp, sp, #0x10
    400032a0:	d65f03c0 	ret

00000000400032a4 <UART_UCR3_BF_set_DCD>:

// DCD (unused)
#define DCD_SHIFT 9
#define DCD_MASK (0b1 << DCD_SHIFT)
UCR3_DECLARE_BIT_FIELD_FNS(DCD, bool);
    400032a4:	d10043ff 	sub	sp, sp, #0x10
    400032a8:	f90007e0 	str	x0, [sp, #8]
    400032ac:	39001fe1 	strb	w1, [sp, #7]
    400032b0:	f94007e0 	ldr	x0, [sp, #8]
    400032b4:	b9400000 	ldr	w0, [x0]
    400032b8:	12167801 	and	w1, w0, #0xfffffdff
    400032bc:	39401fe0 	ldrb	w0, [sp, #7]
    400032c0:	53175800 	lsl	w0, w0, #9
    400032c4:	12170000 	and	w0, w0, #0x200
    400032c8:	2a000021 	orr	w1, w1, w0
    400032cc:	f94007e0 	ldr	x0, [sp, #8]
    400032d0:	b9000001 	str	w1, [x0]
    400032d4:	910043ff 	add	sp, sp, #0x10
    400032d8:	d65f03c0 	ret

00000000400032dc <UART_UCR3_BF_set_RI>:

// RI (unused)
#define RI_SHIFT 8
#define RI_MASK (0b1 << RI_SHIFT)
UCR3_DECLARE_BIT_FIELD_FNS(RI, bool);
    400032dc:	d10043ff 	sub	sp, sp, #0x10
    400032e0:	f90007e0 	str	x0, [sp, #8]
    400032e4:	39001fe1 	strb	w1, [sp, #7]
    400032e8:	f94007e0 	ldr	x0, [sp, #8]
    400032ec:	b9400000 	ldr	w0, [x0]
    400032f0:	12177801 	and	w1, w0, #0xfffffeff
    400032f4:	39401fe0 	ldrb	w0, [sp, #7]
    400032f8:	53185c00 	lsl	w0, w0, #8
    400032fc:	12180000 	and	w0, w0, #0x100
    40003300:	2a000021 	orr	w1, w1, w0
    40003304:	f94007e0 	ldr	x0, [sp, #8]
    40003308:	b9000001 	str	w1, [x0]
    4000330c:	910043ff 	add	sp, sp, #0x10
    40003310:	d65f03c0 	ret

0000000040003314 <UART_UCR3_BF_set_RXDMUXSEL>:
UCR3_DECLARE_BIT_FIELD_FNS(DTRDEN, bool);

// RXDMUXSEL
#define RXDMUXSEL_SHIFT 2
#define RXDMUXSEL_MASK (0b1 << RXDMUXSEL_SHIFT)
UCR3_DECLARE_BIT_FIELD_FNS(RXDMUXSEL, bool);
    40003314:	d10043ff 	sub	sp, sp, #0x10
    40003318:	f90007e0 	str	x0, [sp, #8]
    4000331c:	39001fe1 	strb	w1, [sp, #7]
    40003320:	f94007e0 	ldr	x0, [sp, #8]
    40003324:	b9400000 	ldr	w0, [x0]
    40003328:	121d7801 	and	w1, w0, #0xfffffffb
    4000332c:	39401fe0 	ldrb	w0, [sp, #7]
    40003330:	531e7400 	lsl	w0, w0, #2
    40003334:	121e0000 	and	w0, w0, #0x4
    40003338:	2a000021 	orr	w1, w1, w0
    4000333c:	f94007e0 	ldr	x0, [sp, #8]
    40003340:	b9000001 	str	w1, [x0]
    40003344:	910043ff 	add	sp, sp, #0x10
    40003348:	d65f03c0 	ret

000000004000334c <UART_UCR4_write>:
MMIO_DECLARE_REG32_VALUE_STRUCT(UCR4_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UCR4, UCR4_VALUE_STRUCT_NAME,
									UART_UCR4_OFFSET);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UCR4, UCR4_VALUE_STRUCT_NAME,
    4000334c:	d10043ff 	sub	sp, sp, #0x10
    40003350:	f90007e0 	str	x0, [sp, #8]
    40003354:	b90003e1 	str	w1, [sp]
    40003358:	f94007e0 	ldr	x0, [sp, #8]
    4000335c:	91023000 	add	x0, x0, #0x8c
    40003360:	aa0003e1 	mov	x1, x0
    40003364:	b94003e0 	ldr	w0, [sp]
    40003368:	b9000020 	str	w0, [x1]
    4000336c:	910043ff 	add	sp, sp, #0x10
    40003370:	d65f03c0 	ret

0000000040003374 <UART_UCR4_BF_set_CTSTL>:
								  bf_name##_SHIFT, bf_name##_MASK);

// CTSTL
#define CTSTL_SHIFT 10
#define CTSTL_MASK (0b111111 << CTSTL_SHIFT)
UCR4_DECLARE_BIT_FIELD_FNS(CTSTL, uint8);
    40003374:	d10043ff 	sub	sp, sp, #0x10
    40003378:	f90007e0 	str	x0, [sp, #8]
    4000337c:	39001fe1 	strb	w1, [sp, #7]
    40003380:	f94007e0 	ldr	x0, [sp, #8]
    40003384:	b9400000 	ldr	w0, [x0]
    40003388:	12106401 	and	w1, w0, #0xffff03ff
    4000338c:	39401fe0 	ldrb	w0, [sp, #7]
    40003390:	53165400 	lsl	w0, w0, #10
    40003394:	12003c00 	and	w0, w0, #0xffff
    40003398:	2a000021 	orr	w1, w1, w0
    4000339c:	f94007e0 	ldr	x0, [sp, #8]
    400033a0:	b9000001 	str	w1, [x0]
    400033a4:	910043ff 	add	sp, sp, #0x10
    400033a8:	d65f03c0 	ret

00000000400033ac <UART_UFCR_write>:
MMIO_DECLARE_REG32_VALUE_STRUCT(UFCR_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UFCR, UFCR_VALUE_STRUCT_NAME,
									UART_UFCR_OFFSET);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UFCR, UFCR_VALUE_STRUCT_NAME,
    400033ac:	d10043ff 	sub	sp, sp, #0x10
    400033b0:	f90007e0 	str	x0, [sp, #8]
    400033b4:	b90003e1 	str	w1, [sp]
    400033b8:	f94007e0 	ldr	x0, [sp, #8]
    400033bc:	91024000 	add	x0, x0, #0x90
    400033c0:	aa0003e1 	mov	x1, x0
    400033c4:	b94003e0 	ldr	w0, [sp]
    400033c8:	b9000020 	str	w0, [x1]
    400033cc:	910043ff 	add	sp, sp, #0x10
    400033d0:	d65f03c0 	ret

00000000400033d4 <UART_UMCR_write>:
MMIO_DECLARE_REG32_VALUE_STRUCT(UMCR_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UMCR, UMCR_VALUE_STRUCT_NAME,
									UART_UMCR_OFFSET);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UMCR, UMCR_VALUE_STRUCT_NAME,
    400033d4:	d10043ff 	sub	sp, sp, #0x10
    400033d8:	f90007e0 	str	x0, [sp, #8]
    400033dc:	b90003e1 	str	w1, [sp]
    400033e0:	f94007e0 	ldr	x0, [sp, #8]
    400033e4:	9102e000 	add	x0, x0, #0xb8
    400033e8:	aa0003e1 	mov	x1, x0
    400033ec:	b94003e0 	ldr	w0, [sp]
    400033f0:	b9000020 	str	w0, [x1]
    400033f4:	910043ff 	add	sp, sp, #0x10
    400033f8:	d65f03c0 	ret

00000000400033fc <UART_URXD_read>:

#define URXD_VALUE_STRUCT_NAME UartUrxdValue

MMIO_DECLARE_REG32_VALUE_STRUCT(URXD_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, URXD, URXD_VALUE_STRUCT_NAME,
    400033fc:	d10043ff 	sub	sp, sp, #0x10
    40003400:	f90007e0 	str	x0, [sp, #8]
    40003404:	f94007e0 	ldr	x0, [sp, #8]
    40003408:	b9400000 	ldr	w0, [x0]
    4000340c:	910043ff 	add	sp, sp, #0x10
    40003410:	d65f03c0 	ret

0000000040003414 <UART_URDX_BF_get_RX_DATA>:
// RX_DATA

#define RX_DATA_SHIFT 0
#define RX_DATA_MASK (0xFF << RX_DATA_SHIFT)

UART_DECLARE_BIT_FIELD_GETTER(URDX, RX_DATA, URXD_VALUE_STRUCT_NAME, uint8,
    40003414:	d10043ff 	sub	sp, sp, #0x10
    40003418:	b9000be0 	str	w0, [sp, #8]
    4000341c:	b9400be0 	ldr	w0, [sp, #8]
    40003420:	12001c00 	and	w0, w0, #0xff
    40003424:	910043ff 	add	sp, sp, #0x10
    40003428:	d65f03c0 	ret

000000004000342c <UART_UTS_read>:

#define UTS_VALUE_STRUCT_NAME UartUtsValue

MMIO_DECLARE_REG32_VALUE_STRUCT(UTS_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_WITH_BASE(UART, UTS, UTS_VALUE_STRUCT_NAME,
    4000342c:	d10043ff 	sub	sp, sp, #0x10
    40003430:	f90007e0 	str	x0, [sp, #8]
    40003434:	f94007e0 	ldr	x0, [sp, #8]
    40003438:	9102d000 	add	x0, x0, #0xb4
    4000343c:	b9400000 	ldr	w0, [x0]
    40003440:	910043ff 	add	sp, sp, #0x10
    40003444:	d65f03c0 	ret

0000000040003448 <UART_UTS_BF_get_RXEMPTY>:
UTS_DECLARE_BIT_FIELD_FNS(TXEMPTY, bool);

// RXEMPTY
#define RXEMPTY_SHIFT 5
#define RXEMPTY_MASK (0b1 << RXEMPTY_SHIFT)
UTS_DECLARE_BIT_FIELD_FNS(RXEMPTY, bool);
    40003448:	d10043ff 	sub	sp, sp, #0x10
    4000344c:	b9000be0 	str	w0, [sp, #8]
    40003450:	b9400be0 	ldr	w0, [sp, #8]
    40003454:	121b0000 	and	w0, w0, #0x20
    40003458:	7100001f 	cmp	w0, #0x0
    4000345c:	1a9f07e0 	cset	w0, ne	// ne = any
    40003460:	12001c00 	and	w0, w0, #0xff
    40003464:	910043ff 	add	sp, sp, #0x10
    40003468:	d65f03c0 	ret

000000004000346c <UART_UTS_BF_get_TXFULL>:

// TXFULL
#define TXFULL_SHIFT 4
#define TXFULL_MASK (0b1 << TXFULL_SHIFT)
UTS_DECLARE_BIT_FIELD_FNS(TXFULL, bool);
    4000346c:	d10043ff 	sub	sp, sp, #0x10
    40003470:	b9000be0 	str	w0, [sp, #8]
    40003474:	b9400be0 	ldr	w0, [sp, #8]
    40003478:	121c0000 	and	w0, w0, #0x10
    4000347c:	7100001f 	cmp	w0, #0x0
    40003480:	1a9f07e0 	cset	w0, ne	// ne = any
    40003484:	12001c00 	and	w0, w0, #0xff
    40003488:	910043ff 	add	sp, sp, #0x10
    4000348c:	d65f03c0 	ret

0000000040003490 <UART_UTS_BF_get_SOFTRST>:
UTS_DECLARE_BIT_FIELD_FNS(RXFULL, bool);

// SOFTRST
#define SOFTRST_SHIFT 0
#define SOFTRST_MASK (0b1 << SOFTRST_SHIFT)
UTS_DECLARE_BIT_FIELD_FNS(SOFTRST, bool);
    40003490:	d10043ff 	sub	sp, sp, #0x10
    40003494:	b9000be0 	str	w0, [sp, #8]
    40003498:	b9400be0 	ldr	w0, [sp, #8]
    4000349c:	12000000 	and	w0, w0, #0x1
    400034a0:	7100001f 	cmp	w0, #0x0
    400034a4:	1a9f07e0 	cset	w0, ne	// ne = any
    400034a8:	12001c00 	and	w0, w0, #0xff
    400034ac:	910043ff 	add	sp, sp, #0x10
    400034b0:	d65f03c0 	ret

00000000400034b4 <UART_UTXD_write>:

#define UTXD_VALUE_STRUCT_NAME UartUtxdValue

MMIO_DECLARE_REG32_VALUE_STRUCT(UTXD_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_SETTER_WITH_BASE(UART, UTXD, UTXD_VALUE_STRUCT_NAME,
    400034b4:	d10043ff 	sub	sp, sp, #0x10
    400034b8:	f90007e0 	str	x0, [sp, #8]
    400034bc:	b90003e1 	str	w1, [sp]
    400034c0:	f94007e0 	ldr	x0, [sp, #8]
    400034c4:	91010000 	add	x0, x0, #0x40
    400034c8:	aa0003e1 	mov	x1, x0
    400034cc:	b94003e0 	ldr	w0, [sp]
    400034d0:	b9000020 	str	w0, [x1]
    400034d4:	910043ff 	add	sp, sp, #0x10
    400034d8:	d65f03c0 	ret

00000000400034dc <UART_tx_fifo_full>:
	UART4_BASE,
};

// Tx fifo full
static inline bool UART_tx_fifo_full(uintptr periph_base)
{
    400034dc:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    400034e0:	910003fd 	mov	x29, sp
    400034e4:	f9000fe0 	str	x0, [sp, #24]
	UartUtsValue uts = UART_UTS_read(periph_base);
    400034e8:	f9400fe0 	ldr	x0, [sp, #24]
    400034ec:	97ffffd0 	bl	4000342c <UART_UTS_read>
    400034f0:	b9002be0 	str	w0, [sp, #40]
	return UART_UTS_BF_get_TXFULL(uts);
    400034f4:	b9402be0 	ldr	w0, [sp, #40]
    400034f8:	97ffffdd 	bl	4000346c <UART_UTS_BF_get_TXFULL>
    400034fc:	12001c00 	and	w0, w0, #0xff
}
    40003500:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40003504:	d65f03c0 	ret

0000000040003508 <UART_putc>:

void UART_putc(UART_ID id, uint8 c)
{
    40003508:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    4000350c:	910003fd 	mov	x29, sp
    40003510:	b9001fe0 	str	w0, [sp, #28]
    40003514:	39006fe1 	strb	w1, [sp, #27]
	UartUtxdValue utxd = {(uint32)c};
    40003518:	39406fe0 	ldrb	w0, [sp, #27]
    4000351c:	b9002be0 	str	w0, [sp, #40]

	while (UART_tx_fifo_full(UART_N_BASE[id])) {
    40003520:	14000002 	b	40003528 <UART_putc+0x20>
		asm volatile("nop");
    40003524:	d503201f 	nop
	while (UART_tx_fifo_full(UART_N_BASE[id])) {
    40003528:	d0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    4000352c:	910ba000 	add	x0, x0, #0x2e8
    40003530:	b9401fe1 	ldr	w1, [sp, #28]
    40003534:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    40003538:	97ffffe9 	bl	400034dc <UART_tx_fifo_full>
    4000353c:	12001c00 	and	w0, w0, #0xff
    40003540:	12000000 	and	w0, w0, #0x1
    40003544:	7100001f 	cmp	w0, #0x0
    40003548:	54fffee1 	b.ne	40003524 <UART_putc+0x1c>  // b.any
	}

	UART_UTXD_write(UART_N_BASE[id], utxd);
    4000354c:	d0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40003550:	910ba000 	add	x0, x0, #0x2e8
    40003554:	b9401fe1 	ldr	w1, [sp, #28]
    40003558:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    4000355c:	b9402be1 	ldr	w1, [sp, #40]
    40003560:	97ffffd5 	bl	400034b4 <UART_UTXD_write>
}
    40003564:	d503201f 	nop
    40003568:	a8c37bfd 	ldp	x29, x30, [sp], #48
    4000356c:	d65f03c0 	ret

0000000040003570 <UART_puts>:

void UART_puts(const UART_ID id, const char *s)
{
    40003570:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    40003574:	910003fd 	mov	x29, sp
    40003578:	b9001fe0 	str	w0, [sp, #28]
    4000357c:	f9000be1 	str	x1, [sp, #16]
	while (*s) UART_putc(id, *s++);
    40003580:	14000008 	b	400035a0 <UART_puts+0x30>
    40003584:	f9400be0 	ldr	x0, [sp, #16]
    40003588:	91000401 	add	x1, x0, #0x1
    4000358c:	f9000be1 	str	x1, [sp, #16]
    40003590:	39400000 	ldrb	w0, [x0]
    40003594:	2a0003e1 	mov	w1, w0
    40003598:	b9401fe0 	ldr	w0, [sp, #28]
    4000359c:	97ffffdb 	bl	40003508 <UART_putc>
    400035a0:	f9400be0 	ldr	x0, [sp, #16]
    400035a4:	39400000 	ldrb	w0, [x0]
    400035a8:	7100001f 	cmp	w0, #0x0
    400035ac:	54fffec1 	b.ne	40003584 <UART_puts+0x14>  // b.any
}
    400035b0:	d503201f 	nop
    400035b4:	d503201f 	nop
    400035b8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    400035bc:	d65f03c0 	ret

00000000400035c0 <UART_reset>:

void UART_reset(UART_ID id)
{
    400035c0:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    400035c4:	910003fd 	mov	x29, sp
    400035c8:	b9001fe0 	str	w0, [sp, #28]
	uintptr periph_base = UART_N_BASE[id];
    400035cc:	d0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400035d0:	910ba000 	add	x0, x0, #0x2e8
    400035d4:	b9401fe1 	ldr	w1, [sp, #28]
    400035d8:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    400035dc:	f9001be0 	str	x0, [sp, #48]
	UartUcr2Value ucr2 = UART_UCR2_read(periph_base);
    400035e0:	f9401be0 	ldr	x0, [sp, #48]
    400035e4:	97fffec3 	bl	400030f0 <UART_UCR2_read>
    400035e8:	b9002be0 	str	w0, [sp, #40]
	UART_UCR2_BF_set_SRST(&ucr2, false);  // UART software reset 17.2.8.2
    400035ec:	9100a3e0 	add	x0, sp, #0x28
    400035f0:	52800001 	mov	w1, #0x0                   	// #0
    400035f4:	97ffff08 	bl	40003214 <UART_UCR2_BF_set_SRST>

	loop
	{
		for (uint64 i = 0; i < 2000; i++) asm volatile("nop");
    400035f8:	f9001fff 	str	xzr, [sp, #56]
    400035fc:	14000005 	b	40003610 <UART_reset+0x50>
    40003600:	d503201f 	nop
    40003604:	f9401fe0 	ldr	x0, [sp, #56]
    40003608:	91000400 	add	x0, x0, #0x1
    4000360c:	f9001fe0 	str	x0, [sp, #56]
    40003610:	f9401fe0 	ldr	x0, [sp, #56]
    40003614:	f11f3c1f 	cmp	x0, #0x7cf
    40003618:	54ffff49 	b.ls	40003600 <UART_reset+0x40>  // b.plast

		UartUtsValue uts = UART_UTS_read(periph_base);
    4000361c:	f9401be0 	ldr	x0, [sp, #48]
    40003620:	97ffff83 	bl	4000342c <UART_UTS_read>
    40003624:	b90023e0 	str	w0, [sp, #32]
		if (UART_UTS_BF_get_SOFTRST(uts) == 0) {
    40003628:	b94023e0 	ldr	w0, [sp, #32]
    4000362c:	97ffff99 	bl	40003490 <UART_UTS_BF_get_SOFTRST>
    40003630:	12001c00 	and	w0, w0, #0xff
    40003634:	52000000 	eor	w0, w0, #0x1
    40003638:	12001c00 	and	w0, w0, #0xff
    4000363c:	12000000 	and	w0, w0, #0x1
    40003640:	7100001f 	cmp	w0, #0x0
    40003644:	54000041 	b.ne	4000364c <UART_reset+0x8c>  // b.any
	{
    40003648:	17ffffec 	b	400035f8 <UART_reset+0x38>
			break;
		}
	}
}
    4000364c:	d503201f 	nop
    40003650:	a8c47bfd 	ldp	x29, x30, [sp], #64
    40003654:	d65f03c0 	ret

0000000040003658 <UART_init>:

// FIXME: read the configuration left by the bootloader to watch what is wrong
void UART_init(UART_ID id)
{
    40003658:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    4000365c:	910003fd 	mov	x29, sp
    40003660:	b9001fe0 	str	w0, [sp, #28]
	// 17.2.12.1 7357
	uintptr periph_base = UART_N_BASE[id];
    40003664:	d0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    40003668:	910ba000 	add	x0, x0, #0x2e8
    4000366c:	b9401fe1 	ldr	w1, [sp, #28]
    40003670:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    40003674:	f90037e0 	str	x0, [sp, #104]

	UartUcr1Value ucr1 = {0};
    40003678:	b90063ff 	str	wzr, [sp, #96]
	UART_UCR1_BF_set_UARTEN(&ucr1, true);
    4000367c:	910183e0 	add	x0, sp, #0x60
    40003680:	52800021 	mov	w1, #0x1                   	// #1
    40003684:	97fffe8f 	bl	400030c0 <UART_UCR1_BF_set_UARTEN>
	UART_UCR1_write(periph_base, ucr1);
    40003688:	b94063e1 	ldr	w1, [sp, #96]
    4000368c:	f94037e0 	ldr	x0, [sp, #104]
    40003690:	97fffe82 	bl	40003098 <UART_UCR1_write>

	UartUcr2Value ucr2 = {0};
    40003694:	b9005bff 	str	wzr, [sp, #88]
	UART_UCR2_BF_set_SRST(&ucr2, true);
    40003698:	910163e0 	add	x0, sp, #0x58
    4000369c:	52800021 	mov	w1, #0x1                   	// #1
    400036a0:	97fffedd 	bl	40003214 <UART_UCR2_BF_set_SRST>
	UART_UCR2_BF_set_RXEN(&ucr2, true);
    400036a4:	910163e0 	add	x0, sp, #0x58
    400036a8:	52800021 	mov	w1, #0x1                   	// #1
    400036ac:	97fffecc 	bl	400031dc <UART_UCR2_BF_set_RXEN>
	UART_UCR2_BF_set_TXEN(&ucr2, true);
    400036b0:	910163e0 	add	x0, sp, #0x58
    400036b4:	52800021 	mov	w1, #0x1                   	// #1
    400036b8:	97fffebb 	bl	400031a4 <UART_UCR2_BF_set_TXEN>
	UART_UCR2_BF_set_WS(&ucr2, true);
    400036bc:	910163e0 	add	x0, sp, #0x58
    400036c0:	52800021 	mov	w1, #0x1                   	// #1
    400036c4:	97fffeaa 	bl	4000316c <UART_UCR2_BF_set_WS>
	UART_UCR2_BF_set_IRTS(&ucr2, true);
    400036c8:	910163e0 	add	x0, sp, #0x58
    400036cc:	52800021 	mov	w1, #0x1                   	// #1
    400036d0:	97fffe99 	bl	40003134 <UART_UCR2_BF_set_IRTS>
	UART_UCR2_write(periph_base, ucr2);
    400036d4:	b9405be1 	ldr	w1, [sp, #88]
    400036d8:	f94037e0 	ldr	x0, [sp, #104]
    400036dc:	97fffe8c 	bl	4000310c <UART_UCR2_write>

	UartUcr3Value ucr3 = {0};
    400036e0:	b90053ff 	str	wzr, [sp, #80]
	UART_UCR3_BF_set_RXDMUXSEL(&ucr3, true);
    400036e4:	910143e0 	add	x0, sp, #0x50
    400036e8:	52800021 	mov	w1, #0x1                   	// #1
    400036ec:	97ffff0a 	bl	40003314 <UART_UCR3_BF_set_RXDMUXSEL>
	UART_UCR3_BF_set_RI(&ucr3, true);
    400036f0:	910143e0 	add	x0, sp, #0x50
    400036f4:	52800021 	mov	w1, #0x1                   	// #1
    400036f8:	97fffef9 	bl	400032dc <UART_UCR3_BF_set_RI>
	UART_UCR3_BF_set_DCD(&ucr3, true);
    400036fc:	910143e0 	add	x0, sp, #0x50
    40003700:	52800021 	mov	w1, #0x1                   	// #1
    40003704:	97fffee8 	bl	400032a4 <UART_UCR3_BF_set_DCD>
	UART_UCR3_BF_set_DSR(&ucr3, true);
    40003708:	910143e0 	add	x0, sp, #0x50
    4000370c:	52800021 	mov	w1, #0x1                   	// #1
    40003710:	97fffed7 	bl	4000326c <UART_UCR3_BF_set_DSR>
	UART_UCR3_write(periph_base, ucr3);
    40003714:	b94053e1 	ldr	w1, [sp, #80]
    40003718:	f94037e0 	ldr	x0, [sp, #104]
    4000371c:	97fffeca 	bl	40003244 <UART_UCR3_write>

	UartUcr4Value ucr4 = {0};
    40003720:	b9004bff 	str	wzr, [sp, #72]
	UART_UCR4_BF_set_CTSTL(&ucr4, 31);
    40003724:	910123e0 	add	x0, sp, #0x48
    40003728:	528003e1 	mov	w1, #0x1f                  	// #31
    4000372c:	97ffff12 	bl	40003374 <UART_UCR4_BF_set_CTSTL>
	UART_UCR4_write(periph_base, ucr4);
    40003730:	b9404be1 	ldr	w1, [sp, #72]
    40003734:	f94037e0 	ldr	x0, [sp, #104]
    40003738:	97ffff05 	bl	4000334c <UART_UCR4_write>

	UartUfcrValue ufcr = {0xA01};  // 0000 1010 0000 0001
    4000373c:	52814020 	mov	w0, #0xa01                 	// #2561
    40003740:	b90043e0 	str	w0, [sp, #64]
	UART_UFCR_write(periph_base, ufcr);
    40003744:	b94043e1 	ldr	w1, [sp, #64]
    40003748:	f94037e0 	ldr	x0, [sp, #104]
    4000374c:	97ffff18 	bl	400033ac <UART_UFCR_write>

	UartUbirValue ubir = {0};
    40003750:	b9003bff 	str	wzr, [sp, #56]
	UART_UBIR_BF_set_INC(&ubir, 0xF);
    40003754:	9100e3e0 	add	x0, sp, #0x38
    40003758:	528001e1 	mov	w1, #0xf                   	// #15
    4000375c:	97fffe2d 	bl	40003010 <UART_UBIR_BF_set_INC>
	UART_UBIR_write(periph_base, ubir);
    40003760:	b9403be1 	ldr	w1, [sp, #56]
    40003764:	f94037e0 	ldr	x0, [sp, #104]
    40003768:	97fffe20 	bl	40002fe8 <UART_UBIR_write>

	UartUbmrValue ubmr = {0};
    4000376c:	b90033ff 	str	wzr, [sp, #48]
	UART_UBMR_BF_set_MOD(&ubmr, 0x68);
    40003770:	9100c3e0 	add	x0, sp, #0x30
    40003774:	52800d01 	mov	w1, #0x68                  	// #104
    40003778:	97fffe3c 	bl	40003068 <UART_UBMR_BF_set_MOD>
	UART_UBMR_write(periph_base, ubmr);
    4000377c:	b94033e1 	ldr	w1, [sp, #48]
    40003780:	f94037e0 	ldr	x0, [sp, #104]
    40003784:	97fffe2f 	bl	40003040 <UART_UBMR_write>

	UartUmcrValue umcr = {0};
    40003788:	b9002bff 	str	wzr, [sp, #40]
	UART_UMCR_write(periph_base, umcr);
    4000378c:	b9402be1 	ldr	w1, [sp, #40]
    40003790:	f94037e0 	ldr	x0, [sp, #104]
    40003794:	97ffff10 	bl	400033d4 <UART_UMCR_write>
}
    40003798:	d503201f 	nop
    4000379c:	a8c77bfd 	ldp	x29, x30, [sp], #112
    400037a0:	d65f03c0 	ret

00000000400037a4 <UART_read>:

bool UART_read(UART_ID id, uint8 *data)
{
    400037a4:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    400037a8:	910003fd 	mov	x29, sp
    400037ac:	b9001fe0 	str	w0, [sp, #28]
    400037b0:	f9000be1 	str	x1, [sp, #16]
	uintptr periph_base = UART_N_BASE[id];
    400037b4:	d0000000 	adrp	x0, 40005000 <STDINT_BASE_REPR_CHARS+0xf0>
    400037b8:	910ba000 	add	x0, x0, #0x2e8
    400037bc:	b9401fe1 	ldr	w1, [sp, #28]
    400037c0:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    400037c4:	f90017e0 	str	x0, [sp, #40]
	if (UART_UTS_BF_get_RXEMPTY(UART_UTS_read(periph_base))) return false;
    400037c8:	f94017e0 	ldr	x0, [sp, #40]
    400037cc:	97ffff18 	bl	4000342c <UART_UTS_read>
    400037d0:	97ffff1e 	bl	40003448 <UART_UTS_BF_get_RXEMPTY>
    400037d4:	12001c00 	and	w0, w0, #0xff
    400037d8:	12000000 	and	w0, w0, #0x1
    400037dc:	7100001f 	cmp	w0, #0x0
    400037e0:	54000060 	b.eq	400037ec <UART_read+0x48>  // b.none
    400037e4:	52800000 	mov	w0, #0x0                   	// #0
    400037e8:	1400000a 	b	40003810 <UART_read+0x6c>

	UartUrxdValue urxd = UART_URXD_read(periph_base);
    400037ec:	f94017e0 	ldr	x0, [sp, #40]
    400037f0:	97ffff03 	bl	400033fc <UART_URXD_read>
    400037f4:	b90023e0 	str	w0, [sp, #32]
	*data = UART_URDX_BF_get_RX_DATA(urxd);
    400037f8:	b94023e0 	ldr	w0, [sp, #32]
    400037fc:	97ffff06 	bl	40003414 <UART_URDX_BF_get_RX_DATA>
    40003800:	12001c01 	and	w1, w0, #0xff
    40003804:	f9400be0 	ldr	x0, [sp, #16]
    40003808:	39000001 	strb	w1, [x0]

	return true;
    4000380c:	52800020 	mov	w0, #0x1                   	// #1
}
    40003810:	a8c37bfd 	ldp	x29, x30, [sp], #48
    40003814:	d65f03c0 	ret
	...

Disassembly of section .vectors:

0000000040004000 <_el2_vector_table>:
.section .vectors, "ax"
.global _el2_vector_table
.align 11
_el2_vector_table:
//  0..3: Current EL, SP0
    SET_VENTRY _el2_cur_sp0_sync
    40004000:	17fff020 	b	40000080 <_el2_cur_sp0_sync>
    40004004:	d503201f 	nop
    40004008:	d503201f 	nop
    4000400c:	d503201f 	nop
    40004010:	d503201f 	nop
    40004014:	d503201f 	nop
    40004018:	d503201f 	nop
    4000401c:	d503201f 	nop
    40004020:	d503201f 	nop
    40004024:	d503201f 	nop
    40004028:	d503201f 	nop
    4000402c:	d503201f 	nop
    40004030:	d503201f 	nop
    40004034:	d503201f 	nop
    40004038:	d503201f 	nop
    4000403c:	d503201f 	nop
    40004040:	d503201f 	nop
    40004044:	d503201f 	nop
    40004048:	d503201f 	nop
    4000404c:	d503201f 	nop
    40004050:	d503201f 	nop
    40004054:	d503201f 	nop
    40004058:	d503201f 	nop
    4000405c:	d503201f 	nop
    40004060:	d503201f 	nop
    40004064:	d503201f 	nop
    40004068:	d503201f 	nop
    4000406c:	d503201f 	nop
    40004070:	d503201f 	nop
    40004074:	d503201f 	nop
    40004078:	d503201f 	nop
    4000407c:	d503201f 	nop
    SET_VENTRY _el2_cur_sp0_irq
    40004080:	17fff024 	b	40000110 <_el2_cur_sp0_irq>
    40004084:	d503201f 	nop
    40004088:	d503201f 	nop
    4000408c:	d503201f 	nop
    40004090:	d503201f 	nop
    40004094:	d503201f 	nop
    40004098:	d503201f 	nop
    4000409c:	d503201f 	nop
    400040a0:	d503201f 	nop
    400040a4:	d503201f 	nop
    400040a8:	d503201f 	nop
    400040ac:	d503201f 	nop
    400040b0:	d503201f 	nop
    400040b4:	d503201f 	nop
    400040b8:	d503201f 	nop
    400040bc:	d503201f 	nop
    400040c0:	d503201f 	nop
    400040c4:	d503201f 	nop
    400040c8:	d503201f 	nop
    400040cc:	d503201f 	nop
    400040d0:	d503201f 	nop
    400040d4:	d503201f 	nop
    400040d8:	d503201f 	nop
    400040dc:	d503201f 	nop
    400040e0:	d503201f 	nop
    400040e4:	d503201f 	nop
    400040e8:	d503201f 	nop
    400040ec:	d503201f 	nop
    400040f0:	d503201f 	nop
    400040f4:	d503201f 	nop
    400040f8:	d503201f 	nop
    400040fc:	d503201f 	nop
    SET_VENTRY _el2_cur_sp0_fiq
    40004100:	17fff028 	b	400001a0 <_el2_cur_sp0_fiq>
    40004104:	d503201f 	nop
    40004108:	d503201f 	nop
    4000410c:	d503201f 	nop
    40004110:	d503201f 	nop
    40004114:	d503201f 	nop
    40004118:	d503201f 	nop
    4000411c:	d503201f 	nop
    40004120:	d503201f 	nop
    40004124:	d503201f 	nop
    40004128:	d503201f 	nop
    4000412c:	d503201f 	nop
    40004130:	d503201f 	nop
    40004134:	d503201f 	nop
    40004138:	d503201f 	nop
    4000413c:	d503201f 	nop
    40004140:	d503201f 	nop
    40004144:	d503201f 	nop
    40004148:	d503201f 	nop
    4000414c:	d503201f 	nop
    40004150:	d503201f 	nop
    40004154:	d503201f 	nop
    40004158:	d503201f 	nop
    4000415c:	d503201f 	nop
    40004160:	d503201f 	nop
    40004164:	d503201f 	nop
    40004168:	d503201f 	nop
    4000416c:	d503201f 	nop
    40004170:	d503201f 	nop
    40004174:	d503201f 	nop
    40004178:	d503201f 	nop
    4000417c:	d503201f 	nop
    SET_VENTRY _el2_cur_sp0_serror
    40004180:	17fff02c 	b	40000230 <_el2_cur_sp0_serror>
    40004184:	d503201f 	nop
    40004188:	d503201f 	nop
    4000418c:	d503201f 	nop
    40004190:	d503201f 	nop
    40004194:	d503201f 	nop
    40004198:	d503201f 	nop
    4000419c:	d503201f 	nop
    400041a0:	d503201f 	nop
    400041a4:	d503201f 	nop
    400041a8:	d503201f 	nop
    400041ac:	d503201f 	nop
    400041b0:	d503201f 	nop
    400041b4:	d503201f 	nop
    400041b8:	d503201f 	nop
    400041bc:	d503201f 	nop
    400041c0:	d503201f 	nop
    400041c4:	d503201f 	nop
    400041c8:	d503201f 	nop
    400041cc:	d503201f 	nop
    400041d0:	d503201f 	nop
    400041d4:	d503201f 	nop
    400041d8:	d503201f 	nop
    400041dc:	d503201f 	nop
    400041e0:	d503201f 	nop
    400041e4:	d503201f 	nop
    400041e8:	d503201f 	nop
    400041ec:	d503201f 	nop
    400041f0:	d503201f 	nop
    400041f4:	d503201f 	nop
    400041f8:	d503201f 	nop
    400041fc:	d503201f 	nop
//  4..7: Current EL, SPx 
    SET_VENTRY _el2_cur_spx_sync
    40004200:	17fff030 	b	400002c0 <_el2_cur_spx_sync>
    40004204:	d503201f 	nop
    40004208:	d503201f 	nop
    4000420c:	d503201f 	nop
    40004210:	d503201f 	nop
    40004214:	d503201f 	nop
    40004218:	d503201f 	nop
    4000421c:	d503201f 	nop
    40004220:	d503201f 	nop
    40004224:	d503201f 	nop
    40004228:	d503201f 	nop
    4000422c:	d503201f 	nop
    40004230:	d503201f 	nop
    40004234:	d503201f 	nop
    40004238:	d503201f 	nop
    4000423c:	d503201f 	nop
    40004240:	d503201f 	nop
    40004244:	d503201f 	nop
    40004248:	d503201f 	nop
    4000424c:	d503201f 	nop
    40004250:	d503201f 	nop
    40004254:	d503201f 	nop
    40004258:	d503201f 	nop
    4000425c:	d503201f 	nop
    40004260:	d503201f 	nop
    40004264:	d503201f 	nop
    40004268:	d503201f 	nop
    4000426c:	d503201f 	nop
    40004270:	d503201f 	nop
    40004274:	d503201f 	nop
    40004278:	d503201f 	nop
    4000427c:	d503201f 	nop
    SET_VENTRY _el2_cur_spx_irq
    40004280:	17fff034 	b	40000350 <_el2_cur_spx_irq>
    40004284:	d503201f 	nop
    40004288:	d503201f 	nop
    4000428c:	d503201f 	nop
    40004290:	d503201f 	nop
    40004294:	d503201f 	nop
    40004298:	d503201f 	nop
    4000429c:	d503201f 	nop
    400042a0:	d503201f 	nop
    400042a4:	d503201f 	nop
    400042a8:	d503201f 	nop
    400042ac:	d503201f 	nop
    400042b0:	d503201f 	nop
    400042b4:	d503201f 	nop
    400042b8:	d503201f 	nop
    400042bc:	d503201f 	nop
    400042c0:	d503201f 	nop
    400042c4:	d503201f 	nop
    400042c8:	d503201f 	nop
    400042cc:	d503201f 	nop
    400042d0:	d503201f 	nop
    400042d4:	d503201f 	nop
    400042d8:	d503201f 	nop
    400042dc:	d503201f 	nop
    400042e0:	d503201f 	nop
    400042e4:	d503201f 	nop
    400042e8:	d503201f 	nop
    400042ec:	d503201f 	nop
    400042f0:	d503201f 	nop
    400042f4:	d503201f 	nop
    400042f8:	d503201f 	nop
    400042fc:	d503201f 	nop
    SET_VENTRY _el2_cur_spx_fiq
    40004300:	17fff038 	b	400003e0 <_el2_cur_spx_fiq>
    40004304:	d503201f 	nop
    40004308:	d503201f 	nop
    4000430c:	d503201f 	nop
    40004310:	d503201f 	nop
    40004314:	d503201f 	nop
    40004318:	d503201f 	nop
    4000431c:	d503201f 	nop
    40004320:	d503201f 	nop
    40004324:	d503201f 	nop
    40004328:	d503201f 	nop
    4000432c:	d503201f 	nop
    40004330:	d503201f 	nop
    40004334:	d503201f 	nop
    40004338:	d503201f 	nop
    4000433c:	d503201f 	nop
    40004340:	d503201f 	nop
    40004344:	d503201f 	nop
    40004348:	d503201f 	nop
    4000434c:	d503201f 	nop
    40004350:	d503201f 	nop
    40004354:	d503201f 	nop
    40004358:	d503201f 	nop
    4000435c:	d503201f 	nop
    40004360:	d503201f 	nop
    40004364:	d503201f 	nop
    40004368:	d503201f 	nop
    4000436c:	d503201f 	nop
    40004370:	d503201f 	nop
    40004374:	d503201f 	nop
    40004378:	d503201f 	nop
    4000437c:	d503201f 	nop
    SET_VENTRY _el2_cur_spx_serror
    40004380:	17fff03c 	b	40000470 <_el2_cur_spx_serror>
    40004384:	d503201f 	nop
    40004388:	d503201f 	nop
    4000438c:	d503201f 	nop
    40004390:	d503201f 	nop
    40004394:	d503201f 	nop
    40004398:	d503201f 	nop
    4000439c:	d503201f 	nop
    400043a0:	d503201f 	nop
    400043a4:	d503201f 	nop
    400043a8:	d503201f 	nop
    400043ac:	d503201f 	nop
    400043b0:	d503201f 	nop
    400043b4:	d503201f 	nop
    400043b8:	d503201f 	nop
    400043bc:	d503201f 	nop
    400043c0:	d503201f 	nop
    400043c4:	d503201f 	nop
    400043c8:	d503201f 	nop
    400043cc:	d503201f 	nop
    400043d0:	d503201f 	nop
    400043d4:	d503201f 	nop
    400043d8:	d503201f 	nop
    400043dc:	d503201f 	nop
    400043e0:	d503201f 	nop
    400043e4:	d503201f 	nop
    400043e8:	d503201f 	nop
    400043ec:	d503201f 	nop
    400043f0:	d503201f 	nop
    400043f4:	d503201f 	nop
    400043f8:	d503201f 	nop
    400043fc:	d503201f 	nop
//  8..11: Lower EL, AArch64
    SET_VENTRY _el2_low_a64_sync
    40004400:	17fff040 	b	40000500 <_el2_low_a64_sync>
    40004404:	d503201f 	nop
    40004408:	d503201f 	nop
    4000440c:	d503201f 	nop
    40004410:	d503201f 	nop
    40004414:	d503201f 	nop
    40004418:	d503201f 	nop
    4000441c:	d503201f 	nop
    40004420:	d503201f 	nop
    40004424:	d503201f 	nop
    40004428:	d503201f 	nop
    4000442c:	d503201f 	nop
    40004430:	d503201f 	nop
    40004434:	d503201f 	nop
    40004438:	d503201f 	nop
    4000443c:	d503201f 	nop
    40004440:	d503201f 	nop
    40004444:	d503201f 	nop
    40004448:	d503201f 	nop
    4000444c:	d503201f 	nop
    40004450:	d503201f 	nop
    40004454:	d503201f 	nop
    40004458:	d503201f 	nop
    4000445c:	d503201f 	nop
    40004460:	d503201f 	nop
    40004464:	d503201f 	nop
    40004468:	d503201f 	nop
    4000446c:	d503201f 	nop
    40004470:	d503201f 	nop
    40004474:	d503201f 	nop
    40004478:	d503201f 	nop
    4000447c:	d503201f 	nop
    SET_VENTRY _el2_low_a64_irq
    40004480:	17fff044 	b	40000590 <_el2_low_a64_irq>
    40004484:	d503201f 	nop
    40004488:	d503201f 	nop
    4000448c:	d503201f 	nop
    40004490:	d503201f 	nop
    40004494:	d503201f 	nop
    40004498:	d503201f 	nop
    4000449c:	d503201f 	nop
    400044a0:	d503201f 	nop
    400044a4:	d503201f 	nop
    400044a8:	d503201f 	nop
    400044ac:	d503201f 	nop
    400044b0:	d503201f 	nop
    400044b4:	d503201f 	nop
    400044b8:	d503201f 	nop
    400044bc:	d503201f 	nop
    400044c0:	d503201f 	nop
    400044c4:	d503201f 	nop
    400044c8:	d503201f 	nop
    400044cc:	d503201f 	nop
    400044d0:	d503201f 	nop
    400044d4:	d503201f 	nop
    400044d8:	d503201f 	nop
    400044dc:	d503201f 	nop
    400044e0:	d503201f 	nop
    400044e4:	d503201f 	nop
    400044e8:	d503201f 	nop
    400044ec:	d503201f 	nop
    400044f0:	d503201f 	nop
    400044f4:	d503201f 	nop
    400044f8:	d503201f 	nop
    400044fc:	d503201f 	nop
    SET_VENTRY _el2_low_a64_fiq
    40004500:	17fff048 	b	40000620 <_el2_low_a64_fiq>
    40004504:	d503201f 	nop
    40004508:	d503201f 	nop
    4000450c:	d503201f 	nop
    40004510:	d503201f 	nop
    40004514:	d503201f 	nop
    40004518:	d503201f 	nop
    4000451c:	d503201f 	nop
    40004520:	d503201f 	nop
    40004524:	d503201f 	nop
    40004528:	d503201f 	nop
    4000452c:	d503201f 	nop
    40004530:	d503201f 	nop
    40004534:	d503201f 	nop
    40004538:	d503201f 	nop
    4000453c:	d503201f 	nop
    40004540:	d503201f 	nop
    40004544:	d503201f 	nop
    40004548:	d503201f 	nop
    4000454c:	d503201f 	nop
    40004550:	d503201f 	nop
    40004554:	d503201f 	nop
    40004558:	d503201f 	nop
    4000455c:	d503201f 	nop
    40004560:	d503201f 	nop
    40004564:	d503201f 	nop
    40004568:	d503201f 	nop
    4000456c:	d503201f 	nop
    40004570:	d503201f 	nop
    40004574:	d503201f 	nop
    40004578:	d503201f 	nop
    4000457c:	d503201f 	nop
    SET_VENTRY _el2_low_a64_serror
    40004580:	17fff04c 	b	400006b0 <_el2_low_a64_serror>
    40004584:	d503201f 	nop
    40004588:	d503201f 	nop
    4000458c:	d503201f 	nop
    40004590:	d503201f 	nop
    40004594:	d503201f 	nop
    40004598:	d503201f 	nop
    4000459c:	d503201f 	nop
    400045a0:	d503201f 	nop
    400045a4:	d503201f 	nop
    400045a8:	d503201f 	nop
    400045ac:	d503201f 	nop
    400045b0:	d503201f 	nop
    400045b4:	d503201f 	nop
    400045b8:	d503201f 	nop
    400045bc:	d503201f 	nop
    400045c0:	d503201f 	nop
    400045c4:	d503201f 	nop
    400045c8:	d503201f 	nop
    400045cc:	d503201f 	nop
    400045d0:	d503201f 	nop
    400045d4:	d503201f 	nop
    400045d8:	d503201f 	nop
    400045dc:	d503201f 	nop
    400045e0:	d503201f 	nop
    400045e4:	d503201f 	nop
    400045e8:	d503201f 	nop
    400045ec:	d503201f 	nop
    400045f0:	d503201f 	nop
    400045f4:	d503201f 	nop
    400045f8:	d503201f 	nop
    400045fc:	d503201f 	nop
//  12..15: Lower EL, AArch32 
    SET_VENTRY _el2_low_a32_sync
    40004600:	17fff050 	b	40000740 <_el2_low_a32_sync>
    40004604:	d503201f 	nop
    40004608:	d503201f 	nop
    4000460c:	d503201f 	nop
    40004610:	d503201f 	nop
    40004614:	d503201f 	nop
    40004618:	d503201f 	nop
    4000461c:	d503201f 	nop
    40004620:	d503201f 	nop
    40004624:	d503201f 	nop
    40004628:	d503201f 	nop
    4000462c:	d503201f 	nop
    40004630:	d503201f 	nop
    40004634:	d503201f 	nop
    40004638:	d503201f 	nop
    4000463c:	d503201f 	nop
    40004640:	d503201f 	nop
    40004644:	d503201f 	nop
    40004648:	d503201f 	nop
    4000464c:	d503201f 	nop
    40004650:	d503201f 	nop
    40004654:	d503201f 	nop
    40004658:	d503201f 	nop
    4000465c:	d503201f 	nop
    40004660:	d503201f 	nop
    40004664:	d503201f 	nop
    40004668:	d503201f 	nop
    4000466c:	d503201f 	nop
    40004670:	d503201f 	nop
    40004674:	d503201f 	nop
    40004678:	d503201f 	nop
    4000467c:	d503201f 	nop
    SET_VENTRY _el2_low_a32_irq
    40004680:	17fff054 	b	400007d0 <_el2_low_a32_irq>
    40004684:	d503201f 	nop
    40004688:	d503201f 	nop
    4000468c:	d503201f 	nop
    40004690:	d503201f 	nop
    40004694:	d503201f 	nop
    40004698:	d503201f 	nop
    4000469c:	d503201f 	nop
    400046a0:	d503201f 	nop
    400046a4:	d503201f 	nop
    400046a8:	d503201f 	nop
    400046ac:	d503201f 	nop
    400046b0:	d503201f 	nop
    400046b4:	d503201f 	nop
    400046b8:	d503201f 	nop
    400046bc:	d503201f 	nop
    400046c0:	d503201f 	nop
    400046c4:	d503201f 	nop
    400046c8:	d503201f 	nop
    400046cc:	d503201f 	nop
    400046d0:	d503201f 	nop
    400046d4:	d503201f 	nop
    400046d8:	d503201f 	nop
    400046dc:	d503201f 	nop
    400046e0:	d503201f 	nop
    400046e4:	d503201f 	nop
    400046e8:	d503201f 	nop
    400046ec:	d503201f 	nop
    400046f0:	d503201f 	nop
    400046f4:	d503201f 	nop
    400046f8:	d503201f 	nop
    400046fc:	d503201f 	nop
    SET_VENTRY _el2_low_a32_fiq
    40004700:	17fff058 	b	40000860 <_el2_low_a32_fiq>
    40004704:	d503201f 	nop
    40004708:	d503201f 	nop
    4000470c:	d503201f 	nop
    40004710:	d503201f 	nop
    40004714:	d503201f 	nop
    40004718:	d503201f 	nop
    4000471c:	d503201f 	nop
    40004720:	d503201f 	nop
    40004724:	d503201f 	nop
    40004728:	d503201f 	nop
    4000472c:	d503201f 	nop
    40004730:	d503201f 	nop
    40004734:	d503201f 	nop
    40004738:	d503201f 	nop
    4000473c:	d503201f 	nop
    40004740:	d503201f 	nop
    40004744:	d503201f 	nop
    40004748:	d503201f 	nop
    4000474c:	d503201f 	nop
    40004750:	d503201f 	nop
    40004754:	d503201f 	nop
    40004758:	d503201f 	nop
    4000475c:	d503201f 	nop
    40004760:	d503201f 	nop
    40004764:	d503201f 	nop
    40004768:	d503201f 	nop
    4000476c:	d503201f 	nop
    40004770:	d503201f 	nop
    40004774:	d503201f 	nop
    40004778:	d503201f 	nop
    4000477c:	d503201f 	nop
    SET_VENTRY _el2_low_a32_serror
    40004780:	17fff05c 	b	400008f0 <_el2_low_a32_serror>

Disassembly of section .rodata:

0000000040004790 <STDINT_BASE_REPR_CHARS-0x780>:
    40004790:	696e6150 	ldpsw	x16, x24, [x10, #-144]
    40004794:	656d2063 	fmls	z3.h, p0/m, z3.h, z13.h
    40004798:	67617373 	.inst	0x67617373 ; undefined
    4000479c:	6f6e2065 	umlal2	v5.4s, v3.8h, v14.h[2]
    400047a0:	65642074 	fmls	z20.h, p0/m, z3.h, z4.h
    400047a4:	656e6966 	fnmls	z6.h, p2/m, z11.h, z14.h
    400047a8:	6e612064 	usubl2	v4.4s, v3.8h, v1.8h
    400047ac:	6f6e2064 	umlal2	v4.4s, v3.8h, v14.h[2]
    400047b0:	68632074 	.inst	0x68632074 ; undefined
    400047b4:	65676e61 	fnmls	z1.h, p3/m, z19.h, z7.h
    400047b8:	72662064 	.inst	0x72662064 ; undefined
    400047bc:	69206d6f 	stgp	x15, x27, [x11, #-1024]
    400047c0:	5f74696e 	.inst	0x5f74696e ; undefined
    400047c4:	696e6170 	ldpsw	x16, x24, [x11, #-144]
    400047c8:	20292863 	.inst	0x20292863 ; undefined
    400047cc:	74696e69 	.inst	0x74696e69 ; undefined
    400047d0:	696c6169 	ldpsw	x9, x24, [x11, #-160]
    400047d4:	6974617a 	ldpsw	x26, x24, [x11, #-96]
    400047d8:	73206e6f 	.inst	0x73206e6f ; undefined
    400047dc:	65676174 	fnmls	z20.h, p0/m, z11.h, z7.h
    400047e0:	0000002e 	udf	#46
    400047e4:	00000000 	udf	#0
    400047e8:	696e6150 	ldpsw	x16, x24, [x10, #-144]
    400047ec:	69662063 	ldpsw	x3, x8, [x3, #-208]
    400047f0:	6e20656c 	umax	v12.16b, v11.16b, v0.16b
    400047f4:	6420746f 	.inst	0x6420746f ; undefined
    400047f8:	6e696665 	umax	v5.8h, v19.8h, v9.8h
    400047fc:	00006465 	udf	#25701
    40004800:	505b0d0a 	adr	x10, 400ba9a2 <src+0xb4222>
    40004804:	43494e41 	.inst	0x43494e41 ; undefined
    40004808:	00005d21 	udf	#23841
    4000480c:	00000000 	udf	#0
    40004810:	61500d0a 	.inst	0x61500d0a ; undefined
    40004814:	2063696e 	.inst	0x2063696e ; undefined
    40004818:	7373656d 	.inst	0x7373656d ; undefined
    4000481c:	3a656761 	.inst	0x3a656761 ; undefined
    40004820:	00000009 	udf	#9
    40004824:	00000000 	udf	#0
    40004828:	61500d0a 	.inst	0x61500d0a ; undefined
    4000482c:	2063696e 	.inst	0x2063696e ; undefined
    40004830:	656c6966 	fnmls	z6.h, p2/m, z11.h, z12.h
    40004834:	0000093a 	udf	#2362
    40004838:	20746120 	.inst	0x20746120 ; undefined
    4000483c:	656e696c 	fnmls	z12.h, p2/m, z11.h, z14.h
    40004840:	00000020 	udf	#32
    40004844:	00000000 	udf	#0
    40004848:	0000003a 	udf	#58
    4000484c:	00000000 	udf	#0
    40004850:	78450d0a 	ldrh	w10, [x8, #80]!
    40004854:	74706563 	.inst	0x74706563 ; undefined
    40004858:	736e6f69 	.inst	0x736e6f69 ; undefined
    4000485c:	61747320 	.inst	0x61747320 ; undefined
    40004860:	0a3a6574 	bic	w20, w11, w26, lsl #25
    40004864:	0000000d 	udf	#13
    40004868:	62616e65 	.inst	0x62616e65 ; undefined
    4000486c:	0a64656c 	bic	w12, w11, w4, lsr #25
    40004870:	0000000d 	udf	#13
    40004874:	00000000 	udf	#0
    40004878:	61736964 	.inst	0x61736964 ; undefined
    4000487c:	64656c62 	.inst	0x64656c62 ; undefined
    40004880:	00000d0a 	udf	#3338
    40004884:	00000000 	udf	#0
    40004888:	51494609 	sub	w9, w16, #0x251, lsl #12
    4000488c:	2020203a 	.inst	0x2020203a ; undefined
    40004890:	00000020 	udf	#32
    40004894:	00000000 	udf	#0
    40004898:	51524909 	sub	w9, w8, #0x492, lsl #12
    4000489c:	2020203a 	.inst	0x2020203a ; undefined
    400048a0:	00000020 	udf	#32
    400048a4:	00000000 	udf	#0
    400048a8:	72455309 	.inst	0x72455309 ; undefined
    400048ac:	3a726f72 	.inst	0x3a726f72 ; undefined
    400048b0:	00000020 	udf	#32
    400048b4:	00000000 	udf	#0
    400048b8:	62654409 	.inst	0x62654409 ; undefined
    400048bc:	203a6775 	.inst	0x203a6775 ; undefined
    400048c0:	00000020 	udf	#32
    400048c4:	00000000 	udf	#0
    400048c8:	6c6c6548 	ldnp	d8, d25, [x10, #-320]
    400048cc:	6574206f 	fmls	z15.h, p0/m, z3.h, z20.h
    400048d0:	0a217473 	bic	w19, w3, w1, lsl #29
    400048d4:	0000000d 	udf	#13
    400048d8:	203a4449 	.inst	0x203a4449 ; undefined
    400048dc:	00000000 	udf	#0
    400048e0:	00000d0a 	udf	#3338
    400048e4:	00000000 	udf	#0
    400048e8:	20324c45 	.inst	0x20324c45 ; undefined
    400048ec:	45435845 	usubwb	z5.h, z2.h, z3.b
    400048f0:	4f495450 	shl	v16.2d, v2.2d, #9
    400048f4:	6c20214e 	stnp	d14, d8, [x10, #-512]
    400048f8:	615f776f 	.inst	0x615f776f ; undefined
    400048fc:	735f3233 	.inst	0x735f3233 ; undefined
    40004900:	6f727265 	fcmla	v5.8h, v19.8h, v18.h[1], #270
    40004904:	00000072 	udf	#114
    40004908:	6372735f 	.inst	0x6372735f ; undefined
    4000490c:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004910:	6378652f 	.inst	0x6378652f ; undefined
    40004914:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004918:	2f736e6f 	.inst	0x2f736e6f ; undefined
    4000491c:	646e6168 	.inst	0x646e6168 ; undefined
    40004920:	7372656c 	.inst	0x7372656c ; undefined
    40004924:	326c652f 	.inst	0x326c652f ; undefined
    40004928:	326c652f 	.inst	0x326c652f ; undefined
    4000492c:	776f6c5f 	.inst	0x776f6c5f ; undefined
    40004930:	3233615f 	orr	wsp, w10, #0xffffe03f
    40004934:	7265735f 	.inst	0x7265735f ; undefined
    40004938:	2e726f72 	umin	v18.4h, v27.4h, v18.4h
    4000493c:	00000063 	udf	#99
    40004940:	20324c45 	.inst	0x20324c45 ; undefined
    40004944:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004948:	4f495450 	shl	v16.2d, v2.2d, #9
    4000494c:	6320214e 	.inst	0x6320214e ; undefined
    40004950:	735f7275 	.inst	0x735f7275 ; undefined
    40004954:	735f7870 	.inst	0x735f7870 ; undefined
    40004958:	6f727265 	fcmla	v5.8h, v19.8h, v18.h[1], #270
    4000495c:	00000072 	udf	#114
    40004960:	6372735f 	.inst	0x6372735f ; undefined
    40004964:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004968:	6378652f 	.inst	0x6378652f ; undefined
    4000496c:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004970:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004974:	646e6168 	.inst	0x646e6168 ; undefined
    40004978:	7372656c 	.inst	0x7372656c ; undefined
    4000497c:	326c652f 	.inst	0x326c652f ; undefined
    40004980:	326c652f 	.inst	0x326c652f ; undefined
    40004984:	7275635f 	.inst	0x7275635f ; undefined
    40004988:	7870735f 	stuminlh	w16, [x26]
    4000498c:	7265735f 	.inst	0x7265735f ; undefined
    40004990:	2e726f72 	umin	v18.4h, v27.4h, v18.4h
    40004994:	00000063 	udf	#99
    40004998:	20324c45 	.inst	0x20324c45 ; undefined
    4000499c:	45435845 	usubwb	z5.h, z2.h, z3.b
    400049a0:	4f495450 	shl	v16.2d, v2.2d, #9
    400049a4:	6c20214e 	stnp	d14, d8, [x10, #-512]
    400049a8:	615f776f 	.inst	0x615f776f ; undefined
    400049ac:	735f3436 	.inst	0x735f3436 ; undefined
    400049b0:	6f727265 	fcmla	v5.8h, v19.8h, v18.h[1], #270
    400049b4:	00000072 	udf	#114
    400049b8:	6372735f 	.inst	0x6372735f ; undefined
    400049bc:	6d72612f 	ldp	d15, d24, [x9, #-224]
    400049c0:	6378652f 	.inst	0x6378652f ; undefined
    400049c4:	69747065 	ldpsw	x5, x28, [x3, #-96]
    400049c8:	2f736e6f 	.inst	0x2f736e6f ; undefined
    400049cc:	646e6168 	.inst	0x646e6168 ; undefined
    400049d0:	7372656c 	.inst	0x7372656c ; undefined
    400049d4:	326c652f 	.inst	0x326c652f ; undefined
    400049d8:	326c652f 	.inst	0x326c652f ; undefined
    400049dc:	776f6c5f 	.inst	0x776f6c5f ; undefined
    400049e0:	3436615f 	cbz	wzr, 40071608 <src+0x6ae88>
    400049e4:	7265735f 	.inst	0x7265735f ; undefined
    400049e8:	2e726f72 	umin	v18.4h, v27.4h, v18.4h
    400049ec:	00000063 	udf	#99
    400049f0:	20324c45 	.inst	0x20324c45 ; undefined
    400049f4:	45435845 	usubwb	z5.h, z2.h, z3.b
    400049f8:	4f495450 	shl	v16.2d, v2.2d, #9
    400049fc:	6c20214e 	stnp	d14, d8, [x10, #-512]
    40004a00:	615f776f 	.inst	0x615f776f ; undefined
    40004a04:	735f3436 	.inst	0x735f3436 ; undefined
    40004a08:	00636e79 	.inst	0x00636e79 ; undefined
    40004a0c:	00000000 	udf	#0
    40004a10:	6372735f 	.inst	0x6372735f ; undefined
    40004a14:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004a18:	6378652f 	.inst	0x6378652f ; undefined
    40004a1c:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004a20:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004a24:	646e6168 	.inst	0x646e6168 ; undefined
    40004a28:	7372656c 	.inst	0x7372656c ; undefined
    40004a2c:	326c652f 	.inst	0x326c652f ; undefined
    40004a30:	326c652f 	.inst	0x326c652f ; undefined
    40004a34:	776f6c5f 	.inst	0x776f6c5f ; undefined
    40004a38:	3436615f 	cbz	wzr, 40071660 <src+0x6aee0>
    40004a3c:	6e79735f 	uabdl2	v31.4s, v26.8h, v25.8h
    40004a40:	00632e63 	.inst	0x00632e63 ; undefined
    40004a44:	00000000 	udf	#0
    40004a48:	20324c45 	.inst	0x20324c45 ; undefined
    40004a4c:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004a50:	4f495450 	shl	v16.2d, v2.2d, #9
    40004a54:	6320214e 	.inst	0x6320214e ; undefined
    40004a58:	735f7275 	.inst	0x735f7275 ; undefined
    40004a5c:	695f3070 	ldpsw	x16, x12, [x3, #248]
    40004a60:	00007172 	udf	#29042
    40004a64:	00000000 	udf	#0
    40004a68:	6372735f 	.inst	0x6372735f ; undefined
    40004a6c:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004a70:	6378652f 	.inst	0x6378652f ; undefined
    40004a74:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004a78:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004a7c:	646e6168 	.inst	0x646e6168 ; undefined
    40004a80:	7372656c 	.inst	0x7372656c ; undefined
    40004a84:	326c652f 	.inst	0x326c652f ; undefined
    40004a88:	326c652f 	.inst	0x326c652f ; undefined
    40004a8c:	7275635f 	.inst	0x7275635f ; undefined
    40004a90:	3070735f 	adr	xzr, 400e58f9 <src+0xdf179>
    40004a94:	7172695f 	cmp	w10, #0xc9a, lsl #12
    40004a98:	0000632e 	udf	#25390
    40004a9c:	00000000 	udf	#0
    40004aa0:	20324c45 	.inst	0x20324c45 ; undefined
    40004aa4:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004aa8:	4f495450 	shl	v16.2d, v2.2d, #9
    40004aac:	6320214e 	.inst	0x6320214e ; undefined
    40004ab0:	735f7275 	.inst	0x735f7275 ; undefined
    40004ab4:	735f3070 	.inst	0x735f3070 ; undefined
    40004ab8:	6f727265 	fcmla	v5.8h, v19.8h, v18.h[1], #270
    40004abc:	00000072 	udf	#114
    40004ac0:	6372735f 	.inst	0x6372735f ; undefined
    40004ac4:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004ac8:	6378652f 	.inst	0x6378652f ; undefined
    40004acc:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004ad0:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004ad4:	646e6168 	.inst	0x646e6168 ; undefined
    40004ad8:	7372656c 	.inst	0x7372656c ; undefined
    40004adc:	326c652f 	.inst	0x326c652f ; undefined
    40004ae0:	326c652f 	.inst	0x326c652f ; undefined
    40004ae4:	7275635f 	.inst	0x7275635f ; undefined
    40004ae8:	3070735f 	adr	xzr, 400e5951 <src+0xdf1d1>
    40004aec:	7265735f 	.inst	0x7265735f ; undefined
    40004af0:	2e726f72 	umin	v18.4h, v27.4h, v18.4h
    40004af4:	00000063 	udf	#99
    40004af8:	20324c45 	.inst	0x20324c45 ; undefined
    40004afc:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004b00:	4f495450 	shl	v16.2d, v2.2d, #9
    40004b04:	6c20214e 	stnp	d14, d8, [x10, #-512]
    40004b08:	615f776f 	.inst	0x615f776f ; undefined
    40004b0c:	695f3436 	ldpsw	x22, x13, [x1, #248]
    40004b10:	00007172 	udf	#29042
    40004b14:	00000000 	udf	#0
    40004b18:	6372735f 	.inst	0x6372735f ; undefined
    40004b1c:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004b20:	6378652f 	.inst	0x6378652f ; undefined
    40004b24:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004b28:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004b2c:	646e6168 	.inst	0x646e6168 ; undefined
    40004b30:	7372656c 	.inst	0x7372656c ; undefined
    40004b34:	326c652f 	.inst	0x326c652f ; undefined
    40004b38:	326c652f 	.inst	0x326c652f ; undefined
    40004b3c:	776f6c5f 	.inst	0x776f6c5f ; undefined
    40004b40:	3436615f 	cbz	wzr, 40071768 <src+0x6afe8>
    40004b44:	7172695f 	cmp	w10, #0xc9a, lsl #12
    40004b48:	0000632e 	udf	#25390
    40004b4c:	00000000 	udf	#0
    40004b50:	20324c45 	.inst	0x20324c45 ; undefined
    40004b54:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004b58:	4f495450 	shl	v16.2d, v2.2d, #9
    40004b5c:	6c20214e 	stnp	d14, d8, [x10, #-512]
    40004b60:	615f776f 	.inst	0x615f776f ; undefined
    40004b64:	665f3436 	.inst	0x665f3436 ; undefined
    40004b68:	00007169 	udf	#29033
    40004b6c:	00000000 	udf	#0
    40004b70:	6372735f 	.inst	0x6372735f ; undefined
    40004b74:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004b78:	6378652f 	.inst	0x6378652f ; undefined
    40004b7c:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004b80:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004b84:	646e6168 	.inst	0x646e6168 ; undefined
    40004b88:	7372656c 	.inst	0x7372656c ; undefined
    40004b8c:	326c652f 	.inst	0x326c652f ; undefined
    40004b90:	326c652f 	.inst	0x326c652f ; undefined
    40004b94:	776f6c5f 	.inst	0x776f6c5f ; undefined
    40004b98:	3436615f 	cbz	wzr, 400717c0 <src+0x6b040>
    40004b9c:	7169665f 	cmp	w18, #0xa59, lsl #12
    40004ba0:	0000632e 	udf	#25390
    40004ba4:	00000000 	udf	#0
    40004ba8:	20324c45 	.inst	0x20324c45 ; undefined
    40004bac:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004bb0:	4f495450 	shl	v16.2d, v2.2d, #9
    40004bb4:	6320214e 	.inst	0x6320214e ; undefined
    40004bb8:	735f7275 	.inst	0x735f7275 ; undefined
    40004bbc:	665f7870 	.inst	0x665f7870 ; undefined
    40004bc0:	00007169 	udf	#29033
    40004bc4:	00000000 	udf	#0
    40004bc8:	6372735f 	.inst	0x6372735f ; undefined
    40004bcc:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004bd0:	6378652f 	.inst	0x6378652f ; undefined
    40004bd4:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004bd8:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004bdc:	646e6168 	.inst	0x646e6168 ; undefined
    40004be0:	7372656c 	.inst	0x7372656c ; undefined
    40004be4:	326c652f 	.inst	0x326c652f ; undefined
    40004be8:	326c652f 	.inst	0x326c652f ; undefined
    40004bec:	7275635f 	.inst	0x7275635f ; undefined
    40004bf0:	7870735f 	stuminlh	w16, [x26]
    40004bf4:	7169665f 	cmp	w18, #0xa59, lsl #12
    40004bf8:	0000632e 	udf	#25390
    40004bfc:	00000000 	udf	#0
    40004c00:	20324c45 	.inst	0x20324c45 ; undefined
    40004c04:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004c08:	4f495450 	shl	v16.2d, v2.2d, #9
    40004c0c:	6c20214e 	stnp	d14, d8, [x10, #-512]
    40004c10:	615f776f 	.inst	0x615f776f ; undefined
    40004c14:	695f3233 	ldpsw	x19, x12, [x17, #248]
    40004c18:	00007172 	udf	#29042
    40004c1c:	00000000 	udf	#0
    40004c20:	6372735f 	.inst	0x6372735f ; undefined
    40004c24:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004c28:	6378652f 	.inst	0x6378652f ; undefined
    40004c2c:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004c30:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004c34:	646e6168 	.inst	0x646e6168 ; undefined
    40004c38:	7372656c 	.inst	0x7372656c ; undefined
    40004c3c:	326c652f 	.inst	0x326c652f ; undefined
    40004c40:	326c652f 	.inst	0x326c652f ; undefined
    40004c44:	776f6c5f 	.inst	0x776f6c5f ; undefined
    40004c48:	3233615f 	orr	wsp, w10, #0xffffe03f
    40004c4c:	7172695f 	cmp	w10, #0xc9a, lsl #12
    40004c50:	0000632e 	udf	#25390
    40004c54:	00000000 	udf	#0
    40004c58:	20324c45 	.inst	0x20324c45 ; undefined
    40004c5c:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004c60:	4f495450 	shl	v16.2d, v2.2d, #9
    40004c64:	6320214e 	.inst	0x6320214e ; undefined
    40004c68:	735f7275 	.inst	0x735f7275 ; undefined
    40004c6c:	665f3070 	.inst	0x665f3070 ; undefined
    40004c70:	00007169 	udf	#29033
    40004c74:	00000000 	udf	#0
    40004c78:	6372735f 	.inst	0x6372735f ; undefined
    40004c7c:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004c80:	6378652f 	.inst	0x6378652f ; undefined
    40004c84:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004c88:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004c8c:	646e6168 	.inst	0x646e6168 ; undefined
    40004c90:	7372656c 	.inst	0x7372656c ; undefined
    40004c94:	326c652f 	.inst	0x326c652f ; undefined
    40004c98:	326c652f 	.inst	0x326c652f ; undefined
    40004c9c:	7275635f 	.inst	0x7275635f ; undefined
    40004ca0:	3070735f 	adr	xzr, 400e5b09 <src+0xdf389>
    40004ca4:	7169665f 	cmp	w18, #0xa59, lsl #12
    40004ca8:	0000632e 	udf	#25390
    40004cac:	00000000 	udf	#0
    40004cb0:	20324c45 	.inst	0x20324c45 ; undefined
    40004cb4:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004cb8:	4f495450 	shl	v16.2d, v2.2d, #9
    40004cbc:	6c20214e 	stnp	d14, d8, [x10, #-512]
    40004cc0:	615f776f 	.inst	0x615f776f ; undefined
    40004cc4:	665f3233 	.inst	0x665f3233 ; undefined
    40004cc8:	00007169 	udf	#29033
    40004ccc:	00000000 	udf	#0
    40004cd0:	6372735f 	.inst	0x6372735f ; undefined
    40004cd4:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004cd8:	6378652f 	.inst	0x6378652f ; undefined
    40004cdc:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004ce0:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004ce4:	646e6168 	.inst	0x646e6168 ; undefined
    40004ce8:	7372656c 	.inst	0x7372656c ; undefined
    40004cec:	326c652f 	.inst	0x326c652f ; undefined
    40004cf0:	326c652f 	.inst	0x326c652f ; undefined
    40004cf4:	776f6c5f 	.inst	0x776f6c5f ; undefined
    40004cf8:	3233615f 	orr	wsp, w10, #0xffffe03f
    40004cfc:	7169665f 	cmp	w18, #0xa59, lsl #12
    40004d00:	0000632e 	udf	#25390
    40004d04:	00000000 	udf	#0
    40004d08:	20324c45 	.inst	0x20324c45 ; undefined
    40004d0c:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004d10:	4f495450 	shl	v16.2d, v2.2d, #9
    40004d14:	6320214e 	.inst	0x6320214e ; undefined
    40004d18:	735f7275 	.inst	0x735f7275 ; undefined
    40004d1c:	735f7870 	.inst	0x735f7870 ; undefined
    40004d20:	00636e79 	.inst	0x00636e79 ; undefined
    40004d24:	00000000 	udf	#0
    40004d28:	6372735f 	.inst	0x6372735f ; undefined
    40004d2c:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004d30:	6378652f 	.inst	0x6378652f ; undefined
    40004d34:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004d38:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004d3c:	646e6168 	.inst	0x646e6168 ; undefined
    40004d40:	7372656c 	.inst	0x7372656c ; undefined
    40004d44:	326c652f 	.inst	0x326c652f ; undefined
    40004d48:	326c652f 	.inst	0x326c652f ; undefined
    40004d4c:	7275635f 	.inst	0x7275635f ; undefined
    40004d50:	7870735f 	stuminlh	w16, [x26]
    40004d54:	6e79735f 	uabdl2	v31.4s, v26.8h, v25.8h
    40004d58:	00632e63 	.inst	0x00632e63 ; undefined
    40004d5c:	00000000 	udf	#0
    40004d60:	20324c45 	.inst	0x20324c45 ; undefined
    40004d64:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004d68:	4f495450 	shl	v16.2d, v2.2d, #9
    40004d6c:	6c20214e 	stnp	d14, d8, [x10, #-512]
    40004d70:	615f776f 	.inst	0x615f776f ; undefined
    40004d74:	735f3233 	.inst	0x735f3233 ; undefined
    40004d78:	00636e79 	.inst	0x00636e79 ; undefined
    40004d7c:	00000000 	udf	#0
    40004d80:	6372735f 	.inst	0x6372735f ; undefined
    40004d84:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004d88:	6378652f 	.inst	0x6378652f ; undefined
    40004d8c:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004d90:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004d94:	646e6168 	.inst	0x646e6168 ; undefined
    40004d98:	7372656c 	.inst	0x7372656c ; undefined
    40004d9c:	326c652f 	.inst	0x326c652f ; undefined
    40004da0:	326c652f 	.inst	0x326c652f ; undefined
    40004da4:	776f6c5f 	.inst	0x776f6c5f ; undefined
    40004da8:	3233615f 	orr	wsp, w10, #0xffffe03f
    40004dac:	6e79735f 	uabdl2	v31.4s, v26.8h, v25.8h
    40004db0:	00632e63 	.inst	0x00632e63 ; undefined
    40004db4:	00000000 	udf	#0
    40004db8:	20324c45 	.inst	0x20324c45 ; undefined
    40004dbc:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004dc0:	4f495450 	shl	v16.2d, v2.2d, #9
    40004dc4:	6320214e 	.inst	0x6320214e ; undefined
    40004dc8:	735f7275 	.inst	0x735f7275 ; undefined
    40004dcc:	735f3070 	.inst	0x735f3070 ; undefined
    40004dd0:	00636e79 	.inst	0x00636e79 ; undefined
    40004dd4:	00000000 	udf	#0
    40004dd8:	6372735f 	.inst	0x6372735f ; undefined
    40004ddc:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004de0:	6378652f 	.inst	0x6378652f ; undefined
    40004de4:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004de8:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004dec:	646e6168 	.inst	0x646e6168 ; undefined
    40004df0:	7372656c 	.inst	0x7372656c ; undefined
    40004df4:	326c652f 	.inst	0x326c652f ; undefined
    40004df8:	326c652f 	.inst	0x326c652f ; undefined
    40004dfc:	7275635f 	.inst	0x7275635f ; undefined
    40004e00:	3070735f 	adr	xzr, 400e5c69 <src+0xdf4e9>
    40004e04:	6e79735f 	uabdl2	v31.4s, v26.8h, v25.8h
    40004e08:	00632e63 	.inst	0x00632e63 ; undefined
    40004e0c:	00000000 	udf	#0
    40004e10:	20324c45 	.inst	0x20324c45 ; undefined
    40004e14:	45435845 	usubwb	z5.h, z2.h, z3.b
    40004e18:	4f495450 	shl	v16.2d, v2.2d, #9
    40004e1c:	6320214e 	.inst	0x6320214e ; undefined
    40004e20:	735f7275 	.inst	0x735f7275 ; undefined
    40004e24:	695f7870 	ldpsw	x16, x30, [x3, #248]
    40004e28:	00007172 	udf	#29042
    40004e2c:	00000000 	udf	#0
    40004e30:	6372735f 	.inst	0x6372735f ; undefined
    40004e34:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004e38:	6378652f 	.inst	0x6378652f ; undefined
    40004e3c:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004e40:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004e44:	646e6168 	.inst	0x646e6168 ; undefined
    40004e48:	7372656c 	.inst	0x7372656c ; undefined
    40004e4c:	326c652f 	.inst	0x326c652f ; undefined
    40004e50:	326c652f 	.inst	0x326c652f ; undefined
    40004e54:	7275635f 	.inst	0x7275635f ; undefined
    40004e58:	7870735f 	stuminlh	w16, [x26]
    40004e5c:	7172695f 	cmp	w10, #0xc9a, lsl #12
    40004e60:	0000632e 	udf	#25390
    40004e64:	00000000 	udf	#0
    40004e68:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
    40004e6c:	6f697470 	uqshl	v16.2d, v3.2d, #41
    40004e70:	735f736e 	.inst	0x735f736e ; undefined
    40004e74:	735f7465 	.inst	0x735f7465 ; undefined
    40004e78:	75746174 	.inst	0x75746174 ; undefined
    40004e7c:	72652073 	.inst	0x72652073 ; undefined
    40004e80:	00726f72 	.inst	0x00726f72 ; undefined
    40004e84:	00000000 	udf	#0
    40004e88:	6372735f 	.inst	0x6372735f ; undefined
    40004e8c:	6d72612f 	ldp	d15, d24, [x9, #-224]
    40004e90:	6378652f 	.inst	0x6378652f ; undefined
    40004e94:	69747065 	ldpsw	x5, x28, [x3, #-96]
    40004e98:	2f736e6f 	.inst	0x2f736e6f ; undefined
    40004e9c:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
    40004ea0:	6f697470 	uqshl	v16.2d, v3.2d, #41
    40004ea4:	632e736e 	.inst	0x632e736e ; undefined
	...
    40004eb0:	746e6975 	.inst	0x746e6975 ; undefined
    40004eb4:	6f745f38 	.inst	0x6f745f38 ; undefined
    40004eb8:	6373615f 	.inst	0x6373615f ; undefined
    40004ebc:	635f6969 	.inst	0x635f6969 ; undefined
    40004ec0:	3a726168 	.inst	0x3a726168 ; undefined
    40004ec4:	71657220 	subs	w0, w17, #0x95c, lsl #12
    40004ec8:	65726975 	fnmls	z21.h, p2/m, z11.h, z18.h
    40004ecc:	68742073 	.inst	0x68742073 ; undefined
    40004ed0:	6e692065 	usubl2	v5.4s, v3.8h, v9.8h
    40004ed4:	20747570 	.inst	0x20747570 ; undefined
    40004ed8:	626d756e 	.inst	0x626d756e ; undefined
    40004edc:	74207265 	.inst	0x74207265 ; undefined
    40004ee0:	6562206f 	fmls	z15.h, p0/m, z3.h, z2.h
    40004ee4:	74656220 	.inst	0x74656220 ; undefined
    40004ee8:	6e656577 	umax	v23.8h, v11.8h, v5.8h
    40004eec:	61203020 	.inst	0x61203020 ; undefined
    40004ef0:	3920646e 	strb	w14, [x3, #2073]
    40004ef4:	00000000 	udf	#0
    40004ef8:	6372735f 	.inst	0x6372735f ; undefined
    40004efc:	62696c2f 	.inst	0x62696c2f ; undefined
    40004f00:	7274732f 	.inst	0x7274732f ; undefined
    40004f04:	2e676e69 	umin	v9.4h, v19.4h, v7.4h
    40004f08:	00000063 	udf	#99
    40004f0c:	00000000 	udf	#0

0000000040004f10 <STDINT_BASE_REPR_CHARS>:
static const uint8 STDINT_BASE_REPR_CHARS[16] = {
    40004f10:	33323130 	.inst	0x33323130 ; undefined
    40004f14:	37363534 	tbnz	w20, #6, 400015b8 <el2_cur_sp0_fiq_handler+0xc>
    40004f18:	42413938 	.inst	0x42413938 ; undefined
    40004f1c:	46454443 	.inst	0x46454443 ; undefined
    40004f20:	78656e55 	.inst	0x78656e55 ; undefined
    40004f24:	74636570 	.inst	0x74636570 ; undefined
    40004f28:	76206465 	.inst	0x76206465 ; undefined
    40004f2c:	65756c61 	fnmls	z1.h, p3/m, z3.h, z21.h
    40004f30:	20666f20 	.inst	0x20666f20 ; undefined
    40004f34:	72706572 	.inst	0x72706572 ; undefined
	...
    40004f40:	69647473 	ldpsw	x19, x29, [x3, #-224]
    40004f44:	745f746e 	.inst	0x745f746e ; undefined
    40004f48:	73615f6f 	.inst	0x73615f6f ; undefined
    40004f4c:	3a696963 	.inst	0x3a696963 ; undefined
    40004f50:	44545320 	smlslb	z0.h, z25.b, z20.b
    40004f54:	5f544e49 	.inst	0x5f544e49 ; undefined
    40004f58:	45505954 	usubwb	z20.h, z10.h, z16.b
    40004f5c:	61632053 	.inst	0x61632053 ; undefined
    40004f60:	6e206573 	umax	v19.16b, v11.16b, v0.16b
    40004f64:	7320746f 	.inst	0x7320746f ; undefined
    40004f68:	6f707075 	fcmla	v21.8h, v3.8h, v16.h[1], #270
    40004f6c:	64657472 	.inst	0x64657472 ; undefined
	...
    40004f78:	69647473 	ldpsw	x19, x29, [x3, #-224]
    40004f7c:	745f746e 	.inst	0x745f746e ; undefined
    40004f80:	73615f6f 	.inst	0x73615f6f ; undefined
    40004f84:	3a696963 	.inst	0x3a696963 ; undefined
    40004f88:	6f727020 	fcmla	v0.8h, v1.8h, v18.h[1], #270
    40004f8c:	65646976 	fnmls	z22.h, p2/m, z11.h, z4.h
    40004f90:	75622064 	.inst	0x75622064 ; undefined
    40004f94:	72656666 	.inst	0x72656666 ; undefined
    40004f98:	20736920 	.inst	0x20736920 ; undefined
    40004f9c:	6c616d73 	ldnp	d19, d27, [x11, #-496]
    40004fa0:	2072656c 	.inst	0x2072656c ; undefined
    40004fa4:	6e616874 	fcvtxn2	v20.4s, v3.2d
    40004fa8:	71657220 	subs	w0, w17, #0x95c, lsl #12
    40004fac:	64656975 	.inst	0x64656975 ; undefined
    40004fb0:	726f6620 	.inst	0x726f6620 ; undefined
    40004fb4:	6f727020 	fcmla	v0.8h, v1.8h, v18.h[1], #270
    40004fb8:	65646976 	fnmls	z22.h, p2/m, z11.h, z4.h
    40004fbc:	74732064 	.inst	0x74732064 ; undefined
    40004fc0:	746e6964 	.inst	0x746e6964 ; undefined
    40004fc4:	00000000 	udf	#0
    40004fc8:	636d656d 	.inst	0x636d656d ; undefined
    40004fcc:	34367970 	cbz	w16, 40071ef8 <src+0x6b778>
    40004fd0:	696c615f 	ldpsw	xzr, x24, [x10, #-160]
    40004fd4:	64656e67 	.inst	0x64656e67 ; undefined
    40004fd8:	7364203a 	.inst	0x7364203a ; undefined
    40004fdc:	6f6e2074 	umlal2	v20.4s, v3.8h, v14.h[2]
    40004fe0:	6c612074 	ldnp	d20, d8, [x3, #-496]
    40004fe4:	656e6769 	fnmls	z9.h, p1/m, z27.h, z14.h
    40004fe8:	6f742064 	umlal2	v4.4s, v3.8h, v4.h[3]
    40004fec:	20363120 	.inst	0x20363120 ; undefined
    40004ff0:	65747962 	fnmls	z2.h, p6/m, z11.h, z20.h
    40004ff4:	00000073 	udf	#115
    40004ff8:	6372735f 	.inst	0x6372735f ; undefined
    40004ffc:	62696c2f 	.inst	0x62696c2f ; undefined
    40005000:	6d656d2f 	ldp	d15, d27, [x9, #-432]
    40005004:	2f797063 	fcmla	v3.4h, v3.4h, v25.h[1], #270
    40005008:	636d656d 	.inst	0x636d656d ; undefined
    4000500c:	632e7970 	.inst	0x632e7970 ; undefined
	...
    40005018:	636d656d 	.inst	0x636d656d ; undefined
    4000501c:	34367970 	cbz	w16, 40071f48 <src+0x6b7c8>
    40005020:	696c615f 	ldpsw	xzr, x24, [x10, #-160]
    40005024:	64656e67 	.inst	0x64656e67 ; undefined
    40005028:	7273203a 	.inst	0x7273203a ; undefined
    4000502c:	6f6e2063 	umlal2	v3.4s, v3.8h, v14.h[2]
    40005030:	6c612074 	ldnp	d20, d8, [x3, #-496]
    40005034:	656e6769 	fnmls	z9.h, p1/m, z27.h, z14.h
    40005038:	6f742064 	umlal2	v4.4s, v3.8h, v4.h[3]
    4000503c:	20363120 	.inst	0x20363120 ; undefined
    40005040:	65747962 	fnmls	z2.h, p6/m, z11.h, z20.h
    40005044:	00000073 	udf	#115
    40005048:	636d656d 	.inst	0x636d656d ; undefined
    4000504c:	34367970 	cbz	w16, 40071f78 <src+0x6b7f8>
    40005050:	696c615f 	ldpsw	xzr, x24, [x10, #-160]
    40005054:	64656e67 	.inst	0x64656e67 ; undefined
    40005058:	6973203a 	ldpsw	x26, x8, [x1, #-104]
    4000505c:	6920657a 	stgp	x26, x25, [x11, #-1024]
    40005060:	6f6e2073 	umlal2	v19.4s, v3.8h, v14.h[2]
    40005064:	20612074 	.inst	0x20612074 ; undefined
    40005068:	746c756d 	.inst	0x746c756d ; undefined
    4000506c:	656c7069 	fnmls	z9.h, p4/m, z3.h, z12.h
    40005070:	20666f20 	.inst	0x20666f20 ; undefined
    40005074:	00003436 	udf	#13366
    40005078:	636d656d 	.inst	0x636d656d ; undefined
    4000507c:	34367970 	cbz	w16, 40071fa8 <src+0x6b828>
    40005080:	6973203a 	ldpsw	x26, x8, [x1, #-104]
    40005084:	6920657a 	stgp	x26, x25, [x11, #-1024]
    40005088:	6f6e2073 	umlal2	v19.4s, v3.8h, v14.h[2]
    4000508c:	20612074 	.inst	0x20612074 ; undefined
    40005090:	746c756d 	.inst	0x746c756d ; undefined
    40005094:	656c7069 	fnmls	z9.h, p4/m, z3.h, z12.h
    40005098:	20666f20 	.inst	0x20666f20 ; undefined
    4000509c:	00003436 	udf	#13366
    400050a0:	656d6f53 	fnmls	z19.h, p3/m, z26.h, z13.h
    400050a4:	6e696874 	.inst	0x6e696874 ; undefined
    400050a8:	65772067 	fmls	z7.h, p0/m, z3.h, z23.h
    400050ac:	7720746e 	.inst	0x7720746e ; undefined
    400050b0:	676e6f72 	.inst	0x676e6f72 ; undefined
    400050b4:	00000000 	udf	#0
    400050b8:	00203a69 	.inst	0x00203a69 ; NYI
    400050bc:	00000000 	udf	#0
    400050c0:	0a6b6f20 	bic	w0, w25, w11, lsr #27
    400050c4:	0000000d 	udf	#13
    400050c8:	494e4946 	.inst	0x494e4946 ; undefined
    400050cc:	44454853 	umlalb	z19.h, z2.b, z5.b
    400050d0:	74697720 	.inst	0x74697720 ; undefined
    400050d4:	74756f68 	.inst	0x74756f68 ; undefined
    400050d8:	6e616820 	fcvtxn2	v0.4s, v1.2d
    400050dc:	00000067 	udf	#103
    400050e0:	44434947 	umlalb	z7.h, z10.b, z3.b
    400050e4:	5247495f 	.inst	0x5247495f ; undefined
    400050e8:	5250554f 	.inst	0x5250554f ; undefined
    400050ec:	6962203a 	ldpsw	x26, x8, [x1, #-240]
    400050f0:	6e692074 	usubl2	v20.4s, v3.8h, v9.8h
    400050f4:	20786564 	.inst	0x20786564 ; undefined
    400050f8:	7473756d 	.inst	0x7473756d ; undefined
    400050fc:	20656220 	.inst	0x20656220 ; undefined
    40005100:	33203d3c 	.inst	0x33203d3c ; undefined
    40005104:	00000031 	udf	#49
    40005108:	636e695f 	.inst	0x636e695f ; undefined
    4000510c:	6564756c 	fnmls	z12.h, p5/m, z11.h, z4.h
    40005110:	6972642f 	ldpsw	x15, x25, [x1, #-112]
    40005114:	73726576 	.inst	0x73726576 ; undefined
    40005118:	746e692f 	.inst	0x746e692f ; undefined
    4000511c:	75727265 	.inst	0x75727265 ; undefined
    40005120:	2f737470 	.inst	0x2f737470 ; undefined
    40005124:	76636967 	.inst	0x76636967 ; undefined
    40005128:	69672f33 	ldpsw	x19, x11, [x25, #-200]
    4000512c:	5f337663 	sqshl	s3, s19, #19
    40005130:	2f776172 	umlsl	v18.4s, v11.4h, v7.h[3]
    40005134:	64636967 	.inst	0x64636967 ; undefined
    40005138:	7267695f 	.inst	0x7267695f ; undefined
    4000513c:	7270756f 	.inst	0x7270756f ; undefined
    40005140:	0000682e 	udf	#26670
    40005144:	00000000 	udf	#0
    40005148:	44434947 	umlalb	z7.h, z10.b, z3.b
    4000514c:	4643495f 	.inst	0x4643495f ; undefined
    40005150:	203a5247 	.inst	0x203a5247 ; undefined
    40005154:	746f6c73 	.inst	0x746f6c73 ; undefined
    40005158:	73756d20 	.inst	0x73756d20 ; undefined
    4000515c:	65622074 	fmls	z20.h, p0/m, z3.h, z2.h
    40005160:	203d3c20 	.inst	0x203d3c20 ; undefined
    40005164:	00003531 	udf	#13617
    40005168:	636e695f 	.inst	0x636e695f ; undefined
    4000516c:	6564756c 	fnmls	z12.h, p5/m, z11.h, z4.h
    40005170:	6972642f 	ldpsw	x15, x25, [x1, #-112]
    40005174:	73726576 	.inst	0x73726576 ; undefined
    40005178:	746e692f 	.inst	0x746e692f ; undefined
    4000517c:	75727265 	.inst	0x75727265 ; undefined
    40005180:	2f737470 	.inst	0x2f737470 ; undefined
    40005184:	76636967 	.inst	0x76636967 ; undefined
    40005188:	69672f33 	ldpsw	x19, x11, [x25, #-200]
    4000518c:	5f337663 	sqshl	s3, s19, #19
    40005190:	2f776172 	umlsl	v18.4s, v11.4h, v7.h[3]
    40005194:	64636967 	.inst	0x64636967 ; undefined
    40005198:	6663695f 	.inst	0x6663695f ; undefined
    4000519c:	682e7267 	.inst	0x682e7267 ; undefined
	...
    400051a8:	44434947 	umlalb	z7.h, z10.b, z3.b
    400051ac:	4643495f 	.inst	0x4643495f ; undefined
    400051b0:	203a5247 	.inst	0x203a5247 ; undefined
    400051b4:	756c6176 	.inst	0x756c6176 ; undefined
    400051b8:	756d2065 	.inst	0x756d2065 ; undefined
    400051bc:	62207473 	.inst	0x62207473 ; undefined
    400051c0:	62302065 	.inst	0x62302065 ; undefined
    400051c4:	6f203031 	.inst	0x6f203031 ; undefined
    400051c8:	62302072 	.inst	0x62302072 ; undefined
    400051cc:	00003030 	udf	#12336
    400051d0:	44434947 	umlalb	z7.h, z10.b, z3.b
    400051d4:	5250495f 	.inst	0x5250495f ; undefined
    400051d8:	49524f49 	.inst	0x49524f49 ; undefined
    400051dc:	3a525954 	.inst	0x3a525954 ; undefined
    400051e0:	74796220 	.inst	0x74796220 ; undefined
    400051e4:	64695f65 	.inst	0x64695f65 ; undefined
    400051e8:	6e692078 	usubl2	v24.4s, v3.8h, v9.8h
    400051ec:	20786564 	.inst	0x20786564 ; undefined
    400051f0:	7473756d 	.inst	0x7473756d ; undefined
    400051f4:	20656220 	.inst	0x20656220 ; undefined
    400051f8:	33203d3c 	.inst	0x33203d3c ; undefined
    400051fc:	00000000 	udf	#0
    40005200:	636e695f 	.inst	0x636e695f ; undefined
    40005204:	6564756c 	fnmls	z12.h, p5/m, z11.h, z4.h
    40005208:	6972642f 	ldpsw	x15, x25, [x1, #-112]
    4000520c:	73726576 	.inst	0x73726576 ; undefined
    40005210:	746e692f 	.inst	0x746e692f ; undefined
    40005214:	75727265 	.inst	0x75727265 ; undefined
    40005218:	2f737470 	.inst	0x2f737470 ; undefined
    4000521c:	76636967 	.inst	0x76636967 ; undefined
    40005220:	69672f33 	ldpsw	x19, x11, [x25, #-200]
    40005224:	5f337663 	sqshl	s3, s19, #19
    40005228:	2f776172 	umlsl	v18.4s, v11.4h, v7.h[3]
    4000522c:	64636967 	.inst	0x64636967 ; undefined
    40005230:	7270695f 	.inst	0x7270695f ; undefined
    40005234:	69726f69 	ldpsw	x9, x27, [x27, #-112]
    40005238:	2e727974 	.inst	0x2e727974 ; undefined
    4000523c:	00000068 	udf	#104
    40005240:	44434947 	umlalb	z7.h, z10.b, z3.b
    40005244:	4553495f 	uaddwb	z31.h, z10.h, z19.b
    40005248:	4c42414e 	.inst	0x4c42414e ; undefined
    4000524c:	203a5245 	.inst	0x203a5245 ; undefined
    40005250:	20746962 	.inst	0x20746962 ; undefined
    40005254:	7473756d 	.inst	0x7473756d ; undefined
    40005258:	20656220 	.inst	0x20656220 ; undefined
    4000525c:	33203d3c 	.inst	0x33203d3c ; undefined
    40005260:	00000031 	udf	#49
    40005264:	00000000 	udf	#0
    40005268:	636e695f 	.inst	0x636e695f ; undefined
    4000526c:	6564756c 	fnmls	z12.h, p5/m, z11.h, z4.h
    40005270:	6972642f 	ldpsw	x15, x25, [x1, #-112]
    40005274:	73726576 	.inst	0x73726576 ; undefined
    40005278:	746e692f 	.inst	0x746e692f ; undefined
    4000527c:	75727265 	.inst	0x75727265 ; undefined
    40005280:	2f737470 	.inst	0x2f737470 ; undefined
    40005284:	76636967 	.inst	0x76636967 ; undefined
    40005288:	69672f33 	ldpsw	x19, x11, [x25, #-200]
    4000528c:	5f337663 	sqshl	s3, s19, #19
    40005290:	2f776172 	umlsl	v18.4s, v11.4h, v7.h[3]
    40005294:	64636967 	.inst	0x64636967 ; undefined
    40005298:	6573695f 	fnmls	z31.h, p2/m, z10.h, z19.h
    4000529c:	6c62616e 	ldnp	d14, d24, [x11, #-480]
    400052a0:	682e7265 	.inst	0x682e7265 ; undefined
    400052a4:	00000000 	udf	#0
    400052a8:	61766e49 	.inst	0x61766e49 ; undefined
    400052ac:	2064696c 	.inst	0x2064696c ; undefined
    400052b0:	20495053 	.inst	0x20495053 ; undefined
    400052b4:	49544e49 	.inst	0x49544e49 ; undefined
    400052b8:	00000044 	udf	#68
    400052bc:	00000000 	udf	#0
    400052c0:	6372735f 	.inst	0x6372735f ; undefined
    400052c4:	6972642f 	ldpsw	x15, x25, [x1, #-112]
    400052c8:	73726576 	.inst	0x73726576 ; undefined
    400052cc:	746e692f 	.inst	0x746e692f ; undefined
    400052d0:	75727265 	.inst	0x75727265 ; undefined
    400052d4:	2f737470 	.inst	0x2f737470 ; undefined
    400052d8:	76636967 	.inst	0x76636967 ; undefined
    400052dc:	69672f33 	ldpsw	x19, x11, [x25, #-200]
    400052e0:	2e337663 	uabd	v3.8b, v19.8b, v19.8b
    400052e4:	00000063 	udf	#99

00000000400052e8 <UART_N_BASE>:
static const uintptr UART_N_BASE[] = {
    400052e8:	30860000 	adr	x0, 3ff112e9 <GPR_FRAME_SIZE+0x3ff111e9>
    400052ec:	00000000 	udf	#0
    400052f0:	30890000 	adr	x0, 3ff172f1 <GPR_FRAME_SIZE+0x3ff171f1>
    400052f4:	00000000 	udf	#0
    400052f8:	30880000 	adr	x0, 3ff152f9 <GPR_FRAME_SIZE+0x3ff151f9>
    400052fc:	00000000 	udf	#0
    40005300:	30a60000 	adr	x0, 3ff51301 <GPR_FRAME_SIZE+0x3ff51201>
	...

Disassembly of section .debug_line:

0000000000000000 <.debug_line>:
       0:	0000004f 	udf	#79
       4:	00080005 	.inst	0x00080005 ; undefined
       8:	0000002e 	udf	#46
       c:	fb010104 	.inst	0xfb010104 ; undefined
      10:	01000d0e 	.inst	0x01000d0e ; undefined
      14:	00010101 	.inst	0x00010101 ; undefined
      18:	00010000 	.inst	0x00010000 ; undefined
      1c:	01010100 	.inst	0x01010100 ; undefined
      20:	0000021f 	udf	#543
      24:	002b0000 	.inst	0x002b0000 ; NYI
      28:	01020000 	.inst	0x01020000 ; undefined
      2c:	020f021f 	.inst	0x020f021f ; undefined
      30:	00000034 	udf	#52
      34:	00003401 	udf	#13313
      38:	09000100 	.inst	0x09000100 ; undefined
      3c:	00004802 	udf	#18434
      40:	00000040 	udf	#64
      44:	21211700 	.inst	0x21211700 ; undefined
      48:	21242124 	.inst	0x21242124 ; undefined
      4c:	01022124 	.inst	0x01022124 ; undefined
      50:	ac010100 	stnp	q0, q0, [x8, #32]
      54:	05000000 	orr	z0.s, z0.s, #0x1
      58:	2e000800 	ext	v0.8b, v0.8b, v0.8b, #1
      5c:	04000000 	add	z0.b, p0/m, z0.b, z0.b
      60:	0efb0101 	.inst	0x0efb0101 ; undefined
      64:	0101000d 	.inst	0x0101000d ; undefined
      68:	00000101 	udf	#257
      6c:	00000100 	udf	#256
      70:	1f010101 	fmadd	s1, s8, s1, s0
      74:	00000002 	udf	#2
      78:	00003e00 	udf	#15872
      7c:	1f010200 	fmadd	s0, s16, s1, s0
      80:	52020f02 	eor	w2, w24, #0xc0000003
      84:	01000000 	.inst	0x01000000 ; undefined
      88:	00000052 	udf	#82
      8c:	02090001 	.inst	0x02090001 ; undefined
      90:	40000070 	.inst	0x40000070 ; undefined
      94:	00000000 	udf	#0
      98:	21212116 	.inst	0x21212116 ; undefined
      9c:	02203803 	.inst	0x02203803 ; undefined
      a0:	24021524 	cmphs	p4.b, p5/z, z9.b, z2.b
      a4:	15240215 	b	49008f8 <GPR_FRAME_SIZE+0x49007f8>
      a8:	02152402 	.inst	0x02152402 ; undefined
      ac:	24021524 	cmphs	p4.b, p5/z, z9.b, z2.b
      b0:	15240215 	b	4900904 <GPR_FRAME_SIZE+0x4900804>
      b4:	02152402 	.inst	0x02152402 ; undefined
      b8:	24021524 	cmphs	p4.b, p5/z, z9.b, z2.b
      bc:	15240215 	b	4900910 <GPR_FRAME_SIZE+0x4900810>
      c0:	02152402 	.inst	0x02152402 ; undefined
      c4:	24021524 	cmphs	p4.b, p5/z, z9.b, z2.b
      c8:	15240215 	b	490091c <GPR_FRAME_SIZE+0x490081c>
      cc:	01002402 	.inst	0x01002402 ; undefined
      d0:	02090001 	.inst	0x02090001 ; undefined
      d4:	40004000 	.inst	0x40004000 ; undefined
      d8:	00000000 	udf	#0
      dc:	0100fd03 	.inst	0x0100fd03 ; undefined
      e0:	e508e508 	.inst	0xe508e508 ; undefined
      e4:	e608e508 	.inst	0xe608e508 ; undefined
      e8:	e508e508 	.inst	0xe508e508 ; undefined
      ec:	e608e508 	.inst	0xe608e508 ; undefined
      f0:	e508e508 	.inst	0xe508e508 ; undefined
      f4:	e608e508 	.inst	0xe608e508 ; undefined
      f8:	e508e508 	.inst	0xe508e508 ; undefined
      fc:	0102e508 	.inst	0x0102e508 ; undefined
     100:	60010100 	.inst	0x60010100 ; undefined
     104:	05000000 	orr	z0.s, z0.s, #0x1
     108:	2e000800 	ext	v0.8b, v0.8b, v0.8b, #1
     10c:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     110:	0efb0101 	.inst	0x0efb0101 ; undefined
     114:	0101000d 	.inst	0x0101000d ; undefined
     118:	00000101 	udf	#257
     11c:	00000100 	udf	#256
     120:	1f010101 	fmadd	s1, s8, s1, s0
     124:	00000002 	udf	#2
     128:	00003e00 	udf	#15872
     12c:	1f010200 	fmadd	s0, s16, s1, s0
     130:	60020f02 	.inst	0x60020f02 ; undefined
     134:	01000000 	.inst	0x01000000 ; undefined
     138:	00000060 	udf	#96
     13c:	02090001 	.inst	0x02090001 ; undefined
     140:	40000980 	.inst	0x40000980 ; undefined
     144:	00000000 	udf	#0
     148:	21242117 	.inst	0x21242117 ; undefined
     14c:	21212421 	.inst	0x21212421 ; undefined
     150:	24212124 	cmplo	p4.b, p0/z, z9.b, #4
     154:	21242121 	.inst	0x21242121 ; undefined
     158:	21212421 	.inst	0x21212421 ; undefined
     15c:	24212124 	cmplo	p4.b, p0/z, z9.b, #4
     160:	01022121 	.inst	0x01022121 ; undefined
     164:	d0010100 	adrp	x0, 2022000 <GPR_FRAME_SIZE+0x2021f00>
     168:	05000000 	orr	z0.s, z0.s, #0x1
     16c:	2e000800 	ext	v0.8b, v0.8b, v0.8b, #1
     170:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     174:	0efb0101 	.inst	0x0efb0101 ; undefined
     178:	0101000d 	.inst	0x0101000d ; undefined
     17c:	00000101 	udf	#257
     180:	00000100 	udf	#256
     184:	1f010101 	fmadd	s1, s8, s1, s0
     188:	00000002 	udf	#2
     18c:	00006d00 	udf	#27904
     190:	1f010200 	fmadd	s0, s16, s1, s0
     194:	7d020f02 	str	h2, [x24, #262]
     198:	01000000 	.inst	0x01000000 ; undefined
     19c:	0000007d 	udf	#125
     1a0:	02090001 	.inst	0x02090001 ; undefined
     1a4:	400009f0 	.inst	0x400009f0 ; undefined
     1a8:	00000000 	udf	#0
     1ac:	22010a03 	.inst	0x22010a03 ; undefined
     1b0:	22212321 	.inst	0x22212321 ; undefined
     1b4:	22212221 	.inst	0x22212221 ; undefined
     1b8:	21222123 	.inst	0x21222123 ; undefined
     1bc:	22212321 	.inst	0x22212321 ; undefined
     1c0:	21232121 	.inst	0x21232121 ; undefined
     1c4:	23212122 	.inst	0x23212122 ; undefined
     1c8:	21222122 	.inst	0x21222122 ; undefined
     1cc:	21222124 	.inst	0x21222124 ; undefined
     1d0:	21222123 	.inst	0x21222123 ; undefined
     1d4:	21232121 	.inst	0x21232121 ; undefined
     1d8:	23222122 	.inst	0x23222122 ; undefined
     1dc:	22212221 	.inst	0x22212221 ; undefined
     1e0:	21232121 	.inst	0x21232121 ; undefined
     1e4:	23222122 	.inst	0x23222122 ; undefined
     1e8:	21222122 	.inst	0x21222122 ; undefined
     1ec:	21232123 	.inst	0x21232123 ; undefined
     1f0:	223c1803 	.inst	0x223c1803 ; undefined
     1f4:	22212321 	.inst	0x22212321 ; undefined
     1f8:	21232121 	.inst	0x21232121 ; undefined
     1fc:	23212242 	.inst	0x23212242 ; undefined
     200:	21212221 	.inst	0x21212221 ; undefined
     204:	22422123 	.inst	0x22422123 ; undefined
     208:	22212221 	.inst	0x22212221 ; undefined
     20c:	21232121 	.inst	0x21232121 ; undefined
     210:	23212242 	.inst	0x23212242 ; undefined
     214:	21212221 	.inst	0x21212221 ; undefined
     218:	22422123 	.inst	0x22422123 ; undefined
     21c:	22212321 	.inst	0x22212321 ; undefined
     220:	21232121 	.inst	0x21232121 ; undefined
     224:	23212242 	.inst	0x23212242 ; undefined
     228:	21212221 	.inst	0x21212221 ; undefined
     22c:	22422123 	.inst	0x22422123 ; undefined
     230:	21222123 	.inst	0x21222123 ; undefined
     234:	01022123 	.inst	0x01022123 ; undefined
     238:	57010100 	.inst	0x57010100 ; undefined
     23c:	05000000 	orr	z0.s, z0.s, #0x1
     240:	2e000800 	ext	v0.8b, v0.8b, v0.8b, #1
     244:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     248:	0efb0101 	.inst	0x0efb0101 ; undefined
     24c:	0101000d 	.inst	0x0101000d ; undefined
     250:	00000101 	udf	#257
     254:	00000100 	udf	#256
     258:	1f010101 	fmadd	s1, s8, s1, s0
     25c:	00000002 	udf	#2
     260:	00008600 	udf	#34304
     264:	1f010200 	fmadd	s0, s16, s1, s0
     268:	90020f02 	adrp	x2, 41e0000 <GPR_FRAME_SIZE+0x41dff00>
     26c:	01000000 	.inst	0x01000000 ; undefined
     270:	00000090 	udf	#144
     274:	02090001 	.inst	0x02090001 ; undefined
     278:	40000c40 	.inst	0x40000c40 ; undefined
     27c:	00000000 	udf	#0
     280:	21222117 	.inst	0x21222117 ; undefined
     284:	21232121 	.inst	0x21232121 ; undefined
     288:	21232122 	.inst	0x21232122 ; undefined
     28c:	23222122 	.inst	0x23222122 ; undefined
     290:	00060221 	.inst	0x00060221 ; undefined
     294:	00540101 	.inst	0x00540101 ; undefined
     298:	00050000 	.inst	0x00050000 ; undefined
     29c:	002e0008 	.inst	0x002e0008 ; NYI
     2a0:	01040000 	.inst	0x01040000 ; undefined
     2a4:	0d0efb01 	.inst	0x0d0efb01 ; undefined
     2a8:	01010100 	.inst	0x01010100 ; undefined
     2ac:	00000001 	udf	#1
     2b0:	01000001 	.inst	0x01000001 ; undefined
     2b4:	021f0101 	.inst	0x021f0101 ; undefined
     2b8:	00000000 	udf	#0
     2bc:	00000086 	udf	#134
     2c0:	021f0102 	.inst	0x021f0102 ; undefined
     2c4:	009c020f 	.inst	0x009c020f ; undefined
     2c8:	9c010000 	ldr	q0, 22c8 <GPR_FRAME_SIZE+0x21c8>
     2cc:	01000000 	.inst	0x01000000 ; undefined
     2d0:	00020900 	.inst	0x00020900 ; undefined
     2d4:	00400000 	.inst	0x00400000 ; undefined
     2d8:	16000000 	b	fffffffff80002d8 <__stack_el2_top+0xffffffffb69f92d8>
     2dc:	21212125 	.inst	0x21212125 ; undefined
     2e0:	21232124 	.inst	0x21232124 ; undefined
     2e4:	23222223 	.inst	0x23222223 ; undefined
     2e8:	00050221 	.inst	0x00050221 ; undefined
     2ec:	012c0101 	.inst	0x012c0101 ; undefined
     2f0:	00050000 	.inst	0x00050000 ; undefined
     2f4:	00570008 	.inst	0x00570008 ; undefined
     2f8:	01040000 	.inst	0x01040000 ; undefined
     2fc:	0d0efb01 	.inst	0x0d0efb01 ; undefined
     300:	01010100 	.inst	0x01010100 ; undefined
     304:	00000001 	udf	#1
     308:	01000001 	.inst	0x01000001 ; undefined
     30c:	061f0101 	.inst	0x061f0101 ; undefined
     310:	00000000 	udf	#0
     314:	000000b7 	udf	#183
     318:	000000c3 	udf	#195
     31c:	000000db 	udf	#219
     320:	000000e8 	udf	#232
     324:	000000fe 	udf	#254
     328:	021f0102 	.inst	0x021f0102 ; undefined
     32c:	00af070f 	.inst	0x00af070f ; undefined
     330:	af010000 	.inst	0xaf010000 ; undefined
     334:	01000000 	.inst	0x01000000 ; undefined
     338:	0000010e 	udf	#270
     33c:	00011b02 	.inst	0x00011b02 ; undefined
     340:	01240300 	.inst	0x01240300 ; undefined
     344:	2b040000 	adds	w0, w0, w4
     348:	05000001 	orr	z1.s, z1.s, #0x1
     34c:	00000133 	udf	#307
     350:	00010503 	.inst	0x00010503 ; undefined
     354:	0c980209 	st4	{v9.8b-v12.8b}, [x16], x24
     358:	00004000 	udf	#16384
     35c:	20030000 	.inst	0x20030000 ; undefined
     360:	2f190501 	ushr	v1.4h, v8.4h, #7
     364:	054b1605 	.inst	0x054b1605 ; undefined
     368:	15054c18 	b	41533c8 <GPR_FRAME_SIZE+0x41532c8>
     36c:	5a0d0559 	.inst	0x5a0d0559 ; undefined
     370:	053d0c05 	ext	z5.b, z5.b, z0.b, #235
     374:	05873e02 	.inst	0x05873e02 ; undefined
     378:	05428401 	eor	z1.d, z1.d, #0xffff00000001ffff
     37c:	4b4c3002 	sub	w2, w0, w12, lsr #12
     380:	4c674b68 	.inst	0x4c674b68 ; undefined
     384:	01040200 	.inst	0x01040200 ; undefined
     388:	1005ac06 	adr	x6, b908 <GPR_FRAME_SIZE+0xb808>
     38c:	05053f06 	.inst	0x05053f06 ; undefined
     390:	2f03053c 	mvni	v28.2s, #0x69
     394:	0402004b 	.inst	0x0402004b ; undefined
     398:	05ac0601 	zip2	z1.q, z16.q, z12.q
     39c:	22410602 	.inst	0x22410602 ; undefined
     3a0:	05320105 	ext	z5.b, z5.b, z8.b, #144
     3a4:	05694b02 	.inst	0x05694b02 ; undefined
     3a8:	0d056922 	.inst	0x0d056922 ; undefined
     3ac:	3d210520 	str	b0, [x9, #2113]
     3b0:	05200c05 	ext	z5.b, z5.b, z0.b, #3
     3b4:	054d3d01 	.inst	0x054d3d01 ; undefined
     3b8:	05834b02 	and	z2.d, z2.d, #0xffffff800000
     3bc:	1c052601 	ldr	s1, a87c <GPR_FRAME_SIZE+0xa77c>
     3c0:	3002052f 	adr	x15, 4465 <GPR_FRAME_SIZE+0x4365>
     3c4:	3d4c0805 	ldr	b5, [x0, #770]
     3c8:	4b3e0205 	sub	w5, w16, w30, uxtb
     3cc:	01040200 	.inst	0x01040200 ; undefined
     3d0:	02004a06 	.inst	0x02004a06 ; undefined
     3d4:	002e0204 	.inst	0x002e0204 ; NYI
     3d8:	20040402 	.inst	0x20040402 ; undefined
     3dc:	004b3e06 	.inst	0x004b3e06 ; undefined
     3e0:	06010402 	.inst	0x06010402 ; undefined
     3e4:	0402004a 	.inst	0x0402004a ; undefined
     3e8:	02002e02 	.inst	0x02002e02 ; undefined
     3ec:	06200404 	.inst	0x06200404 ; undefined
     3f0:	02004b3e 	.inst	0x02004b3e ; undefined
     3f4:	4a060104 	eor	w4, w8, w6
     3f8:	02040200 	.inst	0x02040200 ; undefined
     3fc:	0402002e 	.inst	0x0402002e ; undefined
     400:	3e062004 	.inst	0x3e062004 ; undefined
     404:	0402004b 	.inst	0x0402004b ; undefined
     408:	004a0601 	.inst	0x004a0601 ; undefined
     40c:	2e020402 	.inst	0x2e020402 ; undefined
     410:	04040200 	.inst	0x04040200 ; undefined
     414:	06010520 	.inst	0x06010520 ; undefined
     418:	0003023f 	.inst	0x0003023f ; undefined
     41c:	011b0101 	.inst	0x011b0101 ; undefined
     420:	00050000 	.inst	0x00050000 ; undefined
     424:	00720008 	.inst	0x00720008 ; undefined
     428:	01040000 	.inst	0x01040000 ; undefined
     42c:	0d0efb01 	.inst	0x0d0efb01 ; undefined
     430:	01010100 	.inst	0x01010100 ; undefined
     434:	00000001 	udf	#1
     438:	01000001 	.inst	0x01000001 ; undefined
     43c:	091f0101 	.inst	0x091f0101 ; undefined
     440:	00000000 	udf	#0
     444:	000000b7 	udf	#183
     448:	0000017c 	udf	#380
     44c:	000000c3 	udf	#195
     450:	000000db 	udf	#219
     454:	000000e8 	udf	#232
     458:	000001a8 	udf	#424
     45c:	000001b5 	udf	#437
     460:	000000fe 	udf	#254
     464:	021f0102 	.inst	0x021f0102 ; undefined
     468:	016d0a0f 	.inst	0x016d0a0f ; undefined
     46c:	c7010000 	.inst	0xc7010000 ; undefined
     470:	02000001 	.inst	0x02000001 ; undefined
     474:	0000016d 	udf	#365
     478:	00010e01 	.inst	0x00010e01 ; undefined
     47c:	011b0300 	.inst	0x011b0300 ; undefined
     480:	24040000 	cmphs	p0.b, p0/z, z0.b, z4.b
     484:	05000001 	orr	z1.s, z1.s, #0x1
     488:	000001d4 	udf	#468
     48c:	0001da06 	.inst	0x0001da06 ; undefined
     490:	01330700 	.inst	0x01330700 ; undefined
     494:	2b040000 	adds	w0, w0, w4
     498:	08000001 	stxrb	w0, w1, [x0]
     49c:	09000105 	.inst	0x09000105 ; undefined
     4a0:	00102c02 	.inst	0x00102c02 ; undefined
     4a4:	00000040 	udf	#64
     4a8:	01130300 	.inst	0x01130300 ; undefined
     4ac:	8210032e 	.inst	0x8210032e ; undefined
     4b0:	05300e05 	ext	z5.b, z5.b, z16.b, #131
     4b4:	09052029 	.inst	0x09052029 ; undefined
     4b8:	0105231f 	.inst	0x0105231f ; undefined
     4bc:	030204f3 	.inst	0x030204f3 ; undefined
     4c0:	02052e68 	.inst	0x02052e68 ; undefined
     4c4:	2a05213d 	orr	w29, w9, w5, lsl #8
     4c8:	82020530 	.inst	0x82020530 ; undefined
     4cc:	51340105 	sub	w5, w8, #0xd00
     4d0:	224b0205 	.inst	0x224b0205 ; undefined
     4d4:	054e0e05 	.inst	0x054e0e05 ; undefined
     4d8:	11052002 	add	w2, w0, #0x148
     4dc:	3f040521 	.inst	0x3f040521 ; undefined
     4e0:	01040200 	.inst	0x01040200 ; undefined
     4e4:	02002e06 	.inst	0x02002e06 ; undefined
     4e8:	004a0204 	.inst	0x004a0204 ; undefined
     4ec:	66030402 	.inst	0x66030402 ; undefined
     4f0:	04040200 	.inst	0x04040200 ; undefined
     4f4:	060a0566 	.inst	0x060a0566 ; undefined
     4f8:	3103052d 	adds	w13, w9, #0xc1
     4fc:	054b3605 	.inst	0x054b3605 ; undefined
     500:	03053c18 	.inst	0x03053c18 ; undefined
     504:	01040200 	.inst	0x01040200 ; undefined
     508:	1d053f66 	.inst	0x1d053f66 ; undefined
     50c:	03040200 	.inst	0x03040200 ; undefined
     510:	054a7603 	.inst	0x054a7603 ; undefined
     514:	04020017 	.inst	0x04020017 ; undefined
     518:	13053c01 	sbfx	w1, w0, #5, #11
     51c:	053c0d03 	ext	z3.b, z3.b, z8.b, #227
     520:	06053024 	.inst	0x06053024 ; undefined
     524:	65020520 	bfsub	z0.h, z9.h, z2.h
     528:	05440705 	.inst	0x05440705 ; undefined
     52c:	04020006 	.inst	0x04020006 ; undefined
     530:	04055801 	mla	z1.b, p6/m, z0.b, z5.b
     534:	4602053d 	.inst	0x4602053d ; undefined
     538:	01000102 	.inst	0x01000102 ; undefined
     53c:	00007b01 	udf	#31489
     540:	08000500 	stxrb	w0, w0, [x8]
     544:	00004500 	udf	#17664
     548:	01010400 	.inst	0x01010400 ; undefined
     54c:	000d0efb 	.inst	0x000d0efb ; undefined
     550:	01010101 	.inst	0x01010101 ; undefined
     554:	01000000 	.inst	0x01000000 ; undefined
     558:	01010000 	.inst	0x01010000 ; undefined
     55c:	00041f01 	.inst	0x00041f01 ; undefined
     560:	2b000000 	adds	w0, w0, w0
     564:	db000000 	.inst	0xdb000000 ; undefined
     568:	a8000000 	stnp	x0, x0, [x0]
     56c:	02000001 	.inst	0x02000001 ; undefined
     570:	0f021f01 	.inst	0x0f021f01 ; undefined
     574:	0001ef05 	.inst	0x0001ef05 ; undefined
     578:	01ef0100 	.inst	0x01ef0100 ; undefined
     57c:	1b010000 	madd	w0, w0, w1, w0
     580:	02000001 	.inst	0x02000001 ; undefined
     584:	000001d4 	udf	#468
     588:	0001f503 	.inst	0x0001f503 ; undefined
     58c:	01050300 	.inst	0x01050300 ; undefined
     590:	5c020900 	ldr	d0, 46b0 <GPR_FRAME_SIZE+0x45b0>
     594:	00400012 	.inst	0x00400012 ; undefined
     598:	18000000 	ldr	w0, 598 <GPR_FRAME_SIZE+0x498>
     59c:	052f0d05 	ext	z5.b, z5.b, z8.b, #123
     5a0:	0e05330f 	tbx	v15.8b, {v24.16b-v25.16b}, v5.8b
     5a4:	310f052a 	adds	w10, w9, #0x3c1
     5a8:	052b0e05 	ext	z5.b, z5.b, z16.b, #91
     5ac:	0e05300f 	tbx	v15.8b, {v0.16b-v1.16b}, v5.8b
     5b0:	5f09052c 	.inst	0x5f09052c ; undefined
     5b4:	02210105 	.inst	0x02210105 ; undefined
     5b8:	01010002 	.inst	0x01010002 ; undefined
     5bc:	0000005b 	udf	#91
     5c0:	00080005 	.inst	0x00080005 ; undefined
     5c4:	00000040 	udf	#64
     5c8:	fb010104 	.inst	0xfb010104 ; undefined
     5cc:	01000d0e 	.inst	0x01000d0e ; undefined
     5d0:	00010101 	.inst	0x00010101 ; undefined
     5d4:	00010000 	.inst	0x00010000 ; undefined
     5d8:	01010100 	.inst	0x01010100 ; undefined
     5dc:	0000041f 	udf	#1055
     5e0:	02350000 	.inst	0x02350000 ; undefined
     5e4:	00fe0000 	.inst	0x00fe0000 ; undefined
     5e8:	00db0000 	.inst	0x00db0000 ; undefined
     5ec:	01020000 	.inst	0x01020000 ; undefined
     5f0:	040f021f 	.inst	0x040f021f ; undefined
     5f4:	00000220 	udf	#544
     5f8:	00022001 	.inst	0x00022001 ; undefined
     5fc:	012b0100 	.inst	0x012b0100 ; undefined
     600:	1b020000 	madd	w0, w0, w2, w0
     604:	03000001 	.inst	0x03000001 ; undefined
     608:	09000105 	.inst	0x09000105 ; undefined
     60c:	0012b402 	.inst	0x0012b402 ; undefined
     610:	00000040 	udf	#64
     614:	082e1400 	.inst	0x082e1400 ; undefined
     618:	5b010100 	.inst	0x5b010100 ; undefined
     61c:	05000000 	orr	z0.s, z0.s, #0x1
     620:	40000800 	.inst	0x40000800 ; undefined
     624:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     628:	0efb0101 	.inst	0x0efb0101 ; undefined
     62c:	0101000d 	.inst	0x0101000d ; undefined
     630:	00000101 	udf	#257
     634:	00000100 	udf	#256
     638:	1f010101 	fmadd	s1, s8, s1, s0
     63c:	00000004 	udf	#4
     640:	00023500 	.inst	0x00023500 ; undefined
     644:	0000fe00 	udf	#65024
     648:	0000db00 	udf	#56064
     64c:	1f010200 	fmadd	s0, s16, s1, s0
     650:	77040f02 	.inst	0x77040f02 ; undefined
     654:	01000002 	.inst	0x01000002 ; undefined
     658:	00000277 	udf	#631
     65c:	00012b01 	.inst	0x00012b01 ; undefined
     660:	011b0200 	.inst	0x011b0200 ; undefined
     664:	05030000 	orr	z0.d, z0.d, #0x100000000
     668:	02090001 	.inst	0x02090001 ; undefined
     66c:	40001300 	.inst	0x40001300 ; undefined
     670:	00000000 	udf	#0
     674:	00082e14 	.inst	0x00082e14 ; undefined
     678:	005b0101 	.inst	0x005b0101 ; undefined
     67c:	00050000 	.inst	0x00050000 ; undefined
     680:	00400008 	.inst	0x00400008 ; undefined
     684:	01040000 	.inst	0x01040000 ; undefined
     688:	0d0efb01 	.inst	0x0d0efb01 ; undefined
     68c:	01010100 	.inst	0x01010100 ; undefined
     690:	00000001 	udf	#1
     694:	01000001 	.inst	0x01000001 ; undefined
     698:	041f0101 	.inst	0x041f0101 ; undefined
     69c:	00000000 	udf	#0
     6a0:	00000235 	udf	#565
     6a4:	000000fe 	udf	#254
     6a8:	000000db 	udf	#219
     6ac:	021f0102 	.inst	0x021f0102 ; undefined
     6b0:	02ad040f 	.inst	0x02ad040f ; undefined
     6b4:	ad010000 	stp	q0, q0, [x0, #32]
     6b8:	01000002 	.inst	0x01000002 ; undefined
     6bc:	0000012b 	udf	#299
     6c0:	00011b02 	.inst	0x00011b02 ; undefined
     6c4:	01050300 	.inst	0x01050300 ; undefined
     6c8:	4c020900 	.inst	0x4c020900 ; undefined
     6cc:	00400013 	.inst	0x00400013 ; undefined
     6d0:	14000000 	b	6d0 <GPR_FRAME_SIZE+0x5d0>
     6d4:	0100082e 	.inst	0x0100082e ; undefined
     6d8:	00005b01 	udf	#23297
     6dc:	08000500 	stxrb	w0, w0, [x8]
     6e0:	00004000 	udf	#16384
     6e4:	01010400 	.inst	0x01010400 ; undefined
     6e8:	000d0efb 	.inst	0x000d0efb ; undefined
     6ec:	01010101 	.inst	0x01010101 ; undefined
     6f0:	01000000 	.inst	0x01000000 ; undefined
     6f4:	01010000 	.inst	0x01010000 ; undefined
     6f8:	00041f01 	.inst	0x00041f01 ; undefined
     6fc:	35000000 	cbnz	w0, 6fc <GPR_FRAME_SIZE+0x5fc>
     700:	fe000002 	.inst	0xfe000002 ; undefined
     704:	db000000 	.inst	0xdb000000 ; undefined
     708:	02000000 	.inst	0x02000000 ; undefined
     70c:	0f021f01 	.inst	0x0f021f01 ; undefined
     710:	0002e304 	.inst	0x0002e304 ; undefined
     714:	02e30100 	.inst	0x02e30100 ; undefined
     718:	2b010000 	adds	w0, w0, w1
     71c:	02000001 	.inst	0x02000001 ; undefined
     720:	0000011b 	udf	#283
     724:	00010503 	.inst	0x00010503 ; undefined
     728:	13980209 	extr	w9, w16, w24, #0
     72c:	00004000 	udf	#16384
     730:	2e140000 	ext	v0.8b, v0.8b, v20.8b, #0
     734:	01010008 	.inst	0x01010008 ; undefined
     738:	0000005b 	udf	#91
     73c:	00080005 	.inst	0x00080005 ; undefined
     740:	00000040 	udf	#64
     744:	fb010104 	.inst	0xfb010104 ; undefined
     748:	01000d0e 	.inst	0x01000d0e ; undefined
     74c:	00010101 	.inst	0x00010101 ; undefined
     750:	00010000 	.inst	0x00010000 ; undefined
     754:	01010100 	.inst	0x01010100 ; undefined
     758:	0000041f 	udf	#1055
     75c:	02350000 	.inst	0x02350000 ; undefined
     760:	00fe0000 	.inst	0x00fe0000 ; undefined
     764:	00db0000 	.inst	0x00db0000 ; undefined
     768:	01020000 	.inst	0x01020000 ; undefined
     76c:	040f021f 	.inst	0x040f021f ; undefined
     770:	00000317 	udf	#791
     774:	00031701 	.inst	0x00031701 ; undefined
     778:	012b0100 	.inst	0x012b0100 ; undefined
     77c:	1b020000 	madd	w0, w0, w2, w0
     780:	03000001 	.inst	0x03000001 ; undefined
     784:	09000105 	.inst	0x09000105 ; undefined
     788:	0013e402 	.inst	0x0013e402 ; undefined
     78c:	00000040 	udf	#64
     790:	082e1400 	.inst	0x082e1400 ; undefined
     794:	5b010100 	.inst	0x5b010100 ; undefined
     798:	05000000 	orr	z0.s, z0.s, #0x1
     79c:	40000800 	.inst	0x40000800 ; undefined
     7a0:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     7a4:	0efb0101 	.inst	0x0efb0101 ; undefined
     7a8:	0101000d 	.inst	0x0101000d ; undefined
     7ac:	00000101 	udf	#257
     7b0:	00000100 	udf	#256
     7b4:	1f010101 	fmadd	s1, s8, s1, s0
     7b8:	00000004 	udf	#4
     7bc:	00023500 	.inst	0x00023500 ; undefined
     7c0:	0000fe00 	udf	#65024
     7c4:	0000db00 	udf	#56064
     7c8:	1f010200 	fmadd	s0, s16, s1, s0
     7cc:	4a040f02 	eor	w2, w24, w4, lsl #3
     7d0:	01000003 	.inst	0x01000003 ; undefined
     7d4:	0000034a 	udf	#842
     7d8:	00012b01 	.inst	0x00012b01 ; undefined
     7dc:	011b0200 	.inst	0x011b0200 ; undefined
     7e0:	05030000 	orr	z0.d, z0.d, #0x100000000
     7e4:	02090001 	.inst	0x02090001 ; undefined
     7e8:	40001430 	.inst	0x40001430 ; undefined
     7ec:	00000000 	udf	#0
     7f0:	00082e14 	.inst	0x00082e14 ; undefined
     7f4:	005b0101 	.inst	0x005b0101 ; undefined
     7f8:	00050000 	.inst	0x00050000 ; undefined
     7fc:	00400008 	.inst	0x00400008 ; undefined
     800:	01040000 	.inst	0x01040000 ; undefined
     804:	0d0efb01 	.inst	0x0d0efb01 ; undefined
     808:	01010100 	.inst	0x01010100 ; undefined
     80c:	00000001 	udf	#1
     810:	01000001 	.inst	0x01000001 ; undefined
     814:	041f0101 	.inst	0x041f0101 ; undefined
     818:	00000000 	udf	#0
     81c:	00000235 	udf	#565
     820:	000000fe 	udf	#254
     824:	000000db 	udf	#219
     828:	021f0102 	.inst	0x021f0102 ; undefined
     82c:	0380040f 	.inst	0x0380040f ; undefined
     830:	80010000 	.inst	0x80010000 ; undefined
     834:	01000003 	.inst	0x01000003 ; undefined
     838:	0000012b 	udf	#299
     83c:	00011b02 	.inst	0x00011b02 ; undefined
     840:	01050300 	.inst	0x01050300 ; undefined
     844:	7c020900 	.inst	0x7c020900 ; undefined
     848:	00400014 	.inst	0x00400014 ; undefined
     84c:	14000000 	b	84c <GPR_FRAME_SIZE+0x74c>
     850:	0100082e 	.inst	0x0100082e ; undefined
     854:	00005b01 	udf	#23297
     858:	08000500 	stxrb	w0, w0, [x8]
     85c:	00004000 	udf	#16384
     860:	01010400 	.inst	0x01010400 ; undefined
     864:	000d0efb 	.inst	0x000d0efb ; undefined
     868:	01010101 	.inst	0x01010101 ; undefined
     86c:	01000000 	.inst	0x01000000 ; undefined
     870:	01010000 	.inst	0x01010000 ; undefined
     874:	00041f01 	.inst	0x00041f01 ; undefined
     878:	35000000 	cbnz	w0, 878 <GPR_FRAME_SIZE+0x778>
     87c:	fe000002 	.inst	0xfe000002 ; undefined
     880:	db000000 	.inst	0xdb000000 ; undefined
     884:	02000000 	.inst	0x02000000 ; undefined
     888:	0f021f01 	.inst	0x0f021f01 ; undefined
     88c:	0003b304 	.inst	0x0003b304 ; undefined
     890:	03b30100 	.inst	0x03b30100 ; undefined
     894:	2b010000 	adds	w0, w0, w1
     898:	02000001 	.inst	0x02000001 ; undefined
     89c:	0000011b 	udf	#283
     8a0:	00010503 	.inst	0x00010503 ; undefined
     8a4:	14c80209 	b	32010c8 <GPR_FRAME_SIZE+0x3200fc8>
     8a8:	00004000 	udf	#16384
     8ac:	2e140000 	ext	v0.8b, v0.8b, v20.8b, #0
     8b0:	01010008 	.inst	0x01010008 ; undefined
     8b4:	0000005b 	udf	#91
     8b8:	00080005 	.inst	0x00080005 ; undefined
     8bc:	00000040 	udf	#64
     8c0:	fb010104 	.inst	0xfb010104 ; undefined
     8c4:	01000d0e 	.inst	0x01000d0e ; undefined
     8c8:	00010101 	.inst	0x00010101 ; undefined
     8cc:	00010000 	.inst	0x00010000 ; undefined
     8d0:	01010100 	.inst	0x01010100 ; undefined
     8d4:	0000041f 	udf	#1055
     8d8:	02350000 	.inst	0x02350000 ; undefined
     8dc:	00fe0000 	.inst	0x00fe0000 ; undefined
     8e0:	00db0000 	.inst	0x00db0000 ; undefined
     8e4:	01020000 	.inst	0x01020000 ; undefined
     8e8:	040f021f 	.inst	0x040f021f ; undefined
     8ec:	000003e6 	udf	#998
     8f0:	0003e601 	.inst	0x0003e601 ; undefined
     8f4:	012b0100 	.inst	0x012b0100 ; undefined
     8f8:	1b020000 	madd	w0, w0, w2, w0
     8fc:	03000001 	.inst	0x03000001 ; undefined
     900:	09000105 	.inst	0x09000105 ; undefined
     904:	00151402 	.inst	0x00151402 ; undefined
     908:	00000040 	udf	#64
     90c:	082e1400 	.inst	0x082e1400 ; undefined
     910:	5b010100 	.inst	0x5b010100 ; undefined
     914:	05000000 	orr	z0.s, z0.s, #0x1
     918:	40000800 	.inst	0x40000800 ; undefined
     91c:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     920:	0efb0101 	.inst	0x0efb0101 ; undefined
     924:	0101000d 	.inst	0x0101000d ; undefined
     928:	00000101 	udf	#257
     92c:	00000100 	udf	#256
     930:	1f010101 	fmadd	s1, s8, s1, s0
     934:	00000004 	udf	#4
     938:	00023500 	.inst	0x00023500 ; undefined
     93c:	0000fe00 	udf	#65024
     940:	0000db00 	udf	#56064
     944:	1f010200 	fmadd	s0, s16, s1, s0
     948:	19040f02 	.inst	0x19040f02 ; undefined
     94c:	01000004 	.inst	0x01000004 ; undefined
     950:	00000419 	udf	#1049
     954:	00012b01 	.inst	0x00012b01 ; undefined
     958:	011b0200 	.inst	0x011b0200 ; undefined
     95c:	05030000 	orr	z0.d, z0.d, #0x100000000
     960:	02090001 	.inst	0x02090001 ; undefined
     964:	40001560 	.inst	0x40001560 ; undefined
     968:	00000000 	udf	#0
     96c:	00082e14 	.inst	0x00082e14 ; undefined
     970:	005b0101 	.inst	0x005b0101 ; undefined
     974:	00050000 	.inst	0x00050000 ; undefined
     978:	00400008 	.inst	0x00400008 ; undefined
     97c:	01040000 	.inst	0x01040000 ; undefined
     980:	0d0efb01 	.inst	0x0d0efb01 ; undefined
     984:	01010100 	.inst	0x01010100 ; undefined
     988:	00000001 	udf	#1
     98c:	01000001 	.inst	0x01000001 ; undefined
     990:	041f0101 	.inst	0x041f0101 ; undefined
     994:	00000000 	udf	#0
     998:	00000235 	udf	#565
     99c:	000000fe 	udf	#254
     9a0:	000000db 	udf	#219
     9a4:	021f0102 	.inst	0x021f0102 ; undefined
     9a8:	044c040f 	sabd	z15.h, p1/m, z15.h, z0.h
     9ac:	4c010000 	.inst	0x4c010000 ; undefined
     9b0:	01000004 	.inst	0x01000004 ; undefined
     9b4:	0000012b 	udf	#299
     9b8:	00011b02 	.inst	0x00011b02 ; undefined
     9bc:	01050300 	.inst	0x01050300 ; undefined
     9c0:	ac020900 	stnp	q0, q2, [x8, #64]
     9c4:	00400015 	.inst	0x00400015 ; undefined
     9c8:	14000000 	b	9c8 <GPR_FRAME_SIZE+0x8c8>
     9cc:	0100082e 	.inst	0x0100082e ; undefined
     9d0:	00005b01 	udf	#23297
     9d4:	08000500 	stxrb	w0, w0, [x8]
     9d8:	00004000 	udf	#16384
     9dc:	01010400 	.inst	0x01010400 ; undefined
     9e0:	000d0efb 	.inst	0x000d0efb ; undefined
     9e4:	01010101 	.inst	0x01010101 ; undefined
     9e8:	01000000 	.inst	0x01000000 ; undefined
     9ec:	01010000 	.inst	0x01010000 ; undefined
     9f0:	00041f01 	.inst	0x00041f01 ; undefined
     9f4:	35000000 	cbnz	w0, 9f4 <GPR_FRAME_SIZE+0x8f4>
     9f8:	fe000002 	.inst	0xfe000002 ; undefined
     9fc:	db000000 	.inst	0xdb000000 ; undefined
     a00:	02000000 	.inst	0x02000000 ; undefined
     a04:	0f021f01 	.inst	0x0f021f01 ; undefined
     a08:	00047f04 	.inst	0x00047f04 ; undefined
     a0c:	047f0100 	add	z0.h, z8.h, z31.h
     a10:	2b010000 	adds	w0, w0, w1
     a14:	02000001 	.inst	0x02000001 ; undefined
     a18:	0000011b 	udf	#283
     a1c:	00010503 	.inst	0x00010503 ; undefined
     a20:	15f80209 	b	7e01244 <GPR_FRAME_SIZE+0x7e01144>
     a24:	00004000 	udf	#16384
     a28:	2e140000 	ext	v0.8b, v0.8b, v20.8b, #0
     a2c:	01010008 	.inst	0x01010008 ; undefined
     a30:	0000005b 	udf	#91
     a34:	00080005 	.inst	0x00080005 ; undefined
     a38:	00000040 	udf	#64
     a3c:	fb010104 	.inst	0xfb010104 ; undefined
     a40:	01000d0e 	.inst	0x01000d0e ; undefined
     a44:	00010101 	.inst	0x00010101 ; undefined
     a48:	00010000 	.inst	0x00010000 ; undefined
     a4c:	01010100 	.inst	0x01010100 ; undefined
     a50:	0000041f 	udf	#1055
     a54:	02350000 	.inst	0x02350000 ; undefined
     a58:	00fe0000 	.inst	0x00fe0000 ; undefined
     a5c:	00db0000 	.inst	0x00db0000 ; undefined
     a60:	01020000 	.inst	0x01020000 ; undefined
     a64:	040f021f 	.inst	0x040f021f ; undefined
     a68:	000004b2 	udf	#1202
     a6c:	0004b201 	.inst	0x0004b201 ; undefined
     a70:	012b0100 	.inst	0x012b0100 ; undefined
     a74:	1b020000 	madd	w0, w0, w2, w0
     a78:	03000001 	.inst	0x03000001 ; undefined
     a7c:	09000105 	.inst	0x09000105 ; undefined
     a80:	00164402 	.inst	0x00164402 ; undefined
     a84:	00000040 	udf	#64
     a88:	082e1400 	.inst	0x082e1400 ; undefined
     a8c:	5b010100 	.inst	0x5b010100 ; undefined
     a90:	05000000 	orr	z0.s, z0.s, #0x1
     a94:	40000800 	.inst	0x40000800 ; undefined
     a98:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     a9c:	0efb0101 	.inst	0x0efb0101 ; undefined
     aa0:	0101000d 	.inst	0x0101000d ; undefined
     aa4:	00000101 	udf	#257
     aa8:	00000100 	udf	#256
     aac:	1f010101 	fmadd	s1, s8, s1, s0
     ab0:	00000004 	udf	#4
     ab4:	00023500 	.inst	0x00023500 ; undefined
     ab8:	0000fe00 	udf	#65024
     abc:	0000db00 	udf	#56064
     ac0:	1f010200 	fmadd	s0, s16, s1, s0
     ac4:	e6040f02 	.inst	0xe6040f02 ; undefined
     ac8:	01000004 	.inst	0x01000004 ; undefined
     acc:	000004e6 	udf	#1254
     ad0:	00012b01 	.inst	0x00012b01 ; undefined
     ad4:	011b0200 	.inst	0x011b0200 ; undefined
     ad8:	05030000 	orr	z0.d, z0.d, #0x100000000
     adc:	02090001 	.inst	0x02090001 ; undefined
     ae0:	40001690 	.inst	0x40001690 ; undefined
     ae4:	00000000 	udf	#0
     ae8:	00082e14 	.inst	0x00082e14 ; undefined
     aec:	005b0101 	.inst	0x005b0101 ; undefined
     af0:	00050000 	.inst	0x00050000 ; undefined
     af4:	00400008 	.inst	0x00400008 ; undefined
     af8:	01040000 	.inst	0x01040000 ; undefined
     afc:	0d0efb01 	.inst	0x0d0efb01 ; undefined
     b00:	01010100 	.inst	0x01010100 ; undefined
     b04:	00000001 	udf	#1
     b08:	01000001 	.inst	0x01000001 ; undefined
     b0c:	041f0101 	.inst	0x041f0101 ; undefined
     b10:	00000000 	udf	#0
     b14:	00000235 	udf	#565
     b18:	000000fe 	udf	#254
     b1c:	000000db 	udf	#219
     b20:	021f0102 	.inst	0x021f0102 ; undefined
     b24:	051a040f 	mov	z15.b, p10/z, #32
     b28:	1a010000 	adc	w0, w0, w1
     b2c:	01000005 	.inst	0x01000005 ; undefined
     b30:	0000012b 	udf	#299
     b34:	00011b02 	.inst	0x00011b02 ; undefined
     b38:	01050300 	.inst	0x01050300 ; undefined
     b3c:	dc020900 	.inst	0xdc020900 ; undefined
     b40:	00400016 	.inst	0x00400016 ; undefined
     b44:	14000000 	b	b44 <GPR_FRAME_SIZE+0xa44>
     b48:	0100082e 	.inst	0x0100082e ; undefined
     b4c:	00005b01 	udf	#23297
     b50:	08000500 	stxrb	w0, w0, [x8]
     b54:	00004000 	udf	#16384
     b58:	01010400 	.inst	0x01010400 ; undefined
     b5c:	000d0efb 	.inst	0x000d0efb ; undefined
     b60:	01010101 	.inst	0x01010101 ; undefined
     b64:	01000000 	.inst	0x01000000 ; undefined
     b68:	01010000 	.inst	0x01010000 ; undefined
     b6c:	00041f01 	.inst	0x00041f01 ; undefined
     b70:	35000000 	cbnz	w0, b70 <GPR_FRAME_SIZE+0xa70>
     b74:	fe000002 	.inst	0xfe000002 ; undefined
     b78:	db000000 	.inst	0xdb000000 ; undefined
     b7c:	02000000 	.inst	0x02000000 ; undefined
     b80:	0f021f01 	.inst	0x0f021f01 ; undefined
     b84:	00054e04 	.inst	0x00054e04 ; undefined
     b88:	054e0100 	.inst	0x054e0100 ; undefined
     b8c:	2b010000 	adds	w0, w0, w1
     b90:	02000001 	.inst	0x02000001 ; undefined
     b94:	0000011b 	udf	#283
     b98:	00010503 	.inst	0x00010503 ; undefined
     b9c:	17280209 	b	fffffffffca013c0 <__stack_el2_top+0xffffffffbb3fa3c0>
     ba0:	00004000 	udf	#16384
     ba4:	2e140000 	ext	v0.8b, v0.8b, v20.8b, #0
     ba8:	01010008 	.inst	0x01010008 ; undefined
     bac:	00000152 	udf	#338
     bb0:	00080005 	.inst	0x00080005 ; undefined
     bb4:	00000049 	udf	#73
     bb8:	fb010104 	.inst	0xfb010104 ; undefined
     bbc:	01000d0e 	.inst	0x01000d0e ; undefined
     bc0:	00010101 	.inst	0x00010101 ; undefined
     bc4:	00010000 	.inst	0x00010000 ; undefined
     bc8:	01010100 	.inst	0x01010100 ; undefined
     bcc:	0000051f 	udf	#1311
     bd0:	003e0000 	.inst	0x003e0000 ; NYI
     bd4:	00c30000 	.inst	0x00c30000 ; undefined
     bd8:	00db0000 	.inst	0x00db0000 ; undefined
     bdc:	00fe0000 	.inst	0x00fe0000 ; undefined
     be0:	01020000 	.inst	0x01020000 ; undefined
     be4:	050f021f 	.inst	0x050f021f ; undefined
     be8:	00000574 	udf	#1396
     bec:	00057401 	.inst	0x00057401 ; undefined
     bf0:	010e0100 	.inst	0x010e0100 ; undefined
     bf4:	1b020000 	madd	w0, w0, w2, w0
     bf8:	03000001 	.inst	0x03000001 ; undefined
     bfc:	0000012b 	udf	#299
     c00:	00010504 	.inst	0x00010504 ; undefined
     c04:	17740209 	b	fffffffffdd01428 <__stack_el2_top+0xffffffffbc6fa428>
     c08:	00004000 	udf	#16384
     c0c:	12030000 	and	w0, w0, #0x20000000
     c10:	3d100501 	str	b1, [x8, #1025]
     c14:	05302b05 	tbl	z5.b, {z24.b-z25.b}, z16.b
     c18:	02052e31 	.inst	0x02052e31 ; undefined
     c1c:	3d190520 	str	b0, [x9, #1601]
     c20:	052e1f05 	ext	z5.b, z5.b, z24.b, #119
     c24:	1c05200a 	ldr	s10, b024 <GPR_FRAME_SIZE+0xaf24>
     c28:	2e22053d 	uhadd	v29.8b, v9.8b, v2.8b
     c2c:	05200a05 	ext	z5.b, z5.b, z16.b, #2
     c30:	21053d1b 	.inst	0x21053d1b ; undefined
     c34:	200a052e 	.inst	0x200a052e ; undefined
     c38:	05390905 	ext	z5.b, z5.b, z8.b, #202
     c3c:	053f5c01 	.inst	0x053f5c01 ; undefined
     c40:	05053d0c 	.inst	0x05053d0c ; undefined
     c44:	3d030520 	str	b0, [x9, #193]
     c48:	220c0530 	.inst	0x220c0530 ; undefined
     c4c:	05200505 	ext	z5.b, z5.b, z8.b, #1
     c50:	05303d03 	.inst	0x05303d03 ; undefined
     c54:	0505220c 	.inst	0x0505220c ; undefined
     c58:	3d030520 	str	b0, [x9, #193]
     c5c:	220c0530 	.inst	0x220c0530 ; undefined
     c60:	05200505 	ext	z5.b, z5.b, z8.b, #1
     c64:	05303d03 	.inst	0x05303d03 ; undefined
     c68:	0d05231d 	.inst	0x0d05231d ; undefined
     c6c:	201b0530 	.inst	0x201b0530 ; undefined
     c70:	05200505 	ext	z5.b, z5.b, z8.b, #1
     c74:	0402002a 	.inst	0x0402002a ; undefined
     c78:	38052e01 	strb	w1, [x16, #82]!
     c7c:	01040200 	.inst	0x01040200 ; undefined
     c80:	00200520 	.inst	0x00200520 ; NYI
     c84:	20010402 	.inst	0x20010402 ; undefined
     c88:	052f0a05 	ext	z5.b, z5.b, z16.b, #122
     c8c:	3d05201b 	str	b27, [x0, #328]
     c90:	02040200 	.inst	0x02040200 ; undefined
     c94:	2f2d051f 	ushr	v31.2s, v8.2s, #19
     c98:	05203d05 	.inst	0x05203d05 ; undefined
     c9c:	03052023 	.inst	0x03052023 ; undefined
     ca0:	0801052f 	stxrb	w1, w15, [x9]
     ca4:	05053f14 	.inst	0x05053f14 ; undefined
     ca8:	000b0567 	.inst	0x000b0567 ; undefined
     cac:	4a010402 	eor	w2, w0, w1, lsl #1
     cb0:	05220505 	ext	z5.b, z5.b, z8.b, #17
     cb4:	0402000b 	.inst	0x0402000b ; undefined
     cb8:	05054a01 	.inst	0x05054a01 ; undefined
     cbc:	000e0522 	.inst	0x000e0522 ; undefined
     cc0:	4a010402 	eor	w2, w0, w1, lsl #1
     cc4:	05220505 	ext	z5.b, z5.b, z8.b, #17
     cc8:	0402000d 	.inst	0x0402000d ; undefined
     ccc:	01054a01 	.inst	0x01054a01 ; undefined
     cd0:	05053f21 	.inst	0x05053f21 ; undefined
     cd4:	000b0567 	.inst	0x000b0567 ; undefined
     cd8:	4a010402 	eor	w2, w0, w1, lsl #1
     cdc:	05220505 	ext	z5.b, z5.b, z8.b, #17
     ce0:	0402000b 	.inst	0x0402000b ; undefined
     ce4:	05054a01 	.inst	0x05054a01 ; undefined
     ce8:	000e0522 	.inst	0x000e0522 ; undefined
     cec:	4a010402 	eor	w2, w0, w1, lsl #1
     cf0:	05220505 	ext	z5.b, z5.b, z8.b, #17
     cf4:	0402000d 	.inst	0x0402000d ; undefined
     cf8:	01054a01 	.inst	0x01054a01 ; undefined
     cfc:	00030221 	.inst	0x00030221 ; undefined
     d00:	02710101 	.inst	0x02710101 ; undefined
     d04:	00050000 	.inst	0x00050000 ; undefined
     d08:	00400008 	.inst	0x00400008 ; undefined
     d0c:	01040000 	.inst	0x01040000 ; undefined
     d10:	0d0efb01 	.inst	0x0d0efb01 ; undefined
     d14:	01010100 	.inst	0x01010100 ; undefined
     d18:	00000001 	udf	#1
     d1c:	01000001 	.inst	0x01000001 ; undefined
     d20:	041f0101 	.inst	0x041f0101 ; undefined
     d24:	00000000 	udf	#0
     d28:	00000593 	udf	#1427
     d2c:	000000db 	udf	#219
     d30:	000000fe 	udf	#254
     d34:	021f0102 	.inst	0x021f0102 ; undefined
     d38:	058a040f 	.inst	0x058a040f ; undefined
     d3c:	8a010000 	and	x0, x0, x1
     d40:	01000005 	.inst	0x01000005 ; undefined
     d44:	0000011b 	udf	#283
     d48:	00012b02 	.inst	0x00012b02 ; undefined
     d4c:	01050300 	.inst	0x01050300 ; undefined
     d50:	04020900 	.inst	0x04020900 ; undefined
     d54:	0040001a 	.inst	0x0040001a ; undefined
     d58:	18000000 	ldr	w0, d58 <GPR_FRAME_SIZE+0xc58>
     d5c:	054b0e05 	.inst	0x054b0e05 ; undefined
     d60:	0f052002 	.inst	0x0f052002 ; undefined
     d64:	3c060521 	str	b1, [x9], #96
     d68:	053c0f05 	ext	z5.b, z5.b, z24.b, #227
     d6c:	0522200a 	mov	z10.h, h0
     d70:	28054a06 	stnp	w6, w18, [x16, #40]
     d74:	02040200 	.inst	0x02040200 ; undefined
     d78:	0022052b 	.inst	0x0022052b ; NYI
     d7c:	3c010402 	str	b2, [x0], #16
     d80:	02001705 	.inst	0x02001705 ; undefined
     d84:	052e0104 	ext	z4.b, z4.b, z8.b, #112
     d88:	14054205 	b	15159c <GPR_FRAME_SIZE+0x15149c>
     d8c:	2b17054a 	adds	w10, w10, w23, lsl #1
     d90:	31240105 	adds	w5, w8, #0x900
     d94:	053d0505 	ext	z5.b, z5.b, z8.b, #233
     d98:	09053d03 	.inst	0x09053d03 ; undefined
     d9c:	01051708 	.inst	0x01051708 ; undefined
     da0:	2e09033d 	ext	v29.8b, v25.8b, v9.8b, #0
     da4:	05750905 	ext	z5.b, {z8.b-z9.b}, #170
     da8:	0d052102 	.inst	0x0d052102 ; undefined
     dac:	04053208 	addqv	v8.16b, p4, z16.b
     db0:	220d052f 	.inst	0x220d052f ; undefined
     db4:	052f0405 	ext	z5.b, z5.b, z0.b, #121
     db8:	0405220d 	addqv	v13.16b, p0, z16.b
     dbc:	7503222f 	.inst	0x7503222f ; undefined
     dc0:	08051208 	stxrb	w5, w8, [x16]
     dc4:	05200f03 	ext	z3.b, z3.b, z24.b, #3
     dc8:	02052109 	.inst	0x02052109 ; undefined
     dcc:	02140522 	.inst	0x02140522 ; undefined
     dd0:	1105142b 	add	w11, w1, #0x145
     dd4:	2f0e0520 	ushr	v0.8b, v9.8b, #2
     dd8:	052f0405 	ext	z5.b, z5.b, z0.b, #121
     ddc:	13052216 	sbfx	w22, w16, #5, #4
     de0:	2f0e0520 	ushr	v0.8b, v9.8b, #2
     de4:	05210405 	ext	z5.b, z5.b, z0.b, #9
     de8:	11052214 	add	w20, w16, #0x148
     dec:	2f0e0520 	ushr	v0.8b, v9.8b, #2
     df0:	052f0405 	ext	z5.b, z5.b, z0.b, #121
     df4:	13052216 	sbfx	w22, w16, #5, #4
     df8:	2f0e0520 	ushr	v0.8b, v9.8b, #2
     dfc:	05210405 	ext	z5.b, z5.b, z0.b, #9
     e00:	11052214 	add	w20, w16, #0x148
     e04:	2f0e0520 	ushr	v0.8b, v9.8b, #2
     e08:	052f0405 	ext	z5.b, z5.b, z0.b, #121
     e0c:	13052216 	sbfx	w22, w16, #5, #4
     e10:	2f0e0520 	ushr	v0.8b, v9.8b, #2
     e14:	05210405 	ext	z5.b, z5.b, z0.b, #9
     e18:	0e052211 	tbl	v17.8b, {v16.16b-v17.16b}, v5.8b
     e1c:	2f04052f 	mvni	v15.2s, #0x89
     e20:	05221305 	ext	z5.b, z5.b, z24.b, #20
     e24:	04052f0e 	addqv	v14.16b, p3, z24.b
     e28:	07052221 	.inst	0x07052221 ; undefined
     e2c:	05051608 	.inst	0x05051608 ; undefined
     e30:	4b060522 	sub	w2, w9, w6, lsl #1
     e34:	053d0d05 	ext	z5.b, z5.b, z8.b, #235
     e38:	0a052f14 	and	w20, w24, w5, lsl #11
     e3c:	0905302e 	.inst	0x0905302e ; undefined
     e40:	3105053f 	cmn	w9, #0x141
     e44:	02001405 	.inst	0x02001405 ; undefined
     e48:	053c0104 	ext	z4.b, z4.b, z8.b, #224
     e4c:	04020011 	.inst	0x04020011 ; undefined
     e50:	13053c01 	sbfx	w1, w0, #5, #11
     e54:	2e06053d 	.inst	0x2e06053d ; undefined
     e58:	053d0905 	ext	z5.b, z5.b, z8.b, #234
     e5c:	0a052103 	and	w3, w8, w5, lsl #8
     e60:	08053208 	stxrb	w5, w8, [x16]
     e64:	2e0e054a 	.inst	0x2e0e054a ; undefined
     e68:	052f0a05 	ext	z5.b, z5.b, z16.b, #122
     e6c:	0e054a08 	.inst	0x0e054a08 ; undefined
     e70:	2f05052e 	mvni	v14.2s, #0xa9
     e74:	05220a05 	ext	z5.b, z5.b, z16.b, #18
     e78:	0e054a08 	.inst	0x0e054a08 ; undefined
     e7c:	2f0a052e 	ushr	v14.8b, v9.8b, #6
     e80:	054a0805 	.inst	0x054a0805 ; undefined
     e84:	05052e0e 	.inst	0x05052e0e ; undefined
     e88:	220a052f 	.inst	0x220a052f ; undefined
     e8c:	054a0805 	.inst	0x054a0805 ; undefined
     e90:	05052e0e 	.inst	0x05052e0e ; undefined
     e94:	2075032f 	.inst	0x2075032f ; undefined
     e98:	0d030805 	.inst	0x0d030805 ; undefined
     e9c:	4a060520 	eor	w0, w9, w6, lsl #1
     ea0:	052e0c05 	ext	z5.b, z5.b, z0.b, #115
     ea4:	0a052f06 	and	w6, w24, w5, lsl #11
     ea8:	0905213c 	.inst	0x0905213c ; undefined
     eac:	21080531 	.inst	0x21080531 ; undefined
     eb0:	05221705 	ext	z5.b, z5.b, z24.b, #21
     eb4:	05215809 	.inst	0x05215809 ; undefined
     eb8:	0d054d0f 	.inst	0x0d054d0f ; undefined
     ebc:	2e200520 	uhadd	v0.8b, v9.8b, v0.8b
     ec0:	053c0605 	ext	z5.b, z5.b, z16.b, #225
     ec4:	08053e24 	stxrb	w5, w4, [x17]
     ec8:	3c060520 	str	b0, [x9], #96
     ecc:	052e2405 	dupq	z5.h, z0.h[3]
     ed0:	0f054a0c 	.inst	0x0f054a0c ; undefined
     ed4:	05207803 	.inst	0x05207803 ; undefined
     ed8:	3c0b0302 	stur	b2, [x24, #176]
     edc:	32080905 	orr	w5, w8, #0x7000000
     ee0:	053c0705 	ext	z5.b, z5.b, z24.b, #225
     ee4:	09052e0d 	.inst	0x09052e0d ; undefined
     ee8:	3c07052f 	str	b15, [x9], #112
     eec:	052e0d05 	ext	z5.b, z5.b, z8.b, #115
     ef0:	09052f04 	.inst	0x09052f04 ; undefined
     ef4:	3c070522 	str	b2, [x9], #112
     ef8:	052e0d05 	ext	z5.b, z5.b, z8.b, #115
     efc:	07052f09 	.inst	0x07052f09 ; undefined
     f00:	2e0d053c 	.inst	0x2e0d053c ; undefined
     f04:	052f0405 	ext	z5.b, z5.b, z0.b, #121
     f08:	07052209 	.inst	0x07052209 ; undefined
     f0c:	2e0d053c 	.inst	0x2e0d053c ; undefined
     f10:	032f0405 	.inst	0x032f0405 ; undefined
     f14:	05052075 	.inst	0x05052075 ; undefined
     f18:	05200e03 	ext	z3.b, z3.b, z16.b, #3
     f1c:	04020015 	.inst	0x04020015 ; undefined
     f20:	13054a01 	sbfx	w1, w16, #5, #14
     f24:	01040200 	.inst	0x01040200 ; undefined
     f28:	0019053c 	.inst	0x0019053c ; undefined
     f2c:	2e010402 	.inst	0x2e010402 ; undefined
     f30:	052f0505 	ext	z5.b, z5.b, z8.b, #121
     f34:	21233c09 	.inst	0x21233c09 ; undefined
     f38:	053d0805 	ext	z5.b, z5.b, z0.b, #234
     f3c:	08052111 	stxrb	w5, w17, [x8]
     f40:	2f13053c 	ushr	v28.4h, v9.4h, #13
     f44:	053c0605 	ext	z5.b, z5.b, z16.b, #225
     f48:	0e053c13 	umov	w19, v0.b[2]
     f4c:	21060520 	.inst	0x21060520 ; undefined
     f50:	053c0c05 	ext	z5.b, z5.b, z0.b, #227
     f54:	06052f08 	.inst	0x06052f08 ; undefined
     f58:	370f053d 	tbnz	w29, #1, ffffffffffffeffc <__stack_el2_top+0xffffffffbe9f7ffc>
     f5c:	05520905 	mov	z5.h, p2/z, #72
     f60:	2e40031f 	.inst	0x2e40031f ; undefined
     f64:	1d033705 	cpypt	[x5]!, [x3]!, x24!
     f68:	0302052e 	.inst	0x0302052e ; undefined
     f6c:	01052026 	.inst	0x01052026 ; undefined
     f70:	02021708 	.inst	0x02021708 ; undefined
     f74:	5a010100 	sbc	w0, w8, w1
     f78:	05000001 	orr	z1.s, z1.s, #0x1
     f7c:	53000800 	ubfx	w0, w0, #0, #3
     f80:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     f84:	0efb0101 	.inst	0x0efb0101 ; undefined
     f88:	0101000d 	.inst	0x0101000d ; undefined
     f8c:	00000101 	udf	#257
     f90:	00000100 	udf	#256
     f94:	1f010101 	fmadd	s1, s8, s1, s0
     f98:	00000005 	udf	#5
     f9c:	00006d00 	udf	#27904
     fa0:	0000db00 	udf	#56064
     fa4:	0000fe00 	udf	#65024
     fa8:	0000e800 	udf	#59392
     fac:	1f010200 	fmadd	s0, s16, s1, s0
     fb0:	ac070f02 	stnp	q2, q3, [x24, #224]
     fb4:	01000005 	.inst	0x01000005 ; undefined
     fb8:	000005ac 	udf	#1452
     fbc:	00011b01 	.inst	0x00011b01 ; undefined
     fc0:	012b0200 	.inst	0x012b0200 ; undefined
     fc4:	24030000 	cmphs	p0.b, p0/z, z0.b, z3.b
     fc8:	04000001 	add	z1.b, p0/m, z1.b, z0.b
     fcc:	00000133 	udf	#307
     fd0:	0005b502 	.inst	0x0005b502 ; undefined
     fd4:	01050200 	.inst	0x01050200 ; undefined
     fd8:	d0020900 	adrp	x0, 4122000 <GPR_FRAME_SIZE+0x4121f00>
     fdc:	00400021 	.inst	0x00400021 ; undefined
     fe0:	03000000 	.inst	0x03000000 ; undefined
     fe4:	05050111 	.inst	0x05050111 ; undefined
     fe8:	00180559 	.inst	0x00180559 ; undefined
     fec:	3c010402 	str	b2, [x0], #16
     ff0:	07052006 	.inst	0x07052006 ; undefined
     ff4:	14052206 	b	14980c <GPR_FRAME_SIZE+0x14970c>
     ff8:	20050520 	.inst	0x20050520 ; undefined
     ffc:	052f0305 	ext	z5.b, z5.b, z24.b, #120
    1000:	05140807 	mov	z7.b, p4/z, #64
    1004:	05052014 	.inst	0x05052014 ; undefined
    1008:	2f030520 	mvni	v0.2s, #0x69
    100c:	14080c05 	b	204020 <GPR_FRAME_SIZE+0x203f20>
    1010:	052e0505 	ext	z5.b, z5.b, z8.b, #113
    1014:	09052f03 	.inst	0x09052f03 ; undefined
    1018:	01051408 	.inst	0x01051408 ; undefined
    101c:	0505314b 	.inst	0x0505314b ; undefined
    1020:	00180559 	.inst	0x00180559 ; undefined
    1024:	3c010402 	str	b2, [x0], #16
    1028:	0c052006 	.inst	0x0c052006 ; undefined
    102c:	05052206 	.inst	0x05052206 ; undefined
    1030:	0018052e 	.inst	0x0018052e ; undefined
    1034:	2e010402 	.inst	0x2e010402 ; undefined
    1038:	14080905 	b	20344c <GPR_FRAME_SIZE+0x20334c>
    103c:	034b0105 	.inst	0x034b0105 ; undefined
    1040:	0e052e16 	smov	w22, v16.b[2]
    1044:	2002053f 	.inst	0x2002053f ; undefined
    1048:	05210c05 	ext	z5.b, z5.b, z0.b, #11
    104c:	2705740a 	.inst	0x2705740a ; undefined
    1050:	03040200 	.inst	0x03040200 ; undefined
    1054:	00170565 	.inst	0x00170565 ; undefined
    1058:	3c010402 	str	b2, [x0], #16
    105c:	054e0e05 	.inst	0x054e0e05 ; undefined
    1060:	0f052e02 	.inst	0x0f052e02 ; undefined
    1064:	20030521 	.inst	0x20030521 ; undefined
    1068:	05210b05 	ext	z5.b, z5.b, z24.b, #10
    106c:	04020028 	.inst	0x04020028 ; undefined
    1070:	18056503 	ldr	w3, bd10 <GPR_FRAME_SIZE+0xbc10>
    1074:	01040200 	.inst	0x01040200 ; undefined
    1078:	4e03053c 	dup	v28.16b, v9.b[1]
    107c:	05f40f05 	.inst	0x05f40f05 ; undefined
    1080:	22052003 	.inst	0x22052003 ; undefined
    1084:	580b0521 	ldr	x1, 17128 <GPR_FRAME_SIZE+0x17028>
    1088:	053d1f05 	ext	z5.b, z5.b, z24.b, #239
    108c:	07055808 	.inst	0x07055808 ; undefined
    1090:	3005053b 	adr	x27, b135 <GPR_FRAME_SIZE+0xb035>
    1094:	001e054c 	.inst	0x001e054c ; undefined
    1098:	29020402 	stp	w2, w1, [x0, #16]
    109c:	02001805 	.inst	0x02001805 ; undefined
    10a0:	053c0104 	ext	z4.b, z4.b, z8.b, #224
    10a4:	4a090309 	eor	w9, w24, w9
    10a8:	059e0605 	mov	z5.s, p14/z, #48
    10ac:	26052f04 	.inst	0x26052f04 ; undefined
    10b0:	2e08054c 	.inst	0x2e08054c ; undefined
    10b4:	3f730405 	.inst	0x3f730405 ; undefined
    10b8:	02003005 	.inst	0x02003005 ; undefined
    10bc:	6b030204 	subs	w4, w16, w3
    10c0:	0020054a 	.inst	0x0020054a ; NYI
    10c4:	3c010402 	str	b2, [x0], #16
    10c8:	19030205 	stlurb	w5, [x16, #48]
    10cc:	4b01054a 	sub	w10, w10, w1, lsl #1
    10d0:	01000302 	.inst	0x01000302 ; undefined
    10d4:	00026c01 	.inst	0x00026c01 ; undefined
    10d8:	08000500 	stxrb	w0, w0, [x8]
    10dc:	00008200 	udf	#33280
    10e0:	01010400 	.inst	0x01010400 ; undefined
    10e4:	000d0efb 	.inst	0x000d0efb ; undefined
    10e8:	01010101 	.inst	0x01010101 ; undefined
    10ec:	01000000 	.inst	0x01000000 ; undefined
    10f0:	01010000 	.inst	0x01010000 ; undefined
    10f4:	00081f01 	.inst	0x00081f01 ; undefined
    10f8:	e4000000 	.inst	0xe4000000 ; undefined
    10fc:	7c000005 	stur	h5, [x0]
    1100:	db000001 	.inst	0xdb000001 ; undefined
    1104:	a8000000 	stnp	x0, x0, [x0]
    1108:	02000001 	.inst	0x02000001 ; undefined
    110c:	b5000006 	cbnz	x6, 110c <GPR_FRAME_SIZE+0x100c>
    1110:	fe000001 	.inst	0xfe000001 ; undefined
    1114:	02000000 	.inst	0x02000000 ; undefined
    1118:	0f021f01 	.inst	0x0f021f01 ; undefined
    111c:	0005dc0e 	.inst	0x0005dc0e ; undefined
    1120:	061e0100 	.inst	0x061e0100 ; undefined
    1124:	2d020000 	stp	s0, s0, [x0, #16]
    1128:	02000006 	.inst	0x02000006 ; undefined
    112c:	0000063a 	udf	#1594
    1130:	00064702 	.inst	0x00064702 ; undefined
    1134:	06590200 	.inst	0x06590200 ; undefined
    1138:	68020000 	.inst	0x68020000 ; undefined
    113c:	02000006 	.inst	0x02000006 ; undefined
    1140:	00000679 	udf	#1657
    1144:	0005dc02 	.inst	0x0005dc02 ; undefined
    1148:	011b0100 	.inst	0x011b0100 ; undefined
    114c:	d4030000 	.inst	0xd4030000 ; undefined
    1150:	04000001 	add	z1.b, p0/m, z1.b, z0.b
    1154:	00000686 	udf	#1670
    1158:	0001da05 	.inst	0x0001da05 ; undefined
    115c:	012b0600 	.inst	0x012b0600 ; undefined
    1160:	05070000 	.inst	0x05070000 ; undefined
    1164:	02090001 	.inst	0x02090001 ; undefined
    1168:	400025c8 	.inst	0x400025c8 ; undefined
    116c:	00000000 	udf	#0
    1170:	2e011303 	ext	v3.8b, v24.8b, v1.8b, #2
    1174:	0c033c86 	.inst	0x0c033c86 ; undefined
    1178:	5905059e 	.inst	0x5905059e ; undefined
    117c:	02001005 	.inst	0x02001005 ; undefined
    1180:	053c0104 	ext	z4.b, z4.b, z8.b, #224
    1184:	0514080d 	mov	z13.b, p4/z, #64
    1188:	13052e1b 	sbfx	w27, w16, #5, #7
    118c:	2e32053c 	uhadd	v28.8b, v9.8b, v18.8b
    1190:	05203905 	mov	z5.b, w8
    1194:	09052e24 	.inst	0x09052e24 ; undefined
    1198:	2f010520 	mvni	v0.2s, #0x29
    119c:	6a030204 	ands	w4, w16, w3
    11a0:	db03013c 	.inst	0xdb03013c ; undefined
    11a4:	042e4a00 	index	z0.b, #-16, w14
    11a8:	7fa70303 	.inst	0x7fa70303 ; undefined
    11ac:	3c862e66 	str	q6, [x19, #98]!
    11b0:	059e1003 	mov	z3.s, p14/z, #-128
    11b4:	11055905 	add	w5, w8, #0x156
    11b8:	01040200 	.inst	0x01040200 ; undefined
    11bc:	0805053c 	stxrb	w5, w28, [x9]
    11c0:	00100513 	.inst	0x00100513 ; undefined
    11c4:	3c010402 	str	b2, [x0], #16
    11c8:	02001e05 	.inst	0x02001e05 ; undefined
    11cc:	053c0204 	ext	z4.b, z4.b, z16.b, #224
    11d0:	05140809 	mov	z9.b, p4/z, #64
    11d4:	1d053e0d 	.inst	0x1d053e0d ; undefined
    11d8:	3c13052e 	str	b14, [x9], #-208
    11dc:	052e3605 	tbxq	z5.b, z16.b, z14.b
    11e0:	28052e3f 	stnp	wzr, w11, [x17, #40]
    11e4:	2009052e 	.inst	0x2009052e ; undefined
    11e8:	042f0105 	add	z5.b, z8.b, z15.b
    11ec:	3c650304 	.inst	0x3c650304 ; undefined
    11f0:	033c872e 	.inst	0x033c872e ; undefined
    11f4:	05059e11 	.inst	0x05059e11 ; undefined
    11f8:	00140559 	.inst	0x00140559 ; undefined
    11fc:	3c010402 	str	b2, [x0], #16
    1200:	14080905 	b	203614 <GPR_FRAME_SIZE+0x203514>
    1204:	053f0505 	ext	z5.b, z5.b, z8.b, #249
    1208:	0b052e16 	add	w22, w16, w5, lsl #11
    120c:	2e36053c 	uhadd	v28.8b, v9.8b, v22.8b
    1210:	05204005 	zip1	p5.b, p0.b, p0.b
    1214:	09052e21 	.inst	0x09052e21 ; undefined
    1218:	3001051f 	adr	xzr, 32b9 <GPR_FRAME_SIZE+0x31b9>
    121c:	67030504 	.inst	0x67030504 ; undefined
    1220:	10033c3c 	adr	x28, 79a4 <GPR_FRAME_SIZE+0x78a4>
    1224:	3cb13c9e 	.inst	0x3cb13c9e ; undefined
    1228:	3cb13cb1 	.inst	0x3cb13cb1 ; undefined
    122c:	06043cb1 	.inst	0x06043cb1 ; undefined
    1230:	05905503 	mov	z3.s, p0/m, #-88
    1234:	10054b05 	adr	x5, bb94 <GPR_FRAME_SIZE+0xba94>
    1238:	01040200 	.inst	0x01040200 ; undefined
    123c:	0808053c 	stxrb	w8, w28, [x9]
    1240:	3b270515 	.inst	0x3b270515 ; undefined
    1244:	05584405 	mov	z5.h, p8/m, #32
    1248:	07043001 	.inst	0x07043001 ; undefined
    124c:	3c852e38 	str	q24, [x17, #82]!
    1250:	2e9e1503 	.inst	0x2e9e1503 ; undefined
    1254:	08043c79 	stxrb	w4, w25, [x3]
    1258:	05ac5f03 	.inst	0x05ac5f03 ; undefined
    125c:	1b053d14 	madd	w20, w8, w5, w15
    1260:	0009052f 	.inst	0x0009052f ; undefined
    1264:	3c010402 	str	b2, [x0], #16
    1268:	05222805 	tbl	z5.b, {z0.b-z1.b}, z2.b
    126c:	05052e09 	.inst	0x05052e09 ; undefined
    1270:	00110530 	.inst	0x00110530 ; undefined
    1274:	3c020402 	str	b2, [x0], #32
    1278:	02002505 	.inst	0x02002505 ; undefined
    127c:	054a0304 	.inst	0x054a0304 ; undefined
    1280:	3f130801 	.inst	0x3f130801 ; undefined
    1284:	054c0905 	.inst	0x054c0905 ; undefined
    1288:	09053e02 	.inst	0x09053e02 ; undefined
    128c:	18053d30 	ldr	w16, ba30 <GPR_FRAME_SIZE+0xb930>
    1290:	3d02053e 	str	b30, [x9, #129]
    1294:	3d01054b 	str	b11, [x10, #65]
    1298:	4b09053f 	sub	wzr, w9, w9, lsl #1
    129c:	053e0205 	ext	z5.b, z5.b, z16.b, #240
    12a0:	0205300e 	.inst	0x0205300e ; undefined
    12a4:	3d3d3e22 	str	b2, [x17, #3919]
    12a8:	01053e3d 	.inst	0x01053e3d ; undefined
    12ac:	02053f3d 	.inst	0x02053f3d ; undefined
    12b0:	0402003d 	.inst	0x0402003d ; undefined
    12b4:	05200601 	ext	z1.b, z1.b, z16.b, #1
    12b8:	3f3d0601 	.inst	0x3f3d0601 ; undefined
    12bc:	053d0905 	ext	z5.b, z5.b, z8.b, #234
    12c0:	09053e02 	.inst	0x09053e02 ; undefined
    12c4:	02053d30 	.inst	0x02053d30 ; undefined
    12c8:	3d01053e 	str	b30, [x9, #65]
    12cc:	4b09053f 	sub	wzr, w9, w9, lsl #1
    12d0:	053e0205 	ext	z5.b, z5.b, z16.b, #240
    12d4:	053d3009 	tbl	z9.b, {z0.b}, z29.b
    12d8:	02053e14 	.inst	0x02053e14 ; undefined
    12dc:	01054b3d 	.inst	0x01054b3d ; undefined
    12e0:	09053f3d 	.inst	0x09053f3d ; undefined
    12e4:	3e02053d 	.inst	0x3e02053d ; undefined
    12e8:	3d300905 	str	b5, [x8, #3074]
    12ec:	053e1005 	ext	z5.b, z5.b, z0.b, #244
    12f0:	054b3d02 	.inst	0x054b3d02 ; undefined
    12f4:	053f3d01 	.inst	0x053f3d01 ; undefined
    12f8:	02053d09 	.inst	0x02053d09 ; undefined
    12fc:	3009053e 	adr	x30, 133a1 <GPR_FRAME_SIZE+0x132a1>
    1300:	3e10053d 	.inst	0x3e10053d ; undefined
    1304:	4b3d0205 	sub	w5, w16, w29, uxtb
    1308:	3f3d0105 	.inst	0x3f3d0105 ; undefined
    130c:	053d1005 	ext	z5.b, z5.b, z0.b, #236
    1310:	053d3d02 	.inst	0x053d3d02 ; undefined
    1314:	08053e07 	stxrb	w5, w7, [x16]
    1318:	210f0530 	.inst	0x210f0530 ; undefined
    131c:	05200305 	ext	z5.b, z5.b, z24.b, #0
    1320:	04020025 	.inst	0x04020025 ; undefined
    1324:	21052003 	.inst	0x21052003 ; undefined
    1328:	03040200 	.inst	0x03040200 ; undefined
    132c:	00180520 	.inst	0x00180520 ; undefined
    1330:	3c010402 	str	b2, [x0], #16
    1334:	054c1105 	.inst	0x054c1105 ; undefined
    1338:	09053d0c 	.inst	0x09053d0c ; undefined
    133c:	50010538 	adr	x24, 33e2 <GPR_FRAME_SIZE+0x32e2>
    1340:	01000402 	.inst	0x01000402 ; undefined
    1344:	00021801 	.inst	0x00021801 ; undefined
    1348:	08000500 	stxrb	w0, w0, [x8]
    134c:	00008400 	udf	#33792
    1350:	01010400 	.inst	0x01010400 ; undefined
    1354:	000d0efb 	.inst	0x000d0efb ; undefined
    1358:	01010101 	.inst	0x01010101 ; undefined
    135c:	01000000 	.inst	0x01000000 ; undefined
    1360:	01010000 	.inst	0x01010000 ; undefined
    1364:	00061f01 	.inst	0x00061f01 ; undefined
    1368:	ca000000 	eor	x0, x0, x0
    136c:	dc000006 	.inst	0xdc000006 ; undefined
    1370:	db000006 	.inst	0xdb000006 ; undefined
    1374:	e8000000 	.inst	0xe8000000 ; undefined
    1378:	b5000000 	cbnz	x0, 1378 <GPR_FRAME_SIZE+0x1278>
    137c:	02000001 	.inst	0x02000001 ; undefined
    1380:	0f021f01 	.inst	0x0f021f01 ; undefined
    1384:	0006c310 	.inst	0x0006c310 ; undefined
    1388:	06f60100 	.inst	0x06f60100 ; undefined
    138c:	02020000 	.inst	0x02020000 ; undefined
    1390:	02000007 	.inst	0x02000007 ; undefined
    1394:	0000070e 	udf	#1806
    1398:	00071a02 	.inst	0x00071a02 ; undefined
    139c:	07260200 	.inst	0x07260200 ; undefined
    13a0:	32020000 	orr	w0, w0, #0x40000000
    13a4:	02000007 	.inst	0x02000007 ; undefined
    13a8:	0000073e 	udf	#1854
    13ac:	00074a02 	.inst	0x00074a02 ; undefined
    13b0:	07560200 	.inst	0x07560200 ; undefined
    13b4:	62020000 	.inst	0x62020000 ; undefined
    13b8:	02000007 	.inst	0x02000007 ; undefined
    13bc:	0000076d 	udf	#1901
    13c0:	0006c302 	.inst	0x0006c302 ; undefined
    13c4:	011b0100 	.inst	0x011b0100 ; undefined
    13c8:	24030000 	cmphs	p0.b, p0/z, z0.b, z3.b
    13cc:	04000001 	add	z1.b, p0/m, z1.b, z0.b
    13d0:	000001da 	udf	#474
    13d4:	00010505 	.inst	0x00010505 ; undefined
    13d8:	2fe80209 	.inst	0x2fe80209 ; undefined
    13dc:	00004000 	udf	#16384
    13e0:	17030000 	b	fffffffffc0c13e0 <__stack_el2_top+0xffffffffbaaba3e0>
    13e4:	0c033c01 	.inst	0x0c033c01 ; undefined
    13e8:	02043c74 	.inst	0x02043c74 ; undefined
    13ec:	3c907303 	stur	q3, [x24, #-249]
    13f0:	3c740c03 	.inst	0x3c740c03 ; undefined
    13f4:	74030304 	.inst	0x74030304 ; undefined
    13f8:	0d033c90 	.inst	0x0d033c90 ; undefined
    13fc:	04043c74 	.inst	0x04043c74 ; undefined
    1400:	2e907003 	.inst	0x2e907003 ; undefined
    1404:	12033c5b 	and	w27, w2, #0xe0001fff
    1408:	2f033c74 	.inst	0x2f033c74 ; undefined
    140c:	0f033cac 	.inst	0x0f033cac ; undefined
    1410:	3cb13cac 	.inst	0x3cb13cac ; undefined
    1414:	05043cb1 	.inst	0x05043cb1 ; undefined
    1418:	907fa603 	adrp	x3, ff4c1000 <__stack_el2_top+0xbdeba000>
    141c:	7424033c 	.inst	0x7424033c ; undefined
    1420:	b13cb13c 	adds	x28, x9, #0xf2c
    1424:	ac1e033c 	stnp	q28, q0, [x25, #960]
    1428:	0306043c 	.inst	0x0306043c ; undefined
    142c:	3cac7fb4 	.inst	0x3cac7fb4 ; undefined
    1430:	3c740d03 	.inst	0x3c740d03 ; undefined
    1434:	73030704 	.inst	0x73030704 ; undefined
    1438:	08043cac 	stxrb	w4, w12, [x5]
    143c:	09043c74 	.inst	0x09043c74 ; undefined
    1440:	0a032e71 	and	w17, w19, w3, lsl #11
    1444:	0a042e4a 	and	w10, w18, w4, lsl #11
    1448:	2e4a7603 	.inst	0x2e4a7603 ; undefined
    144c:	2e582e03 	facge	v3.4h, v16.4h, v24.4h
    1450:	0a032e79 	and	w25, w19, w3, lsl #11
    1454:	0b042e74 	add	w20, w19, w4, lsl #11
    1458:	3c744203 	.inst	0x3c744203 ; undefined
    145c:	05730c04 	ext	z4.b, {z0.b-z1.b}, #155
    1460:	09053d15 	.inst	0x09053d15 ; undefined
    1464:	3d01053d 	str	b29, [x9, #65]
    1468:	4b180531 	sub	w17, w9, w24, lsl #1
    146c:	05201005 	ext	z5.b, z5.b, z0.b, #4
    1470:	03052208 	.inst	0x03052208 ; undefined
    1474:	1f260521 	fnmadd	s1, s9, s6, s1
    1478:	004a0905 	.inst	0x004a0905 ; undefined
    147c:	06010402 	.inst	0x06010402 ; undefined
    1480:	061d052e 	.inst	0x061d052e ; undefined
    1484:	4a020540 	eor	w0, w10, w2, lsl #1
    1488:	3f2f0105 	.inst	0x3f2f0105 ; undefined
    148c:	054b0805 	.inst	0x054b0805 ; undefined
    1490:	0402001d 	.inst	0x0402001d ; undefined
    1494:	0d052002 	.inst	0x0d052002 ; undefined
    1498:	02040200 	.inst	0x02040200 ; undefined
    149c:	0009053c 	.inst	0x0009053c ; undefined
    14a0:	4a010402 	eor	w2, w0, w1, lsl #1
    14a4:	4d4b0105 	.inst	0x4d4b0105 ; undefined
    14a8:	053d0a05 	ext	z5.b, z5.b, z16.b, #234
    14ac:	02055917 	.inst	0x02055917 ; undefined
    14b0:	400f053d 	.inst	0x400f053d ; undefined
    14b4:	05200305 	ext	z5.b, z5.b, z24.b, #0
    14b8:	04020025 	.inst	0x04020025 ; undefined
    14bc:	21052003 	.inst	0x21052003 ; undefined
    14c0:	03040200 	.inst	0x03040200 ; undefined
    14c4:	00180520 	.inst	0x00180520 ; undefined
    14c8:	3c010402 	str	b2, [x0], #16
    14cc:	053e1605 	ext	z5.b, z5.b, z16.b, #245
    14d0:	24053d07 	cmpeq	p7.b, p7/z, z8.b, z5.d
    14d4:	01040200 	.inst	0x01040200 ; undefined
    14d8:	0006053c 	.inst	0x0006053c ; undefined
    14dc:	2e010402 	.inst	0x2e010402 ; undefined
    14e0:	05380205 	ext	z5.b, z5.b, z16.b, #192
    14e4:	05402801 	eor	z1.s, z1.s, #0x8000000
    14e8:	10053e0a 	adr	x10, bca8 <GPR_FRAME_SIZE+0xbba8>
    14ec:	2102055a 	.inst	0x2102055a ; undefined
    14f0:	3e10053d 	.inst	0x3e10053d ; undefined
    14f4:	3d210205 	str	b5, [x16, #2112]
    14f8:	3d3d3d3d 	str	b29, [x9, #3919]
    14fc:	053e1005 	ext	z5.b, z5.b, z0.b, #244
    1500:	3d3d2102 	str	b2, [x8, #3912]
    1504:	10053d3d 	adr	x29, bca8 <GPR_FRAME_SIZE+0xbba8>
    1508:	2102053e 	.inst	0x2102053e ; undefined
    150c:	3e10053d 	.inst	0x3e10053d ; undefined
    1510:	052f0205 	ext	z5.b, z5.b, z16.b, #120
    1514:	02053e10 	.inst	0x02053e10 ; undefined
    1518:	10053d21 	adr	x1, bcbc <GPR_FRAME_SIZE+0xbbbc>
    151c:	2102053e 	.inst	0x2102053e ; undefined
    1520:	3e10053d 	.inst	0x3e10053d ; undefined
    1524:	05210205 	ext	z5.b, z5.b, z16.b, #8
    1528:	053f3d01 	.inst	0x053f3d01 ; undefined
    152c:	06054b0a 	.inst	0x06054b0a ; undefined
    1530:	04020059 	.inst	0x04020059 ; undefined
    1534:	052e0601 	ext	z1.b, z1.b, z16.b, #113
    1538:	04020005 	.inst	0x04020005 ; undefined
    153c:	052e0602 	ext	z2.b, z2.b, z16.b, #113
    1540:	04020042 	.inst	0x04020042 ; undefined
    1544:	20063c01 	.inst	0x20063c01 ; undefined
    1548:	22061705 	.inst	0x22061705 ; undefined
    154c:	053d0a05 	ext	z5.b, z5.b, z16.b, #234
    1550:	04020008 	.inst	0x04020008 ; undefined
    1554:	09053c01 	.inst	0x09053c01 ; undefined
    1558:	21010530 	.inst	0x21010530 ; undefined
    155c:	01000202 	.inst	0x01000202 ; undefined
    1560:	Address 0x1560 is out of bounds.


Disassembly of section .debug_line_str:

0000000000000000 <.debug_line_str>:
   0:	6d6f682f 	ldp	d15, d26, [x1, #-272]
   4:	6e752f65 	uqsub	v5.8h, v27.8h, v21.8h
   8:	662f6261 	.inst	0x662f6261 ; undefined
   c:	73656c69 	.inst	0x73656c69 ; undefined
  10:	73616d2f 	.inst	0x73616d2f ; undefined
  14:	2f726574 	.inst	0x2f726574 ; undefined
  18:	2f6d6674 	.inst	0x2f6d6674 ; undefined
  1c:	38786d69 	.inst	0x38786d69 ; undefined
  20:	702f706d 	adr	x13, 5ee2f <GPR_FRAME_SIZE+0x5ed2f>
  24:	656a6f72 	fnmls	z18.h, p3/m, z27.h, z10.h
  28:	5f007463 	.inst	0x5f007463 ; undefined
  2c:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
  30:	006d7261 	.inst	0x006d7261 ; undefined
  34:	72737973 	.inst	0x72737973 ; undefined
  38:	2e736765 	umax	v5.4h, v27.4h, v19.4h
  3c:	735f0053 	.inst	0x735f0053 ; undefined
  40:	612f6372 	.inst	0x612f6372 ; undefined
  44:	652f6d72 	.inst	0x652f6d72 ; undefined
  48:	70656378 	adr	x24, cacb7 <GPR_FRAME_SIZE+0xcabb7>
  4c:	6e6f6974 	.inst	0x6e6f6974 ; undefined
  50:	6c650073 	ldnp	d19, d0, [x3, #-432]
  54:	65765f32 	fnmla	z18.h, p7/m, z25.h, z22.h
  58:	726f7463 	.inst	0x726f7463 ; undefined
  5c:	00532e73 	.inst	0x00532e73 ; undefined
  60:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
  64:	6f697470 	uqshl	v16.2d, v3.2d, #41
  68:	532e736e 	.inst	0x532e736e ; undefined
  6c:	72735f00 	.inst	0x72735f00 ; undefined
  70:	696c2f63 	ldpsw	x3, x11, [x27, #-160]
  74:	656d2f62 	fmls	z2.h, p3/m, z27.h, z13.h
  78:	7970636d 	ldrh	w13, [x27, #6192]
  7c:	6d656d00 	ldp	d0, d27, [x8, #-432]
  80:	2e797063 	uabdl	v3.4s, v3.4h, v25.4h
  84:	735f0053 	.inst	0x735f0053 ; undefined
  88:	622f6372 	.inst	0x622f6372 ; undefined
  8c:	00746f6f 	.inst	0x00746f6f ; undefined
  90:	61656c63 	.inst	0x61656c63 ; undefined
  94:	73625f6e 	.inst	0x73625f6e ; undefined
  98:	00532e73 	.inst	0x00532e73 ; undefined
  9c:	746f6f62 	.inst	0x746f6f62 ; undefined
  a0:	5f00532e 	fmls	h14, h25, v0.h[0]
  a4:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
  a8:	6e72656b 	umax	v11.8h, v11.8h, v18.8h
  ac:	702f6c65 	adr	x5, 5ee3b <GPR_FRAME_SIZE+0x5ed3b>
  b0:	63696e61 	.inst	0x63696e61 ; undefined
  b4:	5f00632e 	.inst	0x5f00632e ; undefined
  b8:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
  bc:	6e72656b 	umax	v11.8h, v11.8h, v18.8h
  c0:	5f006c65 	.inst	0x5f006c65 ; undefined
  c4:	6c636e69 	ldnp	d9, d27, [x19, #-464]
  c8:	2f656475 	.inst	0x2f656475 ; undefined
  cc:	2f6d7261 	fcmla	v1.4h, v19.4h, v13.h[1], #270
  d0:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
  d4:	6f697470 	uqshl	v16.2d, v3.2d, #41
  d8:	5f00736e 	.inst	0x5f00736e ; undefined
  dc:	6c636e69 	ldnp	d9, d27, [x19, #-464]
  e0:	2f656475 	.inst	0x2f656475 ; undefined
  e4:	0062696c 	.inst	0x0062696c ; undefined
  e8:	636e695f 	.inst	0x636e695f ; undefined
  ec:	6564756c 	fnmls	z12.h, p5/m, z11.h, z4.h
  f0:	6972642f 	ldpsw	x15, x25, [x1, #-112]
  f4:	73726576 	.inst	0x73726576 ; undefined
  f8:	7261752f 	.inst	0x7261752f ; undefined
  fc:	695f0074 	ldpsw	x20, x0, [x3, #248]
 100:	756c636e 	.inst	0x756c636e ; undefined
 104:	6b2f6564 	subs	w4, w11, w15, uxtx #1
 108:	656e7265 	fnmls	z5.h, p4/m, z19.h, z14.h
 10c:	7865006c 	ldaddlh	w5, w12, [x3]
 110:	74706563 	.inst	0x74706563 ; undefined
 114:	736e6f69 	.inst	0x736e6f69 ; undefined
 118:	7300682e 	.inst	0x7300682e ; undefined
 11c:	6e696474 	umax	v20.8h, v3.8h, v9.8h
 120:	00682e74 	.inst	0x00682e74 ; undefined
 124:	74726175 	.inst	0x74726175 ; undefined
 128:	7000682e 	adr	x14, e2f <GPR_FRAME_SIZE+0xd2f>
 12c:	63696e61 	.inst	0x63696e61 ; undefined
 130:	7300682e 	.inst	0x7300682e ; undefined
 134:	6e697274 	uabdl2	v20.4s, v19.8h, v9.8h
 138:	00682e67 	.inst	0x00682e67 ; undefined
 13c:	6372735f 	.inst	0x6372735f ; undefined
 140:	72656b2f 	.inst	0x72656b2f ; undefined
 144:	2f6c656e 	.inst	0x2f6c656e ; undefined
 148:	6c6c616d 	ldnp	d13, d24, [x11, #-320]
 14c:	622f636f 	.inst	0x622f636f ; undefined
 150:	79646475 	ldrh	w21, [x3, #4658]
 154:	6c6c615f 	ldnp	d31, d24, [x10, #-320]
 158:	7461636f 	.inst	0x7461636f ; undefined
 15c:	632e726f 	.inst	0x632e726f ; undefined
 160:	72735f00 	.inst	0x72735f00 ; undefined
 164:	656b2f63 	fmls	z3.h, p3/m, z27.h, z11.h
 168:	6c656e72 	ldnp	d18, d27, [x19, #-432]
 16c:	72656b2f 	.inst	0x72656b2f ; undefined
 170:	5f6c656e 	.inst	0x5f6c656e ; undefined
 174:	72746e65 	.inst	0x72746e65 ; undefined
 178:	00632e79 	.inst	0x00632e79 ; undefined
 17c:	636e695f 	.inst	0x636e695f ; undefined
 180:	6564756c 	fnmls	z12.h, p5/m, z11.h, z4.h
 184:	6972642f 	ldpsw	x15, x25, [x1, #-112]
 188:	73726576 	.inst	0x73726576 ; undefined
 18c:	746e692f 	.inst	0x746e692f ; undefined
 190:	75727265 	.inst	0x75727265 ; undefined
 194:	2f737470 	.inst	0x2f737470 ; undefined
 198:	76636967 	.inst	0x76636967 ; undefined
 19c:	69672f33 	ldpsw	x19, x11, [x25, #-200]
 1a0:	5f337663 	sqshl	s3, s19, #19
 1a4:	00776172 	.inst	0x00776172 ; undefined
 1a8:	636e695f 	.inst	0x636e695f ; undefined
 1ac:	6564756c 	fnmls	z12.h, p5/m, z11.h, z4.h
 1b0:	6d72612f 	ldp	d15, d24, [x9, #-224]
 1b4:	6e695f00 	uqrshl	v0.8h, v24.8h, v9.8h
 1b8:	64756c63 	.inst	0x64756c63 ; undefined
 1bc:	696c2f65 	ldpsw	x5, x11, [x27, #-160]
 1c0:	6d6d2f62 	ldp	d2, d11, [x27, #-304]
 1c4:	67006f69 	.inst	0x67006f69 ; undefined
 1c8:	5f726369 	.inst	0x5f726369 ; undefined
 1cc:	65707974 	fnmls	z20.h, p6/m, z11.h, z16.h
 1d0:	00682e72 	.inst	0x00682e72 ; undefined
 1d4:	2e757063 	uabdl	v3.4s, v3.4h, v21.4h
 1d8:	6d6d0068 	ldp	d8, d0, [x3, #-304]
 1dc:	725f6f69 	.inst	0x725f6f69 ; undefined
 1e0:	2e736765 	umax	v5.4h, v27.4h, v19.4h
 1e4:	735f0068 	.inst	0x735f0068 ; undefined
 1e8:	612f6372 	.inst	0x612f6372 ; undefined
 1ec:	632f6d72 	.inst	0x632f6d72 ; undefined
 1f0:	632e7570 	.inst	0x632e7570 ; undefined
 1f4:	73797300 	.inst	0x73797300 ; undefined
 1f8:	73676572 	.inst	0x73676572 ; undefined
 1fc:	5f00682e 	.inst	0x5f00682e ; undefined
 200:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
 204:	2f6d7261 	fcmla	v1.4h, v19.4h, v13.h[1], #270
 208:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
 20c:	6f697470 	uqshl	v16.2d, v3.2d, #41
 210:	682f736e 	.inst	0x682f736e ; undefined
 214:	6c646e61 	ldnp	d1, d27, [x19, #-448]
 218:	2f737265 	fcmla	v5.4h, v19.4h, v19.h[1], #270
 21c:	2f326c65 	.inst	0x2f326c65 ; undefined
 220:	5f326c65 	.inst	0x5f326c65 ; undefined
 224:	5f776f6c 	.inst	0x5f776f6c ; undefined
 228:	5f323361 	.inst	0x5f323361 ; undefined
 22c:	72726573 	.inst	0x72726573 ; undefined
 230:	632e726f 	.inst	0x632e726f ; undefined
 234:	72735f00 	.inst	0x72735f00 ; undefined
 238:	72612f63 	.inst	0x72612f63 ; undefined
 23c:	78652f6d 	.inst	0x78652f6d ; undefined
 240:	74706563 	.inst	0x74706563 ; undefined
 244:	736e6f69 	.inst	0x736e6f69 ; undefined
 248:	6e61682f 	fcvtxn2	v15.4s, v1.2d
 24c:	72656c64 	.inst	0x72656c64 ; undefined
 250:	6c652f73 	ldnp	d19, d11, [x27, #-432]
 254:	735f0032 	.inst	0x735f0032 ; undefined
 258:	612f6372 	.inst	0x612f6372 ; undefined
 25c:	652f6d72 	.inst	0x652f6d72 ; undefined
 260:	70656378 	adr	x24, caecf <GPR_FRAME_SIZE+0xcadcf>
 264:	6e6f6974 	.inst	0x6e6f6974 ; undefined
 268:	61682f73 	.inst	0x61682f73 ; undefined
 26c:	656c646e 	fnmls	z14.h, p1/m, z3.h, z12.h
 270:	652f7372 	.inst	0x652f7372 ; undefined
 274:	652f326c 	bfmls	z12.h, p4/m, z19.h, z15.h
 278:	635f326c 	.inst	0x635f326c ; undefined
 27c:	735f7275 	.inst	0x735f7275 ; undefined
 280:	735f7870 	.inst	0x735f7870 ; undefined
 284:	6f727265 	fcmla	v5.8h, v19.8h, v18.h[1], #270
 288:	00632e72 	.inst	0x00632e72 ; undefined
 28c:	6372735f 	.inst	0x6372735f ; undefined
 290:	6d72612f 	ldp	d15, d24, [x9, #-224]
 294:	6378652f 	.inst	0x6378652f ; undefined
 298:	69747065 	ldpsw	x5, x28, [x3, #-96]
 29c:	2f736e6f 	.inst	0x2f736e6f ; undefined
 2a0:	646e6168 	.inst	0x646e6168 ; undefined
 2a4:	7372656c 	.inst	0x7372656c ; undefined
 2a8:	326c652f 	.inst	0x326c652f ; undefined
 2ac:	326c652f 	.inst	0x326c652f ; undefined
 2b0:	776f6c5f 	.inst	0x776f6c5f ; undefined
 2b4:	3436615f 	cbz	wzr, 6cedc <GPR_FRAME_SIZE+0x6cddc>
 2b8:	7265735f 	.inst	0x7265735f ; undefined
 2bc:	2e726f72 	umin	v18.4h, v27.4h, v18.4h
 2c0:	735f0063 	.inst	0x735f0063 ; undefined
 2c4:	612f6372 	.inst	0x612f6372 ; undefined
 2c8:	652f6d72 	.inst	0x652f6d72 ; undefined
 2cc:	70656378 	adr	x24, caf3b <GPR_FRAME_SIZE+0xcae3b>
 2d0:	6e6f6974 	.inst	0x6e6f6974 ; undefined
 2d4:	61682f73 	.inst	0x61682f73 ; undefined
 2d8:	656c646e 	fnmls	z14.h, p1/m, z3.h, z12.h
 2dc:	652f7372 	.inst	0x652f7372 ; undefined
 2e0:	652f326c 	bfmls	z12.h, p4/m, z19.h, z15.h
 2e4:	6c5f326c 	ldnp	d12, d12, [x19, #496]
 2e8:	615f776f 	.inst	0x615f776f ; undefined
 2ec:	735f3436 	.inst	0x735f3436 ; undefined
 2f0:	2e636e79 	umin	v25.4h, v19.4h, v3.4h
 2f4:	735f0063 	.inst	0x735f0063 ; undefined
 2f8:	612f6372 	.inst	0x612f6372 ; undefined
 2fc:	652f6d72 	.inst	0x652f6d72 ; undefined
 300:	70656378 	adr	x24, caf6f <GPR_FRAME_SIZE+0xcae6f>
 304:	6e6f6974 	.inst	0x6e6f6974 ; undefined
 308:	61682f73 	.inst	0x61682f73 ; undefined
 30c:	656c646e 	fnmls	z14.h, p1/m, z3.h, z12.h
 310:	652f7372 	.inst	0x652f7372 ; undefined
 314:	652f326c 	bfmls	z12.h, p4/m, z19.h, z15.h
 318:	635f326c 	.inst	0x635f326c ; undefined
 31c:	735f7275 	.inst	0x735f7275 ; undefined
 320:	695f3070 	ldpsw	x16, x12, [x3, #248]
 324:	632e7172 	.inst	0x632e7172 ; undefined
 328:	72735f00 	.inst	0x72735f00 ; undefined
 32c:	72612f63 	.inst	0x72612f63 ; undefined
 330:	78652f6d 	.inst	0x78652f6d ; undefined
 334:	74706563 	.inst	0x74706563 ; undefined
 338:	736e6f69 	.inst	0x736e6f69 ; undefined
 33c:	6e61682f 	fcvtxn2	v15.4s, v1.2d
 340:	72656c64 	.inst	0x72656c64 ; undefined
 344:	6c652f73 	ldnp	d19, d11, [x27, #-432]
 348:	6c652f32 	ldnp	d18, d11, [x25, #-432]
 34c:	75635f32 	.inst	0x75635f32 ; undefined
 350:	70735f72 	adr	x18, e6f3f <GPR_FRAME_SIZE+0xe6e3f>
 354:	65735f30 	fnmla	z16.h, p7/m, z25.h, z19.h
 358:	726f7272 	.inst	0x726f7272 ; undefined
 35c:	5f00632e 	.inst	0x5f00632e ; undefined
 360:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
 364:	2f6d7261 	fcmla	v1.4h, v19.4h, v13.h[1], #270
 368:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
 36c:	6f697470 	uqshl	v16.2d, v3.2d, #41
 370:	682f736e 	.inst	0x682f736e ; undefined
 374:	6c646e61 	ldnp	d1, d27, [x19, #-448]
 378:	2f737265 	fcmla	v5.4h, v19.4h, v19.h[1], #270
 37c:	2f326c65 	.inst	0x2f326c65 ; undefined
 380:	5f326c65 	.inst	0x5f326c65 ; undefined
 384:	5f776f6c 	.inst	0x5f776f6c ; undefined
 388:	5f343661 	.inst	0x5f343661 ; undefined
 38c:	2e717269 	uabdl	v9.4s, v19.4h, v17.4h
 390:	735f0063 	.inst	0x735f0063 ; undefined
 394:	612f6372 	.inst	0x612f6372 ; undefined
 398:	652f6d72 	.inst	0x652f6d72 ; undefined
 39c:	70656378 	adr	x24, cb00b <GPR_FRAME_SIZE+0xcaf0b>
 3a0:	6e6f6974 	.inst	0x6e6f6974 ; undefined
 3a4:	61682f73 	.inst	0x61682f73 ; undefined
 3a8:	656c646e 	fnmls	z14.h, p1/m, z3.h, z12.h
 3ac:	652f7372 	.inst	0x652f7372 ; undefined
 3b0:	652f326c 	bfmls	z12.h, p4/m, z19.h, z15.h
 3b4:	6c5f326c 	ldnp	d12, d12, [x19, #496]
 3b8:	615f776f 	.inst	0x615f776f ; undefined
 3bc:	665f3436 	.inst	0x665f3436 ; undefined
 3c0:	632e7169 	.inst	0x632e7169 ; undefined
 3c4:	72735f00 	.inst	0x72735f00 ; undefined
 3c8:	72612f63 	.inst	0x72612f63 ; undefined
 3cc:	78652f6d 	.inst	0x78652f6d ; undefined
 3d0:	74706563 	.inst	0x74706563 ; undefined
 3d4:	736e6f69 	.inst	0x736e6f69 ; undefined
 3d8:	6e61682f 	fcvtxn2	v15.4s, v1.2d
 3dc:	72656c64 	.inst	0x72656c64 ; undefined
 3e0:	6c652f73 	ldnp	d19, d11, [x27, #-432]
 3e4:	6c652f32 	ldnp	d18, d11, [x25, #-432]
 3e8:	75635f32 	.inst	0x75635f32 ; undefined
 3ec:	70735f72 	adr	x18, e6fdb <GPR_FRAME_SIZE+0xe6edb>
 3f0:	69665f78 	ldpsw	x24, x23, [x27, #-208]
 3f4:	00632e71 	.inst	0x00632e71 ; undefined
 3f8:	6372735f 	.inst	0x6372735f ; undefined
 3fc:	6d72612f 	ldp	d15, d24, [x9, #-224]
 400:	6378652f 	.inst	0x6378652f ; undefined
 404:	69747065 	ldpsw	x5, x28, [x3, #-96]
 408:	2f736e6f 	.inst	0x2f736e6f ; undefined
 40c:	646e6168 	.inst	0x646e6168 ; undefined
 410:	7372656c 	.inst	0x7372656c ; undefined
 414:	326c652f 	.inst	0x326c652f ; undefined
 418:	326c652f 	.inst	0x326c652f ; undefined
 41c:	776f6c5f 	.inst	0x776f6c5f ; undefined
 420:	3233615f 	orr	wsp, w10, #0xffffe03f
 424:	7172695f 	cmp	w10, #0xc9a, lsl #12
 428:	5f00632e 	.inst	0x5f00632e ; undefined
 42c:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
 430:	2f6d7261 	fcmla	v1.4h, v19.4h, v13.h[1], #270
 434:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
 438:	6f697470 	uqshl	v16.2d, v3.2d, #41
 43c:	682f736e 	.inst	0x682f736e ; undefined
 440:	6c646e61 	ldnp	d1, d27, [x19, #-448]
 444:	2f737265 	fcmla	v5.4h, v19.4h, v19.h[1], #270
 448:	2f326c65 	.inst	0x2f326c65 ; undefined
 44c:	5f326c65 	.inst	0x5f326c65 ; undefined
 450:	5f727563 	sqshl	d3, d11, #50
 454:	5f307073 	.inst	0x5f307073 ; undefined
 458:	2e716966 	.inst	0x2e716966 ; undefined
 45c:	735f0063 	.inst	0x735f0063 ; undefined
 460:	612f6372 	.inst	0x612f6372 ; undefined
 464:	652f6d72 	.inst	0x652f6d72 ; undefined
 468:	70656378 	adr	x24, cb0d7 <GPR_FRAME_SIZE+0xcafd7>
 46c:	6e6f6974 	.inst	0x6e6f6974 ; undefined
 470:	61682f73 	.inst	0x61682f73 ; undefined
 474:	656c646e 	fnmls	z14.h, p1/m, z3.h, z12.h
 478:	652f7372 	.inst	0x652f7372 ; undefined
 47c:	652f326c 	bfmls	z12.h, p4/m, z19.h, z15.h
 480:	6c5f326c 	ldnp	d12, d12, [x19, #496]
 484:	615f776f 	.inst	0x615f776f ; undefined
 488:	665f3233 	.inst	0x665f3233 ; undefined
 48c:	632e7169 	.inst	0x632e7169 ; undefined
 490:	72735f00 	.inst	0x72735f00 ; undefined
 494:	72612f63 	.inst	0x72612f63 ; undefined
 498:	78652f6d 	.inst	0x78652f6d ; undefined
 49c:	74706563 	.inst	0x74706563 ; undefined
 4a0:	736e6f69 	.inst	0x736e6f69 ; undefined
 4a4:	6e61682f 	fcvtxn2	v15.4s, v1.2d
 4a8:	72656c64 	.inst	0x72656c64 ; undefined
 4ac:	6c652f73 	ldnp	d19, d11, [x27, #-432]
 4b0:	6c652f32 	ldnp	d18, d11, [x25, #-432]
 4b4:	75635f32 	.inst	0x75635f32 ; undefined
 4b8:	70735f72 	adr	x18, e70a7 <GPR_FRAME_SIZE+0xe6fa7>
 4bc:	79735f78 	ldrh	w24, [x27, #6574]
 4c0:	632e636e 	.inst	0x632e636e ; undefined
 4c4:	72735f00 	.inst	0x72735f00 ; undefined
 4c8:	72612f63 	.inst	0x72612f63 ; undefined
 4cc:	78652f6d 	.inst	0x78652f6d ; undefined
 4d0:	74706563 	.inst	0x74706563 ; undefined
 4d4:	736e6f69 	.inst	0x736e6f69 ; undefined
 4d8:	6e61682f 	fcvtxn2	v15.4s, v1.2d
 4dc:	72656c64 	.inst	0x72656c64 ; undefined
 4e0:	6c652f73 	ldnp	d19, d11, [x27, #-432]
 4e4:	6c652f32 	ldnp	d18, d11, [x25, #-432]
 4e8:	6f6c5f32 	.inst	0x6f6c5f32 ; undefined
 4ec:	33615f77 	.inst	0x33615f77 ; undefined
 4f0:	79735f32 	ldrh	w18, [x25, #6574]
 4f4:	632e636e 	.inst	0x632e636e ; undefined
 4f8:	72735f00 	.inst	0x72735f00 ; undefined
 4fc:	72612f63 	.inst	0x72612f63 ; undefined
 500:	78652f6d 	.inst	0x78652f6d ; undefined
 504:	74706563 	.inst	0x74706563 ; undefined
 508:	736e6f69 	.inst	0x736e6f69 ; undefined
 50c:	6e61682f 	fcvtxn2	v15.4s, v1.2d
 510:	72656c64 	.inst	0x72656c64 ; undefined
 514:	6c652f73 	ldnp	d19, d11, [x27, #-432]
 518:	6c652f32 	ldnp	d18, d11, [x25, #-432]
 51c:	75635f32 	.inst	0x75635f32 ; undefined
 520:	70735f72 	adr	x18, e710f <GPR_FRAME_SIZE+0xe700f>
 524:	79735f30 	ldrh	w16, [x25, #6574]
 528:	632e636e 	.inst	0x632e636e ; undefined
 52c:	72735f00 	.inst	0x72735f00 ; undefined
 530:	72612f63 	.inst	0x72612f63 ; undefined
 534:	78652f6d 	.inst	0x78652f6d ; undefined
 538:	74706563 	.inst	0x74706563 ; undefined
 53c:	736e6f69 	.inst	0x736e6f69 ; undefined
 540:	6e61682f 	fcvtxn2	v15.4s, v1.2d
 544:	72656c64 	.inst	0x72656c64 ; undefined
 548:	6c652f73 	ldnp	d19, d11, [x27, #-432]
 54c:	6c652f32 	ldnp	d18, d11, [x25, #-432]
 550:	75635f32 	.inst	0x75635f32 ; undefined
 554:	70735f72 	adr	x18, e7143 <GPR_FRAME_SIZE+0xe7043>
 558:	72695f78 	.inst	0x72695f78 ; undefined
 55c:	00632e71 	.inst	0x00632e71 ; undefined
 560:	6372735f 	.inst	0x6372735f ; undefined
 564:	6d72612f 	ldp	d15, d24, [x9, #-224]
 568:	6378652f 	.inst	0x6378652f ; undefined
 56c:	69747065 	ldpsw	x5, x28, [x3, #-96]
 570:	2f736e6f 	.inst	0x2f736e6f ; undefined
 574:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
 578:	6f697470 	uqshl	v16.2d, v3.2d, #41
 57c:	632e736e 	.inst	0x632e736e ; undefined
 580:	72735f00 	.inst	0x72735f00 ; undefined
 584:	696c2f63 	ldpsw	x3, x11, [x27, #-160]
 588:	74732f62 	.inst	0x74732f62 ; undefined
 58c:	676e6972 	.inst	0x676e6972 ; undefined
 590:	5f00632e 	.inst	0x5f00632e ; undefined
 594:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
 598:	0062696c 	.inst	0x0062696c ; undefined
 59c:	6372735f 	.inst	0x6372735f ; undefined
 5a0:	62696c2f 	.inst	0x62696c2f ; undefined
 5a4:	6d656d2f 	ldp	d15, d27, [x9, #-432]
 5a8:	2f797063 	fcmla	v3.4h, v3.4h, v25.h[1], #270
 5ac:	636d656d 	.inst	0x636d656d ; undefined
 5b0:	632e7970 	.inst	0x632e7970 ; undefined
 5b4:	6d656d00 	ldp	d0, d27, [x8, #-432]
 5b8:	2e797063 	uabdl	v3.4s, v3.4h, v25.4h
 5bc:	735f0068 	.inst	0x735f0068 ; undefined
 5c0:	642f6372 	.inst	0x642f6372 ; undefined
 5c4:	65766972 	fnmls	z18.h, p2/m, z11.h, z22.h
 5c8:	692f7372 	stgp	x18, x28, [x27, #-544]
 5cc:	7265746e 	.inst	0x7265746e ; undefined
 5d0:	74707572 	.inst	0x74707572 ; undefined
 5d4:	69672f73 	ldpsw	x19, x11, [x27, #-200]
 5d8:	2f337663 	uqshl	v3.2s, v19.2s, #19
 5dc:	76636967 	.inst	0x76636967 ; undefined
 5e0:	00632e33 	.inst	0x00632e33 ; undefined
 5e4:	6372735f 	.inst	0x6372735f ; undefined
 5e8:	6972642f 	ldpsw	x15, x25, [x1, #-112]
 5ec:	73726576 	.inst	0x73726576 ; undefined
 5f0:	746e692f 	.inst	0x746e692f ; undefined
 5f4:	75727265 	.inst	0x75727265 ; undefined
 5f8:	2f737470 	.inst	0x2f737470 ; undefined
 5fc:	76636967 	.inst	0x76636967 ; undefined
 600:	695f0033 	ldpsw	x19, x0, [x1, #248]
 604:	756c636e 	.inst	0x756c636e ; undefined
 608:	642f6564 	.inst	0x642f6564 ; undefined
 60c:	65766972 	fnmls	z18.h, p2/m, z11.h, z22.h
 610:	692f7372 	stgp	x18, x28, [x27, #-544]
 614:	7265746e 	.inst	0x7265746e ; undefined
 618:	74707572 	.inst	0x74707572 ; undefined
 61c:	69670073 	ldpsw	x19, x0, [x3, #-200]
 620:	695f6463 	ldpsw	x3, x25, [x3, #248]
 624:	756f7267 	.inst	0x756f7267 ; undefined
 628:	682e7270 	.inst	0x682e7270 ; undefined
 62c:	63696700 	.inst	0x63696700 ; undefined
 630:	79745f64 	ldrh	w4, [x27, #6702]
 634:	2e726570 	umax	v16.4h, v11.4h, v18.4h
 638:	69670068 	ldpsw	x8, x0, [x3, #-200]
 63c:	695f6463 	ldpsw	x3, x25, [x3, #248]
 640:	72676663 	.inst	0x72676663 ; undefined
 644:	6700682e 	.inst	0x6700682e ; undefined
 648:	5f646369 	.inst	0x5f646369 ; undefined
 64c:	69727069 	ldpsw	x9, x28, [x3, #-112]
 650:	7469726f 	.inst	0x7469726f ; undefined
 654:	682e7279 	.inst	0x682e7279 ; undefined
 658:	63696700 	.inst	0x63696700 ; undefined
 65c:	72695f64 	.inst	0x72695f64 ; undefined
 660:	6574756f 	fnmls	z15.h, p5/m, z11.h, z20.h
 664:	00682e72 	.inst	0x00682e72 ; undefined
 668:	64636967 	.inst	0x64636967 ; undefined
 66c:	6573695f 	fnmls	z31.h, p2/m, z10.h, z19.h
 670:	6c62616e 	ldnp	d14, d24, [x11, #-480]
 674:	682e7265 	.inst	0x682e7265 ; undefined
 678:	63696700 	.inst	0x63696700 ; undefined
 67c:	61775f72 	.inst	0x61775f72 ; undefined
 680:	2e72656b 	umax	v11.4h, v11.4h, v18.4h
 684:	6e690068 	uaddl2	v8.4s, v3.8h, v9.8h
 688:	72726574 	.inst	0x72726574 ; undefined
 68c:	73747075 	.inst	0x73747075 ; undefined
 690:	5f00682e 	.inst	0x5f00682e ; undefined
 694:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
 698:	76697264 	.inst	0x76697264 ; undefined
 69c:	2f737265 	fcmla	v5.4h, v19.4h, v19.h[1], #270
 6a0:	65746e69 	fnmls	z9.h, p3/m, z19.h, z20.h
 6a4:	70757272 	adr	x18, eb4f3 <GPR_FRAME_SIZE+0xeb3f3>
 6a8:	692f7374 	stgp	x20, x28, [x27, #-544]
 6ac:	632e7172 	.inst	0x632e7172 ; undefined
 6b0:	72735f00 	.inst	0x72735f00 ; undefined
 6b4:	72642f63 	.inst	0x72642f63 ; undefined
 6b8:	72657669 	.inst	0x72657669 ; undefined
 6bc:	61752f73 	.inst	0x61752f73 ; undefined
 6c0:	752f7472 	.inst	0x752f7472 ; undefined
 6c4:	2e747261 	uabdl	v1.4s, v19.4h, v20.4h
 6c8:	735f0063 	.inst	0x735f0063 ; undefined
 6cc:	642f6372 	.inst	0x642f6372 ; undefined
 6d0:	65766972 	fnmls	z18.h, p2/m, z11.h, z22.h
 6d4:	752f7372 	.inst	0x752f7372 ; undefined
 6d8:	00747261 	.inst	0x00747261 ; undefined
 6dc:	636e695f 	.inst	0x636e695f ; undefined
 6e0:	6564756c 	fnmls	z12.h, p5/m, z11.h, z4.h
 6e4:	6972642f 	ldpsw	x15, x25, [x1, #-112]
 6e8:	73726576 	.inst	0x73726576 ; undefined
 6ec:	7261752f 	.inst	0x7261752f ; undefined
 6f0:	61722f74 	.inst	0x61722f74 ; undefined
 6f4:	61750077 	.inst	0x61750077 ; undefined
 6f8:	755f7472 	.inst	0x755f7472 ; undefined
 6fc:	2e726962 	.inst	0x2e726962 ; undefined
 700:	61750068 	.inst	0x61750068 ; undefined
 704:	755f7472 	.inst	0x755f7472 ; undefined
 708:	2e726d62 	umin	v2.4h, v11.4h, v18.4h
 70c:	61750068 	.inst	0x61750068 ; undefined
 710:	755f7472 	.inst	0x755f7472 ; undefined
 714:	2e317263 	uabdl	v3.8h, v19.8b, v17.8b
 718:	61750068 	.inst	0x61750068 ; undefined
 71c:	755f7472 	.inst	0x755f7472 ; undefined
 720:	2e327263 	uabdl	v3.8h, v19.8b, v18.8b
 724:	61750068 	.inst	0x61750068 ; undefined
 728:	755f7472 	.inst	0x755f7472 ; undefined
 72c:	2e337263 	uabdl	v3.8h, v19.8b, v19.8b
 730:	61750068 	.inst	0x61750068 ; undefined
 734:	755f7472 	.inst	0x755f7472 ; undefined
 738:	2e347263 	uabdl	v3.8h, v19.8b, v20.8b
 73c:	61750068 	.inst	0x61750068 ; undefined
 740:	755f7472 	.inst	0x755f7472 ; undefined
 744:	2e726366 	rsubhn	v6.4h, v27.4s, v18.4s
 748:	61750068 	.inst	0x61750068 ; undefined
 74c:	755f7472 	.inst	0x755f7472 ; undefined
 750:	2e72636d 	rsubhn	v13.4h, v27.4s, v18.4s
 754:	61750068 	.inst	0x61750068 ; undefined
 758:	755f7472 	.inst	0x755f7472 ; undefined
 75c:	2e647872 	.inst	0x2e647872 ; undefined
 760:	61750068 	.inst	0x61750068 ; undefined
 764:	755f7472 	.inst	0x755f7472 ; undefined
 768:	682e7374 	.inst	0x682e7374 ; undefined
 76c:	72617500 	.inst	0x72617500 ; undefined
 770:	74755f74 	.inst	0x74755f74 ; undefined
 774:	682e6478 	.inst	0x682e6478 ; undefined
	...

Disassembly of section .debug_info:

0000000000000000 <.debug_info>:
       0:	00000024 	udf	#36
       4:	08010005 	stxrb	w1, w5, [x0]
       8:	00000000 	udf	#0
       c:	00000001 	udf	#1
      10:	00004800 	udf	#18432
      14:	00000040 	udf	#64
      18:	00002400 	udf	#9216
      1c:	00130000 	.inst	0x00130000 ; undefined
      20:	003e0000 	.inst	0x003e0000 ; NYI
      24:	80010000 	.inst	0x80010000 ; undefined
      28:	0000001f 	udf	#31
      2c:	08010005 	stxrb	w1, w5, [x0]
      30:	00000014 	udf	#20
      34:	00005301 	udf	#21249
      38:	00000c00 	udf	#3072
      3c:	00004c00 	udf	#19456
      40:	00001300 	udf	#4864
      44:	00003e00 	udf	#15872
      48:	24800100 	cmphs	p0.s, p0/z, z8.s, z0.s
      4c:	05000000 	orr	z0.s, z0.s, #0x1
      50:	26080100 	.inst	0x26080100 ; undefined
      54:	01000000 	.inst	0x01000000 ; undefined
      58:	00000103 	udf	#259
      5c:	40000980 	.inst	0x40000980 ; undefined
      60:	00000000 	udf	#0
      64:	00006e68 	udf	#28264
      68:	00001300 	udf	#4864
      6c:	00003e00 	udf	#15872
      70:	25800100 	cmpge	p0.s, p0/z, z8.s, #0
      74:	05000000 	orr	z0.s, z0.s, #0x1
      78:	3a080100 	adcs	w0, w8, w8
      7c:	01000000 	.inst	0x01000000 ; undefined
      80:	00000167 	udf	#359
      84:	400009f0 	.inst	0x400009f0 ; undefined
      88:	00000000 	udf	#0
      8c:	008f04d0 	.inst	0x008f04d0 ; undefined
      90:	00130000 	.inst	0x00130000 ; undefined
      94:	003e0000 	.inst	0x003e0000 ; NYI
      98:	80010000 	.inst	0x80010000 ; undefined
      9c:	00000024 	udf	#36
      a0:	08010005 	stxrb	w1, w5, [x0]
      a4:	0000004e 	udf	#78
      a8:	00023b01 	.inst	0x00023b01 ; undefined
      ac:	000c4000 	.inst	0x000c4000 ; undefined
      b0:	00000040 	udf	#64
      b4:	00a85800 	.inst	0x00a85800 ; undefined
      b8:	00130000 	.inst	0x00130000 ; undefined
      bc:	003e0000 	.inst	0x003e0000 ; NYI
      c0:	80010000 	.inst	0x80010000 ; undefined
      c4:	00000024 	udf	#36
      c8:	08010005 	stxrb	w1, w5, [x0]
      cc:	00000062 	udf	#98
      d0:	00029601 	.inst	0x00029601 ; undefined
      d4:	00000000 	udf	#0
      d8:	00000040 	udf	#64
      dc:	00be4800 	.inst	0x00be4800 ; undefined
      e0:	00130000 	.inst	0x00130000 ; undefined
      e4:	003e0000 	.inst	0x003e0000 ; NYI
      e8:	80010000 	.inst	0x80010000 ; undefined
      ec:	00000507 	udf	#1287
      f0:	08010005 	stxrb	w1, w5, [x0]
      f4:	00000076 	udf	#118
      f8:	0001b615 	.inst	0x0001b615 ; undefined
      fc:	00a31d00 	.inst	0x00a31d00 ; undefined
     100:	00000000 	udf	#0
     104:	0c980000 	st4	{v0.8b-v3.8b}, [x0], x24
     108:	00004000 	udf	#16384
     10c:	03940000 	.inst	0x03940000 ; undefined
     110:	00000000 	udf	#0
     114:	02ee0000 	.inst	0x02ee0000 ; undefined
     118:	04090000 	umax	z0.b, p0/m, z0.b, z0.b
     11c:	006b0502 	.inst	0x006b0502 ; undefined
     120:	660a0000 	.inst	0x660a0000 ; undefined
     124:	02007169 	.inst	0x02007169 ; undefined
     128:	006b0706 	.inst	0x006b0706 ; undefined
     12c:	0a000000 	and	w0, w0, w0
     130:	00717269 	.inst	0x00717269 ; undefined
     134:	6b070702 	subs	w2, w24, w7, lsl #1
     138:	01000000 	.inst	0x01000000 ; undefined
     13c:	00023406 	.inst	0x00023406 ; undefined
     140:	07080200 	.inst	0x07080200 ; undefined
     144:	0000006b 	udf	#107
     148:	01900602 	.inst	0x01900602 ; undefined
     14c:	09020000 	.inst	0x09020000 ; undefined
     150:	00006b07 	udf	#27399
     154:	03000300 	.inst	0x03000300 ; undefined
     158:	041c0201 	.inst	0x041c0201 ; undefined
     15c:	f5020000 	.inst	0xf5020000 ; undefined
     160:	02000000 	.inst	0x02000000 ; undefined
     164:	002e030a 	.inst	0x002e030a ; NYI
     168:	ba0b0000 	adcs	x0, x0, x11
     16c:	03000000 	.inst	0x03000000 ; undefined
     170:	0000ba0b 	udf	#47627
     174:	02980100 	.inst	0x02980100 ; undefined
     178:	01000000 	.inst	0x01000000 ; undefined
     17c:	00000336 	udf	#822
     180:	02570101 	.inst	0x02570101 ; undefined
     184:	01020000 	.inst	0x01020000 ; undefined
     188:	00000283 	udf	#643
     18c:	02640103 	.inst	0x02640103 ; undefined
     190:	01040000 	.inst	0x01040000 ; undefined
     194:	000002b4 	udf	#692
     198:	00d70105 	.inst	0x00d70105 ; undefined
     19c:	01060000 	.inst	0x01060000 ; undefined
     1a0:	000003e4 	udf	#996
     1a4:	04030007 	subr	z7.b, p0/m, z7.b, z0.b
     1a8:	00031a07 	.inst	0x00031a07 ; undefined
     1ac:	03a20200 	.inst	0x03a20200 ; undefined
     1b0:	14030000 	b	c01b0 <GPR_FRAME_SIZE+0xc00b0>
     1b4:	00007e03 	udf	#32259
     1b8:	00ba0b00 	.inst	0x00ba0b00 ; undefined
     1bc:	17030000 	b	fffffffffc0c01bc <__stack_el2_top+0xffffffffbaab91bc>
     1c0:	000000f1 	udf	#241
     1c4:	00016601 	.inst	0x00016601 ; undefined
     1c8:	79010a00 	strh	w0, [x16, #132]
     1cc:	10000003 	adr	x3, 1cc <GPR_FRAME_SIZE+0xcc>
     1d0:	00035601 	.inst	0x00035601 ; undefined
     1d4:	06010200 	.inst	0x06010200 ; undefined
     1d8:	08000001 	stxrb	w0, w1, [x0]
     1dc:	00e40200 	.inst	0x00e40200 ; undefined
     1e0:	1c030000 	ldr	s0, 61e0 <GPR_FRAME_SIZE+0x60e0>
     1e4:	0000cd03 	udf	#52483
     1e8:	02520200 	.inst	0x02520200 ; undefined
     1ec:	1e030000 	.inst	0x1e030000 ; undefined
     1f0:	00010915 	.inst	0x00010915 ; undefined
     1f4:	06010300 	.inst	0x06010300 ; undefined
     1f8:	0000023d 	udf	#573
     1fc:	00025102 	.inst	0x00025102 ; undefined
     200:	171f0300 	b	fffffffffc7c0e00 <__stack_el2_top+0xffffffffbb1b9e00>
     204:	0000011c 	udf	#284
     208:	3b080103 	.inst	0x3b080103 ; undefined
     20c:	02000002 	.inst	0x02000002 ; undefined
     210:	00000292 	udf	#658
     214:	2f162103 	.inst	0x2f162103 ; undefined
     218:	03000001 	.inst	0x03000001 ; undefined
     21c:	03980502 	.inst	0x03980502 ; undefined
     220:	91020000 	add	x0, x0, #0x80
     224:	03000002 	.inst	0x03000002 ; undefined
     228:	01421822 	.inst	0x01421822 ; undefined
     22c:	02030000 	.inst	0x02030000 ; undefined
     230:	00013607 	.inst	0x00013607 ; undefined
     234:	02d00200 	.inst	0x02d00200 ; undefined
     238:	24030000 	cmphs	p0.b, p0/z, z0.b, z3.b
     23c:	00015514 	.inst	0x00015514 ; undefined
     240:	05041600 	.inst	0x05041600 ; undefined
     244:	00746e69 	.inst	0x00746e69 ; undefined
     248:	0002cf02 	.inst	0x0002cf02 ; undefined
     24c:	16250300 	b	fffffffff8940e4c <__stack_el2_top+0xffffffffb7339e4c>
     250:	000000ba 	udf	#186
     254:	00012502 	.inst	0x00012502 ; undefined
     258:	1a270300 	.inst	0x1a270300 ; undefined
     25c:	00000174 	udf	#372
     260:	6b050803 	subs	w3, w0, w5, lsl #2
     264:	02000003 	.inst	0x02000003 ; undefined
     268:	00000124 	udf	#292
     26c:	871c2803 	.inst	0x871c2803 ; undefined
     270:	03000001 	.inst	0x03000001 ; undefined
     274:	03100708 	.inst	0x03100708 ; undefined
     278:	08030000 	stxrb	w3, w0, [x0]
     27c:	00037005 	.inst	0x00037005 ; undefined
     280:	07080300 	.inst	0x07080300 ; undefined
     284:	00000315 	udf	#789
     288:	58030817 	ldr	x23, 6388 <GPR_FRAME_SIZE+0x6288>
     28c:	0001fe09 	.inst	0x0001fe09 ; undefined
     290:	02520500 	.inst	0x02520500 ; undefined
     294:	07590000 	.inst	0x07590000 ; undefined
     298:	000000fd 	udf	#253
     29c:	00025105 	.inst	0x00025105 ; undefined
     2a0:	10085a00 	adr	x0, 10de0 <GPR_FRAME_SIZE+0x10ce0>
     2a4:	05000001 	orr	z1.s, z1.s, #0x1
     2a8:	00000292 	udf	#658
     2ac:	0123085c 	.inst	0x0123085c ; undefined
     2b0:	91050000 	add	x0, x0, #0x140
     2b4:	5d000002 	.inst	0x5d000002 ; undefined
     2b8:	00013609 	.inst	0x00013609 ; undefined
     2bc:	02d00500 	.inst	0x02d00500 ; undefined
     2c0:	085f0000 	ldxrb	w0, [x0]
     2c4:	00000149 	udf	#329
     2c8:	0002cf05 	.inst	0x0002cf05 ; undefined
     2cc:	5c096000 	ldr	d0, 12ecc <GPR_FRAME_SIZE+0x12dcc>
     2d0:	05000001 	orr	z1.s, z1.s, #0x1
     2d4:	00000125 	udf	#293
     2d8:	01680862 	.inst	0x01680862 ; undefined
     2dc:	24050000 	cmphs	p0.b, p0/z, z0.b, z5.b
     2e0:	63000001 	.inst	0x63000001 ; undefined
     2e4:	00017b09 	.inst	0x00017b09 ; undefined
     2e8:	c2020000 	.inst	0xc2020000 ; undefined
     2ec:	03000002 	.inst	0x03000002 ; undefined
     2f0:	019c0364 	.inst	0x019c0364 ; undefined
     2f4:	ba0b0000 	adcs	x0, x0, x11
     2f8:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     2fc:	00022e05 	.inst	0x00022e05 ; undefined
     300:	04220100 	add	z0.b, z8.b, z2.b
     304:	01000000 	.inst	0x01000000 ; undefined
     308:	00000196 	udf	#406
     30c:	042c0101 	add	z1.b, z8.b, z12.b
     310:	01020000 	.inst	0x01020000 ; undefined
     314:	00000436 	udf	#1078
     318:	7b020003 	.inst	0x7b020003 ; undefined
     31c:	04000002 	add	z2.b, p0/m, z2.b, z0.b
     320:	020a030a 	.inst	0x020a030a ; undefined
     324:	2e0f0000 	ext	v0.8b, v0.8b, v15.8b, #0
     328:	07000002 	.inst	0x07000002 ; undefined
     32c:	000002de 	udf	#734
     330:	00017b05 	.inst	0x00017b05 ; undefined
     334:	03f20700 	.inst	0x03f20700 ; undefined
     338:	7b060000 	.inst	0x7b060000 ; undefined
     33c:	07000001 	.inst	0x07000001 ; undefined
     340:	00000406 	udf	#1030
     344:	00025d08 	.inst	0x00025d08 ; undefined
     348:	01100c00 	.inst	0x01100c00 ; undefined
     34c:	43070000 	.inst	0x43070000 ; undefined
     350:	09000003 	.inst	0x09000003 ; undefined
     354:	0000025d 	udf	#605
     358:	0003d907 	.inst	0x0003d907 ; undefined
     35c:	015c0b00 	.inst	0x015c0b00 ; undefined
     360:	71070000 	subs	w0, w0, #0x1c0
     364:	0c000002 	st4	{v2.8b-v5.8b}, [x0]
     368:	0000015c 	udf	#348
     36c:	0e051009 	tbx	v9.8b, {v0.16b}, v5.8b
     370:	000002b0 	udf	#688
     374:	00022f06 	.inst	0x00022f06 ; undefined
     378:	080f0500 	stxrb	w15, w0, [x8]
     37c:	000002b0 	udf	#688
     380:	03270600 	.inst	0x03270600 ; undefined
     384:	10050000 	adr	x0, a384 <GPR_FRAME_SIZE+0xa284>
     388:	00015c09 	.inst	0x00015c09 ; undefined
     38c:	630a0800 	.inst	0x630a0800 ; undefined
     390:	05006c6f 	orr	z15.h, z15.h, #0x78
     394:	015c0911 	.inst	0x015c0911 ; undefined
     398:	000c0000 	.inst	0x000c0000 ; undefined
     39c:	0002b50c 	.inst	0x0002b50c ; undefined
     3a0:	08010300 	stxrb	w1, w0, [x24]
     3a4:	00000244 	udf	#580
     3a8:	0002b50f 	.inst	0x0002b50f ; undefined
     3ac:	03b90200 	.inst	0x03b90200 ; undefined
     3b0:	12050000 	and	w0, w0, #0x8000000
     3b4:	00028003 	.inst	0x00028003 ; undefined
     3b8:	05180900 	mov	z0.b, p8/z, #72
     3bc:	0002f014 	.inst	0x0002f014 ; undefined
     3c0:	00cf0600 	.inst	0x00cf0600 ; undefined
     3c4:	15050000 	b	41403c4 <GPR_FRAME_SIZE+0x41402c4>
     3c8:	0002b008 	.inst	0x0002b008 ; undefined
     3cc:	1b060000 	madd	w0, w0, w6, w0
     3d0:	05000001 	orr	z1.s, z1.s, #0x1
     3d4:	02c11016 	.inst	0x02c11016 ; undefined
     3d8:	00080000 	.inst	0x00080000 ; undefined
     3dc:	00038e02 	.inst	0x00038e02 ; undefined
     3e0:	03170500 	.inst	0x03170500 ; undefined
     3e4:	000002cd 	udf	#717
     3e8:	00023f08 	.inst	0x00023f08 ; undefined
     3ec:	03091200 	.inst	0x03091200 ; undefined
     3f0:	40005340 	.inst	0x40005340 ; undefined
     3f4:	00000000 	udf	#0
     3f8:	00024908 	.inst	0x00024908 ; undefined
     3fc:	03091300 	.inst	0x03091300 ; undefined
     400:	40005348 	.inst	0x40005348 ; undefined
     404:	00000000 	udf	#0
     408:	00025308 	.inst	0x00025308 ; undefined
     40c:	03091800 	.inst	0x03091800 ; undefined
     410:	40005350 	.inst	0x40005350 ; undefined
     414:	00000000 	udf	#0
     418:	00026208 	.inst	0x00026208 ; undefined
     41c:	03091900 	.inst	0x03091900 ; undefined
     420:	40005358 	.inst	0x40005358 ; undefined
     424:	00000000 	udf	#0
     428:	00026c08 	.inst	0x00026c08 ; undefined
     42c:	03091a00 	.inst	0x03091a00 ; undefined
     430:	40005360 	.inst	0x40005360 ; undefined
     434:	00000000 	udf	#0
     438:	00027608 	.inst	0x00027608 ; undefined
     43c:	03091b00 	.inst	0x03091b00 ; undefined
     440:	40005364 	.inst	0x40005364 ; undefined
     444:	00000000 	udf	#0
     448:	0001100d 	.inst	0x0001100d ; undefined
     44c:	00036d00 	.inst	0x00036d00 ; undefined
     450:	01951000 	.inst	0x01951000 ; undefined
     454:	0fff0000 	fmlalb	v0.8h, v0.16b, v7.b[7]
     458:	017b1100 	.inst	0x017b1100 ; undefined
     45c:	5c1d0000 	ldr	d0, 3a45c <GPR_FRAME_SIZE+0x3a35c>
     460:	09000003 	.inst	0x09000003 ; undefined
     464:	00537003 	.inst	0x00537003 ; undefined
     468:	00000040 	udf	#64
     46c:	01100d00 	.inst	0x01100d00 ; undefined
     470:	03920000 	.inst	0x03920000 ; undefined
     474:	95100000 	bl	4400474 <GPR_FRAME_SIZE+0x4400374>
     478:	ff000001 	.inst	0xff000001 ; undefined
     47c:	c7110003 	.inst	0xc7110003 ; undefined
     480:	1e000003 	.inst	0x1e000003 ; undefined
     484:	00000381 	udf	#897
     488:	63700309 	.inst	0x63700309 ; undefined
     48c:	00004000 	udf	#16384
     490:	a0180000 	ld1b	{z0.b-z1.b}, pn8/z, [x0, x24]
     494:	02000001 	.inst	0x02000001 ; undefined
     498:	0072120d 	.inst	0x0072120d ; undefined
     49c:	00190000 	.inst	0x00190000 ; undefined
     4a0:	06000003 	.inst	0x06000003 ; undefined
     4a4:	02b0071d 	.inst	0x02b0071d ; undefined
     4a8:	03dc0000 	.inst	0x03dc0000 ; undefined
     4ac:	fe040000 	.inst	0xfe040000 ; undefined
     4b0:	04000001 	add	z1.b, p0/m, z1.b, z0.b
     4b4:	000000c1 	udf	#193
     4b8:	0002b004 	.inst	0x0002b004 ; undefined
     4bc:	017b0400 	.inst	0x017b0400 ; undefined
     4c0:	f1040000 	subs	x0, x0, #0x100
     4c4:	00000000 	udf	#0
     4c8:	0003af12 	.inst	0x0003af12 ; undefined
     4cc:	f2120400 	ands	x0, x0, #0xc0000000c000
     4d0:	04000003 	add	z3.b, p0/m, z3.b, z0.b
     4d4:	0000023a 	udf	#570
     4d8:	0003f204 	.inst	0x0003f204 ; undefined
     4dc:	bc0c0000 	stur	s0, [x0, #192]
     4e0:	12000002 	and	w2, w0, #0x1
     4e4:	000002d6 	udf	#726
     4e8:	04120806 	smulh	z6.b, p2/m, z6.b, z0.b
     4ec:	b0040000 	adrp	x0, 8001000 <GPR_FRAME_SIZE+0x8000f00>
     4f0:	04000002 	add	z2.b, p0/m, z2.b, z0.b
     4f4:	000002b0 	udf	#688
     4f8:	00017b04 	.inst	0x00017b04 ; undefined
     4fc:	a41a0000 	ld1rqb	{z0.b}, p0/z, [x0, x26]
     500:	01000002 	.inst	0x01000002 ; undefined
     504:	0f080d66 	.inst	0x0f080d66 ; undefined
     508:	00004000 	udf	#16384
     50c:	01240000 	.inst	0x01240000 ; undefined
     510:	00000000 	udf	#0
     514:	9c010000 	ldr	q0, 2514 <GPR_FRAME_SIZE+0x2414>
     518:	0000045b 	udf	#1115
     51c:	0001af0e 	.inst	0x0001af0e ; undefined
     520:	72136800 	ands	w0, w0, #0xffffe0ff
     524:	02000000 	.inst	0x02000000 ; undefined
     528:	490e6891 	.inst	0x490e6891 ; undefined
     52c:	6c000002 	stnp	d2, d0, [x0]
     530:	0002b008 	.inst	0x0002b008 ; undefined
     534:	78910200 	ldursh	x0, [x16, #-240]
     538:	00015d0e 	.inst	0x00015d0e ; undefined
     53c:	b0086d00 	adrp	x0, 10da1000 <GPR_FRAME_SIZE+0x10da0f00>
     540:	02000002 	.inst	0x02000002 ; undefined
     544:	13007091 	sbfx	w17, w4, #0, #29
     548:	00000149 	udf	#329
     54c:	000ed45e 	.inst	0x000ed45e ; undefined
     550:	00000040 	udf	#64
     554:	00003400 	udf	#13312
     558:	00000000 	udf	#0
     55c:	869c0100 	.inst	0x869c0100 ; undefined
     560:	14000004 	b	570 <GPR_FRAME_SIZE+0x470>
     564:	000002f5 	udf	#757
     568:	02f02e5e 	.inst	0x02f02e5e ; undefined
     56c:	83020000 	.inst	0x83020000 ; undefined
     570:	2c1b0000 	stnp	s0, s0, [x0, #216]
     574:	01000003 	.inst	0x01000003 ; undefined
     578:	0e640652 	shadd	v18.4h, v18.4h, v4.4h
     57c:	00004000 	udf	#16384
     580:	00700000 	.inst	0x00700000 ; undefined
     584:	00000000 	udf	#0
     588:	9c010000 	ldr	q0, 2588 <GPR_FRAME_SIZE+0x2488>
     58c:	000004b3 	udf	#1203
     590:	0002f514 	.inst	0x0002f514 ; undefined
     594:	f01a5200 	adrp	x0, 34a43000 <GPR_FRAME_SIZE+0x34a42f00>
     598:	02000002 	.inst	0x02000002 ; undefined
     59c:	13000083 	sbfx	w3, w4, #0, #1
     5a0:	00000330 	udf	#816
     5a4:	000d4c37 	.inst	0x000d4c37 ; undefined
     5a8:	00000040 	udf	#64
     5ac:	00011800 	.inst	0x00011800 ; undefined
     5b0:	00000000 	udf	#0
     5b4:	e09c0100 	ld1w	{za0h.s[w12, 0]}, p0/z, [x8, x28, lsl #2]
     5b8:	1c000004 	ldr	s4, 5b8 <GPR_FRAME_SIZE+0x4b8>
     5bc:	00667562 	.inst	0x00667562 ; undefined
     5c0:	e0073901 	ld1b	{za0h.b[w13, 1]}, p6/z, [x8, x7]
     5c4:	03000004 	.inst	0x03000004 ; undefined
     5c8:	007eb891 	.inst	0x007eb891 ; undefined
     5cc:	0002b50d 	.inst	0x0002b50d ; undefined
     5d0:	0004f000 	.inst	0x0004f000 ; undefined
     5d4:	01951d00 	.inst	0x01951d00 ; undefined
     5d8:	00c70000 	.inst	0x00c70000 ; undefined
     5dc:	00012b1e 	.inst	0x00012b1e ; undefined
     5e0:	06200100 	.inst	0x06200100 ; undefined
     5e4:	40000c98 	.inst	0x40000c98 ; undefined
     5e8:	00000000 	udf	#0
     5ec:	000000b4 	udf	#180
     5f0:	00000000 	udf	#0
     5f4:	ee009c01 	.inst	0xee009c01 ; undefined
     5f8:	05000004 	orr	z4.s, z4.s, #0x1
     5fc:	73080100 	.inst	0x73080100 ; undefined
     600:	12000002 	and	w2, w0, #0x1
     604:	000001b6 	udf	#438
     608:	0001611d 	.inst	0x0001611d ; undefined
     60c:	00000000 	udf	#0
     610:	00102c00 	.inst	0x00102c00 ; undefined
     614:	00000040 	udf	#64
     618:	00023000 	.inst	0x00023000 ; undefined
     61c:	00000000 	udf	#0
     620:	00041e00 	.inst	0x00041e00 ; undefined
     624:	03040a00 	.inst	0x03040a00 ; undefined
     628:	006c0905 	.inst	0x006c0905 ; undefined
     62c:	660b0000 	.inst	0x660b0000 ; undefined
     630:	03007169 	.inst	0x03007169 ; undefined
     634:	006c0706 	.inst	0x006c0706 ; undefined
     638:	0b000000 	add	w0, w0, w0
     63c:	00717269 	.inst	0x00717269 ; undefined
     640:	6c070703 	stnp	d3, d1, [x24, #112]
     644:	01000000 	.inst	0x01000000 ; undefined
     648:	00023406 	.inst	0x00023406 ; undefined
     64c:	07080300 	.inst	0x07080300 ; undefined
     650:	0000006c 	udf	#108
     654:	01900602 	.inst	0x01900602 ; undefined
     658:	09030000 	.inst	0x09030000 ; undefined
     65c:	00006c07 	udf	#27655
     660:	04000300 	add	z0.b, p0/m, z0.b, z24.b
     664:	041c0201 	.inst	0x041c0201 ; undefined
     668:	f5010000 	.inst	0xf5010000 ; undefined
     66c:	03000000 	.inst	0x03000000 ; undefined
     670:	002e030a 	.inst	0x002e030a ; NYI
     674:	bb0c0000 	.inst	0xbb0c0000 ; undefined
     678:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     67c:	0000bb0b 	udf	#47883
     680:	02980200 	.inst	0x02980200 ; undefined
     684:	02000000 	.inst	0x02000000 ; undefined
     688:	00000336 	udf	#822
     68c:	02570201 	.inst	0x02570201 ; undefined
     690:	02020000 	.inst	0x02020000 ; undefined
     694:	00000283 	udf	#643
     698:	02640203 	.inst	0x02640203 ; undefined
     69c:	02040000 	.inst	0x02040000 ; undefined
     6a0:	000002b4 	udf	#692
     6a4:	00d70205 	.inst	0x00d70205 ; undefined
     6a8:	02060000 	.inst	0x02060000 ; undefined
     6ac:	000003e4 	udf	#996
     6b0:	04040007 	.inst	0x04040007 ; undefined
     6b4:	00031a07 	.inst	0x00031a07 ; undefined
     6b8:	03a20100 	.inst	0x03a20100 ; undefined
     6bc:	14040000 	b	1006bc <GPR_FRAME_SIZE+0x1005bc>
     6c0:	00007f03 	udf	#32515
     6c4:	00bb0c00 	.inst	0x00bb0c00 ; undefined
     6c8:	17040000 	b	fffffffffc1006c8 <__stack_el2_top+0xffffffffbaaf96c8>
     6cc:	000000f2 	udf	#242
     6d0:	00016602 	.inst	0x00016602 ; undefined
     6d4:	79020a00 	strh	w0, [x16, #260]
     6d8:	10000003 	adr	x3, 6d8 <GPR_FRAME_SIZE+0x5d8>
     6dc:	00035602 	.inst	0x00035602 ; undefined
     6e0:	06020200 	.inst	0x06020200 ; undefined
     6e4:	08000001 	stxrb	w0, w1, [x0]
     6e8:	00e40100 	.inst	0x00e40100 ; undefined
     6ec:	1c040000 	ldr	s0, 86ec <GPR_FRAME_SIZE+0x85ec>
     6f0:	0000ce03 	udf	#52739
     6f4:	02520100 	.inst	0x02520100 ; undefined
     6f8:	1e040000 	.inst	0x1e040000 ; undefined
     6fc:	00010a15 	.inst	0x00010a15 ; undefined
     700:	06010400 	.inst	0x06010400 ; undefined
     704:	0000023d 	udf	#573
     708:	00025101 	.inst	0x00025101 ; undefined
     70c:	171f0400 	b	fffffffffc7c170c <__stack_el2_top+0xffffffffbb1ba70c>
     710:	0000011d 	udf	#285
     714:	3b080104 	.inst	0x3b080104 ; undefined
     718:	01000002 	.inst	0x01000002 ; undefined
     71c:	00000292 	udf	#658
     720:	30162104 	adr	x4, 2cb41 <GPR_FRAME_SIZE+0x2ca41>
     724:	04000001 	add	z1.b, p0/m, z1.b, z0.b
     728:	03980502 	.inst	0x03980502 ; undefined
     72c:	91010000 	add	x0, x0, #0x40
     730:	04000002 	add	z2.b, p0/m, z2.b, z0.b
     734:	01431822 	.inst	0x01431822 ; undefined
     738:	02040000 	.inst	0x02040000 ; undefined
     73c:	00013607 	.inst	0x00013607 ; undefined
     740:	02d00100 	.inst	0x02d00100 ; undefined
     744:	24040000 	cmphs	p0.b, p0/z, z0.b, z4.b
     748:	00015614 	.inst	0x00015614 ; undefined
     74c:	05041300 	.inst	0x05041300 ; undefined
     750:	00746e69 	.inst	0x00746e69 ; undefined
     754:	0002cf01 	.inst	0x0002cf01 ; undefined
     758:	16250400 	b	fffffffff8941758 <__stack_el2_top+0xffffffffb733a758>
     75c:	000000bb 	udf	#187
     760:	00012501 	.inst	0x00012501 ; undefined
     764:	1a270400 	.inst	0x1a270400 ; undefined
     768:	00000175 	udf	#373
     76c:	6b050804 	subs	w4, w0, w5, lsl #2
     770:	01000003 	.inst	0x01000003 ; undefined
     774:	00000124 	udf	#292
     778:	881c2804 	stxr	w28, w4, [x0]
     77c:	04000001 	add	z1.b, p0/m, z1.b, z0.b
     780:	03100708 	.inst	0x03100708 ; undefined
     784:	88140000 	stxr	w20, w0, [x0]
     788:	04000001 	add	z1.b, p0/m, z1.b, z0.b
     78c:	03700508 	.inst	0x03700508 ; undefined
     790:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     794:	04000005 	add	z5.b, p0/m, z5.b, z0.b
     798:	01a71734 	.inst	0x01a71734 ; undefined
     79c:	08040000 	stxrb	w4, w0, [x0]
     7a0:	00031507 	.inst	0x00031507 ; undefined
     7a4:	04400100 	add	z0.h, p0/m, z0.h, z8.h
     7a8:	35040000 	cbnz	w0, 87a8 <GPR_FRAME_SIZE+0x86a8>
     7ac:	0001a717 	.inst	0x0001a717 ; undefined
     7b0:	04081500 	smax	z0.b, p5/m, z0.b, z8.b
     7b4:	021c0958 	.inst	0x021c0958 ; undefined
     7b8:	52050000 	eor	w0, w0, #0x8000000
     7bc:	59000002 	stlurh	w2, [x0]
     7c0:	0000fe07 	udf	#65031
     7c4:	02510500 	.inst	0x02510500 ; undefined
     7c8:	085a0000 	ldxrb	w0, [x0]
     7cc:	00000111 	udf	#273
     7d0:	00029205 	.inst	0x00029205 ; undefined
     7d4:	24085c00 	cmpge	p0.b, p7/z, z0.b, z8.d
     7d8:	05000001 	orr	z1.s, z1.s, #0x1
     7dc:	00000291 	udf	#657
     7e0:	0137095d 	.inst	0x0137095d ; undefined
     7e4:	d0050000 	adrp	x0, a002000 <GPR_FRAME_SIZE+0xa001f00>
     7e8:	5f000002 	.inst	0x5f000002 ; undefined
     7ec:	00014a08 	.inst	0x00014a08 ; undefined
     7f0:	02cf0500 	.inst	0x02cf0500 ; undefined
     7f4:	09600000 	.inst	0x09600000 ; undefined
     7f8:	0000015d 	udf	#349
     7fc:	00012505 	.inst	0x00012505 ; undefined
     800:	69086200 	stgp	x0, x24, [x16, #256]
     804:	05000001 	orr	z1.s, z1.s, #0x1
     808:	00000124 	udf	#292
     80c:	017c0963 	.inst	0x017c0963 ; undefined
     810:	01000000 	.inst	0x01000000 ; undefined
     814:	000002c2 	udf	#706
     818:	ba036404 	.inst	0xba036404 ; undefined
     81c:	0c000001 	st4	{v1.8b-v4.8b}, [x0]
     820:	000000bb 	udf	#187
     824:	024c0505 	.inst	0x024c0505 ; undefined
     828:	22020000 	.inst	0x22020000 ; undefined
     82c:	00000004 	udf	#4
     830:	00019602 	.inst	0x00019602 ; undefined
     834:	2c020100 	stnp	s0, s0, [x8, #16]
     838:	02000004 	.inst	0x02000004 ; undefined
     83c:	00043602 	.inst	0x00043602 ; undefined
     840:	01000300 	.inst	0x01000300 ; undefined
     844:	0000027b 	udf	#635
     848:	28030a05 	stnp	w5, w2, [x16, #24]
     84c:	0d000002 	st1	{v2.b}[0], [x0]
     850:	0000024c 	udf	#588
     854:	00011107 	.inst	0x00011107 ; undefined
     858:	02670700 	.inst	0x02670700 ; undefined
     85c:	01040000 	.inst	0x01040000 ; undefined
     860:	00024408 	.inst	0x00024408 ; undefined
     864:	02670d00 	.inst	0x02670d00 ; undefined
     868:	040a0000 	smin	z0.b, p0/m, z0.b, z0.b
     86c:	b1090506 	adds	x6, x8, #0x241
     870:	06000002 	.inst	0x06000002 ; undefined
     874:	000004bd 	udf	#1213
     878:	11080606 	add	w6, w16, #0x201
     87c:	00000001 	udf	#1
     880:	0004b806 	.inst	0x0004b806 ; undefined
     884:	08070600 	stxrb	w7, w0, [x16]
     888:	00000111 	udf	#273
     88c:	04b30601 	sub	z1.s, z16.s, z19.s
     890:	09060000 	.inst	0x09060000 ; undefined
     894:	00011108 	.inst	0x00011108 ; undefined
     898:	08060200 	stxrb	w6, w0, [x16]
     89c:	06000005 	.inst	0x06000005 ; undefined
     8a0:	0111080b 	.inst	0x0111080b ; undefined
     8a4:	00030000 	.inst	0x00030000 ; undefined
     8a8:	0004fc01 	.inst	0x0004fc01 ; undefined
     8ac:	030c0600 	.inst	0x030c0600 ; undefined
     8b0:	00000273 	udf	#627
     8b4:	00045101 	.inst	0x00045101 ; undefined
     8b8:	25040700 	cmpge	p0.b, p1/z, z24.b, #4
     8bc:	0000018f 	udf	#399
     8c0:	0004f201 	.inst	0x0004f201 ; undefined
     8c4:	10070700 	adr	x0, e9a4 <GPR_FRAME_SIZE+0xe8a4>
     8c8:	000002d5 	udf	#725
     8cc:	0002bd07 	.inst	0x0002bd07 ; undefined
     8d0:	01080a00 	.inst	0x01080a00 ; undefined
     8d4:	02f10112 	.inst	0x02f10112 ; undefined
     8d8:	760b0000 	.inst	0x760b0000 ; undefined
     8dc:	01006c61 	.inst	0x01006c61 ; undefined
     8e0:	017c0112 	.inst	0x017c0112 ; undefined
     8e4:	00000000 	udf	#0
     8e8:	00044701 	.inst	0x00044701 ; undefined
     8ec:	01120100 	.inst	0x01120100 ; undefined
     8f0:	000002da 	udf	#730
     8f4:	0002f10d 	.inst	0x0002f10d ; undefined
     8f8:	04e80800 	addpt	z0.d, z0.d, z8.d
     8fc:	10050000 	adr	x0, a8fc <GPR_FRAME_SIZE+0xa7fc>
     900:	00000318 	udf	#792
     904:	00024c03 	.inst	0x00024c03 ; undefined
     908:	01110300 	.inst	0x01110300 ; undefined
     90c:	0f000000 	fdot	v0.2s, v0.8b, v0.4b[0]
     910:	0000051a 	udf	#1306
     914:	6c061405 	stnp	d5, d5, [x0, #96]
     918:	33000000 	bfxil	w0, w0, #0, #1
     91c:	03000003 	.inst	0x03000003 ; undefined
     920:	0000024c 	udf	#588
     924:	00025d03 	.inst	0x00025d03 ; undefined
     928:	0d160000 	.inst	0x0d160000 ; undefined
     92c:	02000005 	.inst	0x02000005 ; undefined
     930:	017c0f1e 	.inst	0x017c0f1e ; undefined
     934:	000f0000 	.inst	0x000f0000 ; undefined
     938:	08000003 	stxrb	w0, w3, [x0]
     93c:	0262071d 	.inst	0x0262071d ; undefined
     940:	03690000 	.inst	0x03690000 ; undefined
     944:	1c030000 	ldr	s0, 6944 <GPR_FRAME_SIZE+0x6844>
     948:	03000002 	.inst	0x03000002 ; undefined
     94c:	000000c2 	udf	#194
     950:	00026203 	.inst	0x00026203 ; undefined
     954:	017c0300 	.inst	0x017c0300 ; undefined
     958:	f2030000 	ands	x0, x0, #0x2000000020000000
     95c:	00000000 	udf	#0
     960:	0003af08 	.inst	0x0003af08 ; undefined
     964:	7f120500 	.inst	0x7f120500 ; undefined
     968:	03000003 	.inst	0x03000003 ; undefined
     96c:	00000258 	udf	#600
     970:	00037f03 	.inst	0x00037f03 ; undefined
     974:	6e070000 	ext	v0.16b, v0.16b, v7.16b, #0
     978:	08000002 	stxrb	w0, w2, [x0]
     97c:	00000473 	udf	#1139
     980:	03951003 	.inst	0x03951003 ; undefined
     984:	73030000 	.inst	0x73030000 ; undefined
     988:	00000000 	udf	#0
     98c:	00045708 	.inst	0x00045708 ; undefined
     990:	a60e0500 	.inst	0xa60e0500 ; undefined
     994:	03000003 	.inst	0x03000003 ; undefined
     998:	0000024c 	udf	#588
     99c:	012b1700 	.inst	0x012b1700 ; undefined
     9a0:	19090000 	stlurb	w0, [x0, #144]
     9a4:	04611806 	sqsub	z6.h, z0.h, z1.h
     9a8:	21020000 	.inst	0x21020000 ; undefined
     9ac:	00110010 	.inst	0x00110010 ; undefined
     9b0:	00000040 	udf	#64
     9b4:	00015c00 	.inst	0x00015c00 ; undefined
     9b8:	00000000 	udf	#0
     9bc:	5d9c0100 	.inst	0x5d9c0100 ; undefined
     9c0:	0e000004 	tbl	v4.8b, {v0.16b}, v0.8b
     9c4:	00667562 	.inst	0x00667562 ; undefined
     9c8:	045d0727 	.inst	0x045d0727 ; undefined
     9cc:	91030000 	add	x0, x0, #0xc0
     9d0:	9f097bf8 	.inst	0x9f097bf8 ; undefined
     9d4:	02000004 	.inst	0x02000004 ; undefined
     9d8:	017c0936 	.inst	0x017c0936 ; undefined
     9dc:	91020000 	add	x0, x0, #0x80
     9e0:	11241970 	add	w16, w11, #0x906
     9e4:	00004000 	udf	#16384
     9e8:	00d40000 	.inst	0x00d40000 ; undefined
     9ec:	00000000 	udf	#0
     9f0:	043a0000 	add	z0.b, z0.b, z26.b
     9f4:	690e0000 	stgp	x0, x0, [x0, #448]
     9f8:	ae0e2900 	.inst	0xae0e2900 ; undefined
     9fc:	02000001 	.inst	0x02000001 ; undefined
     a00:	2c107891 	stnp	s17, s30, [x4, #128]
     a04:	00400011 	.inst	0x00400011 ; undefined
     a08:	b4000000 	cbz	x0, a08 <GPR_FRAME_SIZE+0x908>
     a0c:	00000000 	udf	#0
     a10:	0e000000 	tbl	v0.8b, {v0.16b}, v0.8b
     a14:	0d2a0072 	.inst	0x0d2a0072 ; undefined
     a18:	000002f1 	udf	#753
     a1c:	7bf09103 	.inst	0x7bf09103 ; undefined
     a20:	00054d09 	.inst	0x00054d09 ; undefined
     a24:	0a2c0200 	bic	w0, w16, w12
     a28:	0000015d 	udf	#349
     a2c:	006c9102 	.inst	0x006c9102 ; undefined
     a30:	12281000 	and	w0, w0, #0x1f000000
     a34:	00004000 	udf	#16384
     a38:	00300000 	.inst	0x00300000 ; NYI
     a3c:	00000000 	udf	#0
     a40:	6e090000 	ext	v0.16b, v0.16b, v9.16b, #0
     a44:	02000004 	.inst	0x02000004 ; undefined
     a48:	0111093d 	.inst	0x0111093d ; undefined
     a4c:	91030000 	add	x0, x0, #0xc0
     a50:	00007bef 	udf	#31727
     a54:	0002671a 	.inst	0x0002671a ; undefined
     a58:	00046e00 	.inst	0x00046e00 ; undefined
     a5c:	01a71b00 	.inst	0x01a71b00 ; undefined
     a60:	01f30000 	.inst	0x01f30000 ; undefined
     a64:	04a71c00 	uqsub	z0.s, z0.s, z7.s
     a68:	10020000 	adr	x0, 4a68 <GPR_FRAME_SIZE+0x4968>
     a6c:	0010b00d 	.inst	0x0010b00d ; undefined
     a70:	00000040 	udf	#64
     a74:	00005000 	udf	#20480
     a78:	00000000 	udf	#0
     a7c:	1d9c0100 	.inst	0x1d9c0100 ; undefined
     a80:	000004c2 	udf	#1218
     a84:	b11b2201 	adds	x1, x16, #0x6c8
     a88:	54000002 	b.cs	a88 <GPR_FRAME_SIZE+0x988>  // b.hs, b.nlast
     a8c:	00400010 	.inst	0x00400010 ; undefined
     a90:	5c000000 	ldr	d0, a90 <GPR_FRAME_SIZE+0x990>
     a94:	00000000 	udf	#0
     a98:	01000000 	.inst	0x01000000 ; undefined
     a9c:	0004c69c 	.inst	0x0004c69c ; undefined
     aa0:	00721100 	.inst	0x00721100 ; undefined
     aa4:	02fd1223 	.inst	0x02fd1223 ; undefined
     aa8:	91020000 	add	x0, x0, #0x80
     aac:	054d0968 	.inst	0x054d0968 ; undefined
     ab0:	25010000 	cmpge	p0.b, p0/z, z0.b, #1
     ab4:	00015d09 	.inst	0x00015d09 ; undefined
     ab8:	7c910200 	.inst	0x7c910200 ; undefined
     abc:	04891e00 	umax	z0.s, p7/m, z0.s, z16.s
     ac0:	14010000 	b	40ac0 <GPR_FRAME_SIZE+0x409c0>
     ac4:	0002f101 	.inst	0x0002f101 ; undefined
     ac8:	00102c00 	.inst	0x00102c00 ; undefined
     acc:	00000040 	udf	#64
     ad0:	00002800 	udf	#10240
     ad4:	00000000 	udf	#0
     ad8:	119c0100 	.inst	0x119c0100 ; undefined
     adc:	0114006e 	.inst	0x0114006e ; undefined
     ae0:	000001ae 	udf	#430
     ae4:	00789102 	.inst	0x00789102 ; undefined
     ae8:	00011200 	.inst	0x00011200 ; undefined
     aec:	01000500 	.inst	0x01000500 ; undefined
     af0:	00045308 	.inst	0x00045308 ; undefined
     af4:	01b60400 	.inst	0x01b60400 ; undefined
     af8:	e61d0000 	.inst	0xe61d0000 ; undefined
     afc:	00000001 	udf	#1
     b00:	5c000000 	ldr	d0, b00 <GPR_FRAME_SIZE+0xa00>
     b04:	00400012 	.inst	0x00400012 ; undefined
     b08:	58000000 	ldr	x0, b08 <GPR_FRAME_SIZE+0xa08>
     b0c:	00000000 	udf	#0
     b10:	3d000000 	str	b0, [x0]
     b14:	01000005 	.inst	0x01000005 ; undefined
     b18:	031a0704 	.inst	0x031a0704 ; undefined
     b1c:	01010000 	.inst	0x01010000 ; undefined
     b20:	00023d06 	.inst	0x00023d06 ; undefined
     b24:	02510300 	.inst	0x02510300 ; undefined
     b28:	1f020000 	fmadd	s0, s0, s2, s0
     b2c:	00004817 	udf	#18455
     b30:	08010100 	stxrb	w1, w0, [x8]
     b34:	0000023b 	udf	#571
     b38:	98050201 	ldrsw	x1, ab78 <GPR_FRAME_SIZE+0xaa78>
     b3c:	01000003 	.inst	0x01000003 ; undefined
     b40:	01360702 	.inst	0x01360702 ; undefined
     b44:	04050000 	.inst	0x04050000 ; undefined
     b48:	746e6905 	.inst	0x746e6905 ; undefined
     b4c:	05080100 	.inst	0x05080100 ; undefined
     b50:	0000036b 	udf	#875
     b54:	00012403 	.inst	0x00012403 ; undefined
     b58:	1c280200 	ldr	s0, 50b98 <GPR_FRAME_SIZE+0x50a98>
     b5c:	00000077 	udf	#119
     b60:	10070801 	adr	x1, ec60 <GPR_FRAME_SIZE+0xeb60>
     b64:	01000003 	.inst	0x01000003 ; undefined
     b68:	03700508 	.inst	0x03700508 ; undefined
     b6c:	08010000 	stxrb	w1, w0, [x0]
     b70:	00031507 	.inst	0x00031507 ; undefined
     b74:	03040600 	.inst	0x03040600 ; undefined
     b78:	00c20905 	.inst	0x00c20905 ; undefined
     b7c:	bd020000 	str	s0, [x0, #512]
     b80:	06000004 	.inst	0x06000004 ; undefined
     b84:	0000003c 	udf	#60
     b88:	04b80200 	add	z0.s, z16.s, z24.s
     b8c:	3c070000 	stur	b0, [x0, #112]
     b90:	01000000 	.inst	0x01000000 ; undefined
     b94:	0004b302 	.inst	0x0004b302 ; undefined
     b98:	003c0900 	.inst	0x003c0900 ; NYI
     b9c:	02020000 	.inst	0x02020000 ; undefined
     ba0:	00000508 	udf	#1288
     ba4:	00003c0b 	udf	#15371
     ba8:	03000300 	.inst	0x03000300 ; undefined
     bac:	000004fc 	udf	#1276
     bb0:	8c030c03 	.inst	0x8c030c03 ; undefined
     bb4:	07000000 	.inst	0x07000000 ; undefined
     bb8:	00000532 	udf	#1330
     bbc:	6b080704 	subs	w4, w24, w8, lsl #1
     bc0:	08000000 	stxrb	w0, w0, [x0]
     bc4:	00000541 	udf	#1345
     bc8:	c20d0601 	.inst	0xc20d0601 ; undefined
     bcc:	5c000000 	ldr	d0, bcc <GPR_FRAME_SIZE+0xacc>
     bd0:	00400012 	.inst	0x00400012 ; undefined
     bd4:	58000000 	ldr	x0, bd4 <GPR_FRAME_SIZE+0xad4>
     bd8:	00000000 	udf	#0
     bdc:	01000000 	.inst	0x01000000 ; undefined
     be0:	0076099c 	.inst	0x0076099c ; undefined
     be4:	6b090801 	subs	w1, w0, w9, lsl #2
     be8:	02000000 	.inst	0x02000000 ; undefined
     bec:	2c0a7891 	stnp	s17, s30, [x4, #80]
     bf0:	01000005 	.inst	0x01000005 ; undefined
     bf4:	00c20e09 	.inst	0x00c20e09 ; undefined
     bf8:	91020000 	add	x0, x0, #0x80
     bfc:	1b000070 	madd	w16, w3, w0, w0
     c00:	05000001 	orr	z1.s, z1.s, #0x1
     c04:	00080100 	.inst	0x00080100 ; undefined
     c08:	05000005 	orr	z5.s, z5.s, #0x1
     c0c:	000001b6 	udf	#438
     c10:	0001ff1d 	.inst	0x0001ff1d ; undefined
     c14:	00000000 	udf	#0
     c18:	0012b400 	.inst	0x0012b400 ; undefined
     c1c:	00000040 	udf	#64
     c20:	00004c00 	udf	#19456
     c24:	00000000 	udf	#0
     c28:	0005bc00 	.inst	0x0005bc00 ; undefined
     c2c:	07040100 	.inst	0x07040100 ; undefined
     c30:	0000031a 	udf	#794
     c34:	3d060101 	str	b1, [x8, #384]
     c38:	01000002 	.inst	0x01000002 ; undefined
     c3c:	023b0801 	.inst	0x023b0801 ; undefined
     c40:	02010000 	.inst	0x02010000 ; undefined
     c44:	00039805 	.inst	0x00039805 ; undefined
     c48:	07020100 	.inst	0x07020100 ; undefined
     c4c:	00000136 	udf	#310
     c50:	69050406 	stgp	x6, x1, [x0, #160]
     c54:	0300746e 	.inst	0x0300746e ; undefined
     c58:	000002cf 	udf	#719
     c5c:	2e162503 	.inst	0x2e162503 ; undefined
     c60:	01000000 	.inst	0x01000000 ; undefined
     c64:	036b0508 	.inst	0x036b0508 ; undefined
     c68:	08010000 	stxrb	w1, w0, [x0]
     c6c:	00031007 	.inst	0x00031007 ; undefined
     c70:	05080100 	.inst	0x05080100 ; undefined
     c74:	00000370 	udf	#880
     c78:	15070801 	b	41c2c7c <GPR_FRAME_SIZE+0x41c2b7c>
     c7c:	04000003 	add	z3.b, p0/m, z3.b, z0.b
     c80:	00ad0e10 	.inst	0x00ad0e10 ; undefined
     c84:	2f020000 	.inst	0x2f020000 ; undefined
     c88:	0f000002 	fdot	v2.2s, v0.8b, v0.4b[0]
     c8c:	0000ad08 	udf	#44296
     c90:	27020000 	.inst	0x27020000 ; undefined
     c94:	10000003 	adr	x3, c94 <GPR_FRAME_SIZE+0xb94>
     c98:	00005809 	udf	#22537
     c9c:	63070800 	.inst	0x63070800 ; undefined
     ca0:	02006c6f 	.inst	0x02006c6f ; undefined
     ca4:	00580911 	.inst	0x00580911 ; undefined
     ca8:	000c0000 	.inst	0x000c0000 ; undefined
     cac:	00b30808 	.inst	0x00b30808 ; undefined
     cb0:	01010000 	.inst	0x01010000 ; undefined
     cb4:	00024408 	.inst	0x00024408 ; undefined
     cb8:	03b90300 	.inst	0x03b90300 ; undefined
     cbc:	12020000 	and	w0, w0, #0x40000000
     cc0:	00008003 	udf	#32771
     cc4:	14180400 	b	601cc4 <GPR_FRAME_SIZE+0x601bc4>
     cc8:	000000e6 	udf	#230
     ccc:	0000cf02 	udf	#52994
     cd0:	ad081500 	stp	q0, q5, [x8, #256]
     cd4:	00000000 	udf	#0
     cd8:	00011b02 	.inst	0x00011b02 ; undefined
     cdc:	ba101600 	.inst	0xba101600 ; undefined
     ce0:	08000000 	stxrb	w0, w0, [x0]
     ce4:	038e0300 	.inst	0x038e0300 ; undefined
     ce8:	17020000 	b	fffffffffc080ce8 <__stack_el2_top+0xffffffffbaa79ce8>
     cec:	0000c603 	udf	#50691
     cf0:	01490900 	.inst	0x01490900 ; undefined
     cf4:	1c020000 	ldr	s0, 4cf4 <GPR_FRAME_SIZE+0x4bf4>
     cf8:	00010410 	.inst	0x00010410 ; undefined
     cfc:	00e60a00 	.inst	0x00e60a00 ; undefined
     d00:	0b000000 	add	w0, w0, w0
     d04:	00000556 	udf	#1366
     d08:	b4010301 	cbz	x1, 2d68 <GPR_FRAME_SIZE+0x2c68>
     d0c:	00400012 	.inst	0x00400012 ; undefined
     d10:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
     d14:	00000000 	udf	#0
     d18:	01000000 	.inst	0x01000000 ; undefined
     d1c:	011b009c 	.inst	0x011b009c ; undefined
     d20:	00050000 	.inst	0x00050000 ; undefined
     d24:	05ae0801 	uzp1	z1.q, z0.q, z14.q
     d28:	b6050000 	tbz	x0, #32, ffffffffffffad28 <__stack_el2_top+0xffffffffbe9f3d28>
     d2c:	1d000001 	.inst	0x1d000001 ; undefined
     d30:	00000256 	udf	#598
     d34:	00000000 	udf	#0
     d38:	40001300 	.inst	0x40001300 ; undefined
     d3c:	00000000 	udf	#0
     d40:	0000004c 	udf	#76
     d44:	00000000 	udf	#0
     d48:	0000061b 	udf	#1563
     d4c:	1a070401 	.inst	0x1a070401 ; undefined
     d50:	01000003 	.inst	0x01000003 ; undefined
     d54:	023d0601 	.inst	0x023d0601 ; undefined
     d58:	01010000 	.inst	0x01010000 ; undefined
     d5c:	00023b08 	.inst	0x00023b08 ; undefined
     d60:	05020100 	orr	z0.d, z0.d, #0x1ff
     d64:	00000398 	udf	#920
     d68:	36070201 	tbz	w1, #0, ffffffffffffeda8 <__stack_el2_top+0xffffffffbe9f7da8>
     d6c:	06000001 	.inst	0x06000001 ; undefined
     d70:	6e690504 	uhadd	v4.8h, v8.8h, v9.8h
     d74:	cf030074 	.inst	0xcf030074 ; undefined
     d78:	03000002 	.inst	0x03000002 ; undefined
     d7c:	002e1625 	.inst	0x002e1625 ; NYI
     d80:	08010000 	stxrb	w1, w0, [x0]
     d84:	00036b05 	.inst	0x00036b05 ; undefined
     d88:	07080100 	.inst	0x07080100 ; undefined
     d8c:	00000310 	udf	#784
     d90:	70050801 	adr	x1, ae93 <GPR_FRAME_SIZE+0xad93>
     d94:	01000003 	.inst	0x01000003 ; undefined
     d98:	03150708 	.inst	0x03150708 ; undefined
     d9c:	10040000 	adr	x0, 8d9c <GPR_FRAME_SIZE+0x8c9c>
     da0:	0000ad0e 	udf	#44302
     da4:	022f0200 	.inst	0x022f0200 ; undefined
     da8:	080f0000 	stxrb	w15, w0, [x0]
     dac:	000000ad 	udf	#173
     db0:	03270200 	.inst	0x03270200 ; undefined
     db4:	09100000 	.inst	0x09100000 ; undefined
     db8:	00000058 	udf	#88
     dbc:	6f630708 	ushr	v8.2d, v24.2d, #29
     dc0:	1102006c 	add	w12, w3, #0x80
     dc4:	00005809 	udf	#22537
     dc8:	08000c00 	stxrb	w0, w0, [x0]
     dcc:	0000b308 	udf	#45832
     dd0:	08010100 	stxrb	w1, w0, [x8]
     dd4:	00000244 	udf	#580
     dd8:	0003b903 	.inst	0x0003b903 ; undefined
     ddc:	03120200 	.inst	0x03120200 ; undefined
     de0:	00000080 	udf	#128
     de4:	e6141804 	.inst	0xe6141804 ; undefined
     de8:	02000000 	.inst	0x02000000 ; undefined
     dec:	000000cf 	udf	#207
     df0:	00ad0815 	.inst	0x00ad0815 ; undefined
     df4:	02000000 	.inst	0x02000000 ; undefined
     df8:	0000011b 	udf	#283
     dfc:	00ba1016 	.inst	0x00ba1016 ; undefined
     e00:	00080000 	.inst	0x00080000 ; undefined
     e04:	00038e03 	.inst	0x00038e03 ; undefined
     e08:	03170200 	.inst	0x03170200 ; undefined
     e0c:	000000c6 	udf	#198
     e10:	00014909 	.inst	0x00014909 ; undefined
     e14:	101c0200 	adr	x0, 38e54 <GPR_FRAME_SIZE+0x38d54>
     e18:	00000104 	udf	#260
     e1c:	0000e60a 	udf	#58890
     e20:	710b0000 	subs	w0, w0, #0x2c0
     e24:	01000005 	.inst	0x01000005 ; undefined
     e28:	13000103 	sbfx	w3, w8, #0, #1
     e2c:	00004000 	udf	#16384
     e30:	004c0000 	.inst	0x004c0000 ; undefined
     e34:	00000000 	udf	#0
     e38:	9c010000 	ldr	q0, 2e38 <GPR_FRAME_SIZE+0x2d38>
     e3c:	00011b00 	.inst	0x00011b00 ; undefined
     e40:	01000500 	.inst	0x01000500 ; undefined
     e44:	00065c08 	.inst	0x00065c08 ; undefined
     e48:	01b60500 	.inst	0x01b60500 ; undefined
     e4c:	8c1d0000 	.inst	0x8c1d0000 ; undefined
     e50:	00000002 	udf	#2
     e54:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
     e58:	00400013 	.inst	0x00400013 ; undefined
     e5c:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
     e60:	00000000 	udf	#0
     e64:	7a000000 	sbcs	w0, w0, w0
     e68:	01000006 	.inst	0x01000006 ; undefined
     e6c:	031a0704 	.inst	0x031a0704 ; undefined
     e70:	01010000 	.inst	0x01010000 ; undefined
     e74:	00023d06 	.inst	0x00023d06 ; undefined
     e78:	08010100 	stxrb	w1, w0, [x8]
     e7c:	0000023b 	udf	#571
     e80:	98050201 	ldrsw	x1, aec0 <GPR_FRAME_SIZE+0xadc0>
     e84:	01000003 	.inst	0x01000003 ; undefined
     e88:	01360702 	.inst	0x01360702 ; undefined
     e8c:	04060000 	.inst	0x04060000 ; undefined
     e90:	746e6905 	.inst	0x746e6905 ; undefined
     e94:	02cf0300 	.inst	0x02cf0300 ; undefined
     e98:	25030000 	cmpge	p0.b, p0/z, z0.b, #3
     e9c:	00002e16 	udf	#11798
     ea0:	05080100 	.inst	0x05080100 ; undefined
     ea4:	0000036b 	udf	#875
     ea8:	10070801 	adr	x1, efa8 <GPR_FRAME_SIZE+0xeea8>
     eac:	01000003 	.inst	0x01000003 ; undefined
     eb0:	03700508 	.inst	0x03700508 ; undefined
     eb4:	08010000 	stxrb	w1, w0, [x0]
     eb8:	00031507 	.inst	0x00031507 ; undefined
     ebc:	0e100400 	.inst	0x0e100400 ; undefined
     ec0:	000000ad 	udf	#173
     ec4:	00022f02 	.inst	0x00022f02 ; undefined
     ec8:	ad080f00 	stp	q0, q3, [x24, #256]
     ecc:	00000000 	udf	#0
     ed0:	00032702 	.inst	0x00032702 ; undefined
     ed4:	58091000 	ldr	x0, 130d4 <GPR_FRAME_SIZE+0x12fd4>
     ed8:	08000000 	stxrb	w0, w0, [x0]
     edc:	6c6f6307 	ldnp	d7, d24, [x24, #-272]
     ee0:	09110200 	.inst	0x09110200 ; undefined
     ee4:	00000058 	udf	#88
     ee8:	0808000c 	stxrb	w8, w12, [x0]
     eec:	000000b3 	udf	#179
     ef0:	44080101 	.inst	0x44080101 ; undefined
     ef4:	03000002 	.inst	0x03000002 ; undefined
     ef8:	000003b9 	udf	#953
     efc:	80031202 	.inst	0x80031202 ; undefined
     f00:	04000000 	add	z0.b, p0/m, z0.b, z0.b
     f04:	00e61418 	.inst	0x00e61418 ; undefined
     f08:	cf020000 	.inst	0xcf020000 ; undefined
     f0c:	15000000 	b	4000f0c <GPR_FRAME_SIZE+0x4000e0c>
     f10:	0000ad08 	udf	#44296
     f14:	1b020000 	madd	w0, w0, w2, w0
     f18:	16000001 	b	fffffffff8000f1c <__stack_el2_top+0xffffffffb69f9f1c>
     f1c:	0000ba10 	udf	#47632
     f20:	03000800 	.inst	0x03000800 ; undefined
     f24:	0000038e 	udf	#910
     f28:	c6031702 	.inst	0xc6031702 ; undefined
     f2c:	09000000 	.inst	0x09000000 ; undefined
     f30:	00000149 	udf	#329
     f34:	04101c02 	mul	z2.b, p7/m, z2.b, z0.b
     f38:	0a000001 	and	w1, w0, w0
     f3c:	000000e6 	udf	#230
     f40:	058c0b00 	.inst	0x058c0b00 ; undefined
     f44:	03010000 	.inst	0x03010000 ; undefined
     f48:	00134c01 	.inst	0x00134c01 ; undefined
     f4c:	00000040 	udf	#64
     f50:	00004c00 	udf	#19456
     f54:	00000000 	udf	#0
     f58:	009c0100 	.inst	0x009c0100 ; undefined
     f5c:	0000011b 	udf	#283
     f60:	08010005 	stxrb	w1, w5, [x0]
     f64:	0000070a 	udf	#1802
     f68:	0001b605 	.inst	0x0001b605 ; undefined
     f6c:	02c21d00 	.inst	0x02c21d00 ; undefined
     f70:	00000000 	udf	#0
     f74:	13980000 	extr	w0, w0, w24, #0
     f78:	00004000 	udf	#16384
     f7c:	004c0000 	.inst	0x004c0000 ; undefined
     f80:	00000000 	udf	#0
     f84:	06d90000 	.inst	0x06d90000 ; undefined
     f88:	04010000 	sub	z0.b, p0/m, z0.b, z0.b
     f8c:	00031a07 	.inst	0x00031a07 ; undefined
     f90:	06010100 	.inst	0x06010100 ; undefined
     f94:	0000023d 	udf	#573
     f98:	3b080101 	.inst	0x3b080101 ; undefined
     f9c:	01000002 	.inst	0x01000002 ; undefined
     fa0:	03980502 	.inst	0x03980502 ; undefined
     fa4:	02010000 	.inst	0x02010000 ; undefined
     fa8:	00013607 	.inst	0x00013607 ; undefined
     fac:	05040600 	.inst	0x05040600 ; undefined
     fb0:	00746e69 	.inst	0x00746e69 ; undefined
     fb4:	0002cf03 	.inst	0x0002cf03 ; undefined
     fb8:	16250300 	b	fffffffff8941bb8 <__stack_el2_top+0xffffffffb733abb8>
     fbc:	0000002e 	udf	#46
     fc0:	6b050801 	subs	w1, w0, w5, lsl #2
     fc4:	01000003 	.inst	0x01000003 ; undefined
     fc8:	03100708 	.inst	0x03100708 ; undefined
     fcc:	08010000 	stxrb	w1, w0, [x0]
     fd0:	00037005 	.inst	0x00037005 ; undefined
     fd4:	07080100 	.inst	0x07080100 ; undefined
     fd8:	00000315 	udf	#789
     fdc:	ad0e1004 	stp	q4, q4, [x0, #448]
     fe0:	02000000 	.inst	0x02000000 ; undefined
     fe4:	0000022f 	udf	#559
     fe8:	00ad080f 	.inst	0x00ad080f ; undefined
     fec:	02000000 	.inst	0x02000000 ; undefined
     ff0:	00000327 	udf	#807
     ff4:	00580910 	.inst	0x00580910 ; undefined
     ff8:	07080000 	.inst	0x07080000 ; undefined
     ffc:	006c6f63 	.inst	0x006c6f63 ; undefined
    1000:	58091102 	ldr	x2, 13220 <GPR_FRAME_SIZE+0x13120>
    1004:	0c000000 	st4	{v0.8b-v3.8b}, [x0]
    1008:	b3080800 	.inst	0xb3080800 ; undefined
    100c:	01000000 	.inst	0x01000000 ; undefined
    1010:	02440801 	.inst	0x02440801 ; undefined
    1014:	b9030000 	str	w0, [x0, #768]
    1018:	02000003 	.inst	0x02000003 ; undefined
    101c:	00800312 	.inst	0x00800312 ; undefined
    1020:	18040000 	ldr	w0, 9020 <GPR_FRAME_SIZE+0x8f20>
    1024:	0000e614 	udf	#58900
    1028:	00cf0200 	.inst	0x00cf0200 ; undefined
    102c:	08150000 	stxrb	w21, w0, [x0]
    1030:	000000ad 	udf	#173
    1034:	011b0200 	.inst	0x011b0200 ; undefined
    1038:	10160000 	adr	x0, 2d038 <GPR_FRAME_SIZE+0x2cf38>
    103c:	000000ba 	udf	#186
    1040:	8e030008 	.inst	0x8e030008 ; undefined
    1044:	02000003 	.inst	0x02000003 ; undefined
    1048:	00c60317 	.inst	0x00c60317 ; undefined
    104c:	49090000 	.inst	0x49090000 ; undefined
    1050:	02000001 	.inst	0x02000001 ; undefined
    1054:	0104101c 	.inst	0x0104101c ; undefined
    1058:	e60a0000 	.inst	0xe60a0000 ; undefined
    105c:	00000000 	udf	#0
    1060:	0005a70b 	.inst	0x0005a70b ; undefined
    1064:	01030100 	.inst	0x01030100 ; undefined
    1068:	40001398 	.inst	0x40001398 ; undefined
    106c:	00000000 	udf	#0
    1070:	0000004c 	udf	#76
    1074:	00000000 	udf	#0
    1078:	1b009c01 	msub	w1, w0, w0, w7
    107c:	05000001 	orr	z1.s, z1.s, #0x1
    1080:	b8080100 	stur	w0, [x8, #128]
    1084:	05000007 	orr	z7.s, z7.s, #0x1
    1088:	000001b6 	udf	#438
    108c:	0002f61d 	.inst	0x0002f61d ; undefined
    1090:	00000000 	udf	#0
    1094:	0013e400 	.inst	0x0013e400 ; undefined
    1098:	00000040 	udf	#64
    109c:	00004c00 	udf	#19456
    10a0:	00000000 	udf	#0
    10a4:	00073800 	.inst	0x00073800 ; undefined
    10a8:	07040100 	.inst	0x07040100 ; undefined
    10ac:	0000031a 	udf	#794
    10b0:	3d060101 	str	b1, [x8, #384]
    10b4:	01000002 	.inst	0x01000002 ; undefined
    10b8:	023b0801 	.inst	0x023b0801 ; undefined
    10bc:	02010000 	.inst	0x02010000 ; undefined
    10c0:	00039805 	.inst	0x00039805 ; undefined
    10c4:	07020100 	.inst	0x07020100 ; undefined
    10c8:	00000136 	udf	#310
    10cc:	69050406 	stgp	x6, x1, [x0, #160]
    10d0:	0300746e 	.inst	0x0300746e ; undefined
    10d4:	000002cf 	udf	#719
    10d8:	2e162503 	.inst	0x2e162503 ; undefined
    10dc:	01000000 	.inst	0x01000000 ; undefined
    10e0:	036b0508 	.inst	0x036b0508 ; undefined
    10e4:	08010000 	stxrb	w1, w0, [x0]
    10e8:	00031007 	.inst	0x00031007 ; undefined
    10ec:	05080100 	.inst	0x05080100 ; undefined
    10f0:	00000370 	udf	#880
    10f4:	15070801 	b	41c30f8 <GPR_FRAME_SIZE+0x41c2ff8>
    10f8:	04000003 	add	z3.b, p0/m, z3.b, z0.b
    10fc:	00ad0e10 	.inst	0x00ad0e10 ; undefined
    1100:	2f020000 	.inst	0x2f020000 ; undefined
    1104:	0f000002 	fdot	v2.2s, v0.8b, v0.4b[0]
    1108:	0000ad08 	udf	#44296
    110c:	27020000 	.inst	0x27020000 ; undefined
    1110:	10000003 	adr	x3, 1110 <GPR_FRAME_SIZE+0x1010>
    1114:	00005809 	udf	#22537
    1118:	63070800 	.inst	0x63070800 ; undefined
    111c:	02006c6f 	.inst	0x02006c6f ; undefined
    1120:	00580911 	.inst	0x00580911 ; undefined
    1124:	000c0000 	.inst	0x000c0000 ; undefined
    1128:	00b30808 	.inst	0x00b30808 ; undefined
    112c:	01010000 	.inst	0x01010000 ; undefined
    1130:	00024408 	.inst	0x00024408 ; undefined
    1134:	03b90300 	.inst	0x03b90300 ; undefined
    1138:	12020000 	and	w0, w0, #0x40000000
    113c:	00008003 	udf	#32771
    1140:	14180400 	b	602140 <GPR_FRAME_SIZE+0x602040>
    1144:	000000e6 	udf	#230
    1148:	0000cf02 	udf	#52994
    114c:	ad081500 	stp	q0, q5, [x8, #256]
    1150:	00000000 	udf	#0
    1154:	00011b02 	.inst	0x00011b02 ; undefined
    1158:	ba101600 	.inst	0xba101600 ; undefined
    115c:	08000000 	stxrb	w0, w0, [x0]
    1160:	038e0300 	.inst	0x038e0300 ; undefined
    1164:	17020000 	b	fffffffffc081164 <__stack_el2_top+0xffffffffbaa7a164>
    1168:	0000c603 	udf	#50691
    116c:	01490900 	.inst	0x01490900 ; undefined
    1170:	1c020000 	ldr	s0, 5170 <GPR_FRAME_SIZE+0x5070>
    1174:	00010410 	.inst	0x00010410 ; undefined
    1178:	00e60a00 	.inst	0x00e60a00 ; undefined
    117c:	0b000000 	add	w0, w0, w0
    1180:	000005c0 	udf	#1472
    1184:	e4010301 	.inst	0xe4010301 ; undefined
    1188:	00400013 	.inst	0x00400013 ; undefined
    118c:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
    1190:	00000000 	udf	#0
    1194:	01000000 	.inst	0x01000000 ; undefined
    1198:	011b009c 	.inst	0x011b009c ; undefined
    119c:	00050000 	.inst	0x00050000 ; undefined
    11a0:	08660801 	.inst	0x08660801 ; undefined
    11a4:	b6050000 	tbz	x0, #32, ffffffffffffb1a4 <__stack_el2_top+0xffffffffbe9f41a4>
    11a8:	1d000001 	.inst	0x1d000001 ; undefined
    11ac:	00000329 	udf	#809
    11b0:	00000000 	udf	#0
    11b4:	40001430 	.inst	0x40001430 ; undefined
    11b8:	00000000 	udf	#0
    11bc:	0000004c 	udf	#76
    11c0:	00000000 	udf	#0
    11c4:	00000797 	udf	#1943
    11c8:	1a070401 	.inst	0x1a070401 ; undefined
    11cc:	01000003 	.inst	0x01000003 ; undefined
    11d0:	023d0601 	.inst	0x023d0601 ; undefined
    11d4:	01010000 	.inst	0x01010000 ; undefined
    11d8:	00023b08 	.inst	0x00023b08 ; undefined
    11dc:	05020100 	orr	z0.d, z0.d, #0x1ff
    11e0:	00000398 	udf	#920
    11e4:	36070201 	tbz	w1, #0, fffffffffffff224 <__stack_el2_top+0xffffffffbe9f8224>
    11e8:	06000001 	.inst	0x06000001 ; undefined
    11ec:	6e690504 	uhadd	v4.8h, v8.8h, v9.8h
    11f0:	cf030074 	.inst	0xcf030074 ; undefined
    11f4:	03000002 	.inst	0x03000002 ; undefined
    11f8:	002e1625 	.inst	0x002e1625 ; NYI
    11fc:	08010000 	stxrb	w1, w0, [x0]
    1200:	00036b05 	.inst	0x00036b05 ; undefined
    1204:	07080100 	.inst	0x07080100 ; undefined
    1208:	00000310 	udf	#784
    120c:	70050801 	adr	x1, b30f <GPR_FRAME_SIZE+0xb20f>
    1210:	01000003 	.inst	0x01000003 ; undefined
    1214:	03150708 	.inst	0x03150708 ; undefined
    1218:	10040000 	adr	x0, 9218 <GPR_FRAME_SIZE+0x9118>
    121c:	0000ad0e 	udf	#44302
    1220:	022f0200 	.inst	0x022f0200 ; undefined
    1224:	080f0000 	stxrb	w15, w0, [x0]
    1228:	000000ad 	udf	#173
    122c:	03270200 	.inst	0x03270200 ; undefined
    1230:	09100000 	.inst	0x09100000 ; undefined
    1234:	00000058 	udf	#88
    1238:	6f630708 	ushr	v8.2d, v24.2d, #29
    123c:	1102006c 	add	w12, w3, #0x80
    1240:	00005809 	udf	#22537
    1244:	08000c00 	stxrb	w0, w0, [x0]
    1248:	0000b308 	udf	#45832
    124c:	08010100 	stxrb	w1, w0, [x8]
    1250:	00000244 	udf	#580
    1254:	0003b903 	.inst	0x0003b903 ; undefined
    1258:	03120200 	.inst	0x03120200 ; undefined
    125c:	00000080 	udf	#128
    1260:	e6141804 	.inst	0xe6141804 ; undefined
    1264:	02000000 	.inst	0x02000000 ; undefined
    1268:	000000cf 	udf	#207
    126c:	00ad0815 	.inst	0x00ad0815 ; undefined
    1270:	02000000 	.inst	0x02000000 ; undefined
    1274:	0000011b 	udf	#283
    1278:	00ba1016 	.inst	0x00ba1016 ; undefined
    127c:	00080000 	.inst	0x00080000 ; undefined
    1280:	00038e03 	.inst	0x00038e03 ; undefined
    1284:	03170200 	.inst	0x03170200 ; undefined
    1288:	000000c6 	udf	#198
    128c:	00014909 	.inst	0x00014909 ; undefined
    1290:	101c0200 	adr	x0, 392d0 <GPR_FRAME_SIZE+0x391d0>
    1294:	00000104 	udf	#260
    1298:	0000e60a 	udf	#58890
    129c:	d80b0000 	prfm	pldl1keep, 1729c <GPR_FRAME_SIZE+0x1719c>
    12a0:	01000005 	.inst	0x01000005 ; undefined
    12a4:	14300103 	b	c016b0 <GPR_FRAME_SIZE+0xc015b0>
    12a8:	00004000 	udf	#16384
    12ac:	004c0000 	.inst	0x004c0000 ; undefined
    12b0:	00000000 	udf	#0
    12b4:	9c010000 	ldr	q0, 32b4 <GPR_FRAME_SIZE+0x31b4>
    12b8:	00011b00 	.inst	0x00011b00 ; undefined
    12bc:	01000500 	.inst	0x01000500 ; undefined
    12c0:	00091408 	.inst	0x00091408 ; undefined
    12c4:	01b60500 	.inst	0x01b60500 ; undefined
    12c8:	5f1d0000 	.inst	0x5f1d0000 ; undefined
    12cc:	00000003 	udf	#3
    12d0:	7c000000 	stur	h0, [x0]
    12d4:	00400014 	.inst	0x00400014 ; undefined
    12d8:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
    12dc:	00000000 	udf	#0
    12e0:	f6000000 	.inst	0xf6000000 ; undefined
    12e4:	01000007 	.inst	0x01000007 ; undefined
    12e8:	031a0704 	.inst	0x031a0704 ; undefined
    12ec:	01010000 	.inst	0x01010000 ; undefined
    12f0:	00023d06 	.inst	0x00023d06 ; undefined
    12f4:	08010100 	stxrb	w1, w0, [x8]
    12f8:	0000023b 	udf	#571
    12fc:	98050201 	ldrsw	x1, b33c <GPR_FRAME_SIZE+0xb23c>
    1300:	01000003 	.inst	0x01000003 ; undefined
    1304:	01360702 	.inst	0x01360702 ; undefined
    1308:	04060000 	.inst	0x04060000 ; undefined
    130c:	746e6905 	.inst	0x746e6905 ; undefined
    1310:	02cf0300 	.inst	0x02cf0300 ; undefined
    1314:	25030000 	cmpge	p0.b, p0/z, z0.b, #3
    1318:	00002e16 	udf	#11798
    131c:	05080100 	.inst	0x05080100 ; undefined
    1320:	0000036b 	udf	#875
    1324:	10070801 	adr	x1, f424 <GPR_FRAME_SIZE+0xf324>
    1328:	01000003 	.inst	0x01000003 ; undefined
    132c:	03700508 	.inst	0x03700508 ; undefined
    1330:	08010000 	stxrb	w1, w0, [x0]
    1334:	00031507 	.inst	0x00031507 ; undefined
    1338:	0e100400 	.inst	0x0e100400 ; undefined
    133c:	000000ad 	udf	#173
    1340:	00022f02 	.inst	0x00022f02 ; undefined
    1344:	ad080f00 	stp	q0, q3, [x24, #256]
    1348:	00000000 	udf	#0
    134c:	00032702 	.inst	0x00032702 ; undefined
    1350:	58091000 	ldr	x0, 13550 <GPR_FRAME_SIZE+0x13450>
    1354:	08000000 	stxrb	w0, w0, [x0]
    1358:	6c6f6307 	ldnp	d7, d24, [x24, #-272]
    135c:	09110200 	.inst	0x09110200 ; undefined
    1360:	00000058 	udf	#88
    1364:	0808000c 	stxrb	w8, w12, [x0]
    1368:	000000b3 	udf	#179
    136c:	44080101 	.inst	0x44080101 ; undefined
    1370:	03000002 	.inst	0x03000002 ; undefined
    1374:	000003b9 	udf	#953
    1378:	80031202 	.inst	0x80031202 ; undefined
    137c:	04000000 	add	z0.b, p0/m, z0.b, z0.b
    1380:	00e61418 	.inst	0x00e61418 ; undefined
    1384:	cf020000 	.inst	0xcf020000 ; undefined
    1388:	15000000 	b	4001388 <GPR_FRAME_SIZE+0x4001288>
    138c:	0000ad08 	udf	#44296
    1390:	1b020000 	madd	w0, w0, w2, w0
    1394:	16000001 	b	fffffffff8001398 <__stack_el2_top+0xffffffffb69fa398>
    1398:	0000ba10 	udf	#47632
    139c:	03000800 	.inst	0x03000800 ; undefined
    13a0:	0000038e 	udf	#910
    13a4:	c6031702 	.inst	0xc6031702 ; undefined
    13a8:	09000000 	.inst	0x09000000 ; undefined
    13ac:	00000149 	udf	#329
    13b0:	04101c02 	mul	z2.b, p7/m, z2.b, z0.b
    13b4:	0a000001 	and	w1, w0, w0
    13b8:	000000e6 	udf	#230
    13bc:	05f30b00 	.inst	0x05f30b00 ; undefined
    13c0:	03010000 	.inst	0x03010000 ; undefined
    13c4:	00147c01 	.inst	0x00147c01 ; undefined
    13c8:	00000040 	udf	#64
    13cc:	00004c00 	udf	#19456
    13d0:	00000000 	udf	#0
    13d4:	009c0100 	.inst	0x009c0100 ; undefined
    13d8:	0000011b 	udf	#283
    13dc:	08010005 	stxrb	w1, w5, [x0]
    13e0:	000009c2 	udf	#2498
    13e4:	0001b605 	.inst	0x0001b605 ; undefined
    13e8:	03921d00 	.inst	0x03921d00 ; undefined
    13ec:	00000000 	udf	#0
    13f0:	14c80000 	b	32013f0 <GPR_FRAME_SIZE+0x32012f0>
    13f4:	00004000 	udf	#16384
    13f8:	004c0000 	.inst	0x004c0000 ; undefined
    13fc:	00000000 	udf	#0
    1400:	08550000 	ldxrb	w0, [x0]
    1404:	04010000 	sub	z0.b, p0/m, z0.b, z0.b
    1408:	00031a07 	.inst	0x00031a07 ; undefined
    140c:	06010100 	.inst	0x06010100 ; undefined
    1410:	0000023d 	udf	#573
    1414:	3b080101 	.inst	0x3b080101 ; undefined
    1418:	01000002 	.inst	0x01000002 ; undefined
    141c:	03980502 	.inst	0x03980502 ; undefined
    1420:	02010000 	.inst	0x02010000 ; undefined
    1424:	00013607 	.inst	0x00013607 ; undefined
    1428:	05040600 	.inst	0x05040600 ; undefined
    142c:	00746e69 	.inst	0x00746e69 ; undefined
    1430:	0002cf03 	.inst	0x0002cf03 ; undefined
    1434:	16250300 	b	fffffffff8942034 <__stack_el2_top+0xffffffffb733b034>
    1438:	0000002e 	udf	#46
    143c:	6b050801 	subs	w1, w0, w5, lsl #2
    1440:	01000003 	.inst	0x01000003 ; undefined
    1444:	03100708 	.inst	0x03100708 ; undefined
    1448:	08010000 	stxrb	w1, w0, [x0]
    144c:	00037005 	.inst	0x00037005 ; undefined
    1450:	07080100 	.inst	0x07080100 ; undefined
    1454:	00000315 	udf	#789
    1458:	ad0e1004 	stp	q4, q4, [x0, #448]
    145c:	02000000 	.inst	0x02000000 ; undefined
    1460:	0000022f 	udf	#559
    1464:	00ad080f 	.inst	0x00ad080f ; undefined
    1468:	02000000 	.inst	0x02000000 ; undefined
    146c:	00000327 	udf	#807
    1470:	00580910 	.inst	0x00580910 ; undefined
    1474:	07080000 	.inst	0x07080000 ; undefined
    1478:	006c6f63 	.inst	0x006c6f63 ; undefined
    147c:	58091102 	ldr	x2, 1369c <GPR_FRAME_SIZE+0x1359c>
    1480:	0c000000 	st4	{v0.8b-v3.8b}, [x0]
    1484:	b3080800 	.inst	0xb3080800 ; undefined
    1488:	01000000 	.inst	0x01000000 ; undefined
    148c:	02440801 	.inst	0x02440801 ; undefined
    1490:	b9030000 	str	w0, [x0, #768]
    1494:	02000003 	.inst	0x02000003 ; undefined
    1498:	00800312 	.inst	0x00800312 ; undefined
    149c:	18040000 	ldr	w0, 949c <GPR_FRAME_SIZE+0x939c>
    14a0:	0000e614 	udf	#58900
    14a4:	00cf0200 	.inst	0x00cf0200 ; undefined
    14a8:	08150000 	stxrb	w21, w0, [x0]
    14ac:	000000ad 	udf	#173
    14b0:	011b0200 	.inst	0x011b0200 ; undefined
    14b4:	10160000 	adr	x0, 2d4b4 <GPR_FRAME_SIZE+0x2d3b4>
    14b8:	000000ba 	udf	#186
    14bc:	8e030008 	.inst	0x8e030008 ; undefined
    14c0:	02000003 	.inst	0x02000003 ; undefined
    14c4:	00c60317 	.inst	0x00c60317 ; undefined
    14c8:	49090000 	.inst	0x49090000 ; undefined
    14cc:	02000001 	.inst	0x02000001 ; undefined
    14d0:	0104101c 	.inst	0x0104101c ; undefined
    14d4:	e60a0000 	.inst	0xe60a0000 ; undefined
    14d8:	00000000 	udf	#0
    14dc:	00060b0b 	.inst	0x00060b0b ; undefined
    14e0:	01030100 	.inst	0x01030100 ; undefined
    14e4:	400014c8 	.inst	0x400014c8 ; undefined
    14e8:	00000000 	udf	#0
    14ec:	0000004c 	udf	#76
    14f0:	00000000 	udf	#0
    14f4:	1b009c01 	msub	w1, w0, w0, w7
    14f8:	05000001 	orr	z1.s, z1.s, #0x1
    14fc:	70080100 	adr	x0, 1151f <GPR_FRAME_SIZE+0x1141f>
    1500:	0500000a 	orr	z10.s, z10.s, #0x1
    1504:	000001b6 	udf	#438
    1508:	0003c51d 	.inst	0x0003c51d ; undefined
    150c:	00000000 	udf	#0
    1510:	00151400 	.inst	0x00151400 ; undefined
    1514:	00000040 	udf	#64
    1518:	00004c00 	udf	#19456
    151c:	00000000 	udf	#0
    1520:	0008b400 	.inst	0x0008b400 ; undefined
    1524:	07040100 	.inst	0x07040100 ; undefined
    1528:	0000031a 	udf	#794
    152c:	3d060101 	str	b1, [x8, #384]
    1530:	01000002 	.inst	0x01000002 ; undefined
    1534:	023b0801 	.inst	0x023b0801 ; undefined
    1538:	02010000 	.inst	0x02010000 ; undefined
    153c:	00039805 	.inst	0x00039805 ; undefined
    1540:	07020100 	.inst	0x07020100 ; undefined
    1544:	00000136 	udf	#310
    1548:	69050406 	stgp	x6, x1, [x0, #160]
    154c:	0300746e 	.inst	0x0300746e ; undefined
    1550:	000002cf 	udf	#719
    1554:	2e162503 	.inst	0x2e162503 ; undefined
    1558:	01000000 	.inst	0x01000000 ; undefined
    155c:	036b0508 	.inst	0x036b0508 ; undefined
    1560:	08010000 	stxrb	w1, w0, [x0]
    1564:	00031007 	.inst	0x00031007 ; undefined
    1568:	05080100 	.inst	0x05080100 ; undefined
    156c:	00000370 	udf	#880
    1570:	15070801 	b	41c3574 <GPR_FRAME_SIZE+0x41c3474>
    1574:	04000003 	add	z3.b, p0/m, z3.b, z0.b
    1578:	00ad0e10 	.inst	0x00ad0e10 ; undefined
    157c:	2f020000 	.inst	0x2f020000 ; undefined
    1580:	0f000002 	fdot	v2.2s, v0.8b, v0.4b[0]
    1584:	0000ad08 	udf	#44296
    1588:	27020000 	.inst	0x27020000 ; undefined
    158c:	10000003 	adr	x3, 158c <GPR_FRAME_SIZE+0x148c>
    1590:	00005809 	udf	#22537
    1594:	63070800 	.inst	0x63070800 ; undefined
    1598:	02006c6f 	.inst	0x02006c6f ; undefined
    159c:	00580911 	.inst	0x00580911 ; undefined
    15a0:	000c0000 	.inst	0x000c0000 ; undefined
    15a4:	00b30808 	.inst	0x00b30808 ; undefined
    15a8:	01010000 	.inst	0x01010000 ; undefined
    15ac:	00024408 	.inst	0x00024408 ; undefined
    15b0:	03b90300 	.inst	0x03b90300 ; undefined
    15b4:	12020000 	and	w0, w0, #0x40000000
    15b8:	00008003 	udf	#32771
    15bc:	14180400 	b	6025bc <GPR_FRAME_SIZE+0x6024bc>
    15c0:	000000e6 	udf	#230
    15c4:	0000cf02 	udf	#52994
    15c8:	ad081500 	stp	q0, q5, [x8, #256]
    15cc:	00000000 	udf	#0
    15d0:	00011b02 	.inst	0x00011b02 ; undefined
    15d4:	ba101600 	.inst	0xba101600 ; undefined
    15d8:	08000000 	stxrb	w0, w0, [x0]
    15dc:	038e0300 	.inst	0x038e0300 ; undefined
    15e0:	17020000 	b	fffffffffc0815e0 <__stack_el2_top+0xffffffffbaa7a5e0>
    15e4:	0000c603 	udf	#50691
    15e8:	01490900 	.inst	0x01490900 ; undefined
    15ec:	1c020000 	ldr	s0, 55ec <GPR_FRAME_SIZE+0x54ec>
    15f0:	00010410 	.inst	0x00010410 ; undefined
    15f4:	00e60a00 	.inst	0x00e60a00 ; undefined
    15f8:	0b000000 	add	w0, w0, w0
    15fc:	00000623 	udf	#1571
    1600:	14010301 	b	42204 <GPR_FRAME_SIZE+0x42104>
    1604:	00400015 	.inst	0x00400015 ; undefined
    1608:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
    160c:	00000000 	udf	#0
    1610:	01000000 	.inst	0x01000000 ; undefined
    1614:	011b009c 	.inst	0x011b009c ; undefined
    1618:	00050000 	.inst	0x00050000 ; undefined
    161c:	0b1e0801 	add	w1, w0, w30, lsl #2
    1620:	b6050000 	tbz	x0, #32, ffffffffffffb620 <__stack_el2_top+0xffffffffbe9f4620>
    1624:	1d000001 	.inst	0x1d000001 ; undefined
    1628:	000003f8 	udf	#1016
    162c:	00000000 	udf	#0
    1630:	40001560 	.inst	0x40001560 ; undefined
    1634:	00000000 	udf	#0
    1638:	0000004c 	udf	#76
    163c:	00000000 	udf	#0
    1640:	00000913 	udf	#2323
    1644:	1a070401 	.inst	0x1a070401 ; undefined
    1648:	01000003 	.inst	0x01000003 ; undefined
    164c:	023d0601 	.inst	0x023d0601 ; undefined
    1650:	01010000 	.inst	0x01010000 ; undefined
    1654:	00023b08 	.inst	0x00023b08 ; undefined
    1658:	05020100 	orr	z0.d, z0.d, #0x1ff
    165c:	00000398 	udf	#920
    1660:	36070201 	tbz	w1, #0, fffffffffffff6a0 <__stack_el2_top+0xffffffffbe9f86a0>
    1664:	06000001 	.inst	0x06000001 ; undefined
    1668:	6e690504 	uhadd	v4.8h, v8.8h, v9.8h
    166c:	cf030074 	.inst	0xcf030074 ; undefined
    1670:	03000002 	.inst	0x03000002 ; undefined
    1674:	002e1625 	.inst	0x002e1625 ; NYI
    1678:	08010000 	stxrb	w1, w0, [x0]
    167c:	00036b05 	.inst	0x00036b05 ; undefined
    1680:	07080100 	.inst	0x07080100 ; undefined
    1684:	00000310 	udf	#784
    1688:	70050801 	adr	x1, b78b <GPR_FRAME_SIZE+0xb68b>
    168c:	01000003 	.inst	0x01000003 ; undefined
    1690:	03150708 	.inst	0x03150708 ; undefined
    1694:	10040000 	adr	x0, 9694 <GPR_FRAME_SIZE+0x9594>
    1698:	0000ad0e 	udf	#44302
    169c:	022f0200 	.inst	0x022f0200 ; undefined
    16a0:	080f0000 	stxrb	w15, w0, [x0]
    16a4:	000000ad 	udf	#173
    16a8:	03270200 	.inst	0x03270200 ; undefined
    16ac:	09100000 	.inst	0x09100000 ; undefined
    16b0:	00000058 	udf	#88
    16b4:	6f630708 	ushr	v8.2d, v24.2d, #29
    16b8:	1102006c 	add	w12, w3, #0x80
    16bc:	00005809 	udf	#22537
    16c0:	08000c00 	stxrb	w0, w0, [x0]
    16c4:	0000b308 	udf	#45832
    16c8:	08010100 	stxrb	w1, w0, [x8]
    16cc:	00000244 	udf	#580
    16d0:	0003b903 	.inst	0x0003b903 ; undefined
    16d4:	03120200 	.inst	0x03120200 ; undefined
    16d8:	00000080 	udf	#128
    16dc:	e6141804 	.inst	0xe6141804 ; undefined
    16e0:	02000000 	.inst	0x02000000 ; undefined
    16e4:	000000cf 	udf	#207
    16e8:	00ad0815 	.inst	0x00ad0815 ; undefined
    16ec:	02000000 	.inst	0x02000000 ; undefined
    16f0:	0000011b 	udf	#283
    16f4:	00ba1016 	.inst	0x00ba1016 ; undefined
    16f8:	00080000 	.inst	0x00080000 ; undefined
    16fc:	00038e03 	.inst	0x00038e03 ; undefined
    1700:	03170200 	.inst	0x03170200 ; undefined
    1704:	000000c6 	udf	#198
    1708:	00014909 	.inst	0x00014909 ; undefined
    170c:	101c0200 	adr	x0, 3974c <GPR_FRAME_SIZE+0x3964c>
    1710:	00000104 	udf	#260
    1714:	0000e60a 	udf	#58890
    1718:	3b0b0000 	.inst	0x3b0b0000 ; undefined
    171c:	01000006 	.inst	0x01000006 ; undefined
    1720:	15600103 	b	5801b2c <GPR_FRAME_SIZE+0x5801a2c>
    1724:	00004000 	udf	#16384
    1728:	004c0000 	.inst	0x004c0000 ; undefined
    172c:	00000000 	udf	#0
    1730:	9c010000 	ldr	q0, 3730 <GPR_FRAME_SIZE+0x3630>
    1734:	00011b00 	.inst	0x00011b00 ; undefined
    1738:	01000500 	.inst	0x01000500 ; undefined
    173c:	000bcc08 	.inst	0x000bcc08 ; undefined
    1740:	01b60500 	.inst	0x01b60500 ; undefined
    1744:	2b1d0000 	adds	w0, w0, w29
    1748:	00000004 	udf	#4
    174c:	ac000000 	stnp	q0, q0, [x0]
    1750:	00400015 	.inst	0x00400015 ; undefined
    1754:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
    1758:	00000000 	udf	#0
    175c:	72000000 	ands	w0, w0, #0x1
    1760:	01000009 	.inst	0x01000009 ; undefined
    1764:	031a0704 	.inst	0x031a0704 ; undefined
    1768:	01010000 	.inst	0x01010000 ; undefined
    176c:	00023d06 	.inst	0x00023d06 ; undefined
    1770:	08010100 	stxrb	w1, w0, [x8]
    1774:	0000023b 	udf	#571
    1778:	98050201 	ldrsw	x1, b7b8 <GPR_FRAME_SIZE+0xb6b8>
    177c:	01000003 	.inst	0x01000003 ; undefined
    1780:	01360702 	.inst	0x01360702 ; undefined
    1784:	04060000 	.inst	0x04060000 ; undefined
    1788:	746e6905 	.inst	0x746e6905 ; undefined
    178c:	02cf0300 	.inst	0x02cf0300 ; undefined
    1790:	25030000 	cmpge	p0.b, p0/z, z0.b, #3
    1794:	00002e16 	udf	#11798
    1798:	05080100 	.inst	0x05080100 ; undefined
    179c:	0000036b 	udf	#875
    17a0:	10070801 	adr	x1, f8a0 <GPR_FRAME_SIZE+0xf7a0>
    17a4:	01000003 	.inst	0x01000003 ; undefined
    17a8:	03700508 	.inst	0x03700508 ; undefined
    17ac:	08010000 	stxrb	w1, w0, [x0]
    17b0:	00031507 	.inst	0x00031507 ; undefined
    17b4:	0e100400 	.inst	0x0e100400 ; undefined
    17b8:	000000ad 	udf	#173
    17bc:	00022f02 	.inst	0x00022f02 ; undefined
    17c0:	ad080f00 	stp	q0, q3, [x24, #256]
    17c4:	00000000 	udf	#0
    17c8:	00032702 	.inst	0x00032702 ; undefined
    17cc:	58091000 	ldr	x0, 139cc <GPR_FRAME_SIZE+0x138cc>
    17d0:	08000000 	stxrb	w0, w0, [x0]
    17d4:	6c6f6307 	ldnp	d7, d24, [x24, #-272]
    17d8:	09110200 	.inst	0x09110200 ; undefined
    17dc:	00000058 	udf	#88
    17e0:	0808000c 	stxrb	w8, w12, [x0]
    17e4:	000000b3 	udf	#179
    17e8:	44080101 	.inst	0x44080101 ; undefined
    17ec:	03000002 	.inst	0x03000002 ; undefined
    17f0:	000003b9 	udf	#953
    17f4:	80031202 	.inst	0x80031202 ; undefined
    17f8:	04000000 	add	z0.b, p0/m, z0.b, z0.b
    17fc:	00e61418 	.inst	0x00e61418 ; undefined
    1800:	cf020000 	.inst	0xcf020000 ; undefined
    1804:	15000000 	b	4001804 <GPR_FRAME_SIZE+0x4001704>
    1808:	0000ad08 	udf	#44296
    180c:	1b020000 	madd	w0, w0, w2, w0
    1810:	16000001 	b	fffffffff8001814 <__stack_el2_top+0xffffffffb69fa814>
    1814:	0000ba10 	udf	#47632
    1818:	03000800 	.inst	0x03000800 ; undefined
    181c:	0000038e 	udf	#910
    1820:	c6031702 	.inst	0xc6031702 ; undefined
    1824:	09000000 	.inst	0x09000000 ; undefined
    1828:	00000149 	udf	#329
    182c:	04101c02 	mul	z2.b, p7/m, z2.b, z0.b
    1830:	0a000001 	and	w1, w0, w0
    1834:	000000e6 	udf	#230
    1838:	06530b00 	.inst	0x06530b00 ; undefined
    183c:	03010000 	.inst	0x03010000 ; undefined
    1840:	0015ac01 	.inst	0x0015ac01 ; undefined
    1844:	00000040 	udf	#64
    1848:	00004c00 	udf	#19456
    184c:	00000000 	udf	#0
    1850:	009c0100 	.inst	0x009c0100 ; undefined
    1854:	0000011b 	udf	#283
    1858:	08010005 	stxrb	w1, w5, [x0]
    185c:	00000c7a 	udf	#3194
    1860:	0001b605 	.inst	0x0001b605 ; undefined
    1864:	045e1d00 	.inst	0x045e1d00 ; undefined
    1868:	00000000 	udf	#0
    186c:	15f80000 	b	7e0186c <GPR_FRAME_SIZE+0x7e0176c>
    1870:	00004000 	udf	#16384
    1874:	004c0000 	.inst	0x004c0000 ; undefined
    1878:	00000000 	udf	#0
    187c:	09d10000 	.inst	0x09d10000 ; undefined
    1880:	04010000 	sub	z0.b, p0/m, z0.b, z0.b
    1884:	00031a07 	.inst	0x00031a07 ; undefined
    1888:	06010100 	.inst	0x06010100 ; undefined
    188c:	0000023d 	udf	#573
    1890:	3b080101 	.inst	0x3b080101 ; undefined
    1894:	01000002 	.inst	0x01000002 ; undefined
    1898:	03980502 	.inst	0x03980502 ; undefined
    189c:	02010000 	.inst	0x02010000 ; undefined
    18a0:	00013607 	.inst	0x00013607 ; undefined
    18a4:	05040600 	.inst	0x05040600 ; undefined
    18a8:	00746e69 	.inst	0x00746e69 ; undefined
    18ac:	0002cf03 	.inst	0x0002cf03 ; undefined
    18b0:	16250300 	b	fffffffff89424b0 <__stack_el2_top+0xffffffffb733b4b0>
    18b4:	0000002e 	udf	#46
    18b8:	6b050801 	subs	w1, w0, w5, lsl #2
    18bc:	01000003 	.inst	0x01000003 ; undefined
    18c0:	03100708 	.inst	0x03100708 ; undefined
    18c4:	08010000 	stxrb	w1, w0, [x0]
    18c8:	00037005 	.inst	0x00037005 ; undefined
    18cc:	07080100 	.inst	0x07080100 ; undefined
    18d0:	00000315 	udf	#789
    18d4:	ad0e1004 	stp	q4, q4, [x0, #448]
    18d8:	02000000 	.inst	0x02000000 ; undefined
    18dc:	0000022f 	udf	#559
    18e0:	00ad080f 	.inst	0x00ad080f ; undefined
    18e4:	02000000 	.inst	0x02000000 ; undefined
    18e8:	00000327 	udf	#807
    18ec:	00580910 	.inst	0x00580910 ; undefined
    18f0:	07080000 	.inst	0x07080000 ; undefined
    18f4:	006c6f63 	.inst	0x006c6f63 ; undefined
    18f8:	58091102 	ldr	x2, 13b18 <GPR_FRAME_SIZE+0x13a18>
    18fc:	0c000000 	st4	{v0.8b-v3.8b}, [x0]
    1900:	b3080800 	.inst	0xb3080800 ; undefined
    1904:	01000000 	.inst	0x01000000 ; undefined
    1908:	02440801 	.inst	0x02440801 ; undefined
    190c:	b9030000 	str	w0, [x0, #768]
    1910:	02000003 	.inst	0x02000003 ; undefined
    1914:	00800312 	.inst	0x00800312 ; undefined
    1918:	18040000 	ldr	w0, 9918 <GPR_FRAME_SIZE+0x9818>
    191c:	0000e614 	udf	#58900
    1920:	00cf0200 	.inst	0x00cf0200 ; undefined
    1924:	08150000 	stxrb	w21, w0, [x0]
    1928:	000000ad 	udf	#173
    192c:	011b0200 	.inst	0x011b0200 ; undefined
    1930:	10160000 	adr	x0, 2d930 <GPR_FRAME_SIZE+0x2d830>
    1934:	000000ba 	udf	#186
    1938:	8e030008 	.inst	0x8e030008 ; undefined
    193c:	02000003 	.inst	0x02000003 ; undefined
    1940:	00c60317 	.inst	0x00c60317 ; undefined
    1944:	49090000 	.inst	0x49090000 ; undefined
    1948:	02000001 	.inst	0x02000001 ; undefined
    194c:	0104101c 	.inst	0x0104101c ; undefined
    1950:	e60a0000 	.inst	0xe60a0000 ; undefined
    1954:	00000000 	udf	#0
    1958:	00066b0b 	.inst	0x00066b0b ; undefined
    195c:	01030100 	.inst	0x01030100 ; undefined
    1960:	400015f8 	.inst	0x400015f8 ; undefined
    1964:	00000000 	udf	#0
    1968:	0000004c 	udf	#76
    196c:	00000000 	udf	#0
    1970:	1b009c01 	msub	w1, w0, w0, w7
    1974:	05000001 	orr	z1.s, z1.s, #0x1
    1978:	28080100 	stnp	w0, w0, [x8, #64]
    197c:	0500000d 	orr	z13.s, z13.s, #0x1
    1980:	000001b6 	udf	#438
    1984:	0004911d 	.inst	0x0004911d ; undefined
    1988:	00000000 	udf	#0
    198c:	00164400 	.inst	0x00164400 ; undefined
    1990:	00000040 	udf	#64
    1994:	00004c00 	udf	#19456
    1998:	00000000 	udf	#0
    199c:	000a3000 	.inst	0x000a3000 ; undefined
    19a0:	07040100 	.inst	0x07040100 ; undefined
    19a4:	0000031a 	udf	#794
    19a8:	3d060101 	str	b1, [x8, #384]
    19ac:	01000002 	.inst	0x01000002 ; undefined
    19b0:	023b0801 	.inst	0x023b0801 ; undefined
    19b4:	02010000 	.inst	0x02010000 ; undefined
    19b8:	00039805 	.inst	0x00039805 ; undefined
    19bc:	07020100 	.inst	0x07020100 ; undefined
    19c0:	00000136 	udf	#310
    19c4:	69050406 	stgp	x6, x1, [x0, #160]
    19c8:	0300746e 	.inst	0x0300746e ; undefined
    19cc:	000002cf 	udf	#719
    19d0:	2e162503 	.inst	0x2e162503 ; undefined
    19d4:	01000000 	.inst	0x01000000 ; undefined
    19d8:	036b0508 	.inst	0x036b0508 ; undefined
    19dc:	08010000 	stxrb	w1, w0, [x0]
    19e0:	00031007 	.inst	0x00031007 ; undefined
    19e4:	05080100 	.inst	0x05080100 ; undefined
    19e8:	00000370 	udf	#880
    19ec:	15070801 	b	41c39f0 <GPR_FRAME_SIZE+0x41c38f0>
    19f0:	04000003 	add	z3.b, p0/m, z3.b, z0.b
    19f4:	00ad0e10 	.inst	0x00ad0e10 ; undefined
    19f8:	2f020000 	.inst	0x2f020000 ; undefined
    19fc:	0f000002 	fdot	v2.2s, v0.8b, v0.4b[0]
    1a00:	0000ad08 	udf	#44296
    1a04:	27020000 	.inst	0x27020000 ; undefined
    1a08:	10000003 	adr	x3, 1a08 <GPR_FRAME_SIZE+0x1908>
    1a0c:	00005809 	udf	#22537
    1a10:	63070800 	.inst	0x63070800 ; undefined
    1a14:	02006c6f 	.inst	0x02006c6f ; undefined
    1a18:	00580911 	.inst	0x00580911 ; undefined
    1a1c:	000c0000 	.inst	0x000c0000 ; undefined
    1a20:	00b30808 	.inst	0x00b30808 ; undefined
    1a24:	01010000 	.inst	0x01010000 ; undefined
    1a28:	00024408 	.inst	0x00024408 ; undefined
    1a2c:	03b90300 	.inst	0x03b90300 ; undefined
    1a30:	12020000 	and	w0, w0, #0x40000000
    1a34:	00008003 	udf	#32771
    1a38:	14180400 	b	602a38 <GPR_FRAME_SIZE+0x602938>
    1a3c:	000000e6 	udf	#230
    1a40:	0000cf02 	udf	#52994
    1a44:	ad081500 	stp	q0, q5, [x8, #256]
    1a48:	00000000 	udf	#0
    1a4c:	00011b02 	.inst	0x00011b02 ; undefined
    1a50:	ba101600 	.inst	0xba101600 ; undefined
    1a54:	08000000 	stxrb	w0, w0, [x0]
    1a58:	038e0300 	.inst	0x038e0300 ; undefined
    1a5c:	17020000 	b	fffffffffc081a5c <__stack_el2_top+0xffffffffbaa7aa5c>
    1a60:	0000c603 	udf	#50691
    1a64:	01490900 	.inst	0x01490900 ; undefined
    1a68:	1c020000 	ldr	s0, 5a68 <GPR_FRAME_SIZE+0x5968>
    1a6c:	00010410 	.inst	0x00010410 ; undefined
    1a70:	00e60a00 	.inst	0x00e60a00 ; undefined
    1a74:	0b000000 	add	w0, w0, w0
    1a78:	00000683 	udf	#1667
    1a7c:	44010301 	.inst	0x44010301 ; undefined
    1a80:	00400016 	.inst	0x00400016 ; undefined
    1a84:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
    1a88:	00000000 	udf	#0
    1a8c:	01000000 	.inst	0x01000000 ; undefined
    1a90:	011b009c 	.inst	0x011b009c ; undefined
    1a94:	00050000 	.inst	0x00050000 ; undefined
    1a98:	0dd60801 	ld1	{v1.b}[2], [x0], x22
    1a9c:	b6050000 	tbz	x0, #32, ffffffffffffba9c <__stack_el2_top+0xffffffffbe9f4a9c>
    1aa0:	1d000001 	.inst	0x1d000001 ; undefined
    1aa4:	000004c5 	udf	#1221
    1aa8:	00000000 	udf	#0
    1aac:	40001690 	.inst	0x40001690 ; undefined
    1ab0:	00000000 	udf	#0
    1ab4:	0000004c 	udf	#76
    1ab8:	00000000 	udf	#0
    1abc:	00000a8f 	udf	#2703
    1ac0:	1a070401 	.inst	0x1a070401 ; undefined
    1ac4:	01000003 	.inst	0x01000003 ; undefined
    1ac8:	023d0601 	.inst	0x023d0601 ; undefined
    1acc:	01010000 	.inst	0x01010000 ; undefined
    1ad0:	00023b08 	.inst	0x00023b08 ; undefined
    1ad4:	05020100 	orr	z0.d, z0.d, #0x1ff
    1ad8:	00000398 	udf	#920
    1adc:	36070201 	tbz	w1, #0, fffffffffffffb1c <__stack_el2_top+0xffffffffbe9f8b1c>
    1ae0:	06000001 	.inst	0x06000001 ; undefined
    1ae4:	6e690504 	uhadd	v4.8h, v8.8h, v9.8h
    1ae8:	cf030074 	.inst	0xcf030074 ; undefined
    1aec:	03000002 	.inst	0x03000002 ; undefined
    1af0:	002e1625 	.inst	0x002e1625 ; NYI
    1af4:	08010000 	stxrb	w1, w0, [x0]
    1af8:	00036b05 	.inst	0x00036b05 ; undefined
    1afc:	07080100 	.inst	0x07080100 ; undefined
    1b00:	00000310 	udf	#784
    1b04:	70050801 	adr	x1, bc07 <GPR_FRAME_SIZE+0xbb07>
    1b08:	01000003 	.inst	0x01000003 ; undefined
    1b0c:	03150708 	.inst	0x03150708 ; undefined
    1b10:	10040000 	adr	x0, 9b10 <GPR_FRAME_SIZE+0x9a10>
    1b14:	0000ad0e 	udf	#44302
    1b18:	022f0200 	.inst	0x022f0200 ; undefined
    1b1c:	080f0000 	stxrb	w15, w0, [x0]
    1b20:	000000ad 	udf	#173
    1b24:	03270200 	.inst	0x03270200 ; undefined
    1b28:	09100000 	.inst	0x09100000 ; undefined
    1b2c:	00000058 	udf	#88
    1b30:	6f630708 	ushr	v8.2d, v24.2d, #29
    1b34:	1102006c 	add	w12, w3, #0x80
    1b38:	00005809 	udf	#22537
    1b3c:	08000c00 	stxrb	w0, w0, [x0]
    1b40:	0000b308 	udf	#45832
    1b44:	08010100 	stxrb	w1, w0, [x8]
    1b48:	00000244 	udf	#580
    1b4c:	0003b903 	.inst	0x0003b903 ; undefined
    1b50:	03120200 	.inst	0x03120200 ; undefined
    1b54:	00000080 	udf	#128
    1b58:	e6141804 	.inst	0xe6141804 ; undefined
    1b5c:	02000000 	.inst	0x02000000 ; undefined
    1b60:	000000cf 	udf	#207
    1b64:	00ad0815 	.inst	0x00ad0815 ; undefined
    1b68:	02000000 	.inst	0x02000000 ; undefined
    1b6c:	0000011b 	udf	#283
    1b70:	00ba1016 	.inst	0x00ba1016 ; undefined
    1b74:	00080000 	.inst	0x00080000 ; undefined
    1b78:	00038e03 	.inst	0x00038e03 ; undefined
    1b7c:	03170200 	.inst	0x03170200 ; undefined
    1b80:	000000c6 	udf	#198
    1b84:	00014909 	.inst	0x00014909 ; undefined
    1b88:	101c0200 	adr	x0, 39bc8 <GPR_FRAME_SIZE+0x39ac8>
    1b8c:	00000104 	udf	#260
    1b90:	0000e60a 	udf	#58890
    1b94:	9c0b0000 	ldr	q0, 17b94 <GPR_FRAME_SIZE+0x17a94>
    1b98:	01000006 	.inst	0x01000006 ; undefined
    1b9c:	16900103 	b	fffffffffa401fa8 <__stack_el2_top+0xffffffffb8dfafa8>
    1ba0:	00004000 	udf	#16384
    1ba4:	004c0000 	.inst	0x004c0000 ; undefined
    1ba8:	00000000 	udf	#0
    1bac:	9c010000 	ldr	q0, 3bac <GPR_FRAME_SIZE+0x3aac>
    1bb0:	00011b00 	.inst	0x00011b00 ; undefined
    1bb4:	01000500 	.inst	0x01000500 ; undefined
    1bb8:	000e8408 	.inst	0x000e8408 ; undefined
    1bbc:	01b60500 	.inst	0x01b60500 ; undefined
    1bc0:	f91d0000 	str	x0, [x0, #14848]
    1bc4:	00000004 	udf	#4
    1bc8:	dc000000 	.inst	0xdc000000 ; undefined
    1bcc:	00400016 	.inst	0x00400016 ; undefined
    1bd0:	4c000000 	st4	{v0.16b-v3.16b}, [x0]
    1bd4:	00000000 	udf	#0
    1bd8:	ee000000 	.inst	0xee000000 ; undefined
    1bdc:	0100000a 	.inst	0x0100000a ; undefined
    1be0:	031a0704 	.inst	0x031a0704 ; undefined
    1be4:	01010000 	.inst	0x01010000 ; undefined
    1be8:	00023d06 	.inst	0x00023d06 ; undefined
    1bec:	08010100 	stxrb	w1, w0, [x8]
    1bf0:	0000023b 	udf	#571
    1bf4:	98050201 	ldrsw	x1, bc34 <GPR_FRAME_SIZE+0xbb34>
    1bf8:	01000003 	.inst	0x01000003 ; undefined
    1bfc:	01360702 	.inst	0x01360702 ; undefined
    1c00:	04060000 	.inst	0x04060000 ; undefined
    1c04:	746e6905 	.inst	0x746e6905 ; undefined
    1c08:	02cf0300 	.inst	0x02cf0300 ; undefined
    1c0c:	25030000 	cmpge	p0.b, p0/z, z0.b, #3
    1c10:	00002e16 	udf	#11798
    1c14:	05080100 	.inst	0x05080100 ; undefined
    1c18:	0000036b 	udf	#875
    1c1c:	10070801 	adr	x1, fd1c <GPR_FRAME_SIZE+0xfc1c>
    1c20:	01000003 	.inst	0x01000003 ; undefined
    1c24:	03700508 	.inst	0x03700508 ; undefined
    1c28:	08010000 	stxrb	w1, w0, [x0]
    1c2c:	00031507 	.inst	0x00031507 ; undefined
    1c30:	0e100400 	.inst	0x0e100400 ; undefined
    1c34:	000000ad 	udf	#173
    1c38:	00022f02 	.inst	0x00022f02 ; undefined
    1c3c:	ad080f00 	stp	q0, q3, [x24, #256]
    1c40:	00000000 	udf	#0
    1c44:	00032702 	.inst	0x00032702 ; undefined
    1c48:	58091000 	ldr	x0, 13e48 <GPR_FRAME_SIZE+0x13d48>
    1c4c:	08000000 	stxrb	w0, w0, [x0]
    1c50:	6c6f6307 	ldnp	d7, d24, [x24, #-272]
    1c54:	09110200 	.inst	0x09110200 ; undefined
    1c58:	00000058 	udf	#88
    1c5c:	0808000c 	stxrb	w8, w12, [x0]
    1c60:	000000b3 	udf	#179
    1c64:	44080101 	.inst	0x44080101 ; undefined
    1c68:	03000002 	.inst	0x03000002 ; undefined
    1c6c:	000003b9 	udf	#953
    1c70:	80031202 	.inst	0x80031202 ; undefined
    1c74:	04000000 	add	z0.b, p0/m, z0.b, z0.b
    1c78:	00e61418 	.inst	0x00e61418 ; undefined
    1c7c:	cf020000 	.inst	0xcf020000 ; undefined
    1c80:	15000000 	b	4001c80 <GPR_FRAME_SIZE+0x4001b80>
    1c84:	0000ad08 	udf	#44296
    1c88:	1b020000 	madd	w0, w0, w2, w0
    1c8c:	16000001 	b	fffffffff8001c90 <__stack_el2_top+0xffffffffb69fac90>
    1c90:	0000ba10 	udf	#47632
    1c94:	03000800 	.inst	0x03000800 ; undefined
    1c98:	0000038e 	udf	#910
    1c9c:	c6031702 	.inst	0xc6031702 ; undefined
    1ca0:	09000000 	.inst	0x09000000 ; undefined
    1ca4:	00000149 	udf	#329
    1ca8:	04101c02 	mul	z2.b, p7/m, z2.b, z0.b
    1cac:	0a000001 	and	w1, w0, w0
    1cb0:	000000e6 	udf	#230
    1cb4:	06b50b00 	.inst	0x06b50b00 ; undefined
    1cb8:	03010000 	.inst	0x03010000 ; undefined
    1cbc:	0016dc01 	.inst	0x0016dc01 ; undefined
    1cc0:	00000040 	udf	#64
    1cc4:	00004c00 	udf	#19456
    1cc8:	00000000 	udf	#0
    1ccc:	009c0100 	.inst	0x009c0100 ; undefined
    1cd0:	0000011b 	udf	#283
    1cd4:	08010005 	stxrb	w1, w5, [x0]
    1cd8:	00000f32 	udf	#3890
    1cdc:	0001b605 	.inst	0x0001b605 ; undefined
    1ce0:	052d1d00 	ext	z0.b, z0.b, z8.b, #111
    1ce4:	00000000 	udf	#0
    1ce8:	17280000 	b	fffffffffca01ce8 <__stack_el2_top+0xffffffffbb3face8>
    1cec:	00004000 	udf	#16384
    1cf0:	004c0000 	.inst	0x004c0000 ; undefined
    1cf4:	00000000 	udf	#0
    1cf8:	0b4d0000 	add	w0, w0, w13, lsr #0
    1cfc:	04010000 	sub	z0.b, p0/m, z0.b, z0.b
    1d00:	00031a07 	.inst	0x00031a07 ; undefined
    1d04:	06010100 	.inst	0x06010100 ; undefined
    1d08:	0000023d 	udf	#573
    1d0c:	3b080101 	.inst	0x3b080101 ; undefined
    1d10:	01000002 	.inst	0x01000002 ; undefined
    1d14:	03980502 	.inst	0x03980502 ; undefined
    1d18:	02010000 	.inst	0x02010000 ; undefined
    1d1c:	00013607 	.inst	0x00013607 ; undefined
    1d20:	05040600 	.inst	0x05040600 ; undefined
    1d24:	00746e69 	.inst	0x00746e69 ; undefined
    1d28:	0002cf03 	.inst	0x0002cf03 ; undefined
    1d2c:	16250300 	b	fffffffff894292c <__stack_el2_top+0xffffffffb733b92c>
    1d30:	0000002e 	udf	#46
    1d34:	6b050801 	subs	w1, w0, w5, lsl #2
    1d38:	01000003 	.inst	0x01000003 ; undefined
    1d3c:	03100708 	.inst	0x03100708 ; undefined
    1d40:	08010000 	stxrb	w1, w0, [x0]
    1d44:	00037005 	.inst	0x00037005 ; undefined
    1d48:	07080100 	.inst	0x07080100 ; undefined
    1d4c:	00000315 	udf	#789
    1d50:	ad0e1004 	stp	q4, q4, [x0, #448]
    1d54:	02000000 	.inst	0x02000000 ; undefined
    1d58:	0000022f 	udf	#559
    1d5c:	00ad080f 	.inst	0x00ad080f ; undefined
    1d60:	02000000 	.inst	0x02000000 ; undefined
    1d64:	00000327 	udf	#807
    1d68:	00580910 	.inst	0x00580910 ; undefined
    1d6c:	07080000 	.inst	0x07080000 ; undefined
    1d70:	006c6f63 	.inst	0x006c6f63 ; undefined
    1d74:	58091102 	ldr	x2, 13f94 <GPR_FRAME_SIZE+0x13e94>
    1d78:	0c000000 	st4	{v0.8b-v3.8b}, [x0]
    1d7c:	b3080800 	.inst	0xb3080800 ; undefined
    1d80:	01000000 	.inst	0x01000000 ; undefined
    1d84:	02440801 	.inst	0x02440801 ; undefined
    1d88:	b9030000 	str	w0, [x0, #768]
    1d8c:	02000003 	.inst	0x02000003 ; undefined
    1d90:	00800312 	.inst	0x00800312 ; undefined
    1d94:	18040000 	ldr	w0, 9d94 <GPR_FRAME_SIZE+0x9c94>
    1d98:	0000e614 	udf	#58900
    1d9c:	00cf0200 	.inst	0x00cf0200 ; undefined
    1da0:	08150000 	stxrb	w21, w0, [x0]
    1da4:	000000ad 	udf	#173
    1da8:	011b0200 	.inst	0x011b0200 ; undefined
    1dac:	10160000 	adr	x0, 2ddac <GPR_FRAME_SIZE+0x2dcac>
    1db0:	000000ba 	udf	#186
    1db4:	8e030008 	.inst	0x8e030008 ; undefined
    1db8:	02000003 	.inst	0x02000003 ; undefined
    1dbc:	00c60317 	.inst	0x00c60317 ; undefined
    1dc0:	49090000 	.inst	0x49090000 ; undefined
    1dc4:	02000001 	.inst	0x02000001 ; undefined
    1dc8:	0104101c 	.inst	0x0104101c ; undefined
    1dcc:	e60a0000 	.inst	0xe60a0000 ; undefined
    1dd0:	00000000 	udf	#0
    1dd4:	0006ce0b 	.inst	0x0006ce0b ; undefined
    1dd8:	01030100 	.inst	0x01030100 ; undefined
    1ddc:	40001728 	.inst	0x40001728 ; undefined
    1de0:	00000000 	udf	#0
    1de4:	0000004c 	udf	#76
    1de8:	00000000 	udf	#0
    1dec:	af009c01 	.inst	0xaf009c01 ; undefined
    1df0:	05000002 	orr	z2.s, z2.s, #0x1
    1df4:	e0080100 	ld1b	{za0h.b[w12, 0]}, p0/z, [x8, x8]
    1df8:	0b00000f 	add	w15, w0, w0
    1dfc:	000001b6 	udf	#438
    1e00:	0005601d 	.inst	0x0005601d ; undefined
    1e04:	00000000 	udf	#0
    1e08:	00177400 	.inst	0x00177400 ; undefined
    1e0c:	00000040 	udf	#64
    1e10:	00029000 	.inst	0x00029000 ; undefined
    1e14:	00000000 	udf	#0
    1e18:	000bac00 	.inst	0x000bac00 ; undefined
    1e1c:	02040700 	.inst	0x02040700 ; undefined
    1e20:	00006b05 	udf	#27397
    1e24:	69660800 	ldpsw	x0, x2, [x0, #-208]
    1e28:	06020071 	.inst	0x06020071 ; undefined
    1e2c:	00006b07 	udf	#27399
    1e30:	69080000 	stgp	x0, x0, [x0, #256]
    1e34:	02007172 	.inst	0x02007172 ; undefined
    1e38:	006b0707 	.inst	0x006b0707 ; undefined
    1e3c:	03010000 	.inst	0x03010000 ; undefined
    1e40:	00000234 	udf	#564
    1e44:	6b070802 	subs	w2, w0, w7, lsl #2
    1e48:	02000000 	.inst	0x02000000 ; undefined
    1e4c:	00019003 	.inst	0x00019003 ; undefined
    1e50:	07090200 	.inst	0x07090200 ; undefined
    1e54:	0000006b 	udf	#107
    1e58:	01010003 	.inst	0x01010003 ; undefined
    1e5c:	00041c02 	.inst	0x00041c02 ; undefined
    1e60:	00f50400 	.inst	0x00f50400 ; undefined
    1e64:	0a020000 	and	w0, w0, w2
    1e68:	00002e03 	udf	#11779
    1e6c:	07040100 	.inst	0x07040100 ; undefined
    1e70:	0000031a 	udf	#794
    1e74:	3d060101 	str	b1, [x8, #384]
    1e78:	01000002 	.inst	0x01000002 ; undefined
    1e7c:	023b0801 	.inst	0x023b0801 ; undefined
    1e80:	02010000 	.inst	0x02010000 ; undefined
    1e84:	00039805 	.inst	0x00039805 ; undefined
    1e88:	07020100 	.inst	0x07020100 ; undefined
    1e8c:	00000136 	udf	#310
    1e90:	6905040c 	stgp	x12, x1, [x0, #160]
    1e94:	0400746e 	mls	z14.b, p5/m, z3.b, z0.b
    1e98:	000002cf 	udf	#719
    1e9c:	7e162503 	.inst	0x7e162503 ; undefined
    1ea0:	01000000 	.inst	0x01000000 ; undefined
    1ea4:	036b0508 	.inst	0x036b0508 ; undefined
    1ea8:	24040000 	cmphs	p0.b, p0/z, z0.b, z4.b
    1eac:	03000001 	.inst	0x03000001 ; undefined
    1eb0:	00c71c28 	.inst	0x00c71c28 ; undefined
    1eb4:	08010000 	stxrb	w1, w0, [x0]
    1eb8:	00031007 	.inst	0x00031007 ; undefined
    1ebc:	05080100 	.inst	0x05080100 ; undefined
    1ec0:	00000370 	udf	#880
    1ec4:	15070801 	b	41c3ec8 <GPR_FRAME_SIZE+0x41c3dc8>
    1ec8:	07000003 	.inst	0x07000003 ; undefined
    1ecc:	0c0e0410 	.inst	0x0c0e0410 ; undefined
    1ed0:	03000001 	.inst	0x03000001 ; undefined
    1ed4:	0000022f 	udf	#559
    1ed8:	0c080f04 	.inst	0x0c080f04 ; undefined
    1edc:	00000001 	udf	#1
    1ee0:	00032703 	.inst	0x00032703 ; undefined
    1ee4:	09100400 	.inst	0x09100400 ; undefined
    1ee8:	000000a8 	udf	#168
    1eec:	6f630808 	mla	v8.8h, v0.8h, v3.h[6]
    1ef0:	1104006c 	add	w12, w3, #0x100
    1ef4:	0000a809 	udf	#43017
    1ef8:	0d000c00 	st1	{v0.b}[3], [x0]
    1efc:	00011208 	.inst	0x00011208 ; undefined
    1f00:	08010100 	stxrb	w1, w0, [x8]
    1f04:	00000244 	udf	#580
    1f08:	0003b904 	.inst	0x0003b904 ; undefined
    1f0c:	03120400 	.inst	0x03120400 ; undefined
    1f10:	000000dc 	udf	#220
    1f14:	14041807 	b	107f30 <GPR_FRAME_SIZE+0x107e30>
    1f18:	00000148 	udf	#328
    1f1c:	0000cf03 	udf	#52995
    1f20:	08150400 	stxrb	w21, w0, [x0]
    1f24:	0000010c 	udf	#268
    1f28:	011b0300 	.inst	0x011b0300 ; undefined
    1f2c:	16040000 	b	fffffffff8101f2c <__stack_el2_top+0xffffffffb6afaf2c>
    1f30:	00011910 	.inst	0x00011910 ; undefined
    1f34:	04000800 	add	z0.b, p2/m, z0.b, z0.b
    1f38:	0000038e 	udf	#910
    1f3c:	25031704 	cmpge	p4.b, p5/z, z24.b, #3
    1f40:	0e000001 	tbl	v1.8b, {v0.16b}, v0.8b
    1f44:	00000149 	udf	#329
    1f48:	66101c04 	.inst	0x66101c04 ; undefined
    1f4c:	0f000001 	fdot	v1.2s, v0.8b, v0.4b[0]
    1f50:	00000148 	udf	#328
    1f54:	06e60200 	.inst	0x06e60200 ; undefined
    1f58:	020f0000 	.inst	0x020f0000 ; undefined
    1f5c:	00000718 	udf	#1816
    1f60:	0731020a 	.inst	0x0731020a ; undefined
    1f64:	020e0000 	.inst	0x020e0000 ; undefined
    1f68:	0000079c 	udf	#1948
    1f6c:	07000209 	.inst	0x07000209 ; undefined
    1f70:	020d0000 	.inst	0x020d0000 ; undefined
    1f74:	0000074c 	udf	#1868
    1f78:	07b60208 	.inst	0x07b60208 ; undefined
    1f7c:	020c0000 	.inst	0x020c0000 ; undefined
    1f80:	00000768 	udf	#1896
    1f84:	07871007 	.inst	0x07871007 ; undefined
    1f88:	05010000 	orr	z0.s, z0.s, #0x1
    1f8c:	0000bb0f 	udf	#47887
    1f90:	06ed0900 	.inst	0x06ed0900 ; undefined
    1f94:	90460000 	adrp	x0, 8c001000 <__stack_el2_top+0x4a9fa000>
    1f98:	00400019 	.inst	0x00400019 ; undefined
    1f9c:	74000000 	.inst	0x74000000 ; undefined
    1fa0:	00000000 	udf	#0
    1fa4:	01000000 	.inst	0x01000000 ; undefined
    1fa8:	0001f79c 	.inst	0x0001f79c ; undefined
    1fac:	69660600 	ldpsw	x0, x1, [x16, #-208]
    1fb0:	1e460071 	.inst	0x1e460071 ; undefined
    1fb4:	0000006b 	udf	#107
    1fb8:	067f9102 	.inst	0x067f9102 ; undefined
    1fbc:	00717269 	.inst	0x00717269 ; undefined
    1fc0:	006b2846 	.inst	0x006b2846 ; undefined
    1fc4:	91020000 	add	x0, x0, #0x80
    1fc8:	0234057e 	.inst	0x0234057e ; undefined
    1fcc:	32460000 	.inst	0x32460000 ; undefined
    1fd0:	0000006b 	udf	#107
    1fd4:	057d9102 	.inst	0x057d9102 ; undefined
    1fd8:	00000190 	udf	#400
    1fdc:	006b3f46 	.inst	0x006b3f46 ; undefined
    1fe0:	91020000 	add	x0, x0, #0x80
    1fe4:	1f09007c 	fmadd	s28, s3, s9, s0
    1fe8:	3b000007 	.inst	0x3b000007 ; undefined
    1fec:	4000191c 	.inst	0x4000191c ; undefined
    1ff0:	00000000 	udf	#0
    1ff4:	00000074 	udf	#116
    1ff8:	00000000 	udf	#0
    1ffc:	024c9c01 	.inst	0x024c9c01 ; undefined
    2000:	66060000 	.inst	0x66060000 ; undefined
    2004:	3b007169 	.inst	0x3b007169 ; undefined
    2008:	00006b1d 	udf	#27421
    200c:	7f910200 	.inst	0x7f910200 ; undefined
    2010:	71726906 	subs	w6, w8, #0xc9a, lsl #12
    2014:	6b273b00 	.inst	0x6b273b00 ; undefined
    2018:	02000000 	.inst	0x02000000 ; undefined
    201c:	34057e91 	cbz	w17, cfec <GPR_FRAME_SIZE+0xceec>
    2020:	3b000002 	.inst	0x3b000002 ; undefined
    2024:	00006b31 	udf	#27441
    2028:	7d910200 	.inst	0x7d910200 ; undefined
    202c:	00019005 	.inst	0x00019005 ; undefined
    2030:	6b3e3b00 	.inst	0x6b3e3b00 ; undefined
    2034:	02000000 	.inst	0x02000000 ; undefined
    2038:	09007c91 	.inst	0x09007c91 ; undefined
    203c:	00000473 	udf	#1139
    2040:	0018081c 	.inst	0x0018081c ; undefined
    2044:	00000040 	udf	#64
    2048:	00011400 	.inst	0x00011400 ; undefined
    204c:	00000000 	udf	#0
    2050:	859c0100 	ldr	p0, [x8, #224, mul vl]
    2054:	05000002 	orr	z2.s, z2.s, #0x1
    2058:	000001af 	udf	#431
    205c:	00722d1c 	.inst	0x00722d1c ; undefined
    2060:	91020000 	add	x0, x0, #0x80
    2064:	077f0a58 	.inst	0x077f0a58 ; undefined
    2068:	13330000 	.inst	0x13330000 ; undefined
    206c:	00000072 	udf	#114
    2070:	00789102 	.inst	0x00789102 ; undefined
    2074:	0001a011 	.inst	0x0001a011 ; undefined
    2078:	12120100 	and	w0, w8, #0x4000
    207c:	00000072 	udf	#114
    2080:	40001774 	.inst	0x40001774 ; undefined
    2084:	00000000 	udf	#0
    2088:	00000094 	udf	#148
    208c:	00000000 	udf	#0
    2090:	630a9c01 	.inst	0x630a9c01 ; undefined
    2094:	14000007 	b	20b0 <GPR_FRAME_SIZE+0x1fb0>
    2098:	0000bb09 	udf	#47881
    209c:	78910200 	ldursh	x0, [x16, #-240]
    20a0:	043d0000 	add	z0.b, z0.b, z29.b
    20a4:	00050000 	.inst	0x00050000 ; undefined
    20a8:	110b0801 	add	w1, w0, #0x2c2
    20ac:	b60f0000 	tbz	x0, #33, ac <GPR_PAIRS+0x9c>
    20b0:	1d000001 	.inst	0x1d000001 ; undefined
    20b4:	00000581 	udf	#1409
    20b8:	00000000 	udf	#0
    20bc:	40001a04 	.inst	0x40001a04 ; undefined
    20c0:	00000000 	udf	#0
    20c4:	000007cc 	udf	#1996
    20c8:	00000000 	udf	#0
    20cc:	00000d02 	udf	#3330
    20d0:	0000690a 	udf	#26890
    20d4:	00690b00 	.inst	0x00690b00 ; undefined
    20d8:	98020000 	ldrsw	x0, 60d8 <GPR_FRAME_SIZE+0x5fd8>
    20dc:	00000002 	udf	#2
    20e0:	00033602 	.inst	0x00033602 ; undefined
    20e4:	57020100 	.inst	0x57020100 ; undefined
    20e8:	02000002 	.inst	0x02000002 ; undefined
    20ec:	00028302 	.inst	0x00028302 ; undefined
    20f0:	64020300 	.inst	0x64020300 ; undefined
    20f4:	04000002 	add	z2.b, p0/m, z2.b, z0.b
    20f8:	0002b402 	.inst	0x0002b402 ; undefined
    20fc:	d7020500 	.inst	0xd7020500 ; undefined
    2100:	06000000 	.inst	0x06000000 ; undefined
    2104:	0003e402 	.inst	0x0003e402 ; undefined
    2108:	03000700 	.inst	0x03000700 ; undefined
    210c:	031a0704 	.inst	0x031a0704 ; undefined
    2110:	a2010000 	.inst	0xa2010000 ; undefined
    2114:	02000003 	.inst	0x02000003 ; undefined
    2118:	002e0314 	.inst	0x002e0314 ; NYI
    211c:	690a0000 	stgp	x0, x0, [x0, #320]
    2120:	17000000 	b	fffffffffc002120 <__stack_el2_top+0xffffffffba9fb120>
    2124:	0000009f 	udf	#159
    2128:	00016602 	.inst	0x00016602 ; undefined
    212c:	79020a00 	strh	w0, [x16, #260]
    2130:	10000003 	adr	x3, 2130 <GPR_FRAME_SIZE+0x2030>
    2134:	00035602 	.inst	0x00035602 ; undefined
    2138:	06020200 	.inst	0x06020200 ; undefined
    213c:	08000001 	stxrb	w0, w1, [x0]
    2140:	00e40100 	.inst	0x00e40100 ; undefined
    2144:	1c020000 	ldr	s0, 6144 <GPR_FRAME_SIZE+0x6044>
    2148:	00007c03 	udf	#31747
    214c:	02520100 	.inst	0x02520100 ; undefined
    2150:	1e020000 	.inst	0x1e020000 ; undefined
    2154:	0000b715 	udf	#46869
    2158:	06010300 	.inst	0x06010300 ; undefined
    215c:	0000023d 	udf	#573
    2160:	00025101 	.inst	0x00025101 ; undefined
    2164:	171f0200 	b	fffffffffc7c2964 <__stack_el2_top+0xffffffffbb1bb964>
    2168:	000000cf 	udf	#207
    216c:	0000be0b 	udf	#48651
    2170:	08010300 	stxrb	w1, w0, [x24]
    2174:	0000023b 	udf	#571
    2178:	00029201 	.inst	0x00029201 ; undefined
    217c:	16210200 	b	fffffffff884297c <__stack_el2_top+0xffffffffb723b97c>
    2180:	000000e2 	udf	#226
    2184:	98050203 	ldrsw	x3, c1c4 <GPR_FRAME_SIZE+0xc0c4>
    2188:	01000003 	.inst	0x01000003 ; undefined
    218c:	00000291 	udf	#657
    2190:	f5182202 	.inst	0xf5182202 ; undefined
    2194:	03000000 	.inst	0x03000000 ; undefined
    2198:	01360702 	.inst	0x01360702 ; undefined
    219c:	d0010000 	adrp	x0, 2004000 <GPR_FRAME_SIZE+0x2003f00>
    21a0:	02000002 	.inst	0x02000002 ; undefined
    21a4:	01081424 	.inst	0x01081424 ; undefined
    21a8:	04100000 	mul	z0.b, p0/m, z0.b, z0.b
    21ac:	746e6905 	.inst	0x746e6905 ; undefined
    21b0:	02cf0100 	.inst	0x02cf0100 ; undefined
    21b4:	25020000 	cmpge	p0.b, p0/z, z0.b, #2
    21b8:	00006916 	udf	#26902
    21bc:	01250100 	.inst	0x01250100 ; undefined
    21c0:	27020000 	.inst	0x27020000 ; undefined
    21c4:	0001271a 	.inst	0x0001271a ; undefined
    21c8:	05080300 	.inst	0x05080300 ; undefined
    21cc:	0000036b 	udf	#875
    21d0:	00012401 	.inst	0x00012401 ; undefined
    21d4:	1c280200 	ldr	s0, 52214 <GPR_FRAME_SIZE+0x52114>
    21d8:	0000013a 	udf	#314
    21dc:	10070803 	adr	x3, 102dc <GPR_FRAME_SIZE+0x101dc>
    21e0:	03000003 	.inst	0x03000003 ; undefined
    21e4:	03700508 	.inst	0x03700508 ; undefined
    21e8:	08030000 	stxrb	w3, w0, [x0]
    21ec:	00031507 	.inst	0x00031507 ; undefined
    21f0:	02081100 	.inst	0x02081100 ; undefined
    21f4:	01b10958 	.inst	0x01b10958 ; undefined
    21f8:	52050000 	eor	w0, w0, #0x8000000
    21fc:	59000002 	stlurh	w2, [x0]
    2200:	0000ab07 	udf	#43783
    2204:	02510500 	.inst	0x02510500 ; undefined
    2208:	085a0000 	ldxrb	w0, [x0]
    220c:	000000be 	udf	#190
    2210:	00029205 	.inst	0x00029205 ; undefined
    2214:	d6085c00 	.inst	0xd6085c00 ; undefined
    2218:	05000000 	orr	z0.s, z0.s, #0x1
    221c:	00000291 	udf	#657
    2220:	00e9095d 	.inst	0x00e9095d ; undefined
    2224:	d0050000 	adrp	x0, a004000 <GPR_FRAME_SIZE+0xa003f00>
    2228:	5f000002 	.inst	0x5f000002 ; undefined
    222c:	0000fc08 	udf	#64520
    2230:	02cf0500 	.inst	0x02cf0500 ; undefined
    2234:	09600000 	.inst	0x09600000 ; undefined
    2238:	0000010f 	udf	#271
    223c:	00012505 	.inst	0x00012505 ; undefined
    2240:	1b086200 	madd	w0, w16, w8, w24
    2244:	05000001 	orr	z1.s, z1.s, #0x1
    2248:	00000124 	udf	#292
    224c:	012e0963 	.inst	0x012e0963 ; undefined
    2250:	01000000 	.inst	0x01000000 ; undefined
    2254:	000002c2 	udf	#706
    2258:	4f036402 	movi	v2.4s, #0x60, lsl #24
    225c:	0c000001 	st4	{v1.8b-v4.8b}, [x0]
    2260:	01ea0e10 	.inst	0x01ea0e10 ; undefined
    2264:	2f080000 	.inst	0x2f080000 ; undefined
    2268:	0f000002 	fdot	v2.2s, v0.8b, v0.4b[0]
    226c:	0001ea08 	.inst	0x0001ea08 ; undefined
    2270:	27080000 	.inst	0x27080000 ; undefined
    2274:	10000003 	adr	x3, 2274 <GPR_FRAME_SIZE+0x2174>
    2278:	00010f09 	.inst	0x00010f09 ; undefined
    227c:	63120800 	.inst	0x63120800 ; undefined
    2280:	03006c6f 	.inst	0x03006c6f ; undefined
    2284:	010f0911 	.inst	0x010f0911 ; undefined
    2288:	000c0000 	.inst	0x000c0000 ; undefined
    228c:	01f00813 	.inst	0x01f00813 ; undefined
    2290:	01030000 	.inst	0x01030000 ; undefined
    2294:	00024408 	.inst	0x00024408 ; undefined
    2298:	03b90100 	.inst	0x03b90100 ; undefined
    229c:	12030000 	and	w0, w0, #0x20000000
    22a0:	0001bd03 	.inst	0x0001bd03 ; undefined
    22a4:	14180c00 	b	6052a4 <GPR_FRAME_SIZE+0x6051a4>
    22a8:	00000223 	udf	#547
    22ac:	0000cf08 	udf	#53000
    22b0:	ea081500 	ands	x0, x8, x8, lsl #5
    22b4:	00000001 	udf	#1
    22b8:	00011b08 	.inst	0x00011b08 ; undefined
    22bc:	f7101600 	.inst	0xf7101600 ; undefined
    22c0:	08000001 	stxrb	w0, w1, [x0]
    22c4:	038e0100 	.inst	0x038e0100 ; undefined
    22c8:	17030000 	b	fffffffffc0c22c8 <__stack_el2_top+0xffffffffbaabb2c8>
    22cc:	00020303 	.inst	0x00020303 ; undefined
    22d0:	00ca1400 	.inst	0x00ca1400 ; undefined
    22d4:	023f0000 	.inst	0x023f0000 ; undefined
    22d8:	48150000 	stxrh	w21, w0, [x0]
    22dc:	0f000001 	fdot	v1.2s, v0.8b, v0.4b[0]
    22e0:	022f0b00 	.inst	0x022f0b00 ; undefined
    22e4:	e6040000 	.inst	0xe6040000 ; undefined
    22e8:	1c000007 	ldr	s7, 22e8 <GPR_FRAME_SIZE+0x21e8>
    22ec:	00023f14 	.inst	0x00023f14 ; undefined
    22f0:	10030900 	adr	x0, 8410 <GPR_FRAME_SIZE+0x8310>
    22f4:	0040004f 	.inst	0x0040004f ; undefined
    22f8:	16000000 	b	fffffffff80022f8 <__stack_el2_top+0xffffffffb69fb2f8>
    22fc:	00000149 	udf	#329
    2300:	6b101c03 	subs	w3, w0, w16, lsl #7
    2304:	17000002 	b	fffffffffc00230c <__stack_el2_top+0xffffffffba9fb30c>
    2308:	00000223 	udf	#547
    230c:	03000d00 	.inst	0x03000d00 ; undefined
    2310:	07210000 	.inst	0x07210000 ; undefined
    2314:	000001ea 	udf	#490
    2318:	40001b08 	.inst	0x40001b08 ; undefined
    231c:	00000000 	udf	#0
    2320:	000006c8 	udf	#1736
    2324:	00000000 	udf	#0
    2328:	03b49c01 	.inst	0x03b49c01 ; undefined
    232c:	6e060000 	ext	v0.16b, v0.16b, v6.16b, #0
    2330:	b1242100 	adds	x0, x8, #0x908
    2334:	03000001 	.inst	0x03000001 ; undefined
    2338:	097ed891 	.inst	0x097ed891 ; undefined
    233c:	0000080e 	udf	#2062
    2340:	00703421 	.inst	0x00703421 ; undefined
    2344:	91030000 	add	x0, x0, #0xc0
    2348:	62067ed4 	.inst	0x62067ed4 ; undefined
    234c:	21006675 	.inst	0x21006675 ; undefined
    2350:	0001ea42 	.inst	0x0001ea42 ; undefined
    2354:	c8910300 	stllr	x0, [x24]
    2358:	0806097e 	stxrb	w6, w30, [x11]
    235c:	0f220000 	fdot	v0.2s, v0.8b, v2.4b[1]
    2360:	0000012e 	udf	#302
    2364:	7ec09103 	.inst	0x7ec09103 ; undefined
    2368:	0007d809 	.inst	0x0007d809 ; undefined
    236c:	9f292200 	.inst	0x9f292200 ; undefined
    2370:	03000000 	.inst	0x03000000 ; undefined
    2374:	047ed091 	.inst	0x047ed091 ; undefined
    2378:	000007dd 	udf	#2013
    237c:	012e0924 	.inst	0x012e0924 ; undefined
    2380:	91020000 	add	x0, x0, #0x80
    2384:	07ce0478 	.inst	0x07ce0478 ; undefined
    2388:	07350000 	.inst	0x07350000 ; undefined
    238c:	000003b4 	udf	#948
    2390:	04779102 	asr	z2.s, z8.s, #9
    2394:	00000831 	udf	#2097
    2398:	011b0836 	.inst	0x011b0836 ; undefined
    239c:	91020000 	add	x0, x0, #0x80
    23a0:	082f0468 	.inst	0x082f0468 ; undefined
    23a4:	09370000 	.inst	0x09370000 ; undefined
    23a8:	0000012e 	udf	#302
    23ac:	04609102 	asr	z2.s, z8.s, #32
    23b0:	00000838 	udf	#2104
    23b4:	012e095e 	.inst	0x012e095e ; undefined
    23b8:	91020000 	add	x0, x0, #0x80
    23bc:	083e0458 	.inst	0x083e0458 ; undefined
    23c0:	075f0000 	.inst	0x075f0000 ; undefined
    23c4:	000003b4 	udf	#948
    23c8:	18579102 	ldr	w2, b15e8 <GPR_FRAME_SIZE+0xb14e8>
    23cc:	00000330 	udf	#816
    23d0:	8401af01 	ldnt1b	{z1.s}, p3/z, [z24.s, x1]
    23d4:	00400021 	.inst	0x00400021 ; undefined
    23d8:	07000000 	.inst	0x07000000 ; undefined
    23dc:	09830069 	.inst	0x09830069 ; undefined
    23e0:	0000012e 	udf	#302
    23e4:	04409102 	asr	z2.s, p4/m, z2.s, #24
    23e8:	0000085d 	udf	#2141
    23ec:	012e09a3 	.inst	0x012e09a3 ; undefined
    23f0:	91030000 	add	x0, x0, #0xc0
    23f4:	65077fb8 	.inst	0x65077fb8 ; undefined
    23f8:	a400646e 	ldff1b	{z14.b}, p1/z, [x3, x0]
    23fc:	00012e09 	.inst	0x00012e09 ; undefined
    2400:	b0910300 	adrp	x0, ffffffff22063000 <__stack_el2_top+0xfffffffee0a5c000>
    2404:	00380e7f 	.inst	0x00380e7f ; NYI
    2408:	03790000 	.inst	0x03790000 ; undefined
    240c:	69070000 	stgp	x0, x0, [x0, #224]
    2410:	1b096e00 	madd	w0, w16, w9, w27
    2414:	02000001 	.inst	0x02000001 ; undefined
    2418:	0e004891 	.inst	0x0e004891 ; undefined
    241c:	00000043 	udf	#67
    2420:	00000392 	udf	#914
    2424:	00081504 	.inst	0x00081504 ; undefined
    2428:	be098600 	.inst	0xbe098600 ; undefined
    242c:	03000000 	.inst	0x03000000 ; undefined
    2430:	007fae91 	.inst	0x007fae91 ; undefined
    2434:	00210019 	.inst	0x00210019 ; NYI
    2438:	00000040 	udf	#64
    243c:	00006000 	udf	#24576
    2440:	00000000 	udf	#0
    2444:	6d740700 	ldp	d0, d1, [x24, #-192]
    2448:	08a60070 	.inst	0x08a60070 ; undefined
    244c:	000001f0 	udf	#496
    2450:	7faf9103 	fmulx	s3, s8, v15.s[1]
    2454:	01030000 	.inst	0x01030000 ; undefined
    2458:	00041c02 	.inst	0x00041c02 ; undefined
    245c:	081b0d00 	stxrb	w27, w0, [x8]
    2460:	06110000 	.inst	0x06110000 ; undefined
    2464:	000001f0 	udf	#496
    2468:	40001a98 	.inst	0x40001a98 ; undefined
    246c:	00000000 	udf	#0
    2470:	00000070 	udf	#112
    2474:	00000000 	udf	#0
    2478:	03e99c01 	.inst	0x03e99c01 ; undefined
    247c:	6e060000 	ext	v0.16b, v0.16b, v6.16b, #0
    2480:	be201100 	.inst	0xbe201100 ; undefined
    2484:	02000000 	.inst	0x02000000 ; undefined
    2488:	1a005f91 	.inst	0x1a005f91 ; undefined
    248c:	000002d6 	udf	#726
    2490:	04060601 	.inst	0x04060601 ; undefined
    2494:	0040001a 	.inst	0x0040001a ; undefined
    2498:	94000000 	bl	2498 <GPR_FRAME_SIZE+0x2398>
    249c:	00000000 	udf	#0
    24a0:	01000000 	.inst	0x01000000 ; undefined
    24a4:	7364069c 	.inst	0x7364069c ; undefined
    24a8:	14060074 	b	182678 <GPR_FRAME_SIZE+0x182578>
    24ac:	000001ea 	udf	#490
    24b0:	06689102 	.inst	0x06689102 ; undefined
    24b4:	00637273 	.inst	0x00637273 ; undefined
    24b8:	01ea1f06 	.inst	0x01ea1f06 ; undefined
    24bc:	91020000 	add	x0, x0, #0x80
    24c0:	07fd0960 	.inst	0x07fd0960 ; undefined
    24c4:	2b060000 	adds	w0, w0, w6
    24c8:	0000012e 	udf	#302
    24cc:	1b589102 	.inst	0x1b589102 ; undefined
    24d0:	0000002f 	udf	#47
    24d4:	08006907 	stxrb	w0, w7, [x8]
    24d8:	00012e0e 	.inst	0x00012e0e ; undefined
    24dc:	78910200 	ldursh	x0, [x16, #-240]
    24e0:	c9000000 	.inst	0xc9000000 ; undefined
    24e4:	05000004 	orr	z4.s, z4.s, #0x1
    24e8:	9f080100 	.inst	0x9f080100 ; undefined
    24ec:	13000012 	sbfx	w18, w0, #0, #1
    24f0:	000001b6 	udf	#438
    24f4:	00059c1d 	.inst	0x00059c1d ; undefined
    24f8:	00000000 	udf	#0
    24fc:	0021d000 	.inst	0x0021d000 ; NYI
    2500:	00000040 	udf	#64
    2504:	0003f800 	.inst	0x0003f800 ; undefined
    2508:	00000000 	udf	#0
    250c:	000f7700 	.inst	0x000f7700 ; undefined
    2510:	006a0900 	.inst	0x006a0900 ; undefined
    2514:	0b020000 	add	w0, w0, w2
    2518:	0000006a 	udf	#106
    251c:	00029801 	.inst	0x00029801 ; undefined
    2520:	36010000 	tbz	w0, #0, 4520 <GPR_FRAME_SIZE+0x4420>
    2524:	01000003 	.inst	0x01000003 ; undefined
    2528:	00025701 	.inst	0x00025701 ; undefined
    252c:	83010200 	.inst	0x83010200 ; undefined
    2530:	03000002 	.inst	0x03000002 ; undefined
    2534:	00026401 	.inst	0x00026401 ; undefined
    2538:	b4010400 	cbz	x0, 45b8 <GPR_FRAME_SIZE+0x44b8>
    253c:	05000002 	orr	z2.s, z2.s, #0x1
    2540:	0000d701 	udf	#55041
    2544:	e4010600 	.inst	0xe4010600 ; undefined
    2548:	07000003 	.inst	0x07000003 ; undefined
    254c:	07040400 	.inst	0x07040400 ; undefined
    2550:	0000031a 	udf	#794
    2554:	0003a202 	.inst	0x0003a202 ; undefined
    2558:	03140200 	.inst	0x03140200 ; undefined
    255c:	0000002e 	udf	#46
    2560:	00006a09 	udf	#27145
    2564:	a1170200 	ld1b	{z0.b, z8.b}, pn8/z, [x16, x23]
    2568:	01000000 	.inst	0x01000000 ; undefined
    256c:	00000166 	udf	#358
    2570:	0379010a 	.inst	0x0379010a ; undefined
    2574:	01100000 	.inst	0x01100000 ; undefined
    2578:	00000356 	udf	#854
    257c:	01060102 	.inst	0x01060102 ; undefined
    2580:	00080000 	.inst	0x00080000 ; undefined
    2584:	0000e402 	udf	#58370
    2588:	031c0200 	.inst	0x031c0200 ; undefined
    258c:	0000007d 	udf	#125
    2590:	00025202 	.inst	0x00025202 ; undefined
    2594:	151e0200 	b	4782d94 <GPR_FRAME_SIZE+0x4782c94>
    2598:	000000b9 	udf	#185
    259c:	3d060104 	str	b4, [x8, #384]
    25a0:	02000002 	.inst	0x02000002 ; undefined
    25a4:	00000251 	udf	#593
    25a8:	cc171f02 	.inst	0xcc171f02 ; undefined
    25ac:	04000000 	add	z0.b, p0/m, z0.b, z0.b
    25b0:	023b0801 	.inst	0x023b0801 ; undefined
    25b4:	92020000 	and	x0, x0, #0x4000000040000000
    25b8:	02000002 	.inst	0x02000002 ; undefined
    25bc:	00df1621 	.inst	0x00df1621 ; undefined
    25c0:	02040000 	.inst	0x02040000 ; undefined
    25c4:	00039805 	.inst	0x00039805 ; undefined
    25c8:	02910200 	.inst	0x02910200 ; undefined
    25cc:	22020000 	.inst	0x22020000 ; undefined
    25d0:	0000f218 	udf	#61976
    25d4:	07020400 	.inst	0x07020400 ; undefined
    25d8:	00000136 	udf	#310
    25dc:	0002d002 	.inst	0x0002d002 ; undefined
    25e0:	14240200 	b	902de0 <GPR_FRAME_SIZE+0x902ce0>
    25e4:	00000105 	udf	#261
    25e8:	69050414 	stgp	x20, x1, [x0, #160]
    25ec:	0200746e 	.inst	0x0200746e ; undefined
    25f0:	000002cf 	udf	#719
    25f4:	6a162502 	ands	w2, w8, w22, lsl #9
    25f8:	02000000 	.inst	0x02000000 ; undefined
    25fc:	00000125 	udf	#293
    2600:	241a2702 	cmpeq	p2.b, p1/z, z24.b, z26.d
    2604:	04000001 	add	z1.b, p0/m, z1.b, z0.b
    2608:	036b0508 	.inst	0x036b0508 ; undefined
    260c:	24020000 	cmphs	p0.b, p0/z, z0.b, z2.b
    2610:	02000001 	.inst	0x02000001 ; undefined
    2614:	01371c28 	.inst	0x01371c28 ; undefined
    2618:	08040000 	stxrb	w4, w0, [x0]
    261c:	00031007 	.inst	0x00031007 ; undefined
    2620:	05080400 	.inst	0x05080400 ; undefined
    2624:	00000370 	udf	#880
    2628:	00052402 	.inst	0x00052402 ; undefined
    262c:	17340200 	b	fffffffffcd02e2c <__stack_el2_top+0xffffffffbb6fbe2c>
    2630:	00000151 	udf	#337
    2634:	15070804 	b	41c4644 <GPR_FRAME_SIZE+0x41c4544>
    2638:	02000003 	.inst	0x02000003 ; undefined
    263c:	00000440 	udf	#1088
    2640:	51173502 	sub	w2, w8, #0x5cd
    2644:	15000001 	b	4002648 <GPR_FRAME_SIZE+0x4002548>
    2648:	09580208 	.inst	0x09580208 ; undefined
    264c:	000001c6 	udf	#454
    2650:	00025205 	.inst	0x00025205 ; undefined
    2654:	ad075900 	stp	q0, q22, [x8, #224]
    2658:	05000000 	orr	z0.s, z0.s, #0x1
    265c:	00000251 	udf	#593
    2660:	00c0085a 	.inst	0x00c0085a ; undefined
    2664:	92050000 	and	x0, x0, #0x800000008000000
    2668:	5c000002 	ldr	d2, 2668 <GPR_FRAME_SIZE+0x2568>
    266c:	0000d308 	udf	#54024
    2670:	02910500 	.inst	0x02910500 ; undefined
    2674:	095d0000 	.inst	0x095d0000 ; undefined
    2678:	000000e6 	udf	#230
    267c:	0002d005 	.inst	0x0002d005 ; undefined
    2680:	f9085f00 	str	x0, [x24, #4280]
    2684:	05000000 	orr	z0.s, z0.s, #0x1
    2688:	000002cf 	udf	#719
    268c:	010c0960 	.inst	0x010c0960 ; undefined
    2690:	25050000 	cmpge	p0.b, p0/z, z0.b, #5
    2694:	62000001 	.inst	0x62000001 ; undefined
    2698:	00011808 	.inst	0x00011808 ; undefined
    269c:	01240500 	.inst	0x01240500 ; undefined
    26a0:	09630000 	.inst	0x09630000 ; undefined
    26a4:	0000012b 	udf	#299
    26a8:	02c20200 	.inst	0x02c20200 ; undefined
    26ac:	64020000 	.inst	0x64020000 ; undefined
    26b0:	00016403 	.inst	0x00016403 ; undefined
    26b4:	0e100d00 	.inst	0x0e100d00 ; undefined
    26b8:	000001ff 	udf	#511
    26bc:	00022f07 	.inst	0x00022f07 ; undefined
    26c0:	ff080f00 	.inst	0xff080f00 ; undefined
    26c4:	00000001 	udf	#1
    26c8:	00032707 	.inst	0x00032707 ; undefined
    26cc:	0c091000 	.inst	0x0c091000 ; undefined
    26d0:	08000001 	stxrb	w0, w1, [x0]
    26d4:	6c6f6316 	ldnp	d22, d24, [x24, #-272]
    26d8:	09110300 	.inst	0x09110300 ; undefined
    26dc:	0000010c 	udf	#268
    26e0:	040e000c 	.inst	0x040e000c ; undefined
    26e4:	04000002 	add	z2.b, p0/m, z2.b, z0.b
    26e8:	02440801 	.inst	0x02440801 ; undefined
    26ec:	040f0000 	.inst	0x040f0000 ; undefined
    26f0:	02000002 	.inst	0x02000002 ; undefined
    26f4:	000003b9 	udf	#953
    26f8:	d2031203 	eor	x3, x16, #0xe0000003e0000003
    26fc:	0d000001 	st1	{v1.b}[0], [x0]
    2700:	023c1418 	.inst	0x023c1418 ; undefined
    2704:	cf070000 	.inst	0xcf070000 ; undefined
    2708:	15000000 	b	4002708 <GPR_FRAME_SIZE+0x4002608>
    270c:	0001ff08 	.inst	0x0001ff08 ; undefined
    2710:	1b070000 	madd	w0, w0, w7, w0
    2714:	16000001 	b	fffffffff8002718 <__stack_el2_top+0xffffffffb69fb718>
    2718:	00021010 	.inst	0x00021010 ; undefined
    271c:	02000800 	.inst	0x02000800 ; undefined
    2720:	0000038e 	udf	#910
    2724:	1c031703 	ldr	s3, 8a04 <GPR_FRAME_SIZE+0x8904>
    2728:	09000002 	.inst	0x09000002 ; undefined
    272c:	0000006a 	udf	#106
    2730:	026c0504 	.inst	0x026c0504 ; undefined
    2734:	22010000 	.inst	0x22010000 ; undefined
    2738:	00000004 	udf	#4
    273c:	00019601 	.inst	0x00019601 ; undefined
    2740:	2c010100 	stnp	s0, s0, [x8, #8]
    2744:	02000004 	.inst	0x02000004 ; undefined
    2748:	00043601 	.inst	0x00043601 ; undefined
    274c:	02000300 	.inst	0x02000300 ; undefined
    2750:	0000027b 	udf	#635
    2754:	48030a04 	stxrh	w3, w4, [x16]
    2758:	0f000002 	fdot	v2.2s, v0.8b, v0.4b[0]
    275c:	0000026c 	udf	#620
    2760:	0000c010 	udf	#49168
    2764:	00029000 	.inst	0x00029000 ; undefined
    2768:	01511700 	.inst	0x01511700 ; undefined
    276c:	ffff0000 	.inst	0xffff0000 ; undefined
    2770:	0a00003f 	and	wzr, w1, w0
    2774:	00637273 	.inst	0x00637273 ; undefined
    2778:	00027d39 	.inst	0x00027d39 ; undefined
    277c:	80030900 	.inst	0x80030900 ; undefined
    2780:	00400067 	.inst	0x00400067 ; undefined
    2784:	0a000000 	and	w0, w0, w0
    2788:	00747364 	.inst	0x00747364 ; undefined
    278c:	00027d3a 	.inst	0x00027d3a ; undefined
    2790:	80030900 	.inst	0x80030900 ; undefined
    2794:	00404067 	.inst	0x00404067 ; undefined
    2798:	0a000000 	and	w0, w0, w0
    279c:	00666572 	.inst	0x00666572 ; undefined
    27a0:	00027d3b 	.inst	0x00027d3b ; undefined
    27a4:	80030900 	.inst	0x80030900 ; undefined
    27a8:	00408067 	.inst	0x00408067 ; undefined
    27ac:	0b000000 	add	w0, w0, w0
    27b0:	00000300 	udf	#768
    27b4:	ff071d05 	.inst	0xff071d05 ; undefined
    27b8:	f6000001 	.inst	0xf6000001 ; undefined
    27bc:	03000002 	.inst	0x03000002 ; undefined
    27c0:	000001c6 	udf	#454
    27c4:	00007103 	udf	#28931
    27c8:	01ff0300 	.inst	0x01ff0300 ; undefined
    27cc:	2b030000 	adds	w0, w0, w3
    27d0:	03000001 	.inst	0x03000001 ; undefined
    27d4:	000000a1 	udf	#161
    27d8:	03af1800 	.inst	0x03af1800 ; undefined
    27dc:	12040000 	and	w0, w0, #0x10000000
    27e0:	00030d06 	.inst	0x00030d06 ; undefined
    27e4:	02780300 	.inst	0x02780300 ; undefined
    27e8:	0d030000 	.inst	0x0d030000 ; undefined
    27ec:	00000003 	udf	#3
    27f0:	00020b0e 	.inst	0x00020b0e ; undefined
    27f4:	08710b00 	.inst	0x08710b00 ; undefined
    27f8:	0b060000 	add	w0, w0, w6
    27fc:	0003320e 	.inst	0x0003320e ; undefined
    2800:	00033200 	.inst	0x00033200 ; undefined
    2804:	03320300 	.inst	0x03320300 ; undefined
    2808:	32030000 	orr	w0, w0, #0x20000000
    280c:	03000003 	.inst	0x03000003 ; undefined
    2810:	0000012b 	udf	#299
    2814:	0b081900 	add	w0, w8, w8, lsl #6
    2818:	00000863 	udf	#2147
    281c:	320e0701 	orr	w1, w24, #0xc0000
    2820:	54000003 	b.cc	2820 <GPR_FRAME_SIZE+0x2720>  // b.lo, b.ul, b.last
    2824:	03000003 	.inst	0x03000003 ; undefined
    2828:	00000332 	udf	#818
    282c:	00033203 	.inst	0x00033203 ; undefined
    2830:	012b0300 	.inst	0x012b0300 ; undefined
    2834:	1a000000 	adc	w0, w0, w0
    2838:	00000149 	udf	#329
    283c:	66101c03 	.inst	0x66101c03 ; undefined
    2840:	03000003 	.inst	0x03000003 ; undefined
    2844:	0000023c 	udf	#572
    2848:	086d1b00 	.inst	0x086d1b00 ; undefined
    284c:	3d010000 	str	b0, [x0, #64]
    2850:	0023a006 	.inst	0x0023a006 ; NYI
    2854:	00000040 	udf	#64
    2858:	00022800 	.inst	0x00022800 ; undefined
    285c:	00000000 	udf	#0
    2860:	239c0100 	.inst	0x239c0100 ; undefined
    2864:	0c000004 	st4	{v4.8b-v7.8b}, [x0]
    2868:	00000858 	udf	#2136
    286c:	0158193d 	.inst	0x0158193d ; undefined
    2870:	91030000 	add	x0, x0, #0xc0
    2874:	62067ee8 	.inst	0x62067ee8 ; undefined
    2878:	3f006675 	.inst	0x3f006675 ; undefined
    287c:	00042307 	.inst	0x00042307 ; undefined
    2880:	f8910300 	prfum	pldl1keep, [x24, #-240]
    2884:	23ac117e 	.inst	0x23ac117e ; undefined
    2888:	00004000 	udf	#16384
    288c:	00580000 	.inst	0x00580000 ; undefined
    2890:	00000000 	udf	#0
    2894:	03c40000 	.inst	0x03c40000 ; undefined
    2898:	69060000 	stgp	x0, x0, [x0, #192]
    289c:	580e4100 	ldr	x0, 1f0bc <GPR_FRAME_SIZE+0x1efbc>
    28a0:	02000001 	.inst	0x02000001 ; undefined
    28a4:	12007891 	and	w17, w4, #0x7fffffff
    28a8:	40002404 	.inst	0x40002404 ; undefined
    28ac:	00000000 	udf	#0
    28b0:	000001a8 	udf	#424
    28b4:	00000000 	udf	#0
    28b8:	45006906 	pmullb	z6.q, z8.d, z0.d
    28bc:	0001580e 	.inst	0x0001580e ; undefined
    28c0:	70910200 	adr	x0, fffffffffff24903 <__stack_el2_top+0xffffffffbe91d903>
    28c4:	00241011 	.inst	0x00241011 ; NYI
    28c8:	00000040 	udf	#64
    28cc:	00003c00 	udf	#15360
    28d0:	00000000 	udf	#0
    28d4:	00040300 	.inst	0x00040300 ; undefined
    28d8:	006a0600 	.inst	0x006a0600 ; undefined
    28dc:	01580f46 	.inst	0x01580f46 ; undefined
    28e0:	91020000 	add	x0, x0, #0x80
    28e4:	8c120068 	.inst	0x8c120068 ; undefined
    28e8:	00400024 	.inst	0x00400024 ; undefined
    28ec:	84000000 	ld1sb	{z0.s}, p0/z, [x0, z0.s, uxtw]
    28f0:	00000000 	udf	#0
    28f4:	06000000 	.inst	0x06000000 ; undefined
    28f8:	0f4c006a 	fdot	v10.4h, v3.8b, v12.2b[0]
    28fc:	00000158 	udf	#344
    2900:	00609102 	.inst	0x00609102 ; undefined
    2904:	04100000 	mul	z0.b, p0/m, z0.b, z0.b
    2908:	33000002 	bfxil	w2, w0, #0, #1
    290c:	1c000004 	ldr	s4, 290c <GPR_FRAME_SIZE+0x280c>
    2910:	00000151 	udf	#337
    2914:	641d0063 	.inst	0x641d0063 ; undefined
    2918:	01000008 	.inst	0x01000008 ; undefined
    291c:	03320721 	.inst	0x03320721 ; undefined
    2920:	230c0000 	.inst	0x230c0000 ; undefined
    2924:	00004000 	udf	#16384
    2928:	00940000 	.inst	0x00940000 ; undefined
    292c:	00000000 	udf	#0
    2930:	9c010000 	ldr	q0, 4930 <GPR_FRAME_SIZE+0x4830>
    2934:	00000480 	udf	#1152
    2938:	74736408 	.inst	0x74736408 ; undefined
    293c:	32162100 	orr	w0, w8, #0x7fc00
    2940:	02000003 	.inst	0x02000003 ; undefined
    2944:	73085891 	.inst	0x73085891 ; undefined
    2948:	21006372 	.inst	0x21006372 ; undefined
    294c:	00033221 	.inst	0x00033221 ; undefined
    2950:	50910200 	adr	x0, fffffffffff24992 <__stack_el2_top+0xffffffffbe91d992>
    2954:	0008010c 	.inst	0x0008010c ; undefined
    2958:	2b2d2100 	adds	w0, w8, w13, uxth
    295c:	02000001 	.inst	0x02000001 ; undefined
    2960:	1e004891 	.inst	0x1e004891 ; undefined
    2964:	00000847 	udf	#2119
    2968:	32071101 	orr	w1, w8, #0x3e000000
    296c:	d0000003 	adrp	x3, 4000 <GPR_FRAME_SIZE+0x3f00>
    2970:	00400021 	.inst	0x00400021 ; undefined
    2974:	3c000000 	stur	b0, [x0]
    2978:	00000001 	udf	#1
    297c:	01000000 	.inst	0x01000000 ; undefined
    2980:	7364089c 	.inst	0x7364089c ; undefined
    2984:	1e110074 	.inst	0x1e110074 ; undefined
    2988:	00000332 	udf	#818
    298c:	7fa89103 	fmulx	s3, s8, v8.s[1]
    2990:	63727308 	.inst	0x63727308 ; undefined
    2994:	32291100 	orr	w0, w8, #0xf800000
    2998:	03000003 	.inst	0x03000003 ; undefined
    299c:	0c7fa091 	.inst	0x0c7fa091 ; undefined
    29a0:	00000801 	udf	#2049
    29a4:	012b3511 	.inst	0x012b3511 ; undefined
    29a8:	91030000 	add	x0, x0, #0xc0
    29ac:	00007f98 	udf	#32664
    29b0:	00000f3a 	udf	#3898
    29b4:	08010005 	stxrb	w1, w5, [x0]
    29b8:	0000147f 	udf	#5247
    29bc:	0001b613 	.inst	0x0001b613 ; undefined
    29c0:	05be1d00 	trn2	z0.q, z8.q, z30.q
    29c4:	00000000 	udf	#0
    29c8:	25c80000 	cmpge	p0.d, p0/z, z0.d, #8
    29cc:	00004000 	udf	#16384
    29d0:	0a200000 	bic	w0, w0, w0
    29d4:	00000000 	udf	#0
    29d8:	10d50000 	adr	x0, fffffffffffac9d8 <__stack_el2_top+0xffffffffbe9a59d8>
    29dc:	04060000 	.inst	0x04060000 ; undefined
    29e0:	00031a07 	.inst	0x00031a07 ; undefined
    29e4:	002e1100 	.inst	0x002e1100 ; NYI
    29e8:	01060000 	.inst	0x01060000 ; undefined
    29ec:	00023d06 	.inst	0x00023d06 ; undefined
    29f0:	02510300 	.inst	0x02510300 ; undefined
    29f4:	1f090000 	fmadd	s0, s0, s9, s0
    29f8:	00004d17 	udf	#19735
    29fc:	08010600 	stxrb	w1, w0, [x16]
    2a00:	0000023b 	udf	#571
    2a04:	98050206 	ldrsw	x6, ca44 <GPR_FRAME_SIZE+0xc944>
    2a08:	06000003 	.inst	0x06000003 ; undefined
    2a0c:	01360702 	.inst	0x01360702 ; undefined
    2a10:	04140000 	.inst	0x04140000 ; undefined
    2a14:	746e6905 	.inst	0x746e6905 ; undefined
    2a18:	02cf0300 	.inst	0x02cf0300 ; undefined
    2a1c:	25090000 	cmpge	p0.b, p0/z, z0.b, #9
    2a20:	00002e16 	udf	#11798
    2a24:	00691000 	.inst	0x00691000 ; undefined
    2a28:	08060000 	stxrb	w6, w0, [x0]
    2a2c:	00036b05 	.inst	0x00036b05 ; undefined
    2a30:	01240300 	.inst	0x01240300 ; undefined
    2a34:	28090000 	stnp	w0, w0, [x0, #72]
    2a38:	00008d1c 	udf	#36124
    2a3c:	07080600 	.inst	0x07080600 ; undefined
    2a40:	00000310 	udf	#784
    2a44:	00008d11 	udf	#36113
    2a48:	05080600 	.inst	0x05080600 ; undefined
    2a4c:	00000370 	udf	#880
    2a50:	00052403 	.inst	0x00052403 ; undefined
    2a54:	17340900 	b	fffffffffcd04e54 <__stack_el2_top+0xffffffffbb6fde54>
    2a58:	000000ac 	udf	#172
    2a5c:	15070806 	b	41c4a74 <GPR_FRAME_SIZE+0x41c4974>
    2a60:	03000003 	.inst	0x03000003 ; undefined
    2a64:	00000440 	udf	#1088
    2a68:	ac173509 	stnp	q9, q13, [x8, #736]
    2a6c:	08000000 	stxrb	w0, w0, [x0]
    2a70:	09050a04 	.inst	0x09050a04 ; undefined
    2a74:	000000fd 	udf	#253
    2a78:	0004bd09 	.inst	0x0004bd09 ; undefined
    2a7c:	08060a00 	stxrb	w6, w0, [x16]
    2a80:	00000041 	udf	#65
    2a84:	04b80900 	.inst	0x04b80900 ; undefined
    2a88:	070a0000 	.inst	0x070a0000 ; undefined
    2a8c:	00004108 	udf	#16648
    2a90:	b3090100 	.inst	0xb3090100 ; undefined
    2a94:	0a000004 	and	w4, w0, w0
    2a98:	00410809 	.inst	0x00410809 ; undefined
    2a9c:	09020000 	.inst	0x09020000 ; undefined
    2aa0:	00000508 	udf	#1288
    2aa4:	41080b0a 	.inst	0x41080b0a ; undefined
    2aa8:	03000000 	.inst	0x03000000 ; undefined
    2aac:	04fc0300 	add	z0.d, z24.d, z28.d
    2ab0:	0c0a0000 	.inst	0x0c0a0000 ; undefined
    2ab4:	0000bf03 	udf	#48899
    2ab8:	04071500 	.inst	0x04071500 ; undefined
    2abc:	0000002e 	udf	#46
    2ac0:	d80e030b 	prfm	plil2strm, 1eb20 <GPR_FRAME_SIZE+0x1ea20>
    2ac4:	01000004 	.inst	0x01000004 ; undefined
    2ac8:	00001489 	udf	#5257
    2acc:	0f010100 	fdot	v0.2s, v8.8b, v1.4b[0]
    2ad0:	01010000 	.inst	0x01010000 ; undefined
    2ad4:	000009c4 	udf	#2500
    2ad8:	18200102 	ldr	w2, 42af8 <GPR_FRAME_SIZE+0x429f8>
    2adc:	01030000 	.inst	0x01030000 ; undefined
    2ae0:	00000b04 	udf	#2820
    2ae4:	119f0104 	.inst	0x119f0104 ; undefined
    2ae8:	01050000 	.inst	0x01050000 ; undefined
    2aec:	000011b1 	udf	#4529
    2af0:	09d50106 	.inst	0x09d50106 ; undefined
    2af4:	01070000 	.inst	0x01070000 ; undefined
    2af8:	000009e7 	udf	#2535
    2afc:	174c0108 	b	fffffffffd302f1c <__stack_el2_top+0xffffffffbbcfbf1c>
    2b00:	01090000 	.inst	0x01090000 ; undefined
    2b04:	00000df9 	udf	#3577
    2b08:	0e0a010a 	tbl	v10.8b, {v8.16b}, v10.8b
    2b0c:	010b0000 	.inst	0x010b0000 ; undefined
    2b10:	000013c0 	udf	#5056
    2b14:	1317010c 	sbfiz	w12, w8, #9, #1
    2b18:	010d0000 	.inst	0x010d0000 ; undefined
    2b1c:	000015e2 	udf	#5602
    2b20:	1534010e 	b	4d02f58 <GPR_FRAME_SIZE+0x4d02e58>
    2b24:	010f0000 	.inst	0x010f0000 ; undefined
    2b28:	0000097f 	udf	#2431
    2b2c:	12b20110 	mov	w16, #0x6ff7ffff            	// #1878523903
    2b30:	01110000 	.inst	0x01110000 ; undefined
    2b34:	0000138f 	udf	#5007
    2b38:	14d70112 	b	35c2f80 <GPR_FRAME_SIZE+0x35c2e80>
    2b3c:	01130000 	.inst	0x01130000 ; undefined
    2b40:	00000f5e 	udf	#3934
    2b44:	17fb0114 	b	ffffffffffec2f94 <__stack_el2_top+0xffffffffbe8bbf94>
    2b48:	01150000 	.inst	0x01150000 ; undefined
    2b4c:	00000939 	udf	#2361
    2b50:	094b0116 	.inst	0x094b0116 ; undefined
    2b54:	01170000 	.inst	0x01170000 ; undefined
    2b58:	0000095d 	udf	#2397
    2b5c:	16890118 	b	fffffffffa242fbc <__stack_el2_top+0xffffffffb8c3bfbc>
    2b60:	01190000 	.inst	0x01190000 ; undefined
    2b64:	00000c30 	udf	#3120
    2b68:	0c41011a 	.inst	0x0c41011a ; undefined
    2b6c:	011b0000 	.inst	0x011b0000 ; undefined
    2b70:	00000c52 	udf	#3154
    2b74:	0c63011c 	.inst	0x0c63011c ; undefined
    2b78:	011d0000 	.inst	0x011d0000 ; undefined
    2b7c:	00000cbf 	udf	#3263
    2b80:	0b82011e 	add	w30, w8, w2, asr #0
    2b84:	011f0000 	.inst	0x011f0000 ; undefined
    2b88:	00000b94 	udf	#2964
    2b8c:	0ba60120 	.inst	0x0ba60120 ; undefined
    2b90:	01210000 	.inst	0x01210000 ; undefined
    2b94:	00000cae 	udf	#3246
    2b98:	11d30122 	.inst	0x11d30122 ; undefined
    2b9c:	01230000 	.inst	0x01230000 ; undefined
    2ba0:	000011e3 	udf	#4579
    2ba4:	11f30124 	.inst	0x11f30124 ; undefined
    2ba8:	01250000 	.inst	0x01250000 ; undefined
    2bac:	00001203 	udf	#4611
    2bb0:	0bb80126 	.inst	0x0bb80126 ; undefined
    2bb4:	01270000 	.inst	0x01270000 ; undefined
    2bb8:	00000a16 	udf	#2582
    2bbc:	0a260128 	bic	w8, w9, w6
    2bc0:	01290000 	.inst	0x01290000 ; undefined
    2bc4:	00000992 	udf	#2450
    2bc8:	1563012a 	b	58c3070 <GPR_FRAME_SIZE+0x58c2f70>
    2bcc:	012b0000 	.inst	0x012b0000 ; undefined
    2bd0:	00000ea4 	udf	#3748
    2bd4:	1499012c 	b	2643084 <GPR_FRAME_SIZE+0x2642f84>
    2bd8:	012d0000 	.inst	0x012d0000 ; undefined
    2bdc:	00001307 	udf	#4871
    2be0:	0aaa012e 	bic	w14, w9, w10, asr #0
    2be4:	012f0000 	.inst	0x012f0000 ; undefined
    2be8:	00000abb 	udf	#2747
    2bec:	17ba0130 	b	fffffffffee830ac <__stack_el2_top+0xffffffffbd87c0ac>
    2bf0:	01310000 	.inst	0x01310000 ; undefined
    2bf4:	0000118f 	udf	#4495
    2bf8:	12f70132 	.inst	0x12f70132 ; undefined
    2bfc:	01330000 	.inst	0x01330000 ; undefined
    2c00:	000012e7 	udf	#4839
    2c04:	12d70134 	.inst	0x12d70134 ; undefined
    2c08:	01350000 	.inst	0x01350000 ; undefined
    2c0c:	000012c7 	udf	#4807
    2c10:	0e530136 	.inst	0x0e530136 ; undefined
    2c14:	01370000 	.inst	0x01370000 ; undefined
    2c18:	000010f7 	udf	#4343
    2c1c:	10e10138 	adr	x24, fffffffffffc4c40 <__stack_el2_top+0xffffffffbe9bdc40>
    2c20:	01390000 	.inst	0x01390000 ; undefined
    2c24:	000010cb 	udf	#4299
    2c28:	10b5013a 	adr	x26, fffffffffff6cc4c <__stack_el2_top+0xffffffffbe965c4c>
    2c2c:	013b0000 	.inst	0x013b0000 ; undefined
    2c30:	0000109f 	udf	#4255
    2c34:	1089013c 	adr	x28, fffffffffff14c58 <__stack_el2_top+0xffffffffbe90dc58>
    2c38:	013d0000 	.inst	0x013d0000 ; undefined
    2c3c:	00001073 	udf	#4211
    2c40:	105d013e 	adr	x30, bcc64 <GPR_FRAME_SIZE+0xbcb64>
    2c44:	013f0000 	.inst	0x013f0000 ; undefined
    2c48:	0000126a 	udf	#4714
    2c4c:	169a0140 	b	fffffffffa68314c <__stack_el2_top+0xffffffffb907c14c>
    2c50:	01410000 	.inst	0x01410000 ; undefined
    2c54:	0000180a 	udf	#6154
    2c58:	09060142 	.inst	0x09060142 ; undefined
    2c5c:	01430000 	.inst	0x01430000 ; undefined
    2c60:	00000b25 	udf	#2853
    2c64:	08a20144 	.inst	0x08a20144 ; undefined
    2c68:	01450000 	.inst	0x01450000 ; undefined
    2c6c:	00000b3b 	udf	#2875
    2c70:	13260146 	.inst	0x13260146 ; undefined
    2c74:	01470000 	.inst	0x01470000 ; undefined
    2c78:	000013ea 	udf	#5098
    2c7c:	13530148 	.inst	0x13530148 ; undefined
    2c80:	01490000 	.inst	0x01490000 ; undefined
    2c84:	00000c10 	udf	#3088
    2c88:	0c20014a 	.inst	0x0c20014a ; undefined
    2c8c:	014b0000 	.inst	0x014b0000 ; undefined
    2c90:	000017aa 	udf	#6058
    2c94:	1213014c 	and	w12, w10, #0x2000
    2c98:	014d0000 	.inst	0x014d0000 ; undefined
    2c9c:	00000dd7 	udf	#3543
    2ca0:	0de8014e 	ld2	{v14.b-v15.b}[0], [x10], x8
    2ca4:	014f0000 	.inst	0x014f0000 ; undefined
    2ca8:	00001136 	udf	#4406
    2cac:	096f0150 	.inst	0x096f0150 ; undefined
    2cb0:	01510000 	.inst	0x01510000 ; undefined
    2cb4:	00000ed1 	udf	#3793
    2cb8:	0ee10152 	.inst	0x0ee10152 ; undefined
    2cbc:	01530000 	.inst	0x01530000 ; undefined
    2cc0:	00000ef1 	udf	#3825
    2cc4:	14430154 	b	10c3214 <GPR_FRAME_SIZE+0x10c3114>
    2cc8:	01550000 	.inst	0x01550000 ; undefined
    2ccc:	00001457 	udf	#5207
    2cd0:	0e3f0156 	saddl	v22.8h, v10.8b, v31.8b
    2cd4:	01570000 	.inst	0x01570000 ; undefined
    2cd8:	0000104a 	udf	#4170
    2cdc:	175b0158 	b	fffffffffd6c323c <__stack_el2_top+0xffffffffbc0bc23c>
    2ce0:	01590000 	.inst	0x01590000 ; undefined
    2ce4:	00000a6e 	udf	#2670
    2ce8:	0a83015a 	and	w26, w10, w3, asr #0
    2cec:	015b0000 	.inst	0x015b0000 ; undefined
    2cf0:	00000bda 	udf	#3034
    2cf4:	1123015c 	add	w28, w10, #0x8c0
    2cf8:	015d0000 	.inst	0x015d0000 ; undefined
    2cfc:	000017e7 	udf	#6119
    2d00:	116f015e 	add	w30, w10, #0xbc0, lsl #12
    2d04:	015f0000 	.inst	0x015f0000 ; undefined
    2d08:	0000117f 	udf	#4479
    2d0c:	08790160 	.inst	0x08790160 ; undefined
    2d10:	01610000 	.inst	0x01610000 ; undefined
    2d14:	000016f6 	udf	#5878
    2d18:	0c740162 	.inst	0x0c740162 ; undefined
    2d1c:	01630000 	.inst	0x01630000 ; undefined
    2d20:	0000173a 	udf	#5946
    2d24:	14130164 	b	4c32b4 <GPR_FRAME_SIZE+0x4c31b4>
    2d28:	01650000 	.inst	0x01650000 ; undefined
    2d2c:	0000110d 	udf	#4365
    2d30:	0c890166 	st4	{v6.8b-v9.8b}, [x11], x9
    2d34:	01670000 	.inst	0x01670000 ; undefined
    2d38:	000014c8 	udf	#5320
    2d3c:	14750168 	b	1d432dc <GPR_FRAME_SIZE+0x1d431dc>
    2d40:	01690000 	.inst	0x01690000 ; undefined
    2d44:	00001520 	udf	#5408
    2d48:	0bc7016a 	.inst	0x0bc7016a ; undefined
    2d4c:	016b0000 	.inst	0x016b0000 ; undefined
    2d50:	00001773 	udf	#6003
    2d54:	0a98016c 	and	w12, w11, w24, asr #0
    2d58:	016d0000 	.inst	0x016d0000 ; undefined
    2d5c:	00000fa9 	udf	#4009
    2d60:	11c3016e 	smax	w14, w11, #-64
    2d64:	016f0000 	.inst	0x016f0000 ; undefined
    2d68:	00000c9a 	udf	#3226
    2d6c:	154f0170 	b	53c332c <GPR_FRAME_SIZE+0x53c322c>
    2d70:	01710000 	.inst	0x01710000 ; undefined
    2d74:	00001611 	udf	#5649
    2d78:	114b0172 	add	w18, w11, #0x2c0, lsl #12
    2d7c:	01730000 	.inst	0x01730000 ; undefined
    2d80:	00001857 	udf	#6231
    2d84:	14000174 	b	3354 <GPR_FRAME_SIZE+0x3254>
    2d88:	01750000 	.inst	0x01750000 ; undefined
    2d8c:	00000eba 	udf	#3770
    2d90:	15760176 	b	5d83368 <GPR_FRAME_SIZE+0x5d83268>
    2d94:	01770000 	.inst	0x01770000 ; undefined
    2d98:	00000d36 	udf	#3382
    2d9c:	0fbf0178 	fmlal	v24.2s, v11.2h, v15.h[3]
    2da0:	01790000 	.inst	0x01790000 ; undefined
    2da4:	00001021 	udf	#4129
    2da8:	1866017a 	ldr	w26, cedd4 <GPR_FRAME_SIZE+0xcecd4>
    2dac:	017b0000 	.inst	0x017b0000 ; undefined
    2db0:	0000187e 	udf	#6270
    2db4:	1896017c 	ldr	w28, fffffffffff2ede0 <__stack_el2_top+0xffffffffbe927de0>
    2db8:	017d0000 	.inst	0x017d0000 ; undefined
    2dbc:	000018ae 	udf	#6318
    2dc0:	158d017e 	b	63433b8 <GPR_FRAME_SIZE+0x63432b8>
    2dc4:	017f0000 	.inst	0x017f0000 ; undefined
    2dc8:	000013d3 	udf	#5075
    2dcc:	0f100180 	fdot	v0.2s, v12.8b, v16.4b[0]
    2dd0:	01810000 	.inst	0x01810000 ; undefined
    2dd4:	000015ab 	udf	#5547
    2dd8:	14b10182 	b	2c433e0 <GPR_FRAME_SIZE+0x2c432e0>
    2ddc:	01830000 	.inst	0x01830000 ; undefined
    2de0:	00000f27 	udf	#3879
    2de4:	0acc0184 	and	w4, w12, w12, ror #0
    2de8:	01850000 	.inst	0x01850000 ; undefined
    2dec:	000016de 	udf	#5854
    2df0:	0a360186 	bic	w6, w12, w22
    2df4:	01870000 	.inst	0x01870000 ; undefined
    2df8:	000009b1 	udf	#2481
    2dfc:	17840188 	b	fffffffffe10341c <__stack_el2_top+0xffffffffbcafc41c>
    2e00:	01890000 	.inst	0x01890000 ; undefined
    2e04:	000015be 	udf	#5566
    2e08:	0f94018a 	fmlal	v10.2s, v12.2h, v4.h[1]
    2e0c:	018b0000 	.inst	0x018b0000 ; undefined
    2e10:	000008b9 	udf	#2233
    2e14:	1005018c 	adr	x12, ce44 <GPR_FRAME_SIZE+0xcd44>
    2e18:	018d0000 	.inst	0x018d0000 ; undefined
    2e1c:	00001258 	udf	#4696
    2e20:	133d018e 	.inst	0x133d018e ; undefined
    2e24:	018f0000 	.inst	0x018f0000 ; undefined
    2e28:	000015d0 	udf	#5584
    2e2c:	17d10190 	b	ffffffffff44346c <__stack_el2_top+0xffffffffbde3c46c>
    2e30:	01910000 	.inst	0x01910000 ; undefined
    2e34:	00001280 	udf	#4736
    2e38:	16760192 	b	fffffffff9d83480 <__stack_el2_top+0xffffffffb877c480>
    2e3c:	01930000 	.inst	0x01930000 ; undefined
    2e40:	0000165f 	udf	#5727
    2e44:	142c0194 	b	b03494 <GPR_FRAME_SIZE+0xb03394>
    2e48:	01950000 	.inst	0x01950000 ; undefined
    2e4c:	00000a4a 	udf	#2634
    2e50:	0cd60196 	ld4	{v22.8b-v25.8b}, [x12], x22
    2e54:	01970000 	.inst	0x01970000 ; undefined
    2e58:	00000cee 	udf	#3310
    2e5c:	0d060198 	.inst	0x0d060198 ; undefined
    2e60:	01990000 	.inst	0x01990000 ; undefined
    2e64:	00000d1e 	udf	#3358
    2e68:	1508019a 	b	42034d0 <GPR_FRAME_SIZE+0x42033d0>
    2e6c:	019b0000 	.inst	0x019b0000 ; undefined
    2e70:	00000d4c 	udf	#3404
    2e74:	0d64019c 	.inst	0x0d64019c ; undefined
    2e78:	019d0000 	.inst	0x019d0000 ; undefined
    2e7c:	00000d7c 	udf	#3452
    2e80:	0d94019e 	st1	{v30.b}[0], [x12], x20
    2e84:	009f0000 	.inst	0x009f0000 ; undefined
    2e88:	000b1a03 	.inst	0x000b1a03 ; undefined
    2e8c:	03a50b00 	.inst	0x03a50b00 ; undefined
    2e90:	00000109 	udf	#265
    2e94:	00093303 	.inst	0x00093303 ; undefined
    2e98:	1f030c00 	fmadd	s0, s0, s3, s3
    2e9c:	00000035 	udf	#53
    2ea0:	00045103 	.inst	0x00045103 ; undefined
    2ea4:	25040c00 	cmpge	p0.b, p3/z, z0.b, #4
    2ea8:	00000094 	udf	#148
    2eac:	000e8a03 	.inst	0x000e8a03 ; undefined
    2eb0:	10060c00 	adr	x0, f030 <GPR_FRAME_SIZE+0xef30>
    2eb4:	00000508 	udf	#1288
    2eb8:	0004e40a 	.inst	0x0004e40a ; undefined
    2ebc:	04f20300 	add	z0.d, z24.d, z18.d
    2ec0:	070c0000 	.inst	0x070c0000 ; undefined
    2ec4:	00051910 	.inst	0x00051910 ; undefined
    2ec8:	04f00a00 	addpt	z0.d, z16.d, z16.d
    2ecc:	10080000 	adr	x0, 12ecc <GPR_FRAME_SIZE+0x12dcc>
    2ed0:	4f090e0d 	.inst	0x4f090e0d ; undefined
    2ed4:	09000005 	.inst	0x09000005 ; undefined
    2ed8:	0000022f 	udf	#559
    2edc:	4f080f0d 	.inst	0x4f080f0d ; undefined
    2ee0:	00000005 	udf	#5
    2ee4:	00032709 	.inst	0x00032709 ; undefined
    2ee8:	09100d00 	.inst	0x09100d00 ; undefined
    2eec:	00000069 	udf	#105
    2ef0:	6f630c08 	.inst	0x6f630c08 ; undefined
    2ef4:	110d006c 	add	w12, w3, #0x340
    2ef8:	00006909 	udf	#26889
    2efc:	0a000c00 	and	w0, w0, w0, lsl #3
    2f00:	00000554 	udf	#1364
    2f04:	44080106 	.inst	0x44080106 ; undefined
    2f08:	03000002 	.inst	0x03000002 ; undefined
    2f0c:	000003b9 	udf	#953
    2f10:	1e03120d 	.inst	0x1e03120d ; undefined
    2f14:	08000005 	stxrb	w0, w5, [x0]
    2f18:	09140d18 	.inst	0x09140d18 ; undefined
    2f1c:	0000058b 	udf	#1419
    2f20:	0000cf09 	udf	#53001
    2f24:	08150d00 	stxrb	w21, w0, [x8]
    2f28:	0000054f 	udf	#1359
    2f2c:	011b0900 	.inst	0x011b0900 ; undefined
    2f30:	160d0000 	b	fffffffff8342f30 <__stack_el2_top+0xffffffffb6d3bf30>
    2f34:	00055b10 	.inst	0x00055b10 ; undefined
    2f38:	03000800 	.inst	0x03000800 ; undefined
    2f3c:	0000038e 	udf	#910
    2f40:	6703170d 	.inst	0x6703170d ; undefined
    2f44:	08000005 	stxrb	w0, w5, [x0]
    2f48:	01120104 	.inst	0x01120104 ; undefined
    2f4c:	000005ae 	udf	#1454
    2f50:	6c61760c 	ldnp	d12, d29, [x16, #-496]
    2f54:	01120100 	.inst	0x01120100 ; undefined
    2f58:	00000069 	udf	#105
    2f5c:	62030000 	.inst	0x62030000 ; undefined
    2f60:	0100000a 	.inst	0x0100000a ; undefined
    2f64:	05970112 	mov	z18.s, p7/z, #8
    2f68:	04080000 	smax	z0.b, p0/m, z0.b, z0.b
    2f6c:	d1011002 	sub	x2, x0, #0x44
    2f70:	0c000005 	st4	{v5.8b-v8.8b}, [x0]
    2f74:	006c6176 	.inst	0x006c6176 ; undefined
    2f78:	69011002 	stgp	x2, x4, [x0, #32]
    2f7c:	00000000 	udf	#0
    2f80:	08f40300 	.inst	0x08f40300 ; undefined
    2f84:	10020000 	adr	x0, 6f84 <GPR_FRAME_SIZE+0x6e84>
    2f88:	0005ba01 	.inst	0x0005ba01 ; undefined
    2f8c:	05d11000 	mov	z0.d, p1/z, #-128
    2f90:	04080000 	smax	z0.b, p0/m, z0.b, z0.b
    2f94:	f9011203 	str	x3, [x16, #544]
    2f98:	0c000005 	st4	{v5.8b-v8.8b}, [x0]
    2f9c:	006c6176 	.inst	0x006c6176 ; undefined
    2fa0:	69011203 	stgp	x3, x4, [x16, #32]
    2fa4:	00000000 	udf	#0
    2fa8:	146b0300 	b	1ac3ba8 <GPR_FRAME_SIZE+0x1ac3aa8>
    2fac:	12030000 	and	w0, w0, #0x20000000
    2fb0:	0005e201 	.inst	0x0005e201 ; undefined
    2fb4:	04040800 	.inst	0x04040800 ; undefined
    2fb8:	061c0112 	.inst	0x061c0112 ; undefined
    2fbc:	760c0000 	.inst	0x760c0000 ; undefined
    2fc0:	04006c61 	mls	z1.b, p3/m, z3.b, z0.b
    2fc4:	00690112 	.inst	0x00690112 ; undefined
    2fc8:	00000000 	udf	#0
    2fcc:	0008e603 	.inst	0x0008e603 ; undefined
    2fd0:	01120400 	.inst	0x01120400 ; undefined
    2fd4:	00000605 	udf	#1541
    2fd8:	12050808 	and	w8, w0, #0x38000000
    2fdc:	00063f01 	.inst	0x00063f01 ; undefined
    2fe0:	61760c00 	.inst	0x61760c00 ; undefined
    2fe4:	1205006c 	and	w12, w3, #0x8000000
    2fe8:	00008101 	udf	#33025
    2fec:	03000000 	.inst	0x03000000 ; undefined
    2ff0:	000009a5 	udf	#2469
    2ff4:	28011205 	stnp	w5, w4, [x16, #8]
    2ff8:	08000006 	stxrb	w0, w6, [x0]
    2ffc:	01100704 	.inst	0x01100704 ; undefined
    3000:	00000662 	udf	#1634
    3004:	6c61760c 	ldnp	d12, d29, [x16, #-496]
    3008:	01100700 	.inst	0x01100700 ; undefined
    300c:	00000069 	udf	#105
    3010:	9a030000 	adc	x0, x0, x3
    3014:	0700000e 	.inst	0x0700000e ; undefined
    3018:	064b0110 	.inst	0x064b0110 ; undefined
    301c:	62100000 	.inst	0x62100000 ; undefined
    3020:	16000006 	b	fffffffff8003038 <__stack_el2_top+0xffffffffb69fc038>
    3024:	00000541 	udf	#1345
    3028:	fd0d0e0a 	str	d10, [x16, #6680]
    302c:	17000000 	b	fffffffffc00302c <__stack_el2_top+0xffffffffba9fc02c>
    3030:	00000149 	udf	#329
    3034:	91101c0d 	add	x13, x0, #0x407
    3038:	18000006 	ldr	w6, 3038 <GPR_FRAME_SIZE+0x2f38>
    303c:	0000058b 	udf	#1419
    3040:	14ef0b00 	b	3bc5c40 <GPR_FRAME_SIZE+0x3bc5b40>
    3044:	4c730000 	.inst	0x4c730000 ; undefined
    3048:	0040002f 	.inst	0x0040002f ; undefined
    304c:	9c000000 	ldr	q0, 304c <GPR_FRAME_SIZE+0x2f4c>
    3050:	00000000 	udf	#0
    3054:	01000000 	.inst	0x01000000 ; undefined
    3058:	0007129c 	.inst	0x0007129c ; undefined
    305c:	006e0200 	.inst	0x006e0200 ; undefined
    3060:	b3267308 	.inst	0xb3267308 ; undefined
    3064:	02000000 	.inst	0x02000000 ; undefined
    3068:	77055891 	.inst	0x77055891 ; undefined
    306c:	620c7500 	.inst	0x620c7500 ; undefined
    3070:	02000006 	.inst	0x02000006 ; undefined
    3074:	a3046891 	.inst	0xa3046891 ; undefined
    3078:	08000013 	stxrb	w0, w19, [x0]
    307c:	07120779 	.inst	0x07120779 ; undefined
    3080:	91020000 	add	x0, x0, #0x80
    3084:	2f88127f 	.inst	0x2f88127f ; undefined
    3088:	00004000 	udf	#16384
    308c:	00400000 	.inst	0x00400000 ; undefined
    3090:	00000000 	udf	#0
    3094:	72050000 	ands	w0, w0, #0x8000000
    3098:	620d7e00 	.inst	0x620d7e00 ; undefined
    309c:	02000006 	.inst	0x02000006 ; undefined
    30a0:	88126091 	stxr	w18, w17, [x4]
    30a4:	0040002f 	.inst	0x0040002f ; undefined
    30a8:	28000000 	stnp	w0, w0, [x0]
    30ac:	00000000 	udf	#0
    30b0:	05000000 	orr	z0.s, z0.s, #0x1
    30b4:	0f7c0069 	fdot	v9.4h, v3.8b, v12.2b[3]
    30b8:	000000b3 	udf	#179
    30bc:	00709102 	.inst	0x00709102 ; undefined
    30c0:	01060000 	.inst	0x01060000 ; undefined
    30c4:	00041c02 	.inst	0x00041c02 ; undefined
    30c8:	0f3f0b00 	fdot	v0.2s, v24.8b, v31.4b[3]
    30cc:	e0650000 	st1h	{za0h.h[w12, 0]}, p0, [x0, x5, lsl #1]
    30d0:	0040002e 	.inst	0x0040002e ; undefined
    30d4:	6c000000 	stnp	d0, d0, [x0]
    30d8:	00000000 	udf	#0
    30dc:	01000000 	.inst	0x01000000 ; undefined
    30e0:	00077b9c 	.inst	0x00077b9c ; undefined
    30e4:	72690200 	.inst	0x72690200 ; undefined
    30e8:	65080071 	bfadd	z17.h, z3.h, z8.h
    30ec:	0004d82b 	.inst	0x0004d82b ; undefined
    30f0:	6c910200 	stp	d0, d0, [x16], #272
    30f4:	000e9404 	.inst	0x000e9404 ; undefined
    30f8:	09670800 	.inst	0x09670800 ; undefined
    30fc:	00000069 	udf	#105
    3100:	057c9102 	.inst	0x057c9102 ; undefined
    3104:	096b006e 	.inst	0x096b006e ; undefined
    3108:	00000069 	udf	#105
    310c:	04789102 	asr	z2.s, z8.s, #8
    3110:	00000f59 	udf	#3929
    3114:	69096c08 	stgp	x8, x27, [x0, #288]
    3118:	02000000 	.inst	0x02000000 ; undefined
    311c:	72057491 	ands	w17, w4, #0xf9ffffff
    3120:	f90c6e00 	str	x0, [x16, #6360]
    3124:	02000005 	.inst	0x02000005 ; undefined
    3128:	0b007091 	add	w17, w4, w0, lsl #28
    312c:	00000fec 	udf	#4076
    3130:	002e7457 	.inst	0x002e7457 ; NYI
    3134:	00000040 	udf	#64
    3138:	00006c00 	udf	#27648
    313c:	00000000 	udf	#0
    3140:	dd9c0100 	.inst	0xdd9c0100 ; undefined
    3144:	02000007 	.inst	0x02000007 ; undefined
    3148:	00717269 	.inst	0x00717269 ; undefined
    314c:	d82a5708 	prfm	plil1keep, 57c2c <GPR_FRAME_SIZE+0x57b2c>
    3150:	02000004 	.inst	0x02000004 ; undefined
    3154:	94046c91 	bl	11e398 <GPR_FRAME_SIZE+0x11e298>
    3158:	0800000e 	stxrb	w0, w14, [x0]
    315c:	00690959 	.inst	0x00690959 ; undefined
    3160:	91020000 	add	x0, x0, #0x80
    3164:	006e057c 	.inst	0x006e057c ; undefined
    3168:	0069095d 	.inst	0x0069095d ; undefined
    316c:	91020000 	add	x0, x0, #0x80
    3170:	0f590478 	.inst	0x0f590478 ; undefined
    3174:	5e080000 	sha1c	q0, s0, v8.4s
    3178:	00006909 	udf	#26889
    317c:	74910200 	.inst	0x74910200 ; undefined
    3180:	60007205 	.inst	0x60007205 ; undefined
    3184:	0005f90c 	.inst	0x0005f90c ; undefined
    3188:	70910200 	adr	x0, fffffffffff251cb <__stack_el2_top+0xffffffffbe91e1cb>
    318c:	0dc40b00 	ld1	{v0.b}[2], [x24], x4
    3190:	04490000 	umax	z0.h, p0/m, z0.h, z0.h
    3194:	0040002e 	.inst	0x0040002e ; undefined
    3198:	70000000 	adr	x0, 319b <GPR_FRAME_SIZE+0x309b>
    319c:	00000000 	udf	#0
    31a0:	01000000 	.inst	0x01000000 ; undefined
    31a4:	00084e9c 	.inst	0x00084e9c ; undefined
    31a8:	72690200 	.inst	0x72690200 ; undefined
    31ac:	49080071 	.inst	0x49080071 ; undefined
    31b0:	0004d824 	.inst	0x0004d824 ; undefined
    31b4:	6c910200 	stp	d0, d0, [x16], #272
    31b8:	0008eb0d 	.inst	0x0008eb0d ; undefined
    31bc:	2f490800 	mla	v0.4h, v0.4h, v9.h[4]
    31c0:	00000041 	udf	#65
    31c4:	046b9102 	asr	z2.s, z8.s, #21
    31c8:	00000e94 	udf	#3732
    31cc:	69094b08 	stgp	x8, x18, [x24, #288]
    31d0:	02000000 	.inst	0x02000000 ; undefined
    31d4:	6e057c91 	mov	v17.b[2], v4.b[15]
    31d8:	69094f00 	stgp	x0, x19, [x24, #288]
    31dc:	02000000 	.inst	0x02000000 ; undefined
    31e0:	6a047891 	ands	w17, w4, w4, lsl #30
    31e4:	08000017 	stxrb	w0, w23, [x0]
    31e8:	00690950 	.inst	0x00690950 ; undefined
    31ec:	91020000 	add	x0, x0, #0x80
    31f0:	00720574 	.inst	0x00720574 ; undefined
    31f4:	061c1052 	.inst	0x061c1052 ; undefined
    31f8:	91020000 	add	x0, x0, #0x80
    31fc:	990b0070 	stlur	w16, [x3, #176]
    3200:	3d000017 	str	b23, [x0]
    3204:	40002db4 	.inst	0x40002db4 ; undefined
    3208:	00000000 	udf	#0
    320c:	00000050 	udf	#80
    3210:	00000000 	udf	#0
    3214:	08a39c01 	.inst	0x08a39c01 ; undefined
    3218:	69020000 	stgp	x0, x0, [x0, #64]
    321c:	08007172 	stxrb	w0, w18, [x11]
    3220:	04d8223d 	orv	d29, p0, z17.d
    3224:	91020000 	add	x0, x0, #0x80
    3228:	0e94046c 	.inst	0x0e94046c ; undefined
    322c:	3f080000 	.inst	0x3f080000 ; undefined
    3230:	00006909 	udf	#26889
    3234:	7c910200 	.inst	0x7c910200 ; undefined
    3238:	43006e05 	.inst	0x43006e05 ; undefined
    323c:	00006909 	udf	#26889
    3240:	78910200 	ldursh	x0, [x16, #-240]
    3244:	74696205 	.inst	0x74696205 ; undefined
    3248:	69094400 	stgp	x0, x17, [x0, #288]
    324c:	02000000 	.inst	0x02000000 ; undefined
    3250:	0b007491 	add	w17, w4, w0, lsl #29
    3254:	00001240 	udf	#4672
    3258:	002d8c38 	.inst	0x002d8c38 ; NYI
    325c:	00000040 	udf	#64
    3260:	00002800 	udf	#10240
    3264:	00000000 	udf	#0
    3268:	cf9c0100 	.inst	0xcf9c0100 ; undefined
    326c:	02000008 	.inst	0x02000008 ; undefined
    3270:	00717269 	.inst	0x00717269 ; undefined
    3274:	d8293808 	prfm	plil1keep, 55974 <GPR_FRAME_SIZE+0x55874>
    3278:	02000004 	.inst	0x02000004 ; undefined
    327c:	0b007c91 	add	w17, w4, w0, lsl #31
    3280:	0000088b 	udf	#2187
    3284:	002d1026 	.inst	0x002d1026 ; NYI
    3288:	00000040 	udf	#64
    328c:	00007c00 	udf	#31744
    3290:	00000000 	udf	#0
    3294:	259c0100 	cmpge	p0.s, p0/z, z8.s, #-4
    3298:	02000009 	.inst	0x02000009 ; undefined
    329c:	00717269 	.inst	0x00717269 ; undefined
    32a0:	d8282608 	prfm	plil1keep, 53760 <GPR_FRAME_SIZE+0x53660>
    32a4:	02000004 	.inst	0x02000004 ; undefined
    32a8:	4d0d6c91 	.inst	0x4d0d6c91 ; undefined
    32ac:	08000005 	stxrb	w0, w5, [x0]
    32b0:	00fd3926 	.inst	0x00fd3926 ; undefined
    32b4:	91020000 	add	x0, x0, #0x80
    32b8:	0e940468 	.inst	0x0e940468 ; undefined
    32bc:	28080000 	stnp	w0, w0, [x0, #64]
    32c0:	00006909 	udf	#26889
    32c4:	7c910200 	.inst	0x7c910200 ; undefined
    32c8:	2c007205 	stnp	s5, s28, [x16]
    32cc:	00063f0e 	.inst	0x00063f0e ; undefined
    32d0:	70910200 	adr	x0, fffffffffff25313 <__stack_el2_top+0xffffffffbe91e313>
    32d4:	0fd50b00 	fmlalb	v0.8h, v24.16b, v5.b[10]
    32d8:	a0170000 	ld1b	{z0.b-z1.b}, pn8/z, [x0, x23]
    32dc:	0040002c 	.inst	0x0040002c ; undefined
    32e0:	70000000 	adr	x0, 32e3 <GPR_FRAME_SIZE+0x31e3>
    32e4:	00000000 	udf	#0
    32e8:	01000000 	.inst	0x01000000 ; undefined
    32ec:	0009969c 	.inst	0x0009969c ; undefined
    32f0:	72690200 	.inst	0x72690200 ; undefined
    32f4:	17080071 	b	fffffffffc2034b8 <__stack_el2_top+0xffffffffbabfc4b8>
    32f8:	0004d828 	.inst	0x0004d828 ; undefined
    32fc:	6c910200 	stp	d0, d0, [x16], #272
    3300:	08007602 	stxrb	w0, w2, [x16]
    3304:	07123217 	.inst	0x07123217 ; undefined
    3308:	91020000 	add	x0, x0, #0x80
    330c:	0e94046b 	.inst	0x0e94046b ; undefined
    3310:	1a080000 	adc	w0, w0, w8
    3314:	00006909 	udf	#26889
    3318:	7c910200 	.inst	0x7c910200 ; undefined
    331c:	1e006e05 	.inst	0x1e006e05 ; undefined
    3320:	00006909 	udf	#26889
    3324:	78910200 	ldursh	x0, [x16, #-240]
    3328:	74696205 	.inst	0x74696205 ; undefined
    332c:	69091f00 	stgp	x0, x7, [x24, #288]
    3330:	02000000 	.inst	0x02000000 ; undefined
    3334:	19047491 	.inst	0x19047491 ; undefined
    3338:	08000010 	stxrb	w0, w16, [x0]
    333c:	05ae0e21 	uzp2	z1.q, z17.q, z14.q
    3340:	91020000 	add	x0, x0, #0x80
    3344:	c80e0070 	stxr	w14, x16, [x3]
    3348:	08000016 	stxrb	w0, w22, [x0]
    334c:	2c000d0d 	stnp	s13, s3, [x8]
    3350:	00004000 	udf	#16384
    3354:	00a00000 	.inst	0x00a00000 ; undefined
    3358:	00000000 	udf	#0
    335c:	9c010000 	ldr	q0, 535c <GPR_FRAME_SIZE+0x525c>
    3360:	000009f1 	udf	#2545
    3364:	000e940d 	.inst	0x000e940d ; undefined
    3368:	2a0d0800 	orr	w0, w0, w13, lsl #2
    336c:	00000069 	udf	#105
    3370:	044c9102 	srshr	z2.s, p4/m, z2.s, #24
    3374:	0000136a 	udf	#4970
    3378:	d10c0f08 	sub	x8, x24, #0x303
    337c:	02000005 	.inst	0x02000005 ; undefined
    3380:	67047091 	.inst	0x67047091 ; undefined
    3384:	08000011 	stxrb	w0, w17, [x0]
    3388:	00690910 	.inst	0x00690910 ; undefined
    338c:	91020000 	add	x0, x0, #0x80
    3390:	08fe047c 	.inst	0x08fe047c ; undefined
    3394:	12080000 	and	w0, w0, #0x1000000
    3398:	00006909 	udf	#26889
    339c:	78910200 	ldursh	x0, [x16, #-240]
    33a0:	0e180700 	.inst	0x0e180700 ; undefined
    33a4:	2f070000 	.inst	0x2f070000 ; undefined
    33a8:	40002bc8 	.inst	0x40002bc8 ; undefined
    33ac:	00000000 	udf	#0
    33b0:	00000038 	udf	#56
    33b4:	00000000 	udf	#0
    33b8:	0a359c01 	.inst	0x0a359c01 ; undefined
    33bc:	72020000 	ands	w0, w0, #0x40000000
    33c0:	012f0700 	.inst	0x012f0700 ; undefined
    33c4:	00000a35 	udf	#2613
    33c8:	02789102 	.inst	0x02789102 ; undefined
    33cc:	2f070076 	.inst	0x2f070076 ; undefined
    33d0:	00071201 	.inst	0x00071201 ; undefined
    33d4:	77910200 	.inst	0x77910200 ; undefined
    33d8:	0009f903 	.inst	0x0009f903 ; undefined
    33dc:	012f0700 	.inst	0x012f0700 ; undefined
    33e0:	00000069 	udf	#105
    33e4:	06620a00 	.inst	0x06620a00 ; undefined
    33e8:	630f0000 	.inst	0x630f0000 ; undefined
    33ec:	0700000e 	.inst	0x0700000e ; undefined
    33f0:	0007122a 	.inst	0x0007122a ; undefined
    33f4:	002ba400 	.inst	0x002ba400 ; NYI
    33f8:	00000040 	udf	#64
    33fc:	00002400 	udf	#9216
    3400:	00000000 	udf	#0
    3404:	759c0100 	.inst	0x759c0100 ; undefined
    3408:	0200000a 	.inst	0x0200000a ; undefined
    340c:	2a070072 	orr	w18, w3, w7
    3410:	00066e01 	.inst	0x00066e01 ; undefined
    3414:	78910200 	ldursh	x0, [x16, #-240]
    3418:	0009f903 	.inst	0x0009f903 ; undefined
    341c:	012a0700 	.inst	0x012a0700 ; undefined
    3420:	00000075 	udf	#117
    3424:	09ff0700 	.inst	0x09ff0700 ; undefined
    3428:	15070000 	b	41c3428 <GPR_FRAME_SIZE+0x41c3328>
    342c:	40002b70 	.inst	0x40002b70 ; undefined
    3430:	00000000 	udf	#0
    3434:	00000034 	udf	#52
    3438:	00000000 	udf	#0
    343c:	0aad9c01 	.inst	0x0aad9c01 ; undefined
    3440:	6e020000 	ext	v0.16b, v0.16b, v2.16b, #0
    3444:	01150700 	.inst	0x01150700 ; undefined
    3448:	000000b3 	udf	#179
    344c:	02789102 	.inst	0x02789102 ; undefined
    3450:	15070076 	b	41c3628 <GPR_FRAME_SIZE+0x41c3528>
    3454:	00066201 	.inst	0x00066201 ; undefined
    3458:	70910200 	adr	x0, fffffffffff2549b <__stack_el2_top+0xffffffffbe91e49b>
    345c:	091d0f00 	.inst	0x091d0f00 ; undefined
    3460:	12070000 	and	w0, w0, #0x2000000
    3464:	00000662 	udf	#1634
    3468:	40002b48 	.inst	0x40002b48 ; undefined
    346c:	00000000 	udf	#0
    3470:	00000028 	udf	#40
    3474:	00000000 	udf	#0
    3478:	0adc9c01 	.inst	0x0adc9c01 ; undefined
    347c:	6e020000 	ext	v0.16b, v0.16b, v2.16b, #0
    3480:	01120700 	.inst	0x01120700 ; undefined
    3484:	000000b3 	udf	#179
    3488:	00789102 	.inst	0x00789102 ; undefined
    348c:	0012230e 	.inst	0x0012230e ; undefined
    3490:	14100600 	b	404c90 <GPR_FRAME_SIZE+0x404b90>
    3494:	40002ab4 	.inst	0x40002ab4 ; undefined
    3498:	00000000 	udf	#0
    349c:	00000094 	udf	#148
    34a0:	00000000 	udf	#0
    34a4:	0b179c01 	.inst	0x0b179c01 ; undefined
    34a8:	6e020000 	ext	v0.16b, v0.16b, v2.16b, #0
    34ac:	38100600 	strb	w0, [x16], #-256
    34b0:	00000069 	udf	#105
    34b4:	025c9102 	.inst	0x025c9102 ; undefined
    34b8:	00746962 	.inst	0x00746962 ; undefined
    34bc:	69421006 	ldpsw	x6, x4, [x0, #16]
    34c0:	02000000 	.inst	0x02000000 ; undefined
    34c4:	07005891 	.inst	0x07005891 ; undefined
    34c8:	00000ae5 	udf	#2789
    34cc:	2a843c05 	orr	w5, w0, w4, asr #15
    34d0:	00004000 	udf	#16384
    34d4:	00300000 	.inst	0x00300000 ; NYI
    34d8:	00000000 	udf	#0
    34dc:	9c010000 	ldr	q0, 54dc <GPR_FRAME_SIZE+0x53dc>
    34e0:	00000b5b 	udf	#2907
    34e4:	05007202 	orr	z2.s, z2.s, #0xfffc0007
    34e8:	0b5b013c 	add	w28, w9, w27, lsr #0
    34ec:	91020000 	add	x0, x0, #0x80
    34f0:	00760278 	.inst	0x00760278 ; undefined
    34f4:	41013c05 	.inst	0x41013c05 ; undefined
    34f8:	02000000 	.inst	0x02000000 ; undefined
    34fc:	f9037791 	str	x17, [x28, #1768]
    3500:	05000009 	orr	z9.s, z9.s, #0x1
    3504:	0081013c 	.inst	0x0081013c ; undefined
    3508:	0a000000 	and	w0, w0, w0
    350c:	0000063f 	udf	#1599
    3510:	00137007 	.inst	0x00137007 ; undefined
    3514:	4c370500 	.inst	0x4c370500 ; undefined
    3518:	0040002a 	.inst	0x0040002a ; undefined
    351c:	38000000 	sturb	w0, [x0]
    3520:	00000000 	udf	#0
    3524:	01000000 	.inst	0x01000000 ; undefined
    3528:	000ba49c 	.inst	0x000ba49c ; undefined
    352c:	00720200 	.inst	0x00720200 ; undefined
    3530:	5b013705 	.inst	0x5b013705 ; undefined
    3534:	0200000b 	.inst	0x0200000b ; undefined
    3538:	76027891 	.inst	0x76027891 ; undefined
    353c:	01370500 	.inst	0x01370500 ; undefined
    3540:	00000041 	udf	#65
    3544:	03779102 	.inst	0x03779102 ; undefined
    3548:	000009f9 	udf	#2553
    354c:	81013705 	.inst	0x81013705 ; undefined
    3550:	00000000 	udf	#0
    3554:	000f7507 	.inst	0x000f7507 ; undefined
    3558:	14320500 	b	c84958 <GPR_FRAME_SIZE+0xc84858>
    355c:	0040002a 	.inst	0x0040002a ; undefined
    3560:	38000000 	sturb	w0, [x0]
    3564:	00000000 	udf	#0
    3568:	01000000 	.inst	0x01000000 ; undefined
    356c:	000be89c 	.inst	0x000be89c ; undefined
    3570:	00720200 	.inst	0x00720200 ; undefined
    3574:	5b013205 	.inst	0x5b013205 ; undefined
    3578:	0200000b 	.inst	0x0200000b ; undefined
    357c:	76027891 	.inst	0x76027891 ; undefined
    3580:	01320500 	.inst	0x01320500 ; undefined
    3584:	00000041 	udf	#65
    3588:	03779102 	.inst	0x03779102 ; undefined
    358c:	000009f9 	udf	#2553
    3590:	81013205 	.inst	0x81013205 ; undefined
    3594:	00000000 	udf	#0
    3598:	000b5107 	.inst	0x000b5107 ; undefined
    359c:	dc2d0500 	.inst	0xdc2d0500 ; undefined
    35a0:	00400029 	.inst	0x00400029 ; undefined
    35a4:	38000000 	sturb	w0, [x0]
    35a8:	00000000 	udf	#0
    35ac:	01000000 	.inst	0x01000000 ; undefined
    35b0:	000c2c9c 	.inst	0x000c2c9c ; undefined
    35b4:	00720200 	.inst	0x00720200 ; undefined
    35b8:	5b012d05 	.inst	0x5b012d05 ; undefined
    35bc:	0200000b 	.inst	0x0200000b ; undefined
    35c0:	76027891 	.inst	0x76027891 ; undefined
    35c4:	012d0500 	.inst	0x012d0500 ; undefined
    35c8:	00000712 	udf	#1810
    35cc:	03779102 	.inst	0x03779102 ; undefined
    35d0:	000009f9 	udf	#2553
    35d4:	81012d05 	.inst	0x81012d05 ; undefined
    35d8:	00000000 	udf	#0
    35dc:	00162507 	.inst	0x00162507 ; undefined
    35e0:	a4280500 	ld1rob	{z0.b}, p1/z, [x8, x8]
    35e4:	00400029 	.inst	0x00400029 ; undefined
    35e8:	38000000 	sturb	w0, [x0]
    35ec:	00000000 	udf	#0
    35f0:	01000000 	.inst	0x01000000 ; undefined
    35f4:	000c709c 	.inst	0x000c709c ; undefined
    35f8:	00720200 	.inst	0x00720200 ; undefined
    35fc:	5b012805 	.inst	0x5b012805 ; undefined
    3600:	0200000b 	.inst	0x0200000b ; undefined
    3604:	76027891 	.inst	0x76027891 ; undefined
    3608:	01280500 	.inst	0x01280500 ; undefined
    360c:	00000041 	udf	#65
    3610:	03779102 	.inst	0x03779102 ; undefined
    3614:	000009f9 	udf	#2553
    3618:	81012805 	.inst	0x81012805 ; undefined
    361c:	00000000 	udf	#0
    3620:	0008cd07 	.inst	0x0008cd07 ; undefined
    3624:	70180500 	adr	x0, 336c7 <GPR_FRAME_SIZE+0x335c7>
    3628:	00400029 	.inst	0x00400029 ; undefined
    362c:	34000000 	cbz	w0, 362c <GPR_FRAME_SIZE+0x352c>
    3630:	00000000 	udf	#0
    3634:	01000000 	.inst	0x01000000 ; undefined
    3638:	000ca89c 	.inst	0x000ca89c ; undefined
    363c:	006e0200 	.inst	0x006e0200 ; undefined
    3640:	b3011805 	.inst	0xb3011805 ; undefined
    3644:	02000000 	.inst	0x02000000 ; undefined
    3648:	76027891 	.inst	0x76027891 ; undefined
    364c:	01180500 	.inst	0x01180500 ; undefined
    3650:	0000063f 	udf	#1599
    3654:	00709102 	.inst	0x00709102 ; undefined
    3658:	000bf30e 	.inst	0x000bf30e ; undefined
    365c:	14280400 	b	a0465c <GPR_FRAME_SIZE+0xa0455c>
    3660:	400028c0 	.inst	0x400028c0 ; undefined
    3664:	00000000 	udf	#0
    3668:	000000b0 	udf	#176
    366c:	00000000 	udf	#0
    3670:	0d019c01 	.inst	0x0d019c01 ; undefined
    3674:	72020000 	ands	w0, w0, #0x40000000
    3678:	25290400 	whilelt	p0.b, w0, w9
    367c:	00000d01 	udf	#3329
    3680:	0d589102 	.inst	0x0d589102 ; undefined
    3684:	0000176a 	udf	#5994
    3688:	b32f2904 	.inst	0xb32f2904 ; undefined
    368c:	02000000 	.inst	0x02000000 ; undefined
    3690:	eb0d5091 	subs	x17, x4, x13, lsl #20
    3694:	04000008 	add	z8.b, p0/m, z8.b, z0.b
    3698:	00413f29 	.inst	0x00413f29 ; undefined
    369c:	91020000 	add	x0, x0, #0x80
    36a0:	0bed044f 	.inst	0x0bed044f ; undefined
    36a4:	2d040000 	stp	s0, s0, [x0, #32]
    36a8:	00006909 	udf	#26889
    36ac:	7c910200 	.inst	0x7c910200 ; undefined
    36b0:	061c0a00 	.inst	0x061c0a00 ; undefined
    36b4:	96070000 	bl	fffffffff81c36b4 <__stack_el2_top+0xffffffffb6bbc6b4>
    36b8:	04000012 	add	z18.b, p0/m, z18.b, z0.b
    36bc:	00288c19 	.inst	0x00288c19 ; NYI
    36c0:	00000040 	udf	#64
    36c4:	00003400 	udf	#13312
    36c8:	00000000 	udf	#0
    36cc:	3e9c0100 	.inst	0x3e9c0100 ; undefined
    36d0:	0200000d 	.inst	0x0200000d ; undefined
    36d4:	1904006e 	stlurb	w14, [x3, #64]
    36d8:	0000b301 	udf	#45825
    36dc:	78910200 	ldursh	x0, [x16, #-240]
    36e0:	04007602 	mls	z2.b, p5/m, z16.b, z0.b
    36e4:	061c0119 	.inst	0x061c0119 ; undefined
    36e8:	91020000 	add	x0, x0, #0x80
    36ec:	440f0070 	.inst	0x440f0070 ; undefined
    36f0:	04000016 	add	z22.b, p0/m, z22.b, z0.b
    36f4:	00061c14 	.inst	0x00061c14 ; undefined
    36f8:	00286400 	.inst	0x00286400 ; NYI
    36fc:	00000040 	udf	#64
    3700:	00002800 	udf	#10240
    3704:	00000000 	udf	#0
    3708:	6d9c0100 	stp	d0, d0, [x8, #448]!
    370c:	0200000d 	.inst	0x0200000d ; undefined
    3710:	1404006e 	b	1038c8 <GPR_FRAME_SIZE+0x1037c8>
    3714:	0000b301 	udf	#45825
    3718:	78910200 	ldursh	x0, [x16, #-240]
    371c:	0dac0e00 	st2	{v0.b-v1.b}[3], [x16], x12
    3720:	26030000 	.inst	0x26030000 ; undefined
    3724:	00275414 	.inst	0x00275414 ; NYI
    3728:	00000040 	udf	#64
    372c:	00011000 	.inst	0x00011000 ; undefined
    3730:	00000000 	udf	#0
    3734:	c79c0100 	.inst	0xc79c0100 ; undefined
    3738:	0200000d 	.inst	0x0200000d ; undefined
    373c:	26030072 	.inst	0x26030072 ; undefined
    3740:	000dc74a 	.inst	0x000dc74a ; undefined
    3744:	b8910300 	ldursw	x0, [x24, #-240]
    3748:	0f590d7f 	.inst	0x0f590d7f ; undefined
    374c:	27030000 	.inst	0x27030000 ; undefined
    3750:	0000b315 	udf	#45845
    3754:	b0910300 	adrp	x0, ffffffff22064000 <__stack_el2_top+0xfffffffee0a5d000>
    3758:	0076027f 	.inst	0x0076027f ; undefined
    375c:	41212703 	.inst	0x41212703 ; undefined
    3760:	03000000 	.inst	0x03000000 ; undefined
    3764:	047faf91 	adr	z17.d, [z28.d, z31.d, uxtw #3]
    3768:	00000bed 	udf	#3053
    376c:	69092c03 	stgp	x3, x11, [x0, #288]
    3770:	02000000 	.inst	0x02000000 ; undefined
    3774:	0a007c91 	and	w17, w4, w0, lsl #31
    3778:	000005f9 	udf	#1529
    377c:	0016b107 	.inst	0x0016b107 ; undefined
    3780:	20180300 	.inst	0x20180300 ; undefined
    3784:	00400027 	.inst	0x00400027 ; undefined
    3788:	34000000 	cbz	w0, 3788 <GPR_FRAME_SIZE+0x3688>
    378c:	00000000 	udf	#0
    3790:	01000000 	.inst	0x01000000 ; undefined
    3794:	000e049c 	.inst	0x000e049c ; undefined
    3798:	006e0200 	.inst	0x006e0200 ; undefined
    379c:	b3011803 	.inst	0xb3011803 ; undefined
    37a0:	02000000 	.inst	0x02000000 ; undefined
    37a4:	76027891 	.inst	0x76027891 ; undefined
    37a8:	01180300 	.inst	0x01180300 ; undefined
    37ac:	000005f9 	udf	#1529
    37b0:	00709102 	.inst	0x00709102 ; undefined
    37b4:	0013aa0f 	.inst	0x0013aa0f ; undefined
    37b8:	f9140300 	str	x0, [x24, #10240]
    37bc:	f8000005 	stur	x5, [x0]
    37c0:	00400026 	.inst	0x00400026 ; undefined
    37c4:	28000000 	stnp	w0, w0, [x0]
    37c8:	00000000 	udf	#0
    37cc:	01000000 	.inst	0x01000000 ; undefined
    37d0:	000e339c 	.inst	0x000e339c ; undefined
    37d4:	006e0200 	.inst	0x006e0200 ; undefined
    37d8:	b3011403 	.inst	0xb3011403 ; undefined
    37dc:	02000000 	.inst	0x02000000 ; undefined
    37e0:	0f007891 	.inst	0x0f007891 ; undefined
    37e4:	00001831 	udf	#6193
    37e8:	00416d02 	.inst	0x00416d02 ; undefined
    37ec:	26d80000 	.inst	0x26d80000 ; undefined
    37f0:	00004000 	udf	#16384
    37f4:	00200000 	.inst	0x00200000 ; NYI
    37f8:	00000000 	udf	#0
    37fc:	9c010000 	ldr	q0, 57fc <GPR_FRAME_SIZE+0x56fc>
    3800:	00000e6e 	udf	#3694
    3804:	02007202 	.inst	0x02007202 ; undefined
    3808:	05dd016d 	mov	z13.d, p13/z, #11
    380c:	91020000 	add	x0, x0, #0x80
    3810:	09f90378 	.inst	0x09f90378 ; undefined
    3814:	6d020000 	stp	d0, d0, [x0, #32]
    3818:	00007501 	udf	#29953
    381c:	0a190000 	and	w0, w0, w25
    3820:	02000017 	.inst	0x02000017 ; undefined
    3824:	05d10112 	mov	z18.d, p1/z, #8
    3828:	26c80000 	.inst	0x26c80000 ; undefined
    382c:	00004000 	udf	#16384
    3830:	00100000 	.inst	0x00100000 ; undefined
    3834:	00000000 	udf	#0
    3838:	9c010000 	ldr	q0, 5838 <GPR_FRAME_SIZE+0x5738>
    383c:	0017200e 	.inst	0x0017200e ; undefined
    3840:	14230100 	b	8c3c40 <GPR_FRAME_SIZE+0x8c3b40>
    3844:	40002624 	.inst	0x40002624 ; undefined
    3848:	00000000 	udf	#0
    384c:	000000a4 	udf	#164
    3850:	00000000 	udf	#0
    3854:	0ed49c01 	.inst	0x0ed49c01 ; undefined
    3858:	72020000 	ands	w0, w0, #0x40000000
    385c:	4e230100 	saddl2	v0.8h, v8.16b, v3.16b
    3860:	00000ed4 	udf	#3796
    3864:	02589102 	.inst	0x02589102 ; undefined
    3868:	00746962 	.inst	0x00746962 ; undefined
    386c:	69582301 	ldpsw	x1, x8, [x24, #192]
    3870:	02000000 	.inst	0x02000000 ; undefined
    3874:	76025491 	.inst	0x76025491 ; undefined
    3878:	62230100 	.inst	0x62230100 ; undefined
    387c:	00000712 	udf	#1810
    3880:	00539102 	.inst	0x00539102 ; undefined
    3884:	0005ae0a 	.inst	0x0005ae0a ; undefined
    3888:	10310700 	adr	x0, 65968 <GPR_FRAME_SIZE+0x65868>
    388c:	18010000 	ldr	w0, 588c <GPR_FRAME_SIZE+0x578c>
    3890:	400025f0 	.inst	0x400025f0 ; undefined
    3894:	00000000 	udf	#0
    3898:	00000034 	udf	#52
    389c:	00000000 	udf	#0
    38a0:	0f119c01 	sqrshrn	v1.4h, v0.4s, #15
    38a4:	6e020000 	ext	v0.16b, v0.16b, v2.16b, #0
    38a8:	01180100 	.inst	0x01180100 ; undefined
    38ac:	000000b3 	udf	#179
    38b0:	02789102 	.inst	0x02789102 ; undefined
    38b4:	18010076 	ldr	w22, 58c0 <GPR_FRAME_SIZE+0x57c0>
    38b8:	0005ae01 	.inst	0x0005ae01 ; undefined
    38bc:	70910200 	adr	x0, fffffffffff258ff <__stack_el2_top+0xffffffffbe91e8ff>
    38c0:	15f91a00 	b	7e4a0c0 <GPR_FRAME_SIZE+0x7e49fc0>
    38c4:	14010000 	b	438c4 <GPR_FRAME_SIZE+0x437c4>
    38c8:	0005ae01 	.inst	0x0005ae01 ; undefined
    38cc:	0025c800 	.inst	0x0025c800 ; NYI
    38d0:	00000040 	udf	#64
    38d4:	00002800 	udf	#10240
    38d8:	00000000 	udf	#0
    38dc:	029c0100 	.inst	0x029c0100 ; undefined
    38e0:	1401006e 	b	43a98 <GPR_FRAME_SIZE+0x43998>
    38e4:	0000b301 	udf	#45825
    38e8:	78910200 	ldursh	x0, [x16, #-240]
    38ec:	0c190000 	.inst	0x0c190000 ; undefined
    38f0:	00050000 	.inst	0x00050000 ; undefined
    38f4:	163d0801 	b	fffffffff8f458f8 <__stack_el2_top+0xffffffffb793e8f8>
    38f8:	b6100000 	tbz	x0, #34, 38f8 <GPR_FRAME_SIZE+0x37f8>
    38fc:	1d000001 	.inst	0x1d000001 ; undefined
    3900:	000006b1 	udf	#1713
    3904:	00000000 	udf	#0
    3908:	40002fe8 	.inst	0x40002fe8 ; undefined
    390c:	00000000 	udf	#0
    3910:	00000830 	udf	#2096
    3914:	00000000 	udf	#0
    3918:	00001345 	udf	#4933
    391c:	1a070406 	.inst	0x1a070406 ; undefined
    3920:	11000003 	add	w3, w0, #0x0
    3924:	0000002e 	udf	#46
    3928:	3d060106 	str	b6, [x8, #384]
    392c:	02000002 	.inst	0x02000002 ; undefined
    3930:	00000251 	udf	#593
    3934:	4d171f0d 	.inst	0x4d171f0d ; undefined
    3938:	06000000 	.inst	0x06000000 ; undefined
    393c:	023b0801 	.inst	0x023b0801 ; undefined
    3940:	02060000 	.inst	0x02060000 ; undefined
    3944:	00039805 	.inst	0x00039805 ; undefined
    3948:	02910200 	.inst	0x02910200 ; undefined
    394c:	220d0000 	.inst	0x220d0000 ; undefined
    3950:	00006718 	udf	#26392
    3954:	07020600 	.inst	0x07020600 ; undefined
    3958:	00000136 	udf	#310
    395c:	69050412 	stgp	x18, x1, [x0, #160]
    3960:	0200746e 	.inst	0x0200746e ; undefined
    3964:	000002cf 	udf	#719
    3968:	2e16250d 	.inst	0x2e16250d ; undefined
    396c:	0a000000 	and	w0, w0, w0
    3970:	00000075 	udf	#117
    3974:	6b050806 	subs	w6, w0, w5, lsl #2
    3978:	02000003 	.inst	0x02000003 ; undefined
    397c:	00000124 	udf	#292
    3980:	991c280d 	.inst	0x991c280d ; undefined
    3984:	06000000 	.inst	0x06000000 ; undefined
    3988:	03100708 	.inst	0x03100708 ; undefined
    398c:	08060000 	stxrb	w6, w0, [x0]
    3990:	00037005 	.inst	0x00037005 ; undefined
    3994:	05240200 	ext	z0.b, z0.b, z16.b, #32
    3998:	340d0000 	cbz	w0, 1d998 <GPR_FRAME_SIZE+0x1d898>
    399c:	0000b817 	udf	#47127
    39a0:	00a70a00 	.inst	0x00a70a00 ; undefined
    39a4:	08060000 	stxrb	w6, w0, [x0]
    39a8:	00031507 	.inst	0x00031507 ; undefined
    39ac:	04071300 	.inst	0x04071300 ; undefined
    39b0:	0000002e 	udf	#46
    39b4:	e60e050e 	.inst	0xe60e050e ; undefined
    39b8:	0c000000 	st4	{v0.8b-v3.8b}, [x0]
    39bc:	00000422 	udf	#1058
    39c0:	01960c00 	.inst	0x01960c00 ; undefined
    39c4:	0c010000 	.inst	0x0c010000 ; undefined
    39c8:	0000042c 	udf	#1068
    39cc:	04360c02 	.inst	0x04360c02 ; undefined
    39d0:	00030000 	.inst	0x00030000 ; undefined
    39d4:	00027b02 	.inst	0x00027b02 ; undefined
    39d8:	030a0e00 	.inst	0x030a0e00 ; undefined
    39dc:	000000bf 	udf	#191
    39e0:	0000e60a 	udf	#58890
    39e4:	09330200 	.inst	0x09330200 ; undefined
    39e8:	030f0000 	.inst	0x030f0000 ; undefined
    39ec:	0000351f 	udf	#13599
    39f0:	0e8a0200 	.inst	0x0e8a0200 ; undefined
    39f4:	060f0000 	.inst	0x060f0000 ; undefined
    39f8:	00010f10 	.inst	0x00010f10 ; undefined
    39fc:	00f70900 	.inst	0x00f70900 ; undefined
    3a00:	01070000 	.inst	0x01070000 ; undefined
    3a04:	00012713 	.inst	0x00012713 ; undefined
    3a08:	61760800 	.inst	0x61760800 ; undefined
    3a0c:	1301006c 	sbfiz	w12, w3, #31, #1
    3a10:	00000075 	udf	#117
    3a14:	1ade0200 	.inst	0x1ade0200 ; undefined
    3a18:	13010000 	sbfiz	w0, w0, #31, #1
    3a1c:	00011401 	.inst	0x00011401 ; undefined
    3a20:	12020700 	and	w0, w24, #0xc0000000
    3a24:	00000146 	udf	#326
    3a28:	6c617608 	ldnp	d8, d29, [x16, #-496]
    3a2c:	75120200 	.inst	0x75120200 ; undefined
    3a30:	00000000 	udf	#0
    3a34:	001b7e02 	.inst	0x001b7e02 ; undefined
    3a38:	01120200 	.inst	0x01120200 ; undefined
    3a3c:	00000133 	udf	#307
    3a40:	65120307 	bfadd	z7.h, z24.h, z18.h
    3a44:	08000001 	stxrb	w0, w1, [x0]
    3a48:	006c6176 	.inst	0x006c6176 ; undefined
    3a4c:	00751203 	.inst	0x00751203 ; undefined
    3a50:	02000000 	.inst	0x02000000 ; undefined
    3a54:	00001bcf 	udf	#7119
    3a58:	52011203 	eor	w3, w16, #0x8000000f
    3a5c:	07000001 	.inst	0x07000001 ; undefined
    3a60:	01841204 	.inst	0x01841204 ; undefined
    3a64:	76080000 	.inst	0x76080000 ; undefined
    3a68:	04006c61 	mls	z1.b, p3/m, z3.b, z0.b
    3a6c:	00007512 	udf	#29970
    3a70:	72020000 	ands	w0, w0, #0x40000000
    3a74:	04000019 	add	z25.b, p0/m, z25.b, z0.b
    3a78:	01710112 	.inst	0x01710112 ; undefined
    3a7c:	05070000 	.inst	0x05070000 ; undefined
    3a80:	0001a312 	.inst	0x0001a312 ; undefined
    3a84:	61760800 	.inst	0x61760800 ; undefined
    3a88:	1205006c 	and	w12, w3, #0x8000000
    3a8c:	00000075 	udf	#117
    3a90:	18d10200 	ldr	w0, fffffffffffa5ad0 <__stack_el2_top+0xffffffffbe99ead0>
    3a94:	12050000 	and	w0, w0, #0x8000000
    3a98:	00019001 	.inst	0x00019001 ; undefined
    3a9c:	12060700 	and	w0, w24, #0xc000000
    3aa0:	000001c2 	udf	#450
    3aa4:	6c617608 	ldnp	d8, d29, [x16, #-496]
    3aa8:	75120600 	.inst	0x75120600 ; undefined
    3aac:	00000000 	udf	#0
    3ab0:	001b5a02 	.inst	0x001b5a02 ; undefined
    3ab4:	01120600 	.inst	0x01120600 ; undefined
    3ab8:	000001af 	udf	#431
    3abc:	e1120707 	.inst	0xe1120707 ; undefined
    3ac0:	08000001 	stxrb	w0, w1, [x0]
    3ac4:	006c6176 	.inst	0x006c6176 ; undefined
    3ac8:	00751207 	.inst	0x00751207 ; undefined
    3acc:	02000000 	.inst	0x02000000 ; undefined
    3ad0:	00001b26 	udf	#6950
    3ad4:	ce011207 	eor3	v7.16b, v16.16b, v1.16b, v4.16b
    3ad8:	07000001 	.inst	0x07000001 ; undefined
    3adc:	02001208 	.inst	0x02001208 ; undefined
    3ae0:	76080000 	.inst	0x76080000 ; undefined
    3ae4:	08006c61 	stxrb	w0, w1, [x3]
    3ae8:	00007512 	udf	#29970
    3aec:	94020000 	bl	83aec <GPR_FRAME_SIZE+0x839ec>
    3af0:	08000019 	stxrb	w0, w25, [x0]
    3af4:	01ed0112 	.inst	0x01ed0112 ; undefined
    3af8:	09070000 	.inst	0x09070000 ; undefined
    3afc:	00021f12 	.inst	0x00021f12 ; undefined
    3b00:	61760800 	.inst	0x61760800 ; undefined
    3b04:	1209006c 	and	w12, w3, #0x800000
    3b08:	00000075 	udf	#117
    3b0c:	19cd0200 	ldapursb	w0, [x16, #208]
    3b10:	12090000 	and	w0, w0, #0x800000
    3b14:	00020c01 	.inst	0x00020c01 ; undefined
    3b18:	021f0a00 	.inst	0x021f0a00 ; undefined
    3b1c:	0a070000 	and	w0, w0, w7
    3b20:	00024312 	.inst	0x00024312 ; undefined
    3b24:	61760800 	.inst	0x61760800 ; undefined
    3b28:	120a006c 	and	w12, w3, #0x400000
    3b2c:	00000075 	udf	#117
    3b30:	1ab70200 	.inst	0x1ab70200 ; undefined
    3b34:	120a0000 	and	w0, w0, #0x400000
    3b38:	00023001 	.inst	0x00023001 ; undefined
    3b3c:	02430a00 	.inst	0x02430a00 ; undefined
    3b40:	0b070000 	add	w0, w0, w7
    3b44:	00026711 	.inst	0x00026711 ; undefined
    3b48:	61760800 	.inst	0x61760800 ; undefined
    3b4c:	110b006c 	add	w12, w3, #0x2c0
    3b50:	00000075 	udf	#117
    3b54:	1bf20200 	.inst	0x1bf20200 ; undefined
    3b58:	110b0000 	add	w0, w0, #0x2c0
    3b5c:	00025401 	.inst	0x00025401 ; undefined
    3b60:	00b31400 	.inst	0x00b31400 ; undefined
    3b64:	02830000 	.inst	0x02830000 ; undefined
    3b68:	b8150000 	stur	w0, [x0, #-176]
    3b6c:	03000000 	.inst	0x03000000 ; undefined
    3b70:	02730a00 	.inst	0x02730a00 ; undefined
    3b74:	1a040000 	adc	w0, w0, w4
    3b78:	0900001b 	.inst	0x0900001b ; undefined
    3b7c:	00028316 	.inst	0x00028316 ; undefined
    3b80:	e8030900 	.inst	0xe8030900 ; undefined
    3b84:	00400052 	.inst	0x00400052 ; undefined
    3b88:	16000000 	b	fffffffff8003b88 <__stack_el2_top+0xffffffffb69fcb88>
    3b8c:	0000051a 	udf	#1306
    3b90:	f906640c 	str	x12, [x0, #3272]
    3b94:	a4000002 	ld1rqb	{z2.b}, p0/z, [x0, x0]
    3b98:	00400037 	.inst	0x00400037 ; undefined
    3b9c:	74000000 	.inst	0x74000000 ; undefined
    3ba0:	00000000 	udf	#0
    3ba4:	01000000 	.inst	0x01000000 ; undefined
    3ba8:	0002f99c 	.inst	0x0002f99c ; undefined
    3bac:	64690100 	fmla	z0.h, z8.h, z1.h[5]
    3bb0:	18640c00 	ldr	w0, cbd30 <GPR_FRAME_SIZE+0xcbc30>
    3bb4:	000000e6 	udf	#230
    3bb8:	056c9102 	splice	z2.h, p4, z2.h, z8.h
    3bbc:	0000046e 	udf	#1134
    3bc0:	0023640c 	.inst	0x0023640c ; NYI
    3bc4:	02000003 	.inst	0x02000003 ; undefined
    3bc8:	39046091 	strb	w17, [x4, #280]
    3bcc:	6600001b 	.inst	0x6600001b ; undefined
    3bd0:	0000a70a 	udf	#42762
    3bd4:	78910200 	ldursh	x0, [x16, #-240]
    3bd8:	001ab204 	.inst	0x001ab204 ; undefined
    3bdc:	1f106900 	fmadd	s0, s8, s16, s26
    3be0:	02000002 	.inst	0x02000002 ; undefined
    3be4:	06007091 	.inst	0x06007091 ; undefined
    3be8:	041c0201 	.inst	0x041c0201 ; undefined
    3bec:	41090000 	.inst	0x41090000 ; undefined
    3bf0:	0d000000 	st1	{v0.b}[0], [x0]
    3bf4:	00000457 	udf	#1111
    3bf8:	00365839 	.inst	0x00365839 ; NYI
    3bfc:	00000040 	udf	#64
    3c00:	00014c00 	.inst	0x00014c00 ; undefined
    3c04:	00000000 	udf	#0
    3c08:	b09c0100 	adrp	x0, ffffffff38024000 <__stack_el2_top+0xfffffffef6a1d000>
    3c0c:	01000003 	.inst	0x01000003 ; undefined
    3c10:	0c006469 	st1	{v9.4h-v11.4h}, [x3]
    3c14:	00e61839 	.inst	0x00e61839 ; undefined
    3c18:	91030000 	add	x0, x0, #0xc0
    3c1c:	39047fac 	strb	w12, [x29, #287]
    3c20:	3c00001b 	stur	b27, [x0]
    3c24:	0000a70a 	udf	#42762
    3c28:	78910200 	ldursh	x0, [x16, #-240]
    3c2c:	001b0604 	.inst	0x001b0604 ; undefined
    3c30:	65103e00 	.inst	0x65103e00 ; undefined
    3c34:	02000001 	.inst	0x02000001 ; undefined
    3c38:	0b047091 	add	w17, w4, w4, lsl #28
    3c3c:	4200001b 	.inst	0x4200001b ; undefined
    3c40:	00018410 	.inst	0x00018410 ; undefined
    3c44:	68910200 	stgp	x0, x0, [x16], #544
    3c48:	001b1004 	.inst	0x001b1004 ; undefined
    3c4c:	a3104a00 	.inst	0xa3104a00 ; undefined
    3c50:	02000001 	.inst	0x02000001 ; undefined
    3c54:	15046091 	b	411be98 <GPR_FRAME_SIZE+0x411bd98>
    3c58:	5100001b 	sub	w27, w0, #0x0
    3c5c:	0001c210 	.inst	0x0001c210 ; undefined
    3c60:	58910200 	ldr	x0, fffffffffff25ca0 <__stack_el2_top+0xffffffffbe91eca0>
    3c64:	001ac404 	.inst	0x001ac404 ; undefined
    3c68:	e1105500 	.inst	0xe1105500 ; undefined
    3c6c:	02000001 	.inst	0x02000001 ; undefined
    3c70:	01045091 	.inst	0x01045091 ; undefined
    3c74:	5800001b 	ldr	x27, 3c74 <GPR_FRAME_SIZE+0x3b74>
    3c78:	00012710 	.inst	0x00012710 ; undefined
    3c7c:	48910200 	stllrh	w0, [x16]
    3c80:	001b3404 	.inst	0x001b3404 ; undefined
    3c84:	46105c00 	.inst	0x46105c00 ; undefined
    3c88:	02000001 	.inst	0x02000001 ; undefined
    3c8c:	a4044091 	ld1b	{z17.b}, p0/z, [x4, x4]
    3c90:	6000001b 	.inst	0x6000001b ; undefined
    3c94:	00020010 	.inst	0x00020010 ; undefined
    3c98:	b8910300 	ldursw	x0, [x24, #-240]
    3c9c:	c60d007f 	.inst	0xc60d007f ; undefined
    3ca0:	27000018 	.inst	0x27000018 ; undefined
    3ca4:	400035c0 	.inst	0x400035c0 ; undefined
    3ca8:	00000000 	udf	#0
    3cac:	00000098 	udf	#152
    3cb0:	00000000 	udf	#0
    3cb4:	04359c01 	lsl	z1.h, z0.h, #5
    3cb8:	69010000 	stgp	x0, x0, [x0, #32]
    3cbc:	270c0064 	.inst	0x270c0064 ; undefined
    3cc0:	0000e619 	udf	#58905
    3cc4:	5c910200 	ldr	d0, fffffffffff25d04 <__stack_el2_top+0xffffffffbe91ed04>
    3cc8:	001b3904 	.inst	0x001b3904 ; undefined
    3ccc:	a70a2900 	.inst	0xa70a2900 ; undefined
    3cd0:	02000000 	.inst	0x02000000 ; undefined
    3cd4:	0b047091 	add	w17, w4, w4, lsl #28
    3cd8:	2a00001b 	orr	w27, w0, w0
    3cdc:	00018410 	.inst	0x00018410 ; undefined
    3ce0:	68910200 	stgp	x0, x0, [x16], #544
    3ce4:	0035f80f 	.inst	0x0035f80f ; NYI
    3ce8:	00000040 	udf	#64
    3cec:	00005000 	udf	#20480
    3cf0:	00000000 	udf	#0
    3cf4:	74750e00 	.inst	0x74750e00 ; undefined
    3cf8:	10310073 	adr	x19, 65d04 <GPR_FRAME_SIZE+0x65c04>
    3cfc:	00000243 	udf	#579
    3d00:	0f609102 	.inst	0x0f609102 ; undefined
    3d04:	400035f8 	.inst	0x400035f8 ; undefined
    3d08:	00000000 	udf	#0
    3d0c:	00000024 	udf	#36
    3d10:	00000000 	udf	#0
    3d14:	2f00690e 	.inst	0x2f00690e ; undefined
    3d18:	00008d0f 	udf	#36111
    3d1c:	78910200 	ldursh	x0, [x16, #-240]
    3d20:	0d000000 	st1	{v0.b}[0], [x0]
    3d24:	000003af 	udf	#943
    3d28:	00357022 	.inst	0x00357022 ; NYI
    3d2c:	00000040 	udf	#64
    3d30:	00005000 	udf	#20480
    3d34:	00000000 	udf	#0
    3d38:	6d9c0100 	stp	d0, d0, [x8, #448]!
    3d3c:	01000004 	.inst	0x01000004 ; undefined
    3d40:	0c006469 	st1	{v9.4h-v11.4h}, [x3]
    3d44:	00f21e22 	.inst	0x00f21e22 ; undefined
    3d48:	91020000 	add	x0, x0, #0x80
    3d4c:	0073017c 	.inst	0x0073017c ; undefined
    3d50:	6d2e220c 	stp	d12, d8, [x16, #-288]
    3d54:	02000004 	.inst	0x02000004 ; undefined
    3d58:	09007091 	.inst	0x09007091 ; undefined
    3d5c:	00000479 	udf	#1145
    3d60:	44080106 	.inst	0x44080106 ; undefined
    3d64:	0a000002 	and	w2, w0, w0
    3d68:	00000472 	udf	#1138
    3d6c:	0004e80d 	.inst	0x0004e80d ; undefined
    3d70:	35081700 	cbnz	w0, 14050 <GPR_FRAME_SIZE+0x13f50>
    3d74:	00004000 	udf	#16384
    3d78:	00680000 	.inst	0x00680000 ; undefined
    3d7c:	00000000 	udf	#0
    3d80:	9c010000 	ldr	q0, 5d80 <GPR_FRAME_SIZE+0x5c80>
    3d84:	000004c4 	udf	#1220
    3d88:	00646901 	.inst	0x00646901 ; undefined
    3d8c:	e618170c 	.inst	0xe618170c ; undefined
    3d90:	02000000 	.inst	0x02000000 ; undefined
    3d94:	63016c91 	.inst	0x63016c91 ; undefined
    3d98:	22170c00 	.inst	0x22170c00 ; undefined
    3d9c:	00000041 	udf	#65
    3da0:	046b9102 	asr	z2.s, z8.s, #21
    3da4:	00001aad 	udf	#6829
    3da8:	02671019 	.inst	0x02671019 ; undefined
    3dac:	91020000 	add	x0, x0, #0x80
    3db0:	04170078 	.inst	0x04170078 ; undefined
    3db4:	0c000019 	st4	{v25.8b-v28.8b}, [x0]
    3db8:	02f91411 	.inst	0x02f91411 ; undefined
    3dbc:	34dc0000 	cbz	w0, fffffffffffbbdbc <__stack_el2_top+0xffffffffbe9b4dbc>
    3dc0:	00004000 	udf	#16384
    3dc4:	002c0000 	.inst	0x002c0000 ; NYI
    3dc8:	00000000 	udf	#0
    3dcc:	9c010000 	ldr	q0, 5dcc <GPR_FRAME_SIZE+0x5ccc>
    3dd0:	00000504 	udf	#1284
    3dd4:	001b3905 	.inst	0x001b3905 ; undefined
    3dd8:	2e110c00 	.inst	0x2e110c00 ; undefined
    3ddc:	000000a7 	udf	#167
    3de0:	0e689102 	sqdmlal	v2.4s, v8.4h, v8.4h
    3de4:	00737475 	.inst	0x00737475 ; undefined
    3de8:	02430f13 	.inst	0x02430f13 ; undefined
    3dec:	91020000 	add	x0, x0, #0x80
    3df0:	3e030078 	.inst	0x3e030078 ; undefined
    3df4:	0b000019 	add	w25, w0, w0
    3df8:	0034b413 	.inst	0x0034b413 ; NYI
    3dfc:	00000040 	udf	#64
    3e00:	00002800 	udf	#10240
    3e04:	00000000 	udf	#0
    3e08:	3e9c0100 	.inst	0x3e9c0100 ; undefined
    3e0c:	05000005 	orr	z5.s, z5.s, #0x1
    3e10:	00001b39 	udf	#6969
    3e14:	a701130b 	.inst	0xa701130b ; undefined
    3e18:	02000000 	.inst	0x02000000 ; undefined
    3e1c:	76017891 	.inst	0x76017891 ; undefined
    3e20:	01130b00 	.inst	0x01130b00 ; undefined
    3e24:	00000267 	udf	#615
    3e28:	00709102 	.inst	0x00709102 ; undefined
    3e2c:	001a770b 	.inst	0x001a770b ; undefined
    3e30:	f9510a00 	ldr	x0, [x16, #8720]
    3e34:	90000002 	adrp	x2, 3000 <GPR_FRAME_SIZE+0x2f00>
    3e38:	00400034 	.inst	0x00400034 ; undefined
    3e3c:	24000000 	cmphs	p0.b, p0/z, z0.b, z0.b
    3e40:	00000000 	udf	#0
    3e44:	01000000 	.inst	0x01000000 ; undefined
    3e48:	0005799c 	.inst	0x0005799c ; undefined
    3e4c:	00720100 	.inst	0x00720100 ; undefined
    3e50:	4f01510a 	fmls	v10.8h, v8.8h, v1.h[0]
    3e54:	02000002 	.inst	0x02000002 ; undefined
    3e58:	f9027891 	str	x17, [x4, #1264]
    3e5c:	0a000009 	and	w9, w0, w0
    3e60:	00810151 	.inst	0x00810151 ; undefined
    3e64:	0b000000 	add	w0, w0, w0
    3e68:	000019fb 	udf	#6651
    3e6c:	02f9470a 	.inst	0x02f9470a ; undefined
    3e70:	346c0000 	cbz	w0, dbe70 <GPR_FRAME_SIZE+0xdbd70>
    3e74:	00004000 	udf	#16384
    3e78:	00240000 	.inst	0x00240000 ; NYI
    3e7c:	00000000 	udf	#0
    3e80:	9c010000 	ldr	q0, 5e80 <GPR_FRAME_SIZE+0x5d80>
    3e84:	000005b4 	udf	#1460
    3e88:	0a007201 	and	w1, w16, w0, lsl #28
    3e8c:	024f0147 	.inst	0x024f0147 ; undefined
    3e90:	91020000 	add	x0, x0, #0x80
    3e94:	09f90278 	.inst	0x09f90278 ; undefined
    3e98:	470a0000 	.inst	0x470a0000 ; undefined
    3e9c:	00008101 	udf	#33025
    3ea0:	160b0000 	b	fffffffff82c3ea0 <__stack_el2_top+0xffffffffb6cbcea0>
    3ea4:	0a000019 	and	w25, w0, w0
    3ea8:	0002f942 	.inst	0x0002f942 ; undefined
    3eac:	00344800 	.inst	0x00344800 ; NYI
    3eb0:	00000040 	udf	#64
    3eb4:	00002400 	udf	#9216
    3eb8:	00000000 	udf	#0
    3ebc:	ef9c0100 	.inst	0xef9c0100 ; undefined
    3ec0:	01000005 	.inst	0x01000005 ; undefined
    3ec4:	420a0072 	.inst	0x420a0072 ; undefined
    3ec8:	00024f01 	.inst	0x00024f01 ; undefined
    3ecc:	78910200 	ldursh	x0, [x16, #-240]
    3ed0:	0009f902 	.inst	0x0009f902 ; undefined
    3ed4:	01420a00 	.inst	0x01420a00 ; undefined
    3ed8:	00000081 	udf	#129
    3edc:	1a8f0b00 	.inst	0x1a8f0b00 ; undefined
    3ee0:	140a0000 	b	283ee0 <GPR_FRAME_SIZE+0x283de0>
    3ee4:	00000243 	udf	#579
    3ee8:	4000342c 	.inst	0x4000342c ; undefined
    3eec:	00000000 	udf	#0
    3ef0:	0000001c 	udf	#28
    3ef4:	00000000 	udf	#0
    3ef8:	06209c01 	.inst	0x06209c01 ; undefined
    3efc:	39050000 	strb	w0, [x0, #320]
    3f00:	0a00001b 	and	w27, w0, w0
    3f04:	00a70114 	.inst	0x00a70114 ; undefined
    3f08:	91020000 	add	x0, x0, #0x80
    3f0c:	280b0078 	stnp	w24, w0, [x3, #88]
    3f10:	0900001a 	.inst	0x0900001a ; undefined
    3f14:	0000411e 	udf	#16670
    3f18:	00341400 	.inst	0x00341400 ; NYI
    3f1c:	00000040 	udf	#64
    3f20:	00001800 	udf	#6144
    3f24:	00000000 	udf	#0
    3f28:	5b9c0100 	.inst	0x5b9c0100 ; undefined
    3f2c:	01000006 	.inst	0x01000006 ; undefined
    3f30:	1e090072 	.inst	0x1e090072 ; undefined
    3f34:	00022b01 	.inst	0x00022b01 ; undefined
    3f38:	78910200 	ldursh	x0, [x16, #-240]
    3f3c:	0009f902 	.inst	0x0009f902 ; undefined
    3f40:	011e0900 	.inst	0x011e0900 ; undefined
    3f44:	00000081 	udf	#129
    3f48:	1a680b00 	.inst	0x1a680b00 ; undefined
    3f4c:	14090000 	b	243f4c <GPR_FRAME_SIZE+0x243e4c>
    3f50:	0000021f 	udf	#543
    3f54:	400033fc 	.inst	0x400033fc ; undefined
    3f58:	00000000 	udf	#0
    3f5c:	00000018 	udf	#24
    3f60:	00000000 	udf	#0
    3f64:	068c9c01 	.inst	0x068c9c01 ; undefined
    3f68:	39050000 	strb	w0, [x0, #320]
    3f6c:	0900001b 	.inst	0x0900001b ; undefined
    3f70:	00a70114 	.inst	0x00a70114 ; undefined
    3f74:	91020000 	add	x0, x0, #0x80
    3f78:	eb030078 	subs	x24, x3, x3
    3f7c:	08000019 	stxrb	w0, w25, [x0]
    3f80:	0033d417 	.inst	0x0033d417 ; NYI
    3f84:	00000040 	udf	#64
    3f88:	00002800 	udf	#10240
    3f8c:	00000000 	udf	#0
    3f90:	c69c0100 	.inst	0xc69c0100 ; undefined
    3f94:	05000006 	orr	z6.s, z6.s, #0x1
    3f98:	00001b39 	udf	#6969
    3f9c:	a7011708 	.inst	0xa7011708 ; undefined
    3fa0:	02000000 	.inst	0x02000000 ; undefined
    3fa4:	76017891 	.inst	0x76017891 ; undefined
    3fa8:	01170800 	.inst	0x01170800 ; undefined
    3fac:	00000200 	udf	#512
    3fb0:	00709102 	.inst	0x00709102 ; undefined
    3fb4:	0019db03 	.inst	0x0019db03 ; undefined
    3fb8:	ac170700 	stnp	q0, q1, [x24, #736]
    3fbc:	00400033 	.inst	0x00400033 ; undefined
    3fc0:	28000000 	stnp	w0, w0, [x0]
    3fc4:	00000000 	udf	#0
    3fc8:	01000000 	.inst	0x01000000 ; undefined
    3fcc:	0007009c 	.inst	0x0007009c ; undefined
    3fd0:	1b390500 	.inst	0x1b390500 ; undefined
    3fd4:	17070000 	b	fffffffffc1c3fd4 <__stack_el2_top+0xffffffffbabbcfd4>
    3fd8:	0000a701 	udf	#42753
    3fdc:	78910200 	ldursh	x0, [x16, #-240]
    3fe0:	07007601 	.inst	0x07007601 ; undefined
    3fe4:	01e10117 	.inst	0x01e10117 ; undefined
    3fe8:	91020000 	add	x0, x0, #0x80
    3fec:	51030070 	sub	w16, w3, #0xc0
    3ff0:	0600001a 	.inst	0x0600001a ; undefined
    3ff4:	00337424 	.inst	0x00337424 ; NYI
    3ff8:	00000040 	udf	#64
    3ffc:	00003800 	udf	#14336
    4000:	00000000 	udf	#0
    4004:	449c0100 	sdot	z0.s, z8.b, z28.b
    4008:	01000007 	.inst	0x01000007 ; undefined
    400c:	24060072 	cmphi	p2.b, p0/z, z3.b, z6.b
    4010:	00074401 	.inst	0x00074401 ; undefined
    4014:	78910200 	ldursh	x0, [x16, #-240]
    4018:	06007601 	.inst	0x06007601 ; undefined
    401c:	00410124 	.inst	0x00410124 ; undefined
    4020:	91020000 	add	x0, x0, #0x80
    4024:	09f90277 	.inst	0x09f90277 ; undefined
    4028:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
    402c:	00007501 	udf	#29953
    4030:	c2090000 	.inst	0xc2090000 ; undefined
    4034:	03000001 	.inst	0x03000001 ; undefined
    4038:	00001ba9 	udf	#7081
    403c:	334c1706 	.inst	0x334c1706 ; undefined
    4040:	00004000 	udf	#16384
    4044:	00280000 	.inst	0x00280000 ; NYI
    4048:	00000000 	udf	#0
    404c:	9c010000 	ldr	q0, 604c <GPR_FRAME_SIZE+0x5f4c>
    4050:	00000783 	udf	#1923
    4054:	001b3905 	.inst	0x001b3905 ; undefined
    4058:	01170600 	.inst	0x01170600 ; undefined
    405c:	000000a7 	udf	#167
    4060:	01789102 	.inst	0x01789102 ; undefined
    4064:	17060076 	b	fffffffffc18423c <__stack_el2_top+0xffffffffbab7d23c>
    4068:	0001c201 	.inst	0x0001c201 ; undefined
    406c:	70910200 	adr	x0, fffffffffff260af <__stack_el2_top+0xffffffffbe91f0af>
    4070:	19a20300 	.inst	0x19a20300 ; undefined
    4074:	63050000 	.inst	0x63050000 ; undefined
    4078:	40003314 	.inst	0x40003314 ; undefined
    407c:	00000000 	udf	#0
    4080:	00000038 	udf	#56
    4084:	00000000 	udf	#0
    4088:	07c79c01 	.inst	0x07c79c01 ; undefined
    408c:	72010000 	ands	w0, w0, #0x80000000
    4090:	01630500 	.inst	0x01630500 ; undefined
    4094:	000007c7 	udf	#1991
    4098:	01789102 	.inst	0x01789102 ; undefined
    409c:	63050076 	.inst	0x63050076 ; undefined
    40a0:	0002f901 	.inst	0x0002f901 ; undefined
    40a4:	77910200 	.inst	0x77910200 ; undefined
    40a8:	0009f902 	.inst	0x0009f902 ; undefined
    40ac:	01630500 	.inst	0x01630500 ; undefined
    40b0:	00000075 	udf	#117
    40b4:	01a30900 	.inst	0x01a30900 ; undefined
    40b8:	80030000 	.inst	0x80030000 ; undefined
    40bc:	05000019 	orr	z25.s, z25.s, #0x1
    40c0:	0032dc45 	.inst	0x0032dc45 ; NYI
    40c4:	00000040 	udf	#64
    40c8:	00003800 	udf	#14336
    40cc:	00000000 	udf	#0
    40d0:	109c0100 	adr	x0, fffffffffff3c0f0 <__stack_el2_top+0xffffffffbe9350f0>
    40d4:	01000008 	.inst	0x01000008 ; undefined
    40d8:	45050072 	.inst	0x45050072 ; undefined
    40dc:	0007c701 	.inst	0x0007c701 ; undefined
    40e0:	78910200 	ldursh	x0, [x16, #-240]
    40e4:	05007601 	orr	z1.b, z1.b, #0x4
    40e8:	02f90145 	.inst	0x02f90145 ; undefined
    40ec:	91020000 	add	x0, x0, #0x80
    40f0:	09f90277 	.inst	0x09f90277 ; undefined
    40f4:	45050000 	.inst	0x45050000 ; undefined
    40f8:	00007501 	udf	#29953
    40fc:	c9030000 	.inst	0xc9030000 ; undefined
    4100:	0500001a 	orr	z26.s, z26.s, #0x1
    4104:	0032a440 	.inst	0x0032a440 ; NYI
    4108:	00000040 	udf	#64
    410c:	00003800 	udf	#14336
    4110:	00000000 	udf	#0
    4114:	549c0100 	b.eq	fffffffffff3c134 <__stack_el2_top+0xffffffffbe935134>  // b.none
    4118:	01000008 	.inst	0x01000008 ; undefined
    411c:	40050072 	.inst	0x40050072 ; undefined
    4120:	0007c701 	.inst	0x0007c701 ; undefined
    4124:	78910200 	ldursh	x0, [x16, #-240]
    4128:	05007601 	orr	z1.b, z1.b, #0x4
    412c:	02f90140 	.inst	0x02f90140 ; undefined
    4130:	91020000 	add	x0, x0, #0x80
    4134:	09f90277 	.inst	0x09f90277 ; undefined
    4138:	40050000 	.inst	0x40050000 ; undefined
    413c:	00007501 	udf	#29953
    4140:	dd030000 	.inst	0xdd030000 ; undefined
    4144:	0500001b 	orr	z27.s, z27.s, #0x1
    4148:	00326c3b 	.inst	0x00326c3b ; NYI
    414c:	00000040 	udf	#64
    4150:	00003800 	udf	#14336
    4154:	00000000 	udf	#0
    4158:	989c0100 	ldrsw	x0, fffffffffff3c178 <__stack_el2_top+0xffffffffbe935178>
    415c:	01000008 	.inst	0x01000008 ; undefined
    4160:	3b050072 	.inst	0x3b050072 ; undefined
    4164:	0007c701 	.inst	0x0007c701 ; undefined
    4168:	78910200 	ldursh	x0, [x16, #-240]
    416c:	05007601 	orr	z1.b, z1.b, #0x4
    4170:	02f9013b 	.inst	0x02f9013b ; undefined
    4174:	91020000 	add	x0, x0, #0x80
    4178:	09f90277 	.inst	0x09f90277 ; undefined
    417c:	3b050000 	.inst	0x3b050000 ; undefined
    4180:	00007501 	udf	#29953
    4184:	bd030000 	str	s0, [x0, #768]
    4188:	05000019 	orr	z25.s, z25.s, #0x1
    418c:	00324417 	.inst	0x00324417 ; NYI
    4190:	00000040 	udf	#64
    4194:	00002800 	udf	#10240
    4198:	00000000 	udf	#0
    419c:	d29c0100 	mov	x0, #0xe008                	// #57352
    41a0:	05000008 	orr	z8.s, z8.s, #0x1
    41a4:	00001b39 	udf	#6969
    41a8:	a7011705 	.inst	0xa7011705 ; undefined
    41ac:	02000000 	.inst	0x02000000 ; undefined
    41b0:	76017891 	.inst	0x76017891 ; undefined
    41b4:	01170500 	.inst	0x01170500 ; undefined
    41b8:	000001a3 	udf	#419
    41bc:	00709102 	.inst	0x00709102 ; undefined
    41c0:	001a1203 	.inst	0x001a1203 ; undefined
    41c4:	14710400 	b	1c451c4 <GPR_FRAME_SIZE+0x1c450c4>
    41c8:	00400032 	.inst	0x00400032 ; undefined
    41cc:	30000000 	adr	x0, 41cd <GPR_FRAME_SIZE+0x40cd>
    41d0:	00000000 	udf	#0
    41d4:	01000000 	.inst	0x01000000 ; undefined
    41d8:	0009169c 	.inst	0x0009169c ; undefined
    41dc:	00720100 	.inst	0x00720100 ; undefined
    41e0:	16017104 	b	fffffffff80605f0 <__stack_el2_top+0xffffffffb6a595f0>
    41e4:	02000009 	.inst	0x02000009 ; undefined
    41e8:	76017891 	.inst	0x76017891 ; undefined
    41ec:	01710400 	.inst	0x01710400 ; undefined
    41f0:	000002f9 	udf	#761
    41f4:	02779102 	.inst	0x02779102 ; undefined
    41f8:	000009f9 	udf	#2553
    41fc:	75017104 	.inst	0x75017104 ; undefined
    4200:	00000000 	udf	#0
    4204:	00018409 	.inst	0x00018409 ; undefined
    4208:	18ee0300 	ldr	w0, fffffffffffe0268 <__stack_el2_top+0xffffffffbe9d9268>
    420c:	6c040000 	stnp	d0, d0, [x0, #64]
    4210:	400031dc 	.inst	0x400031dc ; undefined
    4214:	00000000 	udf	#0
    4218:	00000038 	udf	#56
    421c:	00000000 	udf	#0
    4220:	095f9c01 	.inst	0x095f9c01 ; undefined
    4224:	72010000 	ands	w0, w0, #0x80000000
    4228:	016c0400 	.inst	0x016c0400 ; undefined
    422c:	00000916 	udf	#2326
    4230:	01789102 	.inst	0x01789102 ; undefined
    4234:	6c040076 	stnp	d22, d0, [x3, #64]
    4238:	0002f901 	.inst	0x0002f901 ; undefined
    423c:	77910200 	.inst	0x77910200 ; undefined
    4240:	0009f902 	.inst	0x0009f902 ; undefined
    4244:	016c0400 	.inst	0x016c0400 ; undefined
    4248:	00000075 	udf	#117
    424c:	1bb90300 	.inst	0x1bb90300 ; undefined
    4250:	67040000 	.inst	0x67040000 ; undefined
    4254:	400031a4 	.inst	0x400031a4 ; undefined
    4258:	00000000 	udf	#0
    425c:	00000038 	udf	#56
    4260:	00000000 	udf	#0
    4264:	09a39c01 	.inst	0x09a39c01 ; undefined
    4268:	72010000 	ands	w0, w0, #0x80000000
    426c:	01670400 	.inst	0x01670400 ; undefined
    4270:	00000916 	udf	#2326
    4274:	01789102 	.inst	0x01789102 ; undefined
    4278:	67040076 	.inst	0x67040076 ; undefined
    427c:	0002f901 	.inst	0x0002f901 ; undefined
    4280:	77910200 	.inst	0x77910200 ; undefined
    4284:	0009f902 	.inst	0x0009f902 ; undefined
    4288:	01670400 	.inst	0x01670400 ; undefined
    428c:	00000075 	udf	#117
    4290:	195e0300 	ldapurb	w0, [x24, #-32]
    4294:	58040000 	ldr	x0, c294 <GPR_FRAME_SIZE+0xc194>
    4298:	4000316c 	.inst	0x4000316c ; undefined
    429c:	00000000 	udf	#0
    42a0:	00000038 	udf	#56
    42a4:	00000000 	udf	#0
    42a8:	09e79c01 	.inst	0x09e79c01 ; undefined
    42ac:	72010000 	ands	w0, w0, #0x80000000
    42b0:	01580400 	.inst	0x01580400 ; undefined
    42b4:	00000916 	udf	#2326
    42b8:	01789102 	.inst	0x01789102 ; undefined
    42bc:	58040076 	ldr	x22, c2c8 <GPR_FRAME_SIZE+0xc1c8>
    42c0:	0002f901 	.inst	0x0002f901 ; undefined
    42c4:	77910200 	.inst	0x77910200 ; undefined
    42c8:	0009f902 	.inst	0x0009f902 ; undefined
    42cc:	01580400 	.inst	0x01580400 ; undefined
    42d0:	00000075 	udf	#117
    42d4:	1b680300 	.inst	0x1b680300 ; undefined
    42d8:	29040000 	stp	w0, w0, [x0, #32]
    42dc:	40003134 	.inst	0x40003134 ; undefined
    42e0:	00000000 	udf	#0
    42e4:	00000038 	udf	#56
    42e8:	00000000 	udf	#0
    42ec:	0a2b9c01 	.inst	0x0a2b9c01 ; undefined
    42f0:	72010000 	ands	w0, w0, #0x80000000
    42f4:	01290400 	.inst	0x01290400 ; undefined
    42f8:	00000916 	udf	#2326
    42fc:	01789102 	.inst	0x01789102 ; undefined
    4300:	29040076 	stp	w22, w0, [x3, #32]
    4304:	0002f901 	.inst	0x0002f901 ; undefined
    4308:	77910200 	.inst	0x77910200 ; undefined
    430c:	0009f902 	.inst	0x0009f902 ; undefined
    4310:	01290400 	.inst	0x01290400 ; undefined
    4314:	00000075 	udf	#117
    4318:	194e0300 	ldapurb	w0, [x24, #224]
    431c:	17040000 	b	fffffffffc10431c <__stack_el2_top+0xffffffffbaafd31c>
    4320:	4000310c 	.inst	0x4000310c ; undefined
    4324:	00000000 	udf	#0
    4328:	00000028 	udf	#40
    432c:	00000000 	udf	#0
    4330:	0a659c01 	.inst	0x0a659c01 ; undefined
    4334:	39050000 	strb	w0, [x0, #320]
    4338:	0400001b 	add	z27.b, p0/m, z27.b, z0.b
    433c:	00a70117 	.inst	0x00a70117 ; undefined
    4340:	91020000 	add	x0, x0, #0x80
    4344:	00760178 	.inst	0x00760178 ; undefined
    4348:	84011704 	ld1sb	{z4.s}, p5/z, [x24, z1.s, uxtw]
    434c:	02000001 	.inst	0x02000001 ; undefined
    4350:	0b007091 	add	w17, w4, w0, lsl #28
    4354:	000018df 	udf	#6367
    4358:	01841404 	.inst	0x01841404 ; undefined
    435c:	30f00000 	adr	x0, fffffffffffe435d <__stack_el2_top+0xffffffffbe9dd35d>
    4360:	00004000 	udf	#16384
    4364:	001c0000 	.inst	0x001c0000 ; undefined
    4368:	00000000 	udf	#0
    436c:	9c010000 	ldr	q0, 636c <GPR_FRAME_SIZE+0x626c>
    4370:	00000a96 	udf	#2710
    4374:	001b3905 	.inst	0x001b3905 ; undefined
    4378:	01140400 	.inst	0x01140400 ; undefined
    437c:	000000a7 	udf	#167
    4380:	00789102 	.inst	0x00789102 ; undefined
    4384:	001b8c03 	.inst	0x001b8c03 ; undefined
    4388:	c0240300 	.inst	0xc0240300 ; undefined
    438c:	00400030 	.inst	0x00400030 ; undefined
    4390:	30000000 	adr	x0, 4391 <GPR_FRAME_SIZE+0x4291>
    4394:	00000000 	udf	#0
    4398:	01000000 	.inst	0x01000000 ; undefined
    439c:	000ada9c 	.inst	0x000ada9c ; undefined
    43a0:	00720100 	.inst	0x00720100 ; undefined
    43a4:	da012403 	subpt	x3, x0, x1, lsl #1
    43a8:	0200000a 	.inst	0x0200000a ; undefined
    43ac:	76017891 	.inst	0x76017891 ; undefined
    43b0:	01240300 	.inst	0x01240300 ; undefined
    43b4:	000002f9 	udf	#761
    43b8:	02779102 	.inst	0x02779102 ; undefined
    43bc:	000009f9 	udf	#2553
    43c0:	75012403 	.inst	0x75012403 ; undefined
    43c4:	00000000 	udf	#0
    43c8:	00016509 	.inst	0x00016509 ; undefined
    43cc:	192e0300 	.inst	0x192e0300 ; undefined
    43d0:	17030000 	b	fffffffffc0c43d0 <__stack_el2_top+0xffffffffbaabd3d0>
    43d4:	40003098 	.inst	0x40003098 ; undefined
    43d8:	00000000 	udf	#0
    43dc:	00000028 	udf	#40
    43e0:	00000000 	udf	#0
    43e4:	0b199c01 	.inst	0x0b199c01 ; undefined
    43e8:	39050000 	strb	w0, [x0, #320]
    43ec:	0300001b 	.inst	0x0300001b ; undefined
    43f0:	00a70117 	.inst	0x00a70117 ; undefined
    43f4:	91020000 	add	x0, x0, #0x80
    43f8:	00760178 	.inst	0x00760178 ; undefined
    43fc:	65011703 	.inst	0x65011703 ; undefined
    4400:	02000001 	.inst	0x02000001 ; undefined
    4404:	03007091 	.inst	0x03007091 ; undefined
    4408:	00001aec 	udf	#6892
    440c:	30682302 	adr	x2, d486d <GPR_FRAME_SIZE+0xd476d>
    4410:	00004000 	udf	#16384
    4414:	00300000 	.inst	0x00300000 ; NYI
    4418:	00000000 	udf	#0
    441c:	9c010000 	ldr	q0, 641c <GPR_FRAME_SIZE+0x631c>
    4420:	00000b5d 	udf	#2909
    4424:	02007201 	.inst	0x02007201 ; undefined
    4428:	0b5d0123 	add	w3, w9, w29, lsr #0
    442c:	91020000 	add	x0, x0, #0x80
    4430:	00760178 	.inst	0x00760178 ; undefined
    4434:	5b012302 	.inst	0x5b012302 ; undefined
    4438:	02000000 	.inst	0x02000000 ; undefined
    443c:	f9027691 	str	x17, [x20, #1256]
    4440:	02000009 	.inst	0x02000009 ; undefined
    4444:	00750123 	.inst	0x00750123 ; undefined
    4448:	09000000 	.inst	0x09000000 ; undefined
    444c:	00000146 	udf	#326
    4450:	001a4103 	.inst	0x001a4103 ; undefined
    4454:	40170200 	.inst	0x40170200 ; undefined
    4458:	00400030 	.inst	0x00400030 ; undefined
    445c:	28000000 	stnp	w0, w0, [x0]
    4460:	00000000 	udf	#0
    4464:	01000000 	.inst	0x01000000 ; undefined
    4468:	000b9c9c 	.inst	0x000b9c9c ; undefined
    446c:	1b390500 	.inst	0x1b390500 ; undefined
    4470:	17020000 	b	fffffffffc084470 <__stack_el2_top+0xffffffffbaa7d470>
    4474:	0000a701 	udf	#42753
    4478:	78910200 	ldursh	x0, [x16, #-240]
    447c:	02007601 	.inst	0x02007601 ; undefined
    4480:	01460117 	.inst	0x01460117 ; undefined
    4484:	91020000 	add	x0, x0, #0x80
    4488:	45030070 	.inst	0x45030070 ; undefined
    448c:	0100001b 	.inst	0x0100001b ; undefined
    4490:	00301024 	.inst	0x00301024 ; NYI
    4494:	00000040 	udf	#64
    4498:	00003000 	udf	#12288
    449c:	00000000 	udf	#0
    44a0:	e09c0100 	ld1w	{za0h.s[w12, 0]}, p0/z, [x8, x28, lsl #2]
    44a4:	0100000b 	.inst	0x0100000b ; undefined
    44a8:	24010072 	cmphi	p2.b, p0/z, z3.b, z1.b
    44ac:	000be001 	.inst	0x000be001 ; undefined
    44b0:	78910200 	ldursh	x0, [x16, #-240]
    44b4:	01007601 	.inst	0x01007601 ; undefined
    44b8:	005b0124 	.inst	0x005b0124 ; undefined
    44bc:	91020000 	add	x0, x0, #0x80
    44c0:	09f90276 	.inst	0x09f90276 ; undefined
    44c4:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
    44c8:	00007501 	udf	#29953
    44cc:	27090000 	.inst	0x27090000 ; undefined
    44d0:	18000001 	ldr	w1, 44d0 <GPR_FRAME_SIZE+0x43d0>
    44d4:	00001a9d 	udf	#6813
    44d8:	e8011801 	.inst	0xe8011801 ; undefined
    44dc:	0040002f 	.inst	0x0040002f ; undefined
    44e0:	28000000 	stnp	w0, w0, [x0]
    44e4:	00000000 	udf	#0
    44e8:	01000000 	.inst	0x01000000 ; undefined
    44ec:	1b39059c 	.inst	0x1b39059c ; undefined
    44f0:	18010000 	ldr	w0, 64f0 <GPR_FRAME_SIZE+0x63f0>
    44f4:	0000a701 	udf	#42753
    44f8:	78910200 	ldursh	x0, [x16, #-240]
    44fc:	01007601 	.inst	0x01007601 ; undefined
    4500:	01270118 	.inst	0x01270118 ; undefined
    4504:	91020000 	add	x0, x0, #0x80
    4508:	Address 0x4508 is out of bounds.


Disassembly of section .debug_abbrev:

0000000000000000 <.debug_abbrev>:
       0:	10001101 	adr	x1, 220 <GPR_FRAME_SIZE+0x120>
       4:	12011117 	and	w23, w8, #0x8000000f
       8:	1b0e030f 	madd	w15, w24, w14, w0
       c:	130e250e 	sbfiz	w14, w8, #18, #10
      10:	00000005 	udf	#5
      14:	10001101 	adr	x1, 234 <GPR_FRAME_SIZE+0x134>
      18:	03175517 	.inst	0x03175517 ; undefined
      1c:	250e1b0e 	cmpge	p14.b, p6/z, z24.b, #14
      20:	0005130e 	.inst	0x0005130e ; undefined
      24:	11010000 	add	w0, w0, #0x40
      28:	11171000 	add	w0, w0, #0x5c4
      2c:	030f1201 	.inst	0x030f1201 ; undefined
      30:	250e1b0e 	cmpge	p14.b, p6/z, z24.b, #14
      34:	0005130e 	.inst	0x0005130e ; undefined
      38:	11010000 	add	w0, w0, #0x40
      3c:	11171000 	add	w0, w0, #0x5c4
      40:	030f1201 	.inst	0x030f1201 ; undefined
      44:	250e1b0e 	cmpge	p14.b, p6/z, z24.b, #14
      48:	0005130e 	.inst	0x0005130e ; undefined
      4c:	11010000 	add	w0, w0, #0x40
      50:	11171000 	add	w0, w0, #0x5c4
      54:	030f1201 	.inst	0x030f1201 ; undefined
      58:	250e1b0e 	cmpge	p14.b, p6/z, z24.b, #14
      5c:	0005130e 	.inst	0x0005130e ; undefined
      60:	11010000 	add	w0, w0, #0x40
      64:	11171000 	add	w0, w0, #0x5c4
      68:	030f1201 	.inst	0x030f1201 ; undefined
      6c:	250e1b0e 	cmpge	p14.b, p6/z, z24.b, #14
      70:	0005130e 	.inst	0x0005130e ; undefined
      74:	28010000 	stnp	w0, w0, [x0, #8]
      78:	1c0e0300 	ldr	s0, 1c0d8 <GPR_FRAME_SIZE+0x1bfd8>
      7c:	0200000b 	.inst	0x0200000b ; undefined
      80:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
      84:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
      88:	13490b39 	.inst	0x13490b39 ; undefined
      8c:	24030000 	cmphs	p0.b, p0/z, z0.b, z3.b
      90:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
      94:	000e030b 	.inst	0x000e030b ; undefined
      98:	00050400 	.inst	0x00050400 ; undefined
      9c:	00001349 	udf	#4937
      a0:	03000d05 	.inst	0x03000d05 ; undefined
      a4:	03213a0e 	.inst	0x03213a0e ; undefined
      a8:	0b390b3b 	add	w27, w25, w25, uxtb #2
      ac:	00001349 	udf	#4937
      b0:	03000d06 	.inst	0x03000d06 ; undefined
      b4:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
      b8:	490b390b 	.inst	0x490b390b ; undefined
      bc:	000b3813 	.inst	0x000b3813 ; undefined
      c0:	00340700 	.inst	0x00340700 ; NYI
      c4:	213a0e03 	.inst	0x213a0e03 ; undefined
      c8:	390b3b05 	strb	w5, [x24, #718]
      cc:	13490f21 	.inst	0x13490f21 ; undefined
      d0:	193c193f 	.inst	0x193c193f ; undefined
      d4:	34080000 	cbz	w0, 100d4 <GPR_FRAME_SIZE+0xffd4>
      d8:	3a134700 	.inst	0x3a134700 ; undefined
      dc:	0b3b0121 	add	w1, w9, w27, uxtb
      e0:	02082139 	.inst	0x02082139 ; undefined
      e4:	09000018 	.inst	0x09000018 ; undefined
      e8:	0b0b0113 	add	w19, w8, w11
      ec:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
      f0:	01092139 	.inst	0x01092139 ; undefined
      f4:	0a000013 	and	w19, w0, w0
      f8:	0803000d 	stxrb	w3, w13, [x0]
      fc:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     100:	13490b39 	.inst	0x13490b39 ; undefined
     104:	00000b38 	udf	#2872
     108:	3e01040b 	.inst	0x3e01040b ; undefined
     10c:	210b0721 	.inst	0x210b0721 ; undefined
     110:	3a134904 	.inst	0x3a134904 ; undefined
     114:	390b3b0b 	strb	w11, [x24, #718]
     118:	13010e21 	sbfx	w1, w17, #1, #3
     11c:	0f0c0000 	fdot	v0.2s, v0.8b, v12.4b[0]
     120:	08210b00 	.inst	0x08210b00 ; undefined
     124:	00001349 	udf	#4937
     128:	4901010d 	.inst	0x4901010d ; undefined
     12c:	00130113 	.inst	0x00130113 ; undefined
     130:	00340e00 	.inst	0x00340e00 ; NYI
     134:	213a0e03 	.inst	0x213a0e03 ; undefined
     138:	390b3b01 	strb	w1, [x24, #718]
     13c:	0213490b 	.inst	0x0213490b ; undefined
     140:	0f000018 	fdot	v24.2s, v0.8b, v0.4b[0]
     144:	13490026 	.inst	0x13490026 ; undefined
     148:	21100000 	.inst	0x21100000 ; undefined
     14c:	2f134900 	.inst	0x2f134900 ; undefined
     150:	11000005 	add	w5, w0, #0x0
     154:	0e030034 	tbl	v20.8b, {v1.16b}, v3.8b
     158:	3b01213a 	.inst	0x3b01213a ; undefined
     15c:	1b21390b 	.inst	0x1b21390b ; undefined
     160:	01881349 	.inst	0x01881349 ; undefined
     164:	18021021 	ldr	w1, 4368 <GPR_FRAME_SIZE+0x4268>
     168:	2e120000 	ext	v0.8b, v0.8b, v18.8b, #0
     16c:	03193f01 	.inst	0x03193f01 ; undefined
     170:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     174:	0621390b 	.inst	0x0621390b ; undefined
     178:	193c1927 	.inst	0x193c1927 ; undefined
     17c:	00001301 	udf	#4865
     180:	3f012e13 	.inst	0x3f012e13 ; undefined
     184:	3a0e0319 	adcs	w25, w24, w14
     188:	0b3b0121 	add	w1, w9, w27, uxtb
     18c:	27102139 	.inst	0x27102139 ; undefined
     190:	19018719 	cpyfprn	[x25]!, [x1]!, x24!
     194:	07120111 	.inst	0x07120111 ; undefined
     198:	197c1840 	.inst	0x197c1840 ; undefined
     19c:	00001301 	udf	#4865
     1a0:	03000514 	.inst	0x03000514 ; undefined
     1a4:	01213a0e 	.inst	0x01213a0e ; undefined
     1a8:	0b390b3b 	add	w27, w25, w25, uxtb #2
     1ac:	18021349 	ldr	w9, 4414 <GPR_FRAME_SIZE+0x4314>
     1b0:	11150000 	add	w0, w0, #0x540
     1b4:	130e2501 	sbfiz	w1, w8, #18, #10
     1b8:	1b1f030b 	madd	w11, w24, wzr, w0
     1bc:	1201111f 	and	wsp, w8, #0x8000000f
     1c0:	00171007 	.inst	0x00171007 ; undefined
     1c4:	00241600 	.inst	0x00241600 ; NYI
     1c8:	0b3e0b0b 	add	w11, w24, w30, uxtb #2
     1cc:	00000803 	udf	#2051
     1d0:	0b011717 	add	w23, w24, w1, lsl #5
     1d4:	3b0b3a0b 	.inst	0x3b0b3a0b ; undefined
     1d8:	010b390b 	.inst	0x010b390b ; undefined
     1dc:	18000013 	ldr	w19, 1dc <GPR_FRAME_SIZE+0xdc>
     1e0:	193f002e 	.inst	0x193f002e ; undefined
     1e4:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     1e8:	0b390b3b 	add	w27, w25, w25, uxtb #2
     1ec:	13491927 	.inst	0x13491927 ; undefined
     1f0:	0000193c 	udf	#6460
     1f4:	3f012e19 	.inst	0x3f012e19 ; undefined
     1f8:	3a0e0319 	adcs	w25, w24, w14
     1fc:	390b3b0b 	strb	w11, [x24, #718]
     200:	4919270b 	.inst	0x4919270b ; undefined
     204:	01193c13 	.inst	0x01193c13 ; undefined
     208:	1a000013 	adc	w19, w0, w0
     20c:	0e03012e 	tbl	v14.8b, {v9.16b}, v3.8b
     210:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     214:	19270b39 	rcwcas	x7, x25, [x25]
     218:	07120111 	.inst	0x07120111 ; undefined
     21c:	197c1840 	.inst	0x197c1840 ; undefined
     220:	00001301 	udf	#4865
     224:	3f012e1b 	.inst	0x3f012e1b ; undefined
     228:	3a0e0319 	adcs	w25, w24, w14
     22c:	390b3b0b 	strb	w11, [x24, #718]
     230:	1119270b 	add	w11, w24, #0x649
     234:	40071201 	.inst	0x40071201 ; undefined
     238:	01197c18 	.inst	0x01197c18 ; undefined
     23c:	1c000013 	ldr	s19, 23c <GPR_FRAME_SIZE+0x13c>
     240:	08030034 	stxrb	w3, w20, [x1]
     244:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     248:	13490b39 	.inst	0x13490b39 ; undefined
     24c:	00001802 	udf	#6146
     250:	4900211d 	.inst	0x4900211d ; undefined
     254:	000b2f13 	.inst	0x000b2f13 ; undefined
     258:	002e1e00 	.inst	0x002e1e00 ; NYI
     25c:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     260:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     264:	19270b39 	rcwcas	x7, x25, [x25]
     268:	07120111 	.inst	0x07120111 ; undefined
     26c:	197c1840 	.inst	0x197c1840 ; undefined
     270:	01000000 	.inst	0x01000000 ; undefined
     274:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     278:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     27c:	13490b39 	.inst	0x13490b39 ; undefined
     280:	28020000 	stnp	w0, w0, [x0, #16]
     284:	1c0e0300 	ldr	s0, 1c2e4 <GPR_FRAME_SIZE+0x1c1e4>
     288:	0300000b 	.inst	0x0300000b ; undefined
     28c:	13490005 	.inst	0x13490005 ; undefined
     290:	24040000 	cmphs	p0.b, p0/z, z0.b, z4.b
     294:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     298:	000e030b 	.inst	0x000e030b ; undefined
     29c:	000d0500 	.inst	0x000d0500 ; undefined
     2a0:	213a0e03 	.inst	0x213a0e03 ; undefined
     2a4:	390b3b04 	strb	w4, [x24, #718]
     2a8:	0013490b 	.inst	0x0013490b ; undefined
     2ac:	000d0600 	.inst	0x000d0600 ; undefined
     2b0:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     2b4:	0b390b3b 	add	w27, w25, w25, uxtb #2
     2b8:	0b381349 	add	w9, w26, w24, uxtb #4
     2bc:	0f070000 	fdot	v0.2s, v0.8b, v7.4b[0]
     2c0:	08210b00 	.inst	0x08210b00 ; undefined
     2c4:	00001349 	udf	#4937
     2c8:	3f012e08 	.inst	0x3f012e08 ; undefined
     2cc:	3a0e0319 	adcs	w25, w24, w14
     2d0:	390b3b0b 	strb	w11, [x24, #718]
     2d4:	19270621 	.inst	0x19270621 ; undefined
     2d8:	1301193c 	sbfx	w28, w9, #1, #6
     2dc:	34090000 	cbz	w0, 122dc <GPR_FRAME_SIZE+0x121dc>
     2e0:	3a0e0300 	adcs	w0, w24, w14
     2e4:	390b3b0b 	strb	w11, [x24, #718]
     2e8:	0213490b 	.inst	0x0213490b ; undefined
     2ec:	0a000018 	and	w24, w0, w0
     2f0:	0b0b0113 	add	w19, w8, w11
     2f4:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     2f8:	13010b39 	sbfx	w25, w25, #1, #2
     2fc:	0d0b0000 	.inst	0x0d0b0000 ; undefined
     300:	3a080300 	adcs	w0, w24, w8
     304:	390b3b0b 	strb	w11, [x24, #718]
     308:	3813490b 	sttrb	w11, [x8, #-204]
     30c:	0c00000b 	st4	{v11.8b-v14.8b}, [x0]
     310:	213e0104 	.inst	0x213e0104 ; undefined
     314:	04210b07 	.inst	0x04210b07 ; undefined
     318:	0b3a1349 	add	w9, w26, w26, uxtb #4
     31c:	21390b3b 	.inst	0x21390b3b ; undefined
     320:	0013010e 	.inst	0x0013010e ; undefined
     324:	00260d00 	.inst	0x00260d00 ; NYI
     328:	00001349 	udf	#4937
     32c:	0300340e 	.inst	0x0300340e ; undefined
     330:	02213a08 	.inst	0x02213a08 ; undefined
     334:	0b390b3b 	add	w27, w25, w25, uxtb #2
     338:	18021349 	ldr	w9, 45a0 <GPR_FRAME_SIZE+0x44a0>
     33c:	2e0f0000 	ext	v0.8b, v0.8b, v15.8b, #0
     340:	03193f01 	.inst	0x03193f01 ; undefined
     344:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     348:	270b390b 	.inst	0x270b390b ; undefined
     34c:	3c134919 	.inst	0x3c134919 ; undefined
     350:	00130119 	.inst	0x00130119 ; undefined
     354:	010b1000 	.inst	0x010b1000 ; undefined
     358:	07120111 	.inst	0x07120111 ; undefined
     35c:	05110000 	mov	z0.b, p1/z, #0
     360:	3a080300 	adcs	w0, w24, w8
     364:	0b3b0121 	add	w1, w9, w27, uxtb
     368:	13490b39 	.inst	0x13490b39 ; undefined
     36c:	00001802 	udf	#6146
     370:	25011112 	cmpgt	p2.b, p4/z, z8.b, #1
     374:	030b130e 	.inst	0x030b130e ; undefined
     378:	111f1b1f 	add	wsp, w24, #0x7c6
     37c:	10071201 	adr	x1, e5bc <GPR_FRAME_SIZE+0xe4bc>
     380:	13000017 	sbfx	w23, w0, #0, #1
     384:	0b0b0024 	add	w4, w1, w11
     388:	08030b3e 	stxrb	w3, w30, [x25]
     38c:	35140000 	cbnz	w0, 2838c <GPR_FRAME_SIZE+0x2828c>
     390:	00134900 	.inst	0x00134900 ; undefined
     394:	01171500 	.inst	0x01171500 ; undefined
     398:	0b3a0b0b 	add	w11, w24, w26, uxtb #2
     39c:	0b390b3b 	add	w27, w25, w25, uxtb #2
     3a0:	00001301 	udf	#4865
     3a4:	3f002e16 	.inst	0x3f002e16 ; undefined
     3a8:	3a0e0319 	adcs	w25, w24, w14
     3ac:	390b3b0b 	strb	w11, [x24, #718]
     3b0:	4919270b 	.inst	0x4919270b ; undefined
     3b4:	00193c13 	.inst	0x00193c13 ; undefined
     3b8:	002e1700 	.inst	0x002e1700 ; NYI
     3bc:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     3c0:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     3c4:	19270b39 	rcwcas	x7, x25, [x25]
     3c8:	0000193c 	udf	#6460
     3cc:	3f012e18 	.inst	0x3f012e18 ; undefined
     3d0:	3a0e0319 	adcs	w25, w24, w14
     3d4:	390b3b0b 	strb	w11, [x24, #718]
     3d8:	8719270b 	.inst	0x8719270b ; undefined
     3dc:	01111901 	.inst	0x01111901 ; undefined
     3e0:	18400712 	ldr	w18, 804c0 <GPR_FRAME_SIZE+0x803c0>
     3e4:	1301197c 	sbfx	w28, w11, #1, #6
     3e8:	0b190000 	add	w0, w0, w25
     3ec:	12011101 	and	w1, w8, #0x8000000f
     3f0:	00130107 	.inst	0x00130107 ; undefined
     3f4:	01011a00 	.inst	0x01011a00 ; undefined
     3f8:	13011349 	sbfx	w9, w26, #1, #4
     3fc:	211b0000 	.inst	0x211b0000 ; undefined
     400:	2f134900 	.inst	0x2f134900 ; undefined
     404:	1c000005 	ldr	s5, 404 <GPR_FRAME_SIZE+0x304>
     408:	0e03002e 	tbl	v14.8b, {v1.16b}, v3.8b
     40c:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     410:	19270b39 	rcwcas	x7, x25, [x25]
     414:	07120111 	.inst	0x07120111 ; undefined
     418:	197c1840 	.inst	0x197c1840 ; undefined
     41c:	2e1d0000 	ext	v0.8b, v0.8b, v29.8b, #0
     420:	3a0e0301 	adcs	w1, w24, w14
     424:	390b3b0b 	strb	w11, [x24, #718]
     428:	4919270b 	.inst	0x4919270b ; undefined
     42c:	12011113 	and	w19, w8, #0x8000000f
     430:	7a184007 	.inst	0x7a184007 ; undefined
     434:	00130119 	.inst	0x00130119 ; undefined
     438:	012e1e00 	.inst	0x012e1e00 ; undefined
     43c:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     440:	0b390b3b 	add	w27, w25, w25, uxtb #2
     444:	13491927 	.inst	0x13491927 ; undefined
     448:	07120111 	.inst	0x07120111 ; undefined
     44c:	197a1840 	.inst	0x197a1840 ; undefined
     450:	01000000 	.inst	0x01000000 ; undefined
     454:	0b0b0024 	add	w4, w1, w11
     458:	0e030b3e 	.inst	0x0e030b3e ; undefined
     45c:	0d020000 	.inst	0x0d020000 ; undefined
     460:	3a0e0300 	adcs	w0, w24, w14
     464:	0b3b0321 	add	w1, w25, w27, uxtb
     468:	49082139 	.inst	0x49082139 ; undefined
     46c:	000b3813 	.inst	0x000b3813 ; undefined
     470:	00160300 	.inst	0x00160300 ; undefined
     474:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     478:	0b390b3b 	add	w27, w25, w25, uxtb #2
     47c:	00001349 	udf	#4937
     480:	25011104 	cmpge	p4.b, p4/z, z8.b, #1
     484:	030b130e 	.inst	0x030b130e ; undefined
     488:	111f1b1f 	add	wsp, w24, #0x7c6
     48c:	10071201 	adr	x1, e6cc <GPR_FRAME_SIZE+0xe5cc>
     490:	05000017 	orr	z23.s, z23.s, #0x1
     494:	0b0b0024 	add	w4, w1, w11
     498:	08030b3e 	stxrb	w3, w30, [x25]
     49c:	13060000 	sbfiz	w0, w0, #26, #1
     4a0:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     4a4:	390b3b0b 	strb	w11, [x24, #718]
     4a8:	0013010b 	.inst	0x0013010b ; undefined
     4ac:	002e0700 	.inst	0x002e0700 ; NYI
     4b0:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     4b4:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     4b8:	19270b39 	rcwcas	x7, x25, [x25]
     4bc:	193c1349 	ldclrp	x9, x28, [x26]
     4c0:	2e080000 	ext	v0.8b, v0.8b, v8.8b, #0
     4c4:	03193f01 	.inst	0x03193f01 ; undefined
     4c8:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     4cc:	270b390b 	.inst	0x270b390b ; undefined
     4d0:	11134919 	add	w25, w8, #0x4d2
     4d4:	40071201 	.inst	0x40071201 ; undefined
     4d8:	00197c18 	.inst	0x00197c18 ; undefined
     4dc:	00340900 	.inst	0x00340900 ; NYI
     4e0:	0b3a0803 	add	w3, w0, w26, uxtb #2
     4e4:	0b390b3b 	add	w27, w25, w25, uxtb #2
     4e8:	18021349 	ldr	w9, 4750 <GPR_FRAME_SIZE+0x4650>
     4ec:	340a0000 	cbz	w0, 144ec <GPR_FRAME_SIZE+0x143ec>
     4f0:	3a0e0300 	adcs	w0, w24, w14
     4f4:	390b3b0b 	strb	w11, [x24, #718]
     4f8:	0213490b 	.inst	0x0213490b ; undefined
     4fc:	00000018 	udf	#24
     500:	0b002401 	add	w1, w0, w0, lsl #9
     504:	030b3e0b 	.inst	0x030b3e0b ; undefined
     508:	0200000e 	.inst	0x0200000e ; undefined
     50c:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
     510:	3b02213a 	.inst	0x3b02213a ; undefined
     514:	490b390b 	.inst	0x490b390b ; undefined
     518:	000b3813 	.inst	0x000b3813 ; undefined
     51c:	00160300 	.inst	0x00160300 ; undefined
     520:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     524:	0b390b3b 	add	w27, w25, w25, uxtb #2
     528:	00001349 	udf	#4937
     52c:	0b011304 	add	w4, w24, w1, lsl #4
     530:	02213a0b 	.inst	0x02213a0b ; undefined
     534:	21390b3b 	.inst	0x21390b3b ; undefined
     538:	00130109 	.inst	0x00130109 ; undefined
     53c:	01110500 	.inst	0x01110500 ; undefined
     540:	0b130e25 	add	w5, w17, w19, lsl #3
     544:	1f1b1f03 	fmadd	s3, s24, s27, s7
     548:	07120111 	.inst	0x07120111 ; undefined
     54c:	00001710 	udf	#5904
     550:	0b002406 	add	w6, w0, w0, lsl #9
     554:	030b3e0b 	.inst	0x030b3e0b ; undefined
     558:	07000008 	.inst	0x07000008 ; undefined
     55c:	0803000d 	stxrb	w3, w13, [x0]
     560:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     564:	13490b39 	.inst	0x13490b39 ; undefined
     568:	00000b38 	udf	#2872
     56c:	0b000f08 	add	w8, w24, w0, lsl #3
     570:	0013490b 	.inst	0x0013490b ; undefined
     574:	012e0900 	.inst	0x012e0900 ; undefined
     578:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     57c:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     580:	19270b39 	rcwcas	x7, x25, [x25]
     584:	3c190187 	stur	b7, [x12, #-112]
     588:	00130119 	.inst	0x00130119 ; undefined
     58c:	00050a00 	.inst	0x00050a00 ; undefined
     590:	00001349 	udf	#4937
     594:	3f002e0b 	.inst	0x3f002e0b ; undefined
     598:	3a0e0319 	adcs	w25, w24, w14
     59c:	390b3b0b 	strb	w11, [x24, #718]
     5a0:	1119270b 	add	w11, w24, #0x649
     5a4:	40071201 	.inst	0x40071201 ; undefined
     5a8:	00197c18 	.inst	0x00197c18 ; undefined
     5ac:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     5b0:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     5b4:	000e030b 	.inst	0x000e030b ; undefined
     5b8:	000d0200 	.inst	0x000d0200 ; undefined
     5bc:	213a0e03 	.inst	0x213a0e03 ; undefined
     5c0:	390b3b02 	strb	w2, [x24, #718]
     5c4:	3813490b 	sttrb	w11, [x8, #-204]
     5c8:	0300000b 	.inst	0x0300000b ; undefined
     5cc:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     5d0:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     5d4:	13490b39 	.inst	0x13490b39 ; undefined
     5d8:	13040000 	sbfiz	w0, w0, #28, #1
     5dc:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     5e0:	0b3b0221 	add	w1, w17, w27, uxtb
     5e4:	01092139 	.inst	0x01092139 ; undefined
     5e8:	05000013 	orr	z19.s, z19.s, #0x1
     5ec:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
     5f0:	1f030b13 	fmadd	s19, s24, s3, s2
     5f4:	01111f1b 	.inst	0x01111f1b ; undefined
     5f8:	17100712 	b	fffffffffc402240 <__stack_el2_top+0xffffffffbadfb240>
     5fc:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
     600:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     604:	0008030b 	.inst	0x0008030b ; undefined
     608:	000d0700 	.inst	0x000d0700 ; undefined
     60c:	0b3a0803 	add	w3, w0, w26, uxtb #2
     610:	0b390b3b 	add	w27, w25, w25, uxtb #2
     614:	0b381349 	add	w9, w26, w24, uxtb #4
     618:	0f080000 	fdot	v0.2s, v0.8b, v8.4b[0]
     61c:	490b0b00 	.inst	0x490b0b00 ; undefined
     620:	09000013 	.inst	0x09000013 ; undefined
     624:	193f012e 	.inst	0x193f012e ; undefined
     628:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     62c:	0b390b3b 	add	w27, w25, w25, uxtb #2
     630:	01871927 	.inst	0x01871927 ; undefined
     634:	01193c19 	.inst	0x01193c19 ; undefined
     638:	0a000013 	and	w19, w0, w0
     63c:	13490005 	.inst	0x13490005 ; undefined
     640:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
     644:	03193f00 	.inst	0x03193f00 ; undefined
     648:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     64c:	270b390b 	.inst	0x270b390b ; undefined
     650:	12011119 	and	w25, w8, #0x8000000f
     654:	7c184007 	stur	h7, [x0, #-124]
     658:	00000019 	udf	#25
     65c:	0b002401 	add	w1, w0, w0, lsl #9
     660:	030b3e0b 	.inst	0x030b3e0b ; undefined
     664:	0200000e 	.inst	0x0200000e ; undefined
     668:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
     66c:	3b02213a 	.inst	0x3b02213a ; undefined
     670:	490b390b 	.inst	0x490b390b ; undefined
     674:	000b3813 	.inst	0x000b3813 ; undefined
     678:	00160300 	.inst	0x00160300 ; undefined
     67c:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     680:	0b390b3b 	add	w27, w25, w25, uxtb #2
     684:	00001349 	udf	#4937
     688:	0b011304 	add	w4, w24, w1, lsl #4
     68c:	02213a0b 	.inst	0x02213a0b ; undefined
     690:	21390b3b 	.inst	0x21390b3b ; undefined
     694:	00130109 	.inst	0x00130109 ; undefined
     698:	01110500 	.inst	0x01110500 ; undefined
     69c:	0b130e25 	add	w5, w17, w19, lsl #3
     6a0:	1f1b1f03 	fmadd	s3, s24, s27, s7
     6a4:	07120111 	.inst	0x07120111 ; undefined
     6a8:	00001710 	udf	#5904
     6ac:	0b002406 	add	w6, w0, w0, lsl #9
     6b0:	030b3e0b 	.inst	0x030b3e0b ; undefined
     6b4:	07000008 	.inst	0x07000008 ; undefined
     6b8:	0803000d 	stxrb	w3, w13, [x0]
     6bc:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     6c0:	13490b39 	.inst	0x13490b39 ; undefined
     6c4:	00000b38 	udf	#2872
     6c8:	0b000f08 	add	w8, w24, w0, lsl #3
     6cc:	0013490b 	.inst	0x0013490b ; undefined
     6d0:	012e0900 	.inst	0x012e0900 ; undefined
     6d4:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     6d8:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     6dc:	19270b39 	rcwcas	x7, x25, [x25]
     6e0:	3c190187 	stur	b7, [x12, #-112]
     6e4:	00130119 	.inst	0x00130119 ; undefined
     6e8:	00050a00 	.inst	0x00050a00 ; undefined
     6ec:	00001349 	udf	#4937
     6f0:	3f002e0b 	.inst	0x3f002e0b ; undefined
     6f4:	3a0e0319 	adcs	w25, w24, w14
     6f8:	390b3b0b 	strb	w11, [x24, #718]
     6fc:	1119270b 	add	w11, w24, #0x649
     700:	40071201 	.inst	0x40071201 ; undefined
     704:	00197c18 	.inst	0x00197c18 ; undefined
     708:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     70c:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     710:	000e030b 	.inst	0x000e030b ; undefined
     714:	000d0200 	.inst	0x000d0200 ; undefined
     718:	213a0e03 	.inst	0x213a0e03 ; undefined
     71c:	390b3b02 	strb	w2, [x24, #718]
     720:	3813490b 	sttrb	w11, [x8, #-204]
     724:	0300000b 	.inst	0x0300000b ; undefined
     728:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     72c:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     730:	13490b39 	.inst	0x13490b39 ; undefined
     734:	13040000 	sbfiz	w0, w0, #28, #1
     738:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     73c:	0b3b0221 	add	w1, w17, w27, uxtb
     740:	01092139 	.inst	0x01092139 ; undefined
     744:	05000013 	orr	z19.s, z19.s, #0x1
     748:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
     74c:	1f030b13 	fmadd	s19, s24, s3, s2
     750:	01111f1b 	.inst	0x01111f1b ; undefined
     754:	17100712 	b	fffffffffc40239c <__stack_el2_top+0xffffffffbadfb39c>
     758:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
     75c:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     760:	0008030b 	.inst	0x0008030b ; undefined
     764:	000d0700 	.inst	0x000d0700 ; undefined
     768:	0b3a0803 	add	w3, w0, w26, uxtb #2
     76c:	0b390b3b 	add	w27, w25, w25, uxtb #2
     770:	0b381349 	add	w9, w26, w24, uxtb #4
     774:	0f080000 	fdot	v0.2s, v0.8b, v8.4b[0]
     778:	490b0b00 	.inst	0x490b0b00 ; undefined
     77c:	09000013 	.inst	0x09000013 ; undefined
     780:	193f012e 	.inst	0x193f012e ; undefined
     784:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     788:	0b390b3b 	add	w27, w25, w25, uxtb #2
     78c:	01871927 	.inst	0x01871927 ; undefined
     790:	01193c19 	.inst	0x01193c19 ; undefined
     794:	0a000013 	and	w19, w0, w0
     798:	13490005 	.inst	0x13490005 ; undefined
     79c:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
     7a0:	03193f00 	.inst	0x03193f00 ; undefined
     7a4:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     7a8:	270b390b 	.inst	0x270b390b ; undefined
     7ac:	12011119 	and	w25, w8, #0x8000000f
     7b0:	7c184007 	stur	h7, [x0, #-124]
     7b4:	00000019 	udf	#25
     7b8:	0b002401 	add	w1, w0, w0, lsl #9
     7bc:	030b3e0b 	.inst	0x030b3e0b ; undefined
     7c0:	0200000e 	.inst	0x0200000e ; undefined
     7c4:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
     7c8:	3b02213a 	.inst	0x3b02213a ; undefined
     7cc:	490b390b 	.inst	0x490b390b ; undefined
     7d0:	000b3813 	.inst	0x000b3813 ; undefined
     7d4:	00160300 	.inst	0x00160300 ; undefined
     7d8:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     7dc:	0b390b3b 	add	w27, w25, w25, uxtb #2
     7e0:	00001349 	udf	#4937
     7e4:	0b011304 	add	w4, w24, w1, lsl #4
     7e8:	02213a0b 	.inst	0x02213a0b ; undefined
     7ec:	21390b3b 	.inst	0x21390b3b ; undefined
     7f0:	00130109 	.inst	0x00130109 ; undefined
     7f4:	01110500 	.inst	0x01110500 ; undefined
     7f8:	0b130e25 	add	w5, w17, w19, lsl #3
     7fc:	1f1b1f03 	fmadd	s3, s24, s27, s7
     800:	07120111 	.inst	0x07120111 ; undefined
     804:	00001710 	udf	#5904
     808:	0b002406 	add	w6, w0, w0, lsl #9
     80c:	030b3e0b 	.inst	0x030b3e0b ; undefined
     810:	07000008 	.inst	0x07000008 ; undefined
     814:	0803000d 	stxrb	w3, w13, [x0]
     818:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     81c:	13490b39 	.inst	0x13490b39 ; undefined
     820:	00000b38 	udf	#2872
     824:	0b000f08 	add	w8, w24, w0, lsl #3
     828:	0013490b 	.inst	0x0013490b ; undefined
     82c:	012e0900 	.inst	0x012e0900 ; undefined
     830:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     834:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     838:	19270b39 	rcwcas	x7, x25, [x25]
     83c:	3c190187 	stur	b7, [x12, #-112]
     840:	00130119 	.inst	0x00130119 ; undefined
     844:	00050a00 	.inst	0x00050a00 ; undefined
     848:	00001349 	udf	#4937
     84c:	3f002e0b 	.inst	0x3f002e0b ; undefined
     850:	3a0e0319 	adcs	w25, w24, w14
     854:	390b3b0b 	strb	w11, [x24, #718]
     858:	1119270b 	add	w11, w24, #0x649
     85c:	40071201 	.inst	0x40071201 ; undefined
     860:	00197c18 	.inst	0x00197c18 ; undefined
     864:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     868:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     86c:	000e030b 	.inst	0x000e030b ; undefined
     870:	000d0200 	.inst	0x000d0200 ; undefined
     874:	213a0e03 	.inst	0x213a0e03 ; undefined
     878:	390b3b02 	strb	w2, [x24, #718]
     87c:	3813490b 	sttrb	w11, [x8, #-204]
     880:	0300000b 	.inst	0x0300000b ; undefined
     884:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     888:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     88c:	13490b39 	.inst	0x13490b39 ; undefined
     890:	13040000 	sbfiz	w0, w0, #28, #1
     894:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     898:	0b3b0221 	add	w1, w17, w27, uxtb
     89c:	01092139 	.inst	0x01092139 ; undefined
     8a0:	05000013 	orr	z19.s, z19.s, #0x1
     8a4:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
     8a8:	1f030b13 	fmadd	s19, s24, s3, s2
     8ac:	01111f1b 	.inst	0x01111f1b ; undefined
     8b0:	17100712 	b	fffffffffc4024f8 <__stack_el2_top+0xffffffffbadfb4f8>
     8b4:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
     8b8:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     8bc:	0008030b 	.inst	0x0008030b ; undefined
     8c0:	000d0700 	.inst	0x000d0700 ; undefined
     8c4:	0b3a0803 	add	w3, w0, w26, uxtb #2
     8c8:	0b390b3b 	add	w27, w25, w25, uxtb #2
     8cc:	0b381349 	add	w9, w26, w24, uxtb #4
     8d0:	0f080000 	fdot	v0.2s, v0.8b, v8.4b[0]
     8d4:	490b0b00 	.inst	0x490b0b00 ; undefined
     8d8:	09000013 	.inst	0x09000013 ; undefined
     8dc:	193f012e 	.inst	0x193f012e ; undefined
     8e0:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     8e4:	0b390b3b 	add	w27, w25, w25, uxtb #2
     8e8:	01871927 	.inst	0x01871927 ; undefined
     8ec:	01193c19 	.inst	0x01193c19 ; undefined
     8f0:	0a000013 	and	w19, w0, w0
     8f4:	13490005 	.inst	0x13490005 ; undefined
     8f8:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
     8fc:	03193f00 	.inst	0x03193f00 ; undefined
     900:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     904:	270b390b 	.inst	0x270b390b ; undefined
     908:	12011119 	and	w25, w8, #0x8000000f
     90c:	7c184007 	stur	h7, [x0, #-124]
     910:	00000019 	udf	#25
     914:	0b002401 	add	w1, w0, w0, lsl #9
     918:	030b3e0b 	.inst	0x030b3e0b ; undefined
     91c:	0200000e 	.inst	0x0200000e ; undefined
     920:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
     924:	3b02213a 	.inst	0x3b02213a ; undefined
     928:	490b390b 	.inst	0x490b390b ; undefined
     92c:	000b3813 	.inst	0x000b3813 ; undefined
     930:	00160300 	.inst	0x00160300 ; undefined
     934:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     938:	0b390b3b 	add	w27, w25, w25, uxtb #2
     93c:	00001349 	udf	#4937
     940:	0b011304 	add	w4, w24, w1, lsl #4
     944:	02213a0b 	.inst	0x02213a0b ; undefined
     948:	21390b3b 	.inst	0x21390b3b ; undefined
     94c:	00130109 	.inst	0x00130109 ; undefined
     950:	01110500 	.inst	0x01110500 ; undefined
     954:	0b130e25 	add	w5, w17, w19, lsl #3
     958:	1f1b1f03 	fmadd	s3, s24, s27, s7
     95c:	07120111 	.inst	0x07120111 ; undefined
     960:	00001710 	udf	#5904
     964:	0b002406 	add	w6, w0, w0, lsl #9
     968:	030b3e0b 	.inst	0x030b3e0b ; undefined
     96c:	07000008 	.inst	0x07000008 ; undefined
     970:	0803000d 	stxrb	w3, w13, [x0]
     974:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     978:	13490b39 	.inst	0x13490b39 ; undefined
     97c:	00000b38 	udf	#2872
     980:	0b000f08 	add	w8, w24, w0, lsl #3
     984:	0013490b 	.inst	0x0013490b ; undefined
     988:	012e0900 	.inst	0x012e0900 ; undefined
     98c:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     990:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     994:	19270b39 	rcwcas	x7, x25, [x25]
     998:	3c190187 	stur	b7, [x12, #-112]
     99c:	00130119 	.inst	0x00130119 ; undefined
     9a0:	00050a00 	.inst	0x00050a00 ; undefined
     9a4:	00001349 	udf	#4937
     9a8:	3f002e0b 	.inst	0x3f002e0b ; undefined
     9ac:	3a0e0319 	adcs	w25, w24, w14
     9b0:	390b3b0b 	strb	w11, [x24, #718]
     9b4:	1119270b 	add	w11, w24, #0x649
     9b8:	40071201 	.inst	0x40071201 ; undefined
     9bc:	00197c18 	.inst	0x00197c18 ; undefined
     9c0:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     9c4:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     9c8:	000e030b 	.inst	0x000e030b ; undefined
     9cc:	000d0200 	.inst	0x000d0200 ; undefined
     9d0:	213a0e03 	.inst	0x213a0e03 ; undefined
     9d4:	390b3b02 	strb	w2, [x24, #718]
     9d8:	3813490b 	sttrb	w11, [x8, #-204]
     9dc:	0300000b 	.inst	0x0300000b ; undefined
     9e0:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     9e4:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     9e8:	13490b39 	.inst	0x13490b39 ; undefined
     9ec:	13040000 	sbfiz	w0, w0, #28, #1
     9f0:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     9f4:	0b3b0221 	add	w1, w17, w27, uxtb
     9f8:	01092139 	.inst	0x01092139 ; undefined
     9fc:	05000013 	orr	z19.s, z19.s, #0x1
     a00:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
     a04:	1f030b13 	fmadd	s19, s24, s3, s2
     a08:	01111f1b 	.inst	0x01111f1b ; undefined
     a0c:	17100712 	b	fffffffffc402654 <__stack_el2_top+0xffffffffbadfb654>
     a10:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
     a14:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     a18:	0008030b 	.inst	0x0008030b ; undefined
     a1c:	000d0700 	.inst	0x000d0700 ; undefined
     a20:	0b3a0803 	add	w3, w0, w26, uxtb #2
     a24:	0b390b3b 	add	w27, w25, w25, uxtb #2
     a28:	0b381349 	add	w9, w26, w24, uxtb #4
     a2c:	0f080000 	fdot	v0.2s, v0.8b, v8.4b[0]
     a30:	490b0b00 	.inst	0x490b0b00 ; undefined
     a34:	09000013 	.inst	0x09000013 ; undefined
     a38:	193f012e 	.inst	0x193f012e ; undefined
     a3c:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     a40:	0b390b3b 	add	w27, w25, w25, uxtb #2
     a44:	01871927 	.inst	0x01871927 ; undefined
     a48:	01193c19 	.inst	0x01193c19 ; undefined
     a4c:	0a000013 	and	w19, w0, w0
     a50:	13490005 	.inst	0x13490005 ; undefined
     a54:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
     a58:	03193f00 	.inst	0x03193f00 ; undefined
     a5c:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     a60:	270b390b 	.inst	0x270b390b ; undefined
     a64:	12011119 	and	w25, w8, #0x8000000f
     a68:	7c184007 	stur	h7, [x0, #-124]
     a6c:	00000019 	udf	#25
     a70:	0b002401 	add	w1, w0, w0, lsl #9
     a74:	030b3e0b 	.inst	0x030b3e0b ; undefined
     a78:	0200000e 	.inst	0x0200000e ; undefined
     a7c:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
     a80:	3b02213a 	.inst	0x3b02213a ; undefined
     a84:	490b390b 	.inst	0x490b390b ; undefined
     a88:	000b3813 	.inst	0x000b3813 ; undefined
     a8c:	00160300 	.inst	0x00160300 ; undefined
     a90:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     a94:	0b390b3b 	add	w27, w25, w25, uxtb #2
     a98:	00001349 	udf	#4937
     a9c:	0b011304 	add	w4, w24, w1, lsl #4
     aa0:	02213a0b 	.inst	0x02213a0b ; undefined
     aa4:	21390b3b 	.inst	0x21390b3b ; undefined
     aa8:	00130109 	.inst	0x00130109 ; undefined
     aac:	01110500 	.inst	0x01110500 ; undefined
     ab0:	0b130e25 	add	w5, w17, w19, lsl #3
     ab4:	1f1b1f03 	fmadd	s3, s24, s27, s7
     ab8:	07120111 	.inst	0x07120111 ; undefined
     abc:	00001710 	udf	#5904
     ac0:	0b002406 	add	w6, w0, w0, lsl #9
     ac4:	030b3e0b 	.inst	0x030b3e0b ; undefined
     ac8:	07000008 	.inst	0x07000008 ; undefined
     acc:	0803000d 	stxrb	w3, w13, [x0]
     ad0:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     ad4:	13490b39 	.inst	0x13490b39 ; undefined
     ad8:	00000b38 	udf	#2872
     adc:	0b000f08 	add	w8, w24, w0, lsl #3
     ae0:	0013490b 	.inst	0x0013490b ; undefined
     ae4:	012e0900 	.inst	0x012e0900 ; undefined
     ae8:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     aec:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     af0:	19270b39 	rcwcas	x7, x25, [x25]
     af4:	3c190187 	stur	b7, [x12, #-112]
     af8:	00130119 	.inst	0x00130119 ; undefined
     afc:	00050a00 	.inst	0x00050a00 ; undefined
     b00:	00001349 	udf	#4937
     b04:	3f002e0b 	.inst	0x3f002e0b ; undefined
     b08:	3a0e0319 	adcs	w25, w24, w14
     b0c:	390b3b0b 	strb	w11, [x24, #718]
     b10:	1119270b 	add	w11, w24, #0x649
     b14:	40071201 	.inst	0x40071201 ; undefined
     b18:	00197c18 	.inst	0x00197c18 ; undefined
     b1c:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     b20:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     b24:	000e030b 	.inst	0x000e030b ; undefined
     b28:	000d0200 	.inst	0x000d0200 ; undefined
     b2c:	213a0e03 	.inst	0x213a0e03 ; undefined
     b30:	390b3b02 	strb	w2, [x24, #718]
     b34:	3813490b 	sttrb	w11, [x8, #-204]
     b38:	0300000b 	.inst	0x0300000b ; undefined
     b3c:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     b40:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     b44:	13490b39 	.inst	0x13490b39 ; undefined
     b48:	13040000 	sbfiz	w0, w0, #28, #1
     b4c:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     b50:	0b3b0221 	add	w1, w17, w27, uxtb
     b54:	01092139 	.inst	0x01092139 ; undefined
     b58:	05000013 	orr	z19.s, z19.s, #0x1
     b5c:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
     b60:	1f030b13 	fmadd	s19, s24, s3, s2
     b64:	01111f1b 	.inst	0x01111f1b ; undefined
     b68:	17100712 	b	fffffffffc4027b0 <__stack_el2_top+0xffffffffbadfb7b0>
     b6c:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
     b70:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     b74:	0008030b 	.inst	0x0008030b ; undefined
     b78:	000d0700 	.inst	0x000d0700 ; undefined
     b7c:	0b3a0803 	add	w3, w0, w26, uxtb #2
     b80:	0b390b3b 	add	w27, w25, w25, uxtb #2
     b84:	0b381349 	add	w9, w26, w24, uxtb #4
     b88:	0f080000 	fdot	v0.2s, v0.8b, v8.4b[0]
     b8c:	490b0b00 	.inst	0x490b0b00 ; undefined
     b90:	09000013 	.inst	0x09000013 ; undefined
     b94:	193f012e 	.inst	0x193f012e ; undefined
     b98:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     b9c:	0b390b3b 	add	w27, w25, w25, uxtb #2
     ba0:	01871927 	.inst	0x01871927 ; undefined
     ba4:	01193c19 	.inst	0x01193c19 ; undefined
     ba8:	0a000013 	and	w19, w0, w0
     bac:	13490005 	.inst	0x13490005 ; undefined
     bb0:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
     bb4:	03193f00 	.inst	0x03193f00 ; undefined
     bb8:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     bbc:	270b390b 	.inst	0x270b390b ; undefined
     bc0:	12011119 	and	w25, w8, #0x8000000f
     bc4:	7c184007 	stur	h7, [x0, #-124]
     bc8:	00000019 	udf	#25
     bcc:	0b002401 	add	w1, w0, w0, lsl #9
     bd0:	030b3e0b 	.inst	0x030b3e0b ; undefined
     bd4:	0200000e 	.inst	0x0200000e ; undefined
     bd8:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
     bdc:	3b02213a 	.inst	0x3b02213a ; undefined
     be0:	490b390b 	.inst	0x490b390b ; undefined
     be4:	000b3813 	.inst	0x000b3813 ; undefined
     be8:	00160300 	.inst	0x00160300 ; undefined
     bec:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     bf0:	0b390b3b 	add	w27, w25, w25, uxtb #2
     bf4:	00001349 	udf	#4937
     bf8:	0b011304 	add	w4, w24, w1, lsl #4
     bfc:	02213a0b 	.inst	0x02213a0b ; undefined
     c00:	21390b3b 	.inst	0x21390b3b ; undefined
     c04:	00130109 	.inst	0x00130109 ; undefined
     c08:	01110500 	.inst	0x01110500 ; undefined
     c0c:	0b130e25 	add	w5, w17, w19, lsl #3
     c10:	1f1b1f03 	fmadd	s3, s24, s27, s7
     c14:	07120111 	.inst	0x07120111 ; undefined
     c18:	00001710 	udf	#5904
     c1c:	0b002406 	add	w6, w0, w0, lsl #9
     c20:	030b3e0b 	.inst	0x030b3e0b ; undefined
     c24:	07000008 	.inst	0x07000008 ; undefined
     c28:	0803000d 	stxrb	w3, w13, [x0]
     c2c:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     c30:	13490b39 	.inst	0x13490b39 ; undefined
     c34:	00000b38 	udf	#2872
     c38:	0b000f08 	add	w8, w24, w0, lsl #3
     c3c:	0013490b 	.inst	0x0013490b ; undefined
     c40:	012e0900 	.inst	0x012e0900 ; undefined
     c44:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     c48:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     c4c:	19270b39 	rcwcas	x7, x25, [x25]
     c50:	3c190187 	stur	b7, [x12, #-112]
     c54:	00130119 	.inst	0x00130119 ; undefined
     c58:	00050a00 	.inst	0x00050a00 ; undefined
     c5c:	00001349 	udf	#4937
     c60:	3f002e0b 	.inst	0x3f002e0b ; undefined
     c64:	3a0e0319 	adcs	w25, w24, w14
     c68:	390b3b0b 	strb	w11, [x24, #718]
     c6c:	1119270b 	add	w11, w24, #0x649
     c70:	40071201 	.inst	0x40071201 ; undefined
     c74:	00197c18 	.inst	0x00197c18 ; undefined
     c78:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     c7c:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     c80:	000e030b 	.inst	0x000e030b ; undefined
     c84:	000d0200 	.inst	0x000d0200 ; undefined
     c88:	213a0e03 	.inst	0x213a0e03 ; undefined
     c8c:	390b3b02 	strb	w2, [x24, #718]
     c90:	3813490b 	sttrb	w11, [x8, #-204]
     c94:	0300000b 	.inst	0x0300000b ; undefined
     c98:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     c9c:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     ca0:	13490b39 	.inst	0x13490b39 ; undefined
     ca4:	13040000 	sbfiz	w0, w0, #28, #1
     ca8:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     cac:	0b3b0221 	add	w1, w17, w27, uxtb
     cb0:	01092139 	.inst	0x01092139 ; undefined
     cb4:	05000013 	orr	z19.s, z19.s, #0x1
     cb8:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
     cbc:	1f030b13 	fmadd	s19, s24, s3, s2
     cc0:	01111f1b 	.inst	0x01111f1b ; undefined
     cc4:	17100712 	b	fffffffffc40290c <__stack_el2_top+0xffffffffbadfb90c>
     cc8:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
     ccc:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     cd0:	0008030b 	.inst	0x0008030b ; undefined
     cd4:	000d0700 	.inst	0x000d0700 ; undefined
     cd8:	0b3a0803 	add	w3, w0, w26, uxtb #2
     cdc:	0b390b3b 	add	w27, w25, w25, uxtb #2
     ce0:	0b381349 	add	w9, w26, w24, uxtb #4
     ce4:	0f080000 	fdot	v0.2s, v0.8b, v8.4b[0]
     ce8:	490b0b00 	.inst	0x490b0b00 ; undefined
     cec:	09000013 	.inst	0x09000013 ; undefined
     cf0:	193f012e 	.inst	0x193f012e ; undefined
     cf4:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     cf8:	0b390b3b 	add	w27, w25, w25, uxtb #2
     cfc:	01871927 	.inst	0x01871927 ; undefined
     d00:	01193c19 	.inst	0x01193c19 ; undefined
     d04:	0a000013 	and	w19, w0, w0
     d08:	13490005 	.inst	0x13490005 ; undefined
     d0c:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
     d10:	03193f00 	.inst	0x03193f00 ; undefined
     d14:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     d18:	270b390b 	.inst	0x270b390b ; undefined
     d1c:	12011119 	and	w25, w8, #0x8000000f
     d20:	7c184007 	stur	h7, [x0, #-124]
     d24:	00000019 	udf	#25
     d28:	0b002401 	add	w1, w0, w0, lsl #9
     d2c:	030b3e0b 	.inst	0x030b3e0b ; undefined
     d30:	0200000e 	.inst	0x0200000e ; undefined
     d34:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
     d38:	3b02213a 	.inst	0x3b02213a ; undefined
     d3c:	490b390b 	.inst	0x490b390b ; undefined
     d40:	000b3813 	.inst	0x000b3813 ; undefined
     d44:	00160300 	.inst	0x00160300 ; undefined
     d48:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     d4c:	0b390b3b 	add	w27, w25, w25, uxtb #2
     d50:	00001349 	udf	#4937
     d54:	0b011304 	add	w4, w24, w1, lsl #4
     d58:	02213a0b 	.inst	0x02213a0b ; undefined
     d5c:	21390b3b 	.inst	0x21390b3b ; undefined
     d60:	00130109 	.inst	0x00130109 ; undefined
     d64:	01110500 	.inst	0x01110500 ; undefined
     d68:	0b130e25 	add	w5, w17, w19, lsl #3
     d6c:	1f1b1f03 	fmadd	s3, s24, s27, s7
     d70:	07120111 	.inst	0x07120111 ; undefined
     d74:	00001710 	udf	#5904
     d78:	0b002406 	add	w6, w0, w0, lsl #9
     d7c:	030b3e0b 	.inst	0x030b3e0b ; undefined
     d80:	07000008 	.inst	0x07000008 ; undefined
     d84:	0803000d 	stxrb	w3, w13, [x0]
     d88:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     d8c:	13490b39 	.inst	0x13490b39 ; undefined
     d90:	00000b38 	udf	#2872
     d94:	0b000f08 	add	w8, w24, w0, lsl #3
     d98:	0013490b 	.inst	0x0013490b ; undefined
     d9c:	012e0900 	.inst	0x012e0900 ; undefined
     da0:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     da4:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     da8:	19270b39 	rcwcas	x7, x25, [x25]
     dac:	3c190187 	stur	b7, [x12, #-112]
     db0:	00130119 	.inst	0x00130119 ; undefined
     db4:	00050a00 	.inst	0x00050a00 ; undefined
     db8:	00001349 	udf	#4937
     dbc:	3f002e0b 	.inst	0x3f002e0b ; undefined
     dc0:	3a0e0319 	adcs	w25, w24, w14
     dc4:	390b3b0b 	strb	w11, [x24, #718]
     dc8:	1119270b 	add	w11, w24, #0x649
     dcc:	40071201 	.inst	0x40071201 ; undefined
     dd0:	00197c18 	.inst	0x00197c18 ; undefined
     dd4:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     dd8:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     ddc:	000e030b 	.inst	0x000e030b ; undefined
     de0:	000d0200 	.inst	0x000d0200 ; undefined
     de4:	213a0e03 	.inst	0x213a0e03 ; undefined
     de8:	390b3b02 	strb	w2, [x24, #718]
     dec:	3813490b 	sttrb	w11, [x8, #-204]
     df0:	0300000b 	.inst	0x0300000b ; undefined
     df4:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     df8:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     dfc:	13490b39 	.inst	0x13490b39 ; undefined
     e00:	13040000 	sbfiz	w0, w0, #28, #1
     e04:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     e08:	0b3b0221 	add	w1, w17, w27, uxtb
     e0c:	01092139 	.inst	0x01092139 ; undefined
     e10:	05000013 	orr	z19.s, z19.s, #0x1
     e14:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
     e18:	1f030b13 	fmadd	s19, s24, s3, s2
     e1c:	01111f1b 	.inst	0x01111f1b ; undefined
     e20:	17100712 	b	fffffffffc402a68 <__stack_el2_top+0xffffffffbadfba68>
     e24:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
     e28:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     e2c:	0008030b 	.inst	0x0008030b ; undefined
     e30:	000d0700 	.inst	0x000d0700 ; undefined
     e34:	0b3a0803 	add	w3, w0, w26, uxtb #2
     e38:	0b390b3b 	add	w27, w25, w25, uxtb #2
     e3c:	0b381349 	add	w9, w26, w24, uxtb #4
     e40:	0f080000 	fdot	v0.2s, v0.8b, v8.4b[0]
     e44:	490b0b00 	.inst	0x490b0b00 ; undefined
     e48:	09000013 	.inst	0x09000013 ; undefined
     e4c:	193f012e 	.inst	0x193f012e ; undefined
     e50:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     e54:	0b390b3b 	add	w27, w25, w25, uxtb #2
     e58:	01871927 	.inst	0x01871927 ; undefined
     e5c:	01193c19 	.inst	0x01193c19 ; undefined
     e60:	0a000013 	and	w19, w0, w0
     e64:	13490005 	.inst	0x13490005 ; undefined
     e68:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
     e6c:	03193f00 	.inst	0x03193f00 ; undefined
     e70:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     e74:	270b390b 	.inst	0x270b390b ; undefined
     e78:	12011119 	and	w25, w8, #0x8000000f
     e7c:	7c184007 	stur	h7, [x0, #-124]
     e80:	00000019 	udf	#25
     e84:	0b002401 	add	w1, w0, w0, lsl #9
     e88:	030b3e0b 	.inst	0x030b3e0b ; undefined
     e8c:	0200000e 	.inst	0x0200000e ; undefined
     e90:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
     e94:	3b02213a 	.inst	0x3b02213a ; undefined
     e98:	490b390b 	.inst	0x490b390b ; undefined
     e9c:	000b3813 	.inst	0x000b3813 ; undefined
     ea0:	00160300 	.inst	0x00160300 ; undefined
     ea4:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     ea8:	0b390b3b 	add	w27, w25, w25, uxtb #2
     eac:	00001349 	udf	#4937
     eb0:	0b011304 	add	w4, w24, w1, lsl #4
     eb4:	02213a0b 	.inst	0x02213a0b ; undefined
     eb8:	21390b3b 	.inst	0x21390b3b ; undefined
     ebc:	00130109 	.inst	0x00130109 ; undefined
     ec0:	01110500 	.inst	0x01110500 ; undefined
     ec4:	0b130e25 	add	w5, w17, w19, lsl #3
     ec8:	1f1b1f03 	fmadd	s3, s24, s27, s7
     ecc:	07120111 	.inst	0x07120111 ; undefined
     ed0:	00001710 	udf	#5904
     ed4:	0b002406 	add	w6, w0, w0, lsl #9
     ed8:	030b3e0b 	.inst	0x030b3e0b ; undefined
     edc:	07000008 	.inst	0x07000008 ; undefined
     ee0:	0803000d 	stxrb	w3, w13, [x0]
     ee4:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     ee8:	13490b39 	.inst	0x13490b39 ; undefined
     eec:	00000b38 	udf	#2872
     ef0:	0b000f08 	add	w8, w24, w0, lsl #3
     ef4:	0013490b 	.inst	0x0013490b ; undefined
     ef8:	012e0900 	.inst	0x012e0900 ; undefined
     efc:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
     f00:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     f04:	19270b39 	rcwcas	x7, x25, [x25]
     f08:	3c190187 	stur	b7, [x12, #-112]
     f0c:	00130119 	.inst	0x00130119 ; undefined
     f10:	00050a00 	.inst	0x00050a00 ; undefined
     f14:	00001349 	udf	#4937
     f18:	3f002e0b 	.inst	0x3f002e0b ; undefined
     f1c:	3a0e0319 	adcs	w25, w24, w14
     f20:	390b3b0b 	strb	w11, [x24, #718]
     f24:	1119270b 	add	w11, w24, #0x649
     f28:	40071201 	.inst	0x40071201 ; undefined
     f2c:	00197c18 	.inst	0x00197c18 ; undefined
     f30:	24010000 	cmphs	p0.b, p0/z, z0.b, z1.b
     f34:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     f38:	000e030b 	.inst	0x000e030b ; undefined
     f3c:	000d0200 	.inst	0x000d0200 ; undefined
     f40:	213a0e03 	.inst	0x213a0e03 ; undefined
     f44:	390b3b02 	strb	w2, [x24, #718]
     f48:	3813490b 	sttrb	w11, [x8, #-204]
     f4c:	0300000b 	.inst	0x0300000b ; undefined
     f50:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
     f54:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
     f58:	13490b39 	.inst	0x13490b39 ; undefined
     f5c:	13040000 	sbfiz	w0, w0, #28, #1
     f60:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
     f64:	0b3b0221 	add	w1, w17, w27, uxtb
     f68:	01092139 	.inst	0x01092139 ; undefined
     f6c:	05000013 	orr	z19.s, z19.s, #0x1
     f70:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
     f74:	1f030b13 	fmadd	s19, s24, s3, s2
     f78:	01111f1b 	.inst	0x01111f1b ; undefined
     f7c:	17100712 	b	fffffffffc402bc4 <__stack_el2_top+0xffffffffbadfbbc4>
     f80:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
     f84:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
     f88:	0008030b 	.inst	0x0008030b ; undefined
     f8c:	000d0700 	.inst	0x000d0700 ; undefined
     f90:	0b3a0803 	add	w3, w0, w26, uxtb #2
     f94:	0b390b3b 	add	w27, w25, w25, uxtb #2
     f98:	0b381349 	add	w9, w26, w24, uxtb #4
     f9c:	0f080000 	fdot	v0.2s, v0.8b, v8.4b[0]
     fa0:	490b0b00 	.inst	0x490b0b00 ; undefined
     fa4:	09000013 	.inst	0x09000013 ; undefined
     fa8:	193f012e 	.inst	0x193f012e ; undefined
     fac:	0b3a0e03 	add	w3, w16, w26, uxtb #3
     fb0:	0b390b3b 	add	w27, w25, w25, uxtb #2
     fb4:	01871927 	.inst	0x01871927 ; undefined
     fb8:	01193c19 	.inst	0x01193c19 ; undefined
     fbc:	0a000013 	and	w19, w0, w0
     fc0:	13490005 	.inst	0x13490005 ; undefined
     fc4:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
     fc8:	03193f00 	.inst	0x03193f00 ; undefined
     fcc:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
     fd0:	270b390b 	.inst	0x270b390b ; undefined
     fd4:	12011119 	and	w25, w8, #0x8000000f
     fd8:	7c184007 	stur	h7, [x0, #-124]
     fdc:	00000019 	udf	#25
     fe0:	0b002401 	add	w1, w0, w0, lsl #9
     fe4:	030b3e0b 	.inst	0x030b3e0b ; undefined
     fe8:	0200000e 	.inst	0x0200000e ; undefined
     fec:	193f002e 	.inst	0x193f002e ; undefined
     ff0:	213a0e03 	.inst	0x213a0e03 ; undefined
     ff4:	390b3b01 	strb	w1, [x24, #718]
     ff8:	19270d21 	.inst	0x19270d21 ; undefined
     ffc:	0000193c 	udf	#6460
    1000:	03000d03 	.inst	0x03000d03 ; undefined
    1004:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    1008:	490b390b 	.inst	0x490b390b ; undefined
    100c:	000b3813 	.inst	0x000b3813 ; undefined
    1010:	00160400 	.inst	0x00160400 ; undefined
    1014:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    1018:	0b390b3b 	add	w27, w25, w25, uxtb #2
    101c:	00001349 	udf	#4937
    1020:	03000505 	.inst	0x03000505 ; undefined
    1024:	01213a0e 	.inst	0x01213a0e ; undefined
    1028:	0b390b3b 	add	w27, w25, w25, uxtb #2
    102c:	18021349 	ldr	w9, 5294 <GPR_FRAME_SIZE+0x5194>
    1030:	05060000 	.inst	0x05060000 ; undefined
    1034:	3a080300 	adcs	w0, w24, w8
    1038:	0b3b0121 	add	w1, w9, w27, uxtb
    103c:	13490b39 	.inst	0x13490b39 ; undefined
    1040:	00001802 	udf	#6146
    1044:	0b011307 	add	w7, w24, w1, lsl #4
    1048:	3b0b3a0b 	.inst	0x3b0b3a0b ; undefined
    104c:	0921390b 	.inst	0x0921390b ; undefined
    1050:	00001301 	udf	#4865
    1054:	03000d08 	.inst	0x03000d08 ; undefined
    1058:	3b0b3a08 	.inst	0x3b0b3a08 ; undefined
    105c:	490b390b 	.inst	0x490b390b ; undefined
    1060:	000b3813 	.inst	0x000b3813 ; undefined
    1064:	012e0900 	.inst	0x012e0900 ; undefined
    1068:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
    106c:	3b01213a 	.inst	0x3b01213a ; undefined
    1070:	0621390b 	.inst	0x0621390b ; undefined
    1074:	01111927 	.inst	0x01111927 ; undefined
    1078:	18400712 	ldr	w18, 81158 <GPR_FRAME_SIZE+0x81058>
    107c:	1301197c 	sbfx	w28, w11, #1, #6
    1080:	340a0000 	cbz	w0, 15080 <GPR_FRAME_SIZE+0x14f80>
    1084:	3a0e0300 	adcs	w0, w24, w14
    1088:	0b3b0121 	add	w1, w9, w27, uxtb
    108c:	13490b39 	.inst	0x13490b39 ; undefined
    1090:	00001802 	udf	#6146
    1094:	2501110b 	cmpge	p11.b, p4/z, z8.b, #1
    1098:	030b130e 	.inst	0x030b130e ; undefined
    109c:	111f1b1f 	add	wsp, w24, #0x7c6
    10a0:	10071201 	adr	x1, f2e0 <GPR_FRAME_SIZE+0xf1e0>
    10a4:	0c000017 	st4	{v23.8b-v26.8b}, [x0]
    10a8:	0b0b0024 	add	w4, w1, w11
    10ac:	08030b3e 	stxrb	w3, w30, [x25]
    10b0:	0f0d0000 	fdot	v0.2s, v0.8b, v13.4b[0]
    10b4:	490b0b00 	.inst	0x490b0b00 ; undefined
    10b8:	0e000013 	tbl	v19.8b, {v0.16b}, v0.8b
    10bc:	193f012e 	.inst	0x193f012e ; undefined
    10c0:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    10c4:	0b390b3b 	add	w27, w25, w25, uxtb #2
    10c8:	01871927 	.inst	0x01871927 ; undefined
    10cc:	01193c19 	.inst	0x01193c19 ; undefined
    10d0:	0f000013 	fdot	v19.2s, v0.8b, v0.4b[0]
    10d4:	13490005 	.inst	0x13490005 ; undefined
    10d8:	2e100000 	ext	v0.8b, v0.8b, v16.8b, #0
    10dc:	03193f00 	.inst	0x03193f00 ; undefined
    10e0:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    10e4:	270b390b 	.inst	0x270b390b ; undefined
    10e8:	3c134919 	.inst	0x3c134919 ; undefined
    10ec:	11000019 	add	w25, w0, #0x0
    10f0:	193f012e 	.inst	0x193f012e ; undefined
    10f4:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    10f8:	0b390b3b 	add	w27, w25, w25, uxtb #2
    10fc:	13491927 	.inst	0x13491927 ; undefined
    1100:	07120111 	.inst	0x07120111 ; undefined
    1104:	197c1840 	.inst	0x197c1840 ; undefined
    1108:	01000000 	.inst	0x01000000 ; undefined
    110c:	0e030016 	tbl	v22.8b, {v0.16b}, v3.8b
    1110:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
    1114:	13490b39 	.inst	0x13490b39 ; undefined
    1118:	28020000 	stnp	w0, w0, [x0, #16]
    111c:	1c0e0300 	ldr	s0, 1d17c <GPR_FRAME_SIZE+0x1d07c>
    1120:	0300000b 	.inst	0x0300000b ; undefined
    1124:	0b0b0024 	add	w4, w1, w11
    1128:	0e030b3e 	.inst	0x0e030b3e ; undefined
    112c:	34040000 	cbz	w0, 912c <GPR_FRAME_SIZE+0x902c>
    1130:	3a0e0300 	adcs	w0, w24, w14
    1134:	0b3b0121 	add	w1, w9, w27, uxtb
    1138:	13490b39 	.inst	0x13490b39 ; undefined
    113c:	00001802 	udf	#6146
    1140:	03000d05 	.inst	0x03000d05 ; undefined
    1144:	02213a0e 	.inst	0x02213a0e ; undefined
    1148:	0b390b3b 	add	w27, w25, w25, uxtb #2
    114c:	00001349 	udf	#4937
    1150:	03000506 	.inst	0x03000506 ; undefined
    1154:	01213a08 	.inst	0x01213a08 ; undefined
    1158:	0b390b3b 	add	w27, w25, w25, uxtb #2
    115c:	18021349 	ldr	w9, 53c4 <GPR_FRAME_SIZE+0x52c4>
    1160:	34070000 	cbz	w0, f160 <GPR_FRAME_SIZE+0xf060>
    1164:	3a080300 	adcs	w0, w24, w8
    1168:	0b3b0121 	add	w1, w9, w27, uxtb
    116c:	13490b39 	.inst	0x13490b39 ; undefined
    1170:	00001802 	udf	#6146
    1174:	03000d08 	.inst	0x03000d08 ; undefined
    1178:	03213a0e 	.inst	0x03213a0e ; undefined
    117c:	0b390b3b 	add	w27, w25, w25, uxtb #2
    1180:	0b381349 	add	w9, w26, w24, uxtb #4
    1184:	05090000 	.inst	0x05090000 ; undefined
    1188:	3a0e0300 	adcs	w0, w24, w14
    118c:	0b3b0121 	add	w1, w9, w27, uxtb
    1190:	13490b39 	.inst	0x13490b39 ; undefined
    1194:	00001802 	udf	#6146
    1198:	3e01040a 	.inst	0x3e01040a ; undefined
    119c:	210b0721 	.inst	0x210b0721 ; undefined
    11a0:	3a134904 	.inst	0x3a134904 ; undefined
    11a4:	0b3b0221 	add	w1, w17, w27, uxtb
    11a8:	010e2139 	.inst	0x010e2139 ; undefined
    11ac:	0b000013 	add	w19, w0, w0
    11b0:	13490026 	.inst	0x13490026 ; undefined
    11b4:	130c0000 	sbfiz	w0, w0, #20, #1
    11b8:	3a0b0b01 	.inst	0x3a0b0b01 ; undefined
    11bc:	0b3b0321 	add	w1, w25, w27, uxtb
    11c0:	01092139 	.inst	0x01092139 ; undefined
    11c4:	0d000013 	st1	{v19.b}[0], [x0]
    11c8:	193f012e 	.inst	0x193f012e ; undefined
    11cc:	213a0e03 	.inst	0x213a0e03 ; undefined
    11d0:	390b3b01 	strb	w1, [x24, #718]
    11d4:	4919270b 	.inst	0x4919270b ; undefined
    11d8:	12011113 	and	w19, w8, #0x8000000f
    11dc:	7c184007 	stur	h7, [x0, #-124]
    11e0:	00130119 	.inst	0x00130119 ; undefined
    11e4:	010b0e00 	.inst	0x010b0e00 ; undefined
    11e8:	13011755 	sbfx	w21, w26, #1, #5
    11ec:	110f0000 	add	w0, w0, #0x3c0
    11f0:	130e2501 	sbfiz	w1, w8, #18, #10
    11f4:	1b1f030b 	madd	w11, w24, wzr, w0
    11f8:	1201111f 	and	wsp, w8, #0x8000000f
    11fc:	00171007 	.inst	0x00171007 ; undefined
    1200:	00241000 	.inst	0x00241000 ; NYI
    1204:	0b3e0b0b 	add	w11, w24, w30, uxtb #2
    1208:	00000803 	udf	#2051
    120c:	0b011711 	add	w17, w24, w1, lsl #5
    1210:	3b0b3a0b 	.inst	0x3b0b3a0b ; undefined
    1214:	010b390b 	.inst	0x010b390b ; undefined
    1218:	12000013 	and	w19, w0, #0x1
    121c:	0803000d 	stxrb	w3, w13, [x0]
    1220:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
    1224:	13490b39 	.inst	0x13490b39 ; undefined
    1228:	00000b38 	udf	#2872
    122c:	0b000f13 	add	w19, w24, w0, lsl #3
    1230:	0013490b 	.inst	0x0013490b ; undefined
    1234:	01011400 	.inst	0x01011400 ; undefined
    1238:	13011349 	sbfx	w9, w26, #1, #4
    123c:	21150000 	.inst	0x21150000 ; undefined
    1240:	2f134900 	.inst	0x2f134900 ; undefined
    1244:	1600000b 	b	fffffffff8001270 <__stack_el2_top+0xffffffffb69fa270>
    1248:	193f012e 	.inst	0x193f012e ; undefined
    124c:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    1250:	0b390b3b 	add	w27, w25, w25, uxtb #2
    1254:	01871927 	.inst	0x01871927 ; undefined
    1258:	01193c19 	.inst	0x01193c19 ; undefined
    125c:	17000013 	b	fffffffffc0012a8 <__stack_el2_top+0xffffffffba9fa2a8>
    1260:	13490005 	.inst	0x13490005 ; undefined
    1264:	0a180000 	and	w0, w0, w24
    1268:	3a0e0300 	adcs	w0, w24, w14
    126c:	390b3b0b 	strb	w11, [x24, #718]
    1270:	0001110b 	.inst	0x0001110b ; undefined
    1274:	010b1900 	.inst	0x010b1900 ; undefined
    1278:	07120111 	.inst	0x07120111 ; undefined
    127c:	2e1a0000 	ext	v0.8b, v0.8b, v26.8b, #0
    1280:	03193f01 	.inst	0x03193f01 ; undefined
    1284:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    1288:	270b390b 	.inst	0x270b390b ; undefined
    128c:	12011119 	and	w25, w8, #0x8000000f
    1290:	7a184007 	.inst	0x7a184007 ; undefined
    1294:	1b000019 	madd	w25, w0, w0, w0
    1298:	1755010b 	b	fffffffffd5416c4 <__stack_el2_top+0xffffffffbbf3a6c4>
    129c:	01000000 	.inst	0x01000000 ; undefined
    12a0:	0e030028 	tbl	v8.8b, {v1.16b}, v3.8b
    12a4:	00000b1c 	udf	#2844
    12a8:	03001602 	.inst	0x03001602 ; undefined
    12ac:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    12b0:	490b390b 	.inst	0x490b390b ; undefined
    12b4:	03000013 	.inst	0x03000013 ; undefined
    12b8:	13490005 	.inst	0x13490005 ; undefined
    12bc:	24040000 	cmphs	p0.b, p0/z, z0.b, z4.b
    12c0:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
    12c4:	000e030b 	.inst	0x000e030b ; undefined
    12c8:	000d0500 	.inst	0x000d0500 ; undefined
    12cc:	213a0e03 	.inst	0x213a0e03 ; undefined
    12d0:	390b3b02 	strb	w2, [x24, #718]
    12d4:	0013490b 	.inst	0x0013490b ; undefined
    12d8:	00340600 	.inst	0x00340600 ; NYI
    12dc:	213a0803 	.inst	0x213a0803 ; undefined
    12e0:	390b3b01 	strb	w1, [x24, #718]
    12e4:	0213490b 	.inst	0x0213490b ; undefined
    12e8:	07000018 	.inst	0x07000018 ; undefined
    12ec:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
    12f0:	3b03213a 	.inst	0x3b03213a ; undefined
    12f4:	490b390b 	.inst	0x490b390b ; undefined
    12f8:	000b3813 	.inst	0x000b3813 ; undefined
    12fc:	00050800 	.inst	0x00050800 ; undefined
    1300:	213a0803 	.inst	0x213a0803 ; undefined
    1304:	390b3b01 	strb	w1, [x24, #718]
    1308:	0213490b 	.inst	0x0213490b ; undefined
    130c:	09000018 	.inst	0x09000018 ; undefined
    1310:	213e0104 	.inst	0x213e0104 ; undefined
    1314:	04210b07 	.inst	0x04210b07 ; undefined
    1318:	0b3a1349 	add	w9, w26, w26, uxtb #4
    131c:	21390b3b 	.inst	0x21390b3b ; undefined
    1320:	0013010e 	.inst	0x0013010e ; undefined
    1324:	00340a00 	.inst	0x00340a00 ; NYI
    1328:	213a0803 	.inst	0x213a0803 ; undefined
    132c:	390b3b01 	strb	w1, [x24, #718]
    1330:	13491421 	.inst	0x13491421 ; undefined
    1334:	0188193f 	.inst	0x0188193f ; undefined
    1338:	0200c021 	.inst	0x0200c021 ; undefined
    133c:	0b000018 	add	w24, w0, w0
    1340:	193f012e 	.inst	0x193f012e ; undefined
    1344:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    1348:	0b390b3b 	add	w27, w25, w25, uxtb #2
    134c:	13491927 	.inst	0x13491927 ; undefined
    1350:	1301193c 	sbfx	w28, w9, #1, #6
    1354:	050c0000 	.inst	0x050c0000 ; undefined
    1358:	3a0e0300 	adcs	w0, w24, w14
    135c:	0b3b0121 	add	w1, w9, w27, uxtb
    1360:	13490b39 	.inst	0x13490b39 ; undefined
    1364:	00001802 	udf	#6146
    1368:	0b01130d 	add	w13, w24, w1, lsl #4
    136c:	03213a0b 	.inst	0x03213a0b ; undefined
    1370:	21390b3b 	.inst	0x21390b3b ; undefined
    1374:	00130109 	.inst	0x00130109 ; undefined
    1378:	000f0e00 	.inst	0x000f0e00 ; undefined
    137c:	4908210b 	.inst	0x4908210b ; undefined
    1380:	0f000013 	fdot	v19.2s, v0.8b, v0.4b[0]
    1384:	13490026 	.inst	0x13490026 ; undefined
    1388:	01100000 	.inst	0x01100000 ; undefined
    138c:	01134901 	.inst	0x01134901 ; undefined
    1390:	11000013 	add	w19, w0, #0x0
    1394:	0111010b 	.inst	0x0111010b ; undefined
    1398:	13010712 	sbfx	w18, w24, #1, #1
    139c:	0b120000 	add	w0, w0, w18
    13a0:	12011101 	and	w1, w8, #0x8000000f
    13a4:	13000007 	sbfx	w7, w0, #0, #1
    13a8:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
    13ac:	1f030b13 	fmadd	s19, s24, s3, s2
    13b0:	01111f1b 	.inst	0x01111f1b ; undefined
    13b4:	17100712 	b	fffffffffc402ffc <__stack_el2_top+0xffffffffbadfbffc>
    13b8:	24140000 	cmphs	p0.b, p0/z, z0.b, z20.b
    13bc:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
    13c0:	0008030b 	.inst	0x0008030b ; undefined
    13c4:	01171500 	.inst	0x01171500 ; undefined
    13c8:	0b3a0b0b 	add	w11, w24, w26, uxtb #2
    13cc:	0b390b3b 	add	w27, w25, w25, uxtb #2
    13d0:	00001301 	udf	#4865
    13d4:	03000d16 	.inst	0x03000d16 ; undefined
    13d8:	3b0b3a08 	.inst	0x3b0b3a08 ; undefined
    13dc:	490b390b 	.inst	0x490b390b ; undefined
    13e0:	000b3813 	.inst	0x000b3813 ; undefined
    13e4:	00211700 	.inst	0x00211700 ; NYI
    13e8:	062f1349 	.inst	0x062f1349 ; undefined
    13ec:	2e180000 	ext	v0.8b, v0.8b, v24.8b, #0
    13f0:	03193f01 	.inst	0x03193f01 ; undefined
    13f4:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    13f8:	270b390b 	.inst	0x270b390b ; undefined
    13fc:	01193c19 	.inst	0x01193c19 ; undefined
    1400:	19000013 	stlurb	w19, [x0]
    1404:	0b0b000f 	add	w15, w0, w11
    1408:	2e1a0000 	ext	v0.8b, v0.8b, v26.8b, #0
    140c:	03193f01 	.inst	0x03193f01 ; undefined
    1410:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    1414:	270b390b 	.inst	0x270b390b ; undefined
    1418:	19018719 	cpyfprn	[x25]!, [x1]!, x24!
    141c:	1301193c 	sbfx	w28, w9, #1, #6
    1420:	2e1b0000 	ext	v0.8b, v0.8b, v27.8b, #0
    1424:	03193f01 	.inst	0x03193f01 ; undefined
    1428:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    142c:	270b390b 	.inst	0x270b390b ; undefined
    1430:	12011119 	and	w25, w8, #0x8000000f
    1434:	7c184007 	stur	h7, [x0, #-124]
    1438:	00130119 	.inst	0x00130119 ; undefined
    143c:	00211c00 	.inst	0x00211c00 ; NYI
    1440:	0b2f1349 	add	w9, w26, w15, uxtb #4
    1444:	2e1d0000 	ext	v0.8b, v0.8b, v29.8b, #0
    1448:	03193f01 	.inst	0x03193f01 ; undefined
    144c:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    1450:	270b390b 	.inst	0x270b390b ; undefined
    1454:	11134919 	add	w25, w8, #0x4d2
    1458:	40071201 	.inst	0x40071201 ; undefined
    145c:	01197c18 	.inst	0x01197c18 ; undefined
    1460:	1e000013 	.inst	0x1e000013 ; undefined
    1464:	193f012e 	.inst	0x193f012e ; undefined
    1468:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    146c:	0b390b3b 	add	w27, w25, w25, uxtb #2
    1470:	13491927 	.inst	0x13491927 ; undefined
    1474:	07120111 	.inst	0x07120111 ; undefined
    1478:	197c1840 	.inst	0x197c1840 ; undefined
    147c:	01000000 	.inst	0x01000000 ; undefined
    1480:	0e030028 	tbl	v8.8b, {v1.16b}, v3.8b
    1484:	00000b1c 	udf	#2844
    1488:	03000502 	.inst	0x03000502 ; undefined
    148c:	3b0b3a08 	.inst	0x3b0b3a08 ; undefined
    1490:	490b390b 	.inst	0x490b390b ; undefined
    1494:	00180213 	.inst	0x00180213 ; undefined
    1498:	00160300 	.inst	0x00160300 ; undefined
    149c:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    14a0:	0b390b3b 	add	w27, w25, w25, uxtb #2
    14a4:	00001349 	udf	#4937
    14a8:	03003404 	.inst	0x03003404 ; undefined
    14ac:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    14b0:	490b390b 	.inst	0x490b390b ; undefined
    14b4:	00180213 	.inst	0x00180213 ; undefined
    14b8:	00340500 	.inst	0x00340500 ; NYI
    14bc:	213a0803 	.inst	0x213a0803 ; undefined
    14c0:	390b3b08 	strb	w8, [x24, #718]
    14c4:	0213490b 	.inst	0x0213490b ; undefined
    14c8:	06000018 	.inst	0x06000018 ; undefined
    14cc:	0b0b0024 	add	w4, w1, w11
    14d0:	0e030b3e 	.inst	0x0e030b3e ; undefined
    14d4:	2e070000 	ext	v0.8b, v0.8b, v7.8b, #0
    14d8:	3a0e0301 	adcs	w1, w24, w14
    14dc:	390b3b0b 	strb	w11, [x24, #718]
    14e0:	19270121 	.inst	0x19270121 ; undefined
    14e4:	07120111 	.inst	0x07120111 ; undefined
    14e8:	197a1840 	.inst	0x197a1840 ; undefined
    14ec:	00001301 	udf	#4865
    14f0:	0b011308 	add	w8, w24, w1, lsl #4
    14f4:	3b0b3a0b 	.inst	0x3b0b3a0b ; undefined
    14f8:	010b390b 	.inst	0x010b390b ; undefined
    14fc:	09000013 	.inst	0x09000013 ; undefined
    1500:	0e03000d 	tbl	v13.8b, {v0.16b}, v3.8b
    1504:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
    1508:	13490b39 	.inst	0x13490b39 ; undefined
    150c:	00000b38 	udf	#2872
    1510:	0b000f0a 	add	w10, w24, w0, lsl #3
    1514:	13490821 	.inst	0x13490821 ; undefined
    1518:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
    151c:	03193f01 	.inst	0x03193f01 ; undefined
    1520:	08213a0e 	.inst	0x08213a0e ; undefined
    1524:	21390b3b 	.inst	0x21390b3b ; undefined
    1528:	11192706 	add	w6, w24, #0x649
    152c:	40071201 	.inst	0x40071201 ; undefined
    1530:	01197c18 	.inst	0x01197c18 ; undefined
    1534:	0c000013 	st4	{v19.8b-v22.8b}, [x0]
    1538:	0803000d 	stxrb	w3, w13, [x0]
    153c:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
    1540:	13490b39 	.inst	0x13490b39 ; undefined
    1544:	00000b38 	udf	#2872
    1548:	0300050d 	.inst	0x0300050d ; undefined
    154c:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    1550:	490b390b 	.inst	0x490b390b ; undefined
    1554:	00180213 	.inst	0x00180213 ; undefined
    1558:	012e0e00 	.inst	0x012e0e00 ; undefined
    155c:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    1560:	0b390b3b 	add	w27, w25, w25, uxtb #2
    1564:	01111927 	.inst	0x01111927 ; undefined
    1568:	18400712 	ldr	w18, 81648 <GPR_FRAME_SIZE+0x81548>
    156c:	1301197c 	sbfx	w28, w11, #1, #6
    1570:	2e0f0000 	ext	v0.8b, v0.8b, v15.8b, #0
    1574:	3a0e0301 	adcs	w1, w24, w14
    1578:	390b3b0b 	strb	w11, [x24, #718]
    157c:	19270121 	.inst	0x19270121 ; undefined
    1580:	01111349 	.inst	0x01111349 ; undefined
    1584:	18400712 	ldr	w18, 81664 <GPR_FRAME_SIZE+0x81564>
    1588:	1301197a 	sbfx	w26, w11, #1, #6
    158c:	26100000 	.inst	0x26100000 ; undefined
    1590:	00134900 	.inst	0x00134900 ; undefined
    1594:	00351100 	.inst	0x00351100 ; NYI
    1598:	00001349 	udf	#4937
    159c:	11010b12 	add	w18, w24, #0x42
    15a0:	00071201 	.inst	0x00071201 ; undefined
    15a4:	01111300 	.inst	0x01111300 ; undefined
    15a8:	0b130e25 	add	w5, w17, w19, lsl #3
    15ac:	1f1b1f03 	fmadd	s3, s24, s27, s7
    15b0:	07120111 	.inst	0x07120111 ; undefined
    15b4:	00001710 	udf	#5904
    15b8:	0b002414 	add	w20, w0, w0, lsl #9
    15bc:	030b3e0b 	.inst	0x030b3e0b ; undefined
    15c0:	15000008 	b	40015e0 <GPR_FRAME_SIZE+0x40014e0>
    15c4:	0b3e0104 	add	w4, w8, w30, uxtb
    15c8:	13490b0b 	.inst	0x13490b0b ; undefined
    15cc:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
    15d0:	13010b39 	sbfx	w25, w25, #1, #2
    15d4:	2e160000 	ext	v0.8b, v0.8b, v22.8b, #0
    15d8:	03193f00 	.inst	0x03193f00 ; undefined
    15dc:	3b0b3a0e 	.inst	0x3b0b3a0e ; undefined
    15e0:	270b390b 	.inst	0x270b390b ; undefined
    15e4:	3c134919 	.inst	0x3c134919 ; undefined
    15e8:	17000019 	b	fffffffffc00164c <__stack_el2_top+0xffffffffba9fa64c>
    15ec:	193f012e 	.inst	0x193f012e ; undefined
    15f0:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    15f4:	0b390b3b 	add	w27, w25, w25, uxtb #2
    15f8:	01871927 	.inst	0x01871927 ; undefined
    15fc:	01193c19 	.inst	0x01193c19 ; undefined
    1600:	18000013 	ldr	w19, 1600 <GPR_FRAME_SIZE+0x1500>
    1604:	13490005 	.inst	0x13490005 ; undefined
    1608:	2e190000 	ext	v0.8b, v0.8b, v25.8b, #0
    160c:	3a0e0300 	adcs	w0, w24, w14
    1610:	390b3b0b 	strb	w11, [x24, #718]
    1614:	4919270b 	.inst	0x4919270b ; undefined
    1618:	12011113 	and	w19, w8, #0x8000000f
    161c:	7a184007 	.inst	0x7a184007 ; undefined
    1620:	1a000019 	adc	w25, w0, w0
    1624:	0e03012e 	tbl	v14.8b, {v9.16b}, v3.8b
    1628:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
    162c:	19270b39 	rcwcas	x7, x25, [x25]
    1630:	01111349 	.inst	0x01111349 ; undefined
    1634:	18400712 	ldr	w18, 81714 <GPR_FRAME_SIZE+0x81614>
    1638:	0000197a 	udf	#6522
    163c:	00050100 	.inst	0x00050100 ; undefined
    1640:	0b3a0803 	add	w3, w0, w26, uxtb #2
    1644:	0b390b3b 	add	w27, w25, w25, uxtb #2
    1648:	18021349 	ldr	w9, 58b0 <GPR_FRAME_SIZE+0x57b0>
    164c:	16020000 	b	fffffffff808164c <__stack_el2_top+0xffffffffb6a7a64c>
    1650:	3a0e0300 	adcs	w0, w24, w14
    1654:	390b3b0b 	strb	w11, [x24, #718]
    1658:	0013490b 	.inst	0x0013490b ; undefined
    165c:	012e0300 	.inst	0x012e0300 ; undefined
    1660:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    1664:	21390b3b 	.inst	0x21390b3b ; undefined
    1668:	11192701 	add	w1, w24, #0x649
    166c:	40071201 	.inst	0x40071201 ; undefined
    1670:	01197a18 	.inst	0x01197a18 ; undefined
    1674:	04000013 	add	z19.b, p0/m, z19.b, z0.b
    1678:	0e030034 	tbl	v20.8b, {v1.16b}, v3.8b
    167c:	3b0c213a 	.inst	0x3b0c213a ; undefined
    1680:	490b390b 	.inst	0x490b390b ; undefined
    1684:	00180213 	.inst	0x00180213 ; undefined
    1688:	00050500 	.inst	0x00050500 ; undefined
    168c:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    1690:	0b390b3b 	add	w27, w25, w25, uxtb #2
    1694:	18021349 	ldr	w9, 58fc <GPR_FRAME_SIZE+0x57fc>
    1698:	24060000 	cmphs	p0.b, p0/z, z0.b, z6.b
    169c:	3e0b0b00 	.inst	0x3e0b0b00 ; undefined
    16a0:	000e030b 	.inst	0x000e030b ; undefined
    16a4:	01130700 	.inst	0x01130700 ; undefined
    16a8:	3a04210b 	.inst	0x3a04210b ; undefined
    16ac:	390b3b0b 	strb	w11, [x24, #718]
    16b0:	13010121 	sbfiz	w1, w9, #31, #1
    16b4:	0d080000 	.inst	0x0d080000 ; undefined
    16b8:	3a080300 	adcs	w0, w24, w8
    16bc:	390b3b0b 	strb	w11, [x24, #718]
    16c0:	13490121 	.inst	0x13490121 ; undefined
    16c4:	00002138 	udf	#8504
    16c8:	000f0900 	.inst	0x000f0900 ; undefined
    16cc:	4908210b 	.inst	0x4908210b ; undefined
    16d0:	0a000013 	and	w19, w0, w0
    16d4:	13490026 	.inst	0x13490026 ; undefined
    16d8:	2e0b0000 	ext	v0.8b, v0.8b, v11.8b, #0
    16dc:	3a0e0301 	adcs	w1, w24, w14
    16e0:	390b3b0b 	strb	w11, [x24, #718]
    16e4:	19270121 	.inst	0x19270121 ; undefined
    16e8:	01111349 	.inst	0x01111349 ; undefined
    16ec:	18400712 	ldr	w18, 817cc <GPR_FRAME_SIZE+0x816cc>
    16f0:	1301197a 	sbfx	w26, w11, #1, #6
    16f4:	280c0000 	stnp	w0, w0, [x0, #96]
    16f8:	1c0e0300 	ldr	s0, 1d758 <GPR_FRAME_SIZE+0x1d658>
    16fc:	0d00000b 	st1	{v11.b}[0], [x0]
    1700:	193f012e 	.inst	0x193f012e ; undefined
    1704:	213a0e03 	.inst	0x213a0e03 ; undefined
    1708:	390b3b0c 	strb	w12, [x24, #718]
    170c:	19270621 	.inst	0x19270621 ; undefined
    1710:	07120111 	.inst	0x07120111 ; undefined
    1714:	197c1840 	.inst	0x197c1840 ; undefined
    1718:	00001301 	udf	#4865
    171c:	0300340e 	.inst	0x0300340e ; undefined
    1720:	0c213a08 	.inst	0x0c213a08 ; undefined
    1724:	0b390b3b 	add	w27, w25, w25, uxtb #2
    1728:	18021349 	ldr	w9, 5990 <GPR_FRAME_SIZE+0x5890>
    172c:	0b0f0000 	add	w0, w0, w15
    1730:	12011101 	and	w1, w8, #0x8000000f
    1734:	10000007 	adr	x7, 1734 <GPR_FRAME_SIZE+0x1634>
    1738:	0e250111 	saddl	v17.8h, v8.8b, v5.8b
    173c:	1f030b13 	fmadd	s19, s24, s3, s2
    1740:	01111f1b 	.inst	0x01111f1b ; undefined
    1744:	17100712 	b	fffffffffc40338c <__stack_el2_top+0xffffffffbadfc38c>
    1748:	35110000 	cbnz	w0, 23748 <GPR_FRAME_SIZE+0x23648>
    174c:	00134900 	.inst	0x00134900 ; undefined
    1750:	00241200 	.inst	0x00241200 ; NYI
    1754:	0b3e0b0b 	add	w11, w24, w30, uxtb #2
    1758:	00000803 	udf	#2051
    175c:	3e010413 	.inst	0x3e010413 ; undefined
    1760:	490b0b0b 	.inst	0x490b0b0b ; undefined
    1764:	3b0b3a13 	.inst	0x3b0b3a13 ; undefined
    1768:	010b390b 	.inst	0x010b390b ; undefined
    176c:	14000013 	b	17b8 <GPR_FRAME_SIZE+0x16b8>
    1770:	13490101 	.inst	0x13490101 ; undefined
    1774:	00001301 	udf	#4865
    1778:	49002115 	.inst	0x49002115 ; undefined
    177c:	000b2f13 	.inst	0x000b2f13 ; undefined
    1780:	012e1600 	.inst	0x012e1600 ; undefined
    1784:	0e03193f 	uzp1	v31.8b, v9.8b, v3.8b
    1788:	0b3b0b3a 	add	w26, w25, w27, uxtb #2
    178c:	19270b39 	rcwcas	x7, x25, [x25]
    1790:	01111349 	.inst	0x01111349 ; undefined
    1794:	18400712 	ldr	w18, 81874 <GPR_FRAME_SIZE+0x81774>
    1798:	1301197c 	sbfx	w28, w11, #1, #6
    179c:	2e170000 	ext	v0.8b, v0.8b, v23.8b, #0
    17a0:	3a0e0301 	adcs	w1, w24, w14
    17a4:	390b3b0b 	strb	w11, [x24, #718]
    17a8:	4919270b 	.inst	0x4919270b ; undefined
    17ac:	12011113 	and	w19, w8, #0x8000000f
    17b0:	7c184007 	stur	h7, [x0, #-124]
    17b4:	00130119 	.inst	0x00130119 ; undefined
    17b8:	012e1800 	.inst	0x012e1800 ; undefined
    17bc:	0b3a0e03 	add	w3, w16, w26, uxtb #3
    17c0:	0b390b3b 	add	w27, w25, w25, uxtb #2
    17c4:	01111927 	.inst	0x01111927 ; undefined
    17c8:	18400712 	ldr	w18, 818a8 <GPR_FRAME_SIZE+0x817a8>
    17cc:	0000197a 	udf	#6522
	...

Disassembly of section .debug_aranges:

0000000000000000 <.debug_aranges>:
   0:	0000002c 	udf	#44
   4:	00000002 	udf	#2
   8:	00080000 	.inst	0x00080000 ; undefined
   c:	00000000 	udf	#0
  10:	40000048 	.inst	0x40000048 ; undefined
  14:	00000000 	udf	#0
  18:	00000024 	udf	#36
	...
  30:	0000003c 	udf	#60
  34:	00280002 	.inst	0x00280002 ; NYI
  38:	00080000 	.inst	0x00080000 ; undefined
  3c:	00000000 	udf	#0
  40:	40000070 	.inst	0x40000070 ; undefined
  44:	00000000 	udf	#0
  48:	00000910 	udf	#2320
  4c:	00000000 	udf	#0
  50:	40004000 	.inst	0x40004000 ; undefined
  54:	00000000 	udf	#0
  58:	00000784 	udf	#1924
	...
  70:	0000002c 	udf	#44
  74:	004b0002 	.inst	0x004b0002 ; undefined
  78:	00080000 	.inst	0x00080000 ; undefined
  7c:	00000000 	udf	#0
  80:	40000980 	.inst	0x40000980 ; undefined
  84:	00000000 	udf	#0
  88:	00000068 	udf	#104
	...
  a0:	0000002c 	udf	#44
  a4:	00730002 	.inst	0x00730002 ; undefined
  a8:	00080000 	.inst	0x00080000 ; undefined
  ac:	00000000 	udf	#0
  b0:	400009f0 	.inst	0x400009f0 ; undefined
  b4:	00000000 	udf	#0
  b8:	00000250 	udf	#592
	...
  d0:	0000002c 	udf	#44
  d4:	009c0002 	.inst	0x009c0002 ; undefined
  d8:	00080000 	.inst	0x00080000 ; undefined
  dc:	00000000 	udf	#0
  e0:	40000c40 	.inst	0x40000c40 ; undefined
  e4:	00000000 	udf	#0
  e8:	00000058 	udf	#88
	...
 100:	0000002c 	udf	#44
 104:	00c40002 	.inst	0x00c40002 ; undefined
 108:	00080000 	.inst	0x00080000 ; undefined
 10c:	00000000 	udf	#0
 110:	40000000 	.inst	0x40000000 ; undefined
 114:	00000000 	udf	#0
 118:	00000048 	udf	#72
	...
 130:	0000002c 	udf	#44
 134:	00ec0002 	.inst	0x00ec0002 ; undefined
 138:	00080000 	.inst	0x00080000 ; undefined
 13c:	00000000 	udf	#0
 140:	40000c98 	.inst	0x40000c98 ; undefined
 144:	00000000 	udf	#0
 148:	00000394 	udf	#916
	...
 160:	0000002c 	udf	#44
 164:	05f70002 	.inst	0x05f70002 ; undefined
 168:	00080000 	.inst	0x00080000 ; undefined
 16c:	00000000 	udf	#0
 170:	4000102c 	.inst	0x4000102c ; undefined
 174:	00000000 	udf	#0
 178:	00000230 	udf	#560
	...
 190:	0000002c 	udf	#44
 194:	0ae90002 	bic	w2, w0, w9, ror #0
 198:	00080000 	.inst	0x00080000 ; undefined
 19c:	00000000 	udf	#0
 1a0:	4000125c 	.inst	0x4000125c ; undefined
 1a4:	00000000 	udf	#0
 1a8:	00000058 	udf	#88
	...
 1c0:	0000002c 	udf	#44
 1c4:	0bff0002 	.inst	0x0bff0002 ; undefined
 1c8:	00080000 	.inst	0x00080000 ; undefined
 1cc:	00000000 	udf	#0
 1d0:	400012b4 	.inst	0x400012b4 ; undefined
 1d4:	00000000 	udf	#0
 1d8:	0000004c 	udf	#76
	...
 1f0:	0000002c 	udf	#44
 1f4:	0d1e0002 	.inst	0x0d1e0002 ; undefined
 1f8:	00080000 	.inst	0x00080000 ; undefined
 1fc:	00000000 	udf	#0
 200:	40001300 	.inst	0x40001300 ; undefined
 204:	00000000 	udf	#0
 208:	0000004c 	udf	#76
	...
 220:	0000002c 	udf	#44
 224:	0e3d0002 	saddl	v2.8h, v0.8b, v29.8b
 228:	00080000 	.inst	0x00080000 ; undefined
 22c:	00000000 	udf	#0
 230:	4000134c 	.inst	0x4000134c ; undefined
 234:	00000000 	udf	#0
 238:	0000004c 	udf	#76
	...
 250:	0000002c 	udf	#44
 254:	0f5c0002 	fdot	v2.4h, v0.8b, v12.2b[1]
 258:	00080000 	.inst	0x00080000 ; undefined
 25c:	00000000 	udf	#0
 260:	40001398 	.inst	0x40001398 ; undefined
 264:	00000000 	udf	#0
 268:	0000004c 	udf	#76
	...
 280:	0000002c 	udf	#44
 284:	107b0002 	adr	x2, f6284 <GPR_FRAME_SIZE+0xf6184>
 288:	00080000 	.inst	0x00080000 ; undefined
 28c:	00000000 	udf	#0
 290:	400013e4 	.inst	0x400013e4 ; undefined
 294:	00000000 	udf	#0
 298:	0000004c 	udf	#76
	...
 2b0:	0000002c 	udf	#44
 2b4:	119a0002 	.inst	0x119a0002 ; undefined
 2b8:	00080000 	.inst	0x00080000 ; undefined
 2bc:	00000000 	udf	#0
 2c0:	40001430 	.inst	0x40001430 ; undefined
 2c4:	00000000 	udf	#0
 2c8:	0000004c 	udf	#76
	...
 2e0:	0000002c 	udf	#44
 2e4:	12b90002 	mov	w2, #0x37ffffff            	// #939524095
 2e8:	00080000 	.inst	0x00080000 ; undefined
 2ec:	00000000 	udf	#0
 2f0:	4000147c 	.inst	0x4000147c ; undefined
 2f4:	00000000 	udf	#0
 2f8:	0000004c 	udf	#76
	...
 310:	0000002c 	udf	#44
 314:	13d80002 	.inst	0x13d80002 ; undefined
 318:	00080000 	.inst	0x00080000 ; undefined
 31c:	00000000 	udf	#0
 320:	400014c8 	.inst	0x400014c8 ; undefined
 324:	00000000 	udf	#0
 328:	0000004c 	udf	#76
	...
 340:	0000002c 	udf	#44
 344:	14f70002 	b	3dc034c <GPR_FRAME_SIZE+0x3dc024c>
 348:	00080000 	.inst	0x00080000 ; undefined
 34c:	00000000 	udf	#0
 350:	40001514 	.inst	0x40001514 ; undefined
 354:	00000000 	udf	#0
 358:	0000004c 	udf	#76
	...
 370:	0000002c 	udf	#44
 374:	16160002 	b	fffffffff858037c <__stack_el2_top+0xffffffffb6f7937c>
 378:	00080000 	.inst	0x00080000 ; undefined
 37c:	00000000 	udf	#0
 380:	40001560 	.inst	0x40001560 ; undefined
 384:	00000000 	udf	#0
 388:	0000004c 	udf	#76
	...
 3a0:	0000002c 	udf	#44
 3a4:	17350002 	b	fffffffffcd403ac <__stack_el2_top+0xffffffffbb7393ac>
 3a8:	00080000 	.inst	0x00080000 ; undefined
 3ac:	00000000 	udf	#0
 3b0:	400015ac 	.inst	0x400015ac ; undefined
 3b4:	00000000 	udf	#0
 3b8:	0000004c 	udf	#76
	...
 3d0:	0000002c 	udf	#44
 3d4:	18540002 	ldr	w2, a83d4 <GPR_FRAME_SIZE+0xa82d4>
 3d8:	00080000 	.inst	0x00080000 ; undefined
 3dc:	00000000 	udf	#0
 3e0:	400015f8 	.inst	0x400015f8 ; undefined
 3e4:	00000000 	udf	#0
 3e8:	0000004c 	udf	#76
	...
 400:	0000002c 	udf	#44
 404:	19730002 	.inst	0x19730002 ; undefined
 408:	00080000 	.inst	0x00080000 ; undefined
 40c:	00000000 	udf	#0
 410:	40001644 	.inst	0x40001644 ; undefined
 414:	00000000 	udf	#0
 418:	0000004c 	udf	#76
	...
 430:	0000002c 	udf	#44
 434:	1a920002 	csel	w2, w0, w18, eq	// eq = none
 438:	00080000 	.inst	0x00080000 ; undefined
 43c:	00000000 	udf	#0
 440:	40001690 	.inst	0x40001690 ; undefined
 444:	00000000 	udf	#0
 448:	0000004c 	udf	#76
	...
 460:	0000002c 	udf	#44
 464:	1bb10002 	.inst	0x1bb10002 ; undefined
 468:	00080000 	.inst	0x00080000 ; undefined
 46c:	00000000 	udf	#0
 470:	400016dc 	.inst	0x400016dc ; undefined
 474:	00000000 	udf	#0
 478:	0000004c 	udf	#76
	...
 490:	0000002c 	udf	#44
 494:	1cd00002 	ldr	s2, fffffffffffa0494 <__stack_el2_top+0xffffffffbe999494>
 498:	00080000 	.inst	0x00080000 ; undefined
 49c:	00000000 	udf	#0
 4a0:	40001728 	.inst	0x40001728 ; undefined
 4a4:	00000000 	udf	#0
 4a8:	0000004c 	udf	#76
	...
 4c0:	0000002c 	udf	#44
 4c4:	1def0002 	.inst	0x1def0002 ; undefined
 4c8:	00080000 	.inst	0x00080000 ; undefined
 4cc:	00000000 	udf	#0
 4d0:	40001774 	.inst	0x40001774 ; undefined
 4d4:	00000000 	udf	#0
 4d8:	00000290 	udf	#656
	...
 4f0:	0000002c 	udf	#44
 4f4:	20a20002 	.inst	0x20a20002 ; undefined
 4f8:	00080000 	.inst	0x00080000 ; undefined
 4fc:	00000000 	udf	#0
 500:	40001a04 	.inst	0x40001a04 ; undefined
 504:	00000000 	udf	#0
 508:	000007cc 	udf	#1996
	...
 520:	0000002c 	udf	#44
 524:	24e30002 	cmphs	p2.d, p0/z, z0.d, #12
 528:	00080000 	.inst	0x00080000 ; undefined
 52c:	00000000 	udf	#0
 530:	400021d0 	.inst	0x400021d0 ; undefined
 534:	00000000 	udf	#0
 538:	000003f8 	udf	#1016
	...
 550:	0000002c 	udf	#44
 554:	29b00002 	stp	w2, w0, [x0, #-128]!
 558:	00080000 	.inst	0x00080000 ; undefined
 55c:	00000000 	udf	#0
 560:	400025c8 	.inst	0x400025c8 ; undefined
 564:	00000000 	udf	#0
 568:	00000a20 	udf	#2592
	...
 580:	0000002c 	udf	#44
 584:	38ee0002 	ldaddalb	w14, w2, [x0]
 588:	00080000 	.inst	0x00080000 ; undefined
 58c:	00000000 	udf	#0
 590:	40002fe8 	.inst	0x40002fe8 ; undefined
 594:	00000000 	udf	#0
 598:	00000830 	udf	#2096
	...

Disassembly of section .debug_str:

0000000000000000 <.debug_str>:
       0:	6372735f 	.inst	0x6372735f ; undefined
       4:	6d72612f 	ldp	d15, d24, [x9, #-224]
       8:	7379732f 	.inst	0x7379732f ; undefined
       c:	73676572 	.inst	0x73676572 ; undefined
      10:	2f00532e 	.inst	0x2f00532e ; undefined
      14:	656d6f68 	fnmls	z8.h, p3/m, z27.h, z13.h
      18:	616e752f 	.inst	0x616e752f ; undefined
      1c:	69662f62 	ldpsw	x2, x11, [x27, #-208]
      20:	2f73656c 	.inst	0x2f73656c ; undefined
      24:	7473616d 	.inst	0x7473616d ; undefined
      28:	742f7265 	.inst	0x742f7265 ; undefined
      2c:	692f6d66 	stgp	x6, x27, [x11, #-544]
      30:	6d38786d 	stp	d13, d30, [x3, #-128]
      34:	72702f70 	.inst	0x72702f70 ; undefined
      38:	63656a6f 	.inst	0x63656a6f ; undefined
      3c:	4e470074 	.inst	0x4e470074 ; undefined
      40:	53412055 	.inst	0x53412055 ; undefined
      44:	342e3220 	cbz	w0, 5c688 <GPR_FRAME_SIZE+0x5c588>
      48:	00312e33 	.inst	0x00312e33 ; NYI
      4c:	6372735f 	.inst	0x6372735f ; undefined
      50:	6d72612f 	ldp	d15, d24, [x9, #-224]
      54:	6378652f 	.inst	0x6378652f ; undefined
      58:	69747065 	ldpsw	x5, x28, [x3, #-96]
      5c:	2f736e6f 	.inst	0x2f736e6f ; undefined
      60:	5f326c65 	.inst	0x5f326c65 ; undefined
      64:	74636576 	.inst	0x74636576 ; undefined
      68:	2e73726f 	uabdl	v15.4s, v19.4h, v19.4h
      6c:	735f0053 	.inst	0x735f0053 ; undefined
      70:	612f6372 	.inst	0x612f6372 ; undefined
      74:	652f6d72 	.inst	0x652f6d72 ; undefined
      78:	70656378 	adr	x24, cace7 <GPR_FRAME_SIZE+0xcabe7>
      7c:	6e6f6974 	.inst	0x6e6f6974 ; undefined
      80:	78652f73 	.inst	0x78652f73 ; undefined
      84:	74706563 	.inst	0x74706563 ; undefined
      88:	736e6f69 	.inst	0x736e6f69 ; undefined
      8c:	5f00532e 	fmls	h14, h25, v0.h[0]
      90:	2f637273 	fcmla	v19.4h, v19.4h, v3.h[1], #270
      94:	2f62696c 	umlsl	v12.4s, v11.4h, v2.h[6]
      98:	636d656d 	.inst	0x636d656d ; undefined
      9c:	6d2f7970 	stp	d16, d30, [x11, #-272]
      a0:	70636d65 	adr	x5, c6e4f <GPR_FRAME_SIZE+0xc6d4f>
      a4:	00532e79 	.inst	0x00532e79 ; undefined
      a8:	6372735f 	.inst	0x6372735f ; undefined
      ac:	6f6f622f 	umlsl2	v15.4s, v17.8h, v15.h[2]
      b0:	6c632f74 	ldnp	d20, d11, [x27, #-464]
      b4:	5f6e6165 	.inst	0x5f6e6165 ; undefined
      b8:	2e737362 	uabdl	v2.4s, v27.4h, v19.4h
      bc:	735f0053 	.inst	0x735f0053 ; undefined
      c0:	622f6372 	.inst	0x622f6372 ; undefined
      c4:	2f746f6f 	.inst	0x2f746f6f ; undefined
      c8:	746f6f62 	.inst	0x746f6f62 ; undefined
      cc:	6d00532e 	stp	d14, d20, [x25]
      d0:	61737365 	.inst	0x61737365 ; undefined
      d4:	53006567 	ubfx	w7, w11, #0, #26
      d8:	4e494454 	.inst	0x4e494454 ; undefined
      dc:	4e495f54 	.inst	0x4e495f54 ; undefined
      e0:	00343654 	.inst	0x00343654 ; NYI
      e4:	49445453 	.inst	0x49445453 ; undefined
      e8:	425f544e 	.inst	0x425f544e ; undefined
      ec:	5f455341 	.inst	0x5f455341 ; undefined
      f0:	52504552 	.inst	0x52504552 ; undefined
      f4:	43584500 	.inst	0x43584500 ; undefined
      f8:	49545045 	.inst	0x49545045 ; undefined
      fc:	535f4e4f 	.inst	0x535f4e4f ; undefined
     100:	55544154 	.inst	0x55544154 ; undefined
     104:	54530053 	bc.cc	a610c <GPR_FRAME_SIZE+0xa600c>  // bc.lo, bc.ul, bc.last
     108:	544e4944 	b.mi	9ca30 <GPR_FRAME_SIZE+0x9c930>  // b.first
     10c:	5341425f 	.inst	0x5341425f ; undefined
     110:	45525f45 	usubwt	z5.h, z26.h, z18.b
     114:	4f5f5250 	.inst	0x4f5f5250 ; undefined
     118:	6c005443 	stnp	d3, d21, [x2]
     11c:	7461636f 	.inst	0x7461636f ; undefined
     120:	006e6f69 	.inst	0x006e6f69 ; undefined
     124:	746e6975 	.inst	0x746e6975 ; undefined
     128:	69003436 	stgp	x22, x13, [x1]
     12c:	5f74696e 	.inst	0x5f74696e ; undefined
     130:	696e6170 	ldpsw	x16, x24, [x11, #-144]
     134:	68730063 	.inst	0x68730063 ; undefined
     138:	2074726f 	.inst	0x2074726f ; undefined
     13c:	69736e75 	ldpsw	x21, x27, [x19, #-104]
     140:	64656e67 	.inst	0x64656e67 ; undefined
     144:	746e6920 	.inst	0x746e6920 ; undefined
     148:	74657300 	.inst	0x74657300 ; undefined
     14c:	646e615f 	.inst	0x646e615f ; undefined
     150:	7268745f 	.inst	0x7268745f ; undefined
     154:	705f776f 	adr	x15, bf043 <GPR_FRAME_SIZE+0xbef43>
     158:	63696e61 	.inst	0x63696e61 ; undefined
     15c:	73696400 	.inst	0x73696400 ; undefined
     160:	656c6261 	fnmls	z1.h, p0/m, z19.h, z12.h
     164:	54530064 	b.mi	a6170 <GPR_FRAME_SIZE+0xa6070>  // b.first
     168:	544e4944 	b.mi	9ca90 <GPR_FRAME_SIZE+0x9c990>  // b.first
     16c:	5341425f 	.inst	0x5341425f ; undefined
     170:	45525f45 	usubwt	z5.h, z26.h, z18.b
     174:	445f5250 	smlslb	z16.h, z18.b, z31.b
     178:	70004345 	adr	x5, 9e3 <GPR_FRAME_SIZE+0x8e3>
     17c:	63696e61 	.inst	0x63696e61 ; undefined
     180:	73656d5f 	.inst	0x73656d5f ; undefined
     184:	65676173 	fnmls	z19.h, p0/m, z11.h, z7.h
     188:	6675625f 	.inst	0x6675625f ; undefined
     18c:	00726566 	.inst	0x00726566 ; undefined
     190:	75626564 	.inst	0x75626564 ; undefined
     194:	41550067 	.inst	0x41550067 ; undefined
     198:	495f5452 	.inst	0x495f5452 ; undefined
     19c:	00325f44 	.inst	0x00325f44 ; NYI
     1a0:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
     1a4:	6f697470 	uqshl	v16.2d, v3.2d, #41
     1a8:	675f736e 	.inst	0x675f736e ; undefined
     1ac:	735f7465 	.inst	0x735f7465 ; undefined
     1b0:	75746174 	.inst	0x75746174 ; undefined
     1b4:	4e470073 	.inst	0x4e470073 ; undefined
     1b8:	32432055 	.inst	0x32432055 ; undefined
     1bc:	34312033 	cbz	w19, 625c0 <GPR_FRAME_SIZE+0x624c0>
     1c0:	312e322e 	adds	w14, w17, #0xb8c
     1c4:	32303220 	orr	w0, w17, #0x1fff0000
     1c8:	31313134 	adds	w20, w9, #0xc4c
     1cc:	6d2d2039 	stp	d25, d8, [x1, #-304]
     1d0:	68637261 	.inst	0x68637261 ; undefined
     1d4:	6d72613d 	ldp	d29, d24, [x9, #-224]
     1d8:	612d3876 	.inst	0x612d3876 ; undefined
     1dc:	636d2d20 	.inst	0x636d2d20 ; undefined
     1e0:	633d7570 	.inst	0x633d7570 ; undefined
     1e4:	6574726f 	fnmls	z15.h, p4/m, z19.h, z20.h
     1e8:	35612d78 	cbnz	w24, c2794 <GPR_FRAME_SIZE+0xc2694>
     1ec:	69732b33 	ldpsw	x19, x10, [x25, #-104]
     1f0:	2d20646d 	stp	s13, s25, [x3, #-256]
     1f4:	74696c6d 	.inst	0x74696c6d ; undefined
     1f8:	2d656c74 	ldp	s20, s27, [x3, #-216]
     1fc:	69646e65 	ldpsw	x5, x27, [x19, #-224]
     200:	2d206e61 	stp	s1, s27, [x19, #-256]
     204:	6962616d 	ldpsw	x13, x24, [x11, #-240]
     208:	36706c3d 	tbz	w29, #14, f8c <GPR_FRAME_SIZE+0xe8c>
     20c:	672d2034 	.inst	0x672d2034 ; undefined
     210:	304f2d20 	adr	x0, 9e7b5 <GPR_FRAME_SIZE+0x9e6b5>
     214:	74732d20 	.inst	0x74732d20 ; undefined
     218:	6e673d64 	cmhs	v4.8h, v11.8h, v7.8h
     21c:	20333275 	.inst	0x20333275 ; undefined
     220:	7266662d 	.inst	0x7266662d ; undefined
     224:	74736565 	.inst	0x74736565 ; undefined
     228:	69646e61 	ldpsw	x1, x27, [x19, #-224]
     22c:	6600676e 	.inst	0x6600676e ; undefined
     230:	00656c69 	.inst	0x00656c69 ; undefined
     234:	72726573 	.inst	0x72726573 ; undefined
     238:	7500726f 	.inst	0x7500726f ; undefined
     23c:	6769736e 	.inst	0x6769736e ; undefined
     240:	2064656e 	.inst	0x2064656e ; undefined
     244:	72616863 	.inst	0x72616863 ; undefined
     248:	616e6500 	.inst	0x616e6500 ; undefined
     24c:	64656c62 	.inst	0x64656c62 ; undefined
     250:	6e697500 	uabd	v0.8h, v8.8h, v9.8h
     254:	53003874 	ubfx	w20, w3, #0, #15
     258:	4e494454 	.inst	0x4e494454 ; undefined
     25c:	4e495f54 	.inst	0x4e495f54 ; undefined
     260:	00363154 	.inst	0x00363154 ; NYI
     264:	49445453 	.inst	0x49445453 ; undefined
     268:	495f544e 	.inst	0x495f544e ; undefined
     26c:	3233544e 	orr	w14, w2, #0xffffe007
     270:	4e415000 	luti4	v0.8h, {v0.8h-v1.8h}, v1[2]
     274:	435f4349 	.inst	0x435f4349 ; undefined
     278:	55004c4f 	.inst	0x55004c4f ; undefined
     27c:	5f545241 	.inst	0x5f545241 ; undefined
     280:	53004449 	ubfx	w9, w2, #0, #18
     284:	4e494454 	.inst	0x4e494454 ; undefined
     288:	49555f54 	.inst	0x49555f54 ; undefined
     28c:	3631544e 	tbz	w14, #6, 2d14 <GPR_FRAME_SIZE+0x2c14>
     290:	6e697500 	uabd	v0.8h, v8.8h, v9.8h
     294:	00363174 	.inst	0x00363174 ; NYI
     298:	49445453 	.inst	0x49445453 ; undefined
     29c:	495f544e 	.inst	0x495f544e ; undefined
     2a0:	0038544e 	.inst	0x0038544e ; NYI
     2a4:	5f676f6c 	.inst	0x5f676f6c ; undefined
     2a8:	74737973 	.inst	0x74737973 ; undefined
     2ac:	695f6d65 	ldpsw	x5, x27, [x11, #248]
     2b0:	006f666e 	.inst	0x006f666e ; undefined
     2b4:	49445453 	.inst	0x49445453 ; undefined
     2b8:	555f544e 	.inst	0x555f544e ; undefined
     2bc:	33544e49 	.inst	0x33544e49 ; undefined
     2c0:	54530032 	bc.cs	a62c4 <GPR_FRAME_SIZE+0xa61c4>  // bc.hs, bc.nlast
     2c4:	544e4944 	b.mi	9cbec <GPR_FRAME_SIZE+0x9caec>  // b.first
     2c8:	494e555f 	.inst	0x494e555f ; undefined
     2cc:	75004e4f 	.inst	0x75004e4f ; undefined
     2d0:	33746e69 	.inst	0x33746e69 ; undefined
     2d4:	74730032 	.inst	0x74730032 ; undefined
     2d8:	706f6372 	adr	x18, def47 <GPR_FRAME_SIZE+0xdee47>
     2dc:	41500079 	.inst	0x41500079 ; undefined
     2e0:	5f43494e 	.inst	0x5f43494e ; undefined
     2e4:	5353454d 	.inst	0x5353454d ; undefined
     2e8:	5f454741 	.inst	0x5f454741 ; undefined
     2ec:	5f465542 	shl	d2, d10, #6
     2f0:	455a4953 	uaddwb	z19.h, z10.h, z26.b
     2f4:	6e617000 	uabdl2	v0.4s, v0.8h, v1.8h
     2f8:	695f6369 	ldpsw	x9, x24, [x27, #248]
     2fc:	006f666e 	.inst	0x006f666e ; undefined
     300:	69647473 	ldpsw	x19, x29, [x3, #-224]
     304:	745f746e 	.inst	0x745f746e ; undefined
     308:	73615f6f 	.inst	0x73615f6f ; undefined
     30c:	00696963 	.inst	0x00696963 ; undefined
     310:	676e6f6c 	.inst	0x676e6f6c ; undefined
     314:	6e6f6c20 	umin	v0.8h, v1.8h, v15.8h
     318:	6e752067 	usubl2	v7.4s, v3.8h, v21.8h
     31c:	6e676973 	.inst	0x6e676973 ; undefined
     320:	69206465 	stgp	x5, x25, [x3, #-1024]
     324:	6c00746e 	stnp	d14, d29, [x3]
     328:	00656e69 	.inst	0x00656e69 ; undefined
     32c:	5f746573 	.inst	0x5f746573 ; undefined
     330:	696e6170 	ldpsw	x16, x24, [x11, #-144]
     334:	54530063 	b.cc	a6340 <GPR_FRAME_SIZE+0xa6240>  // b.lo, b.ul, b.last
     338:	544e4944 	b.mi	9cc60 <GPR_FRAME_SIZE+0x9cb60>  // b.first
     33c:	4e49555f 	.inst	0x4e49555f ; undefined
     340:	50003854 	adr	x20, a4a <GPR_FRAME_SIZE+0x94a>
     344:	43494e41 	.inst	0x43494e41 ; undefined
     348:	4c49465f 	.inst	0x4c49465f ; undefined
     34c:	55425f45 	.inst	0x55425f45 ; undefined
     350:	54505f46 	b.vs	a0f38 <GPR_FRAME_SIZE+0xa0e38>
     354:	54530052 	bc.cs	a635c <GPR_FRAME_SIZE+0xa625c>  // bc.hs, bc.nlast
     358:	544e4944 	b.mi	9cc80 <GPR_FRAME_SIZE+0x9cb80>  // b.first
     35c:	5341425f 	.inst	0x5341425f ; undefined
     360:	45525f45 	usubwt	z5.h, z26.h, z18.b
     364:	425f5250 	.inst	0x425f5250 ; undefined
     368:	6c004e49 	stnp	d9, d19, [x18]
     36c:	20676e6f 	.inst	0x20676e6f ; undefined
     370:	676e6f6c 	.inst	0x676e6f6c ; undefined
     374:	746e6920 	.inst	0x746e6920 ; undefined
     378:	44545300 	smlslb	z0.h, z24.b, z20.b
     37c:	5f544e49 	.inst	0x5f544e49 ; undefined
     380:	45534142 	saddwb	z2.h, z10.h, z19.b
     384:	5045525f 	adr	xzr, 8adce <GPR_FRAME_SIZE+0x8acce>
     388:	45485f52 	usubwt	z18.h, z26.h, z8.b
     38c:	61500058 	.inst	0x61500058 ; undefined
     390:	4963696e 	.inst	0x4963696e ; undefined
     394:	006f666e 	.inst	0x006f666e ; undefined
     398:	726f6873 	.inst	0x726f6873 ; undefined
     39c:	6e692074 	usubl2	v20.4s, v3.8h, v9.8h
     3a0:	54530074 	bc.mi	a63ac <GPR_FRAME_SIZE+0xa62ac>  // bc.first
     3a4:	544e4944 	b.mi	9cccc <GPR_FRAME_SIZE+0x9cbcc>  // b.first
     3a8:	5059545f 	adr	xzr, b2e32 <GPR_FRAME_SIZE+0xb2d32>
     3ac:	55005345 	.inst	0x55005345 ; undefined
     3b0:	5f545241 	.inst	0x5f545241 ; undefined
     3b4:	73747570 	.inst	0x73747570 ; undefined
     3b8:	6e615000 	uabal2	v0.4s, v0.8h, v1.8h
     3bc:	6f4c6369 	umlsl2	v9.4s, v27.8h, v12.h[0]
     3c0:	69746163 	ldpsw	x3, x24, [x11, #-96]
     3c4:	70006e6f 	adr	x15, 1193 <GPR_FRAME_SIZE+0x1093>
     3c8:	63696e61 	.inst	0x63696e61 ; undefined
     3cc:	6c69665f 	ldnp	d31, d25, [x18, #-368]
     3d0:	75625f65 	.inst	0x75625f65 ; undefined
     3d4:	72656666 	.inst	0x72656666 ; undefined
     3d8:	4e415000 	luti4	v0.8h, {v0.8h-v1.8h}, v1[2]
     3dc:	4c5f4349 	.inst	0x4c5f4349 ; undefined
     3e0:	00454e49 	.inst	0x00454e49 ; undefined
     3e4:	49445453 	.inst	0x49445453 ; undefined
     3e8:	555f544e 	.inst	0x555f544e ; undefined
     3ec:	36544e49 	tbz	w9, #10, ffffffffffff8db4 <__stack_el2_top+0xffffffffbe9f1db4>
     3f0:	41500034 	.inst	0x41500034 ; undefined
     3f4:	5f43494e 	.inst	0x5f43494e ; undefined
     3f8:	454c4946 	uaddwb	z6.h, z10.h, z12.b
     3fc:	4655425f 	.inst	0x4655425f ; undefined
     400:	5a49535f 	.inst	0x5a49535f ; undefined
     404:	41500045 	.inst	0x41500045 ; undefined
     408:	5f43494e 	.inst	0x5f43494e ; undefined
     40c:	5353454d 	.inst	0x5353454d ; undefined
     410:	5f454741 	.inst	0x5f454741 ; undefined
     414:	5f465542 	shl	d2, d10, #6
     418:	00525450 	.inst	0x00525450 ; undefined
     41c:	6f6f425f 	mls	v31.8h, v18.8h, v15.h[2]
     420:	4155006c 	.inst	0x4155006c ; undefined
     424:	495f5452 	.inst	0x495f5452 ; undefined
     428:	00315f44 	.inst	0x00315f44 ; NYI
     42c:	54524155 	bc.pl	a4c54 <GPR_FRAME_SIZE+0xa4b54>  // bc.nfrst
     430:	5f44495f 	.inst	0x5f44495f ; undefined
     434:	41550033 	.inst	0x41550033 ; undefined
     438:	495f5452 	.inst	0x495f5452 ; undefined
     43c:	00345f44 	.inst	0x00345f44 ; NYI
     440:	657a6973 	fnmls	z19.h, p2/m, z11.h, z26.h
     444:	4700745f 	.inst	0x4700745f ; undefined
     448:	54726369 	b.ls	e50b4 <GPR_FRAME_SIZE+0xe4fb4>  // b.plast
     44c:	72657079 	.inst	0x72657079 ; undefined
     450:	67657200 	.inst	0x67657200 ; undefined
     454:	55003436 	.inst	0x55003436 ; undefined
     458:	5f545241 	.inst	0x5f545241 ; undefined
     45c:	74696e69 	.inst	0x74696e69 ; undefined
     460:	72656b00 	.inst	0x72656b00 ; undefined
     464:	5f6c656e 	.inst	0x5f6c656e ; undefined
     468:	72746e65 	.inst	0x72746e65 ; undefined
     46c:	61640079 	.inst	0x61640079 ; undefined
     470:	65006174 	.inst	0x65006174 ; undefined
     474:	70656378 	adr	x24, cb0e3 <GPR_FRAME_SIZE+0xcafe3>
     478:	6e6f6974 	.inst	0x6e6f6974 ; undefined
     47c:	65735f73 	fnmla	z19.h, p7/m, z27.h, z19.h
     480:	74735f74 	.inst	0x74735f74 ; undefined
     484:	73757461 	.inst	0x73757461 ; undefined
     488:	43494700 	.inst	0x43494700 ; undefined
     48c:	475f3356 	.inst	0x475f3356 ; undefined
     490:	5f524349 	.inst	0x5f524349 ; undefined
     494:	45505954 	usubwb	z20.h, z10.h, z16.b
     498:	65725f52 	fnmla	z18.h, p7/m, z26.h, z18.h
     49c:	69006461 	stgp	x1, x25, [x3]
     4a0:	735f6363 	.inst	0x735f6363 ; undefined
     4a4:	6b006572 	subs	w18, w11, w0, lsl #25
     4a8:	656e7265 	fnmls	z5.h, p4/m, z19.h, z14.h
     4ac:	6e695f6c 	uqrshl	v12.8h, v27.8h, v9.8h
     4b0:	61007469 	.inst	0x61007469 ; undefined
     4b4:	00316666 	.inst	0x00316666 ; NYI
     4b8:	32666661 	.inst	0x32666661 ; undefined
     4bc:	66666100 	.inst	0x66666100 ; undefined
     4c0:	49470033 	.inst	0x49470033 ; undefined
     4c4:	5f335643 	.inst	0x5f335643 ; undefined
     4c8:	52434947 	.inst	0x52434947 ; undefined
     4cc:	5059545f 	adr	xzr, b2f56 <GPR_FRAME_SIZE+0xb2e56>
     4d0:	425f5245 	.inst	0x425f5245 ; undefined
     4d4:	65675f46 	fnmla	z6.h, p7/m, z26.h, z7.h
     4d8:	66415f74 	.inst	0x66415f74 ; undefined
     4dc:	696e6966 	ldpsw	x6, x26, [x11, #-144]
     4e0:	61567974 	.inst	0x61567974 ; undefined
     4e4:	0065756c 	.inst	0x0065756c ; undefined
     4e8:	54524155 	bc.pl	a4d10 <GPR_FRAME_SIZE+0xa4c10>  // bc.nfrst
     4ec:	7475705f 	.inst	0x7475705f ; undefined
     4f0:	65720063 	fmla	z3.h, p0/m, z3.h, z18.h
     4f4:	5f343667 	.inst	0x5f343667 ; undefined
     4f8:	00727470 	.inst	0x00727470 ; undefined
     4fc:	41757043 	.inst	0x41757043 ; undefined
     500:	6e696666 	umax	v6.8h, v19.8h, v9.8h
     504:	00797469 	.inst	0x00797469 ; undefined
     508:	30666661 	adr	x1, cd1d5 <GPR_FRAME_SIZE+0xcd0d5>
     50c:	52415f00 	.inst	0x52415f00 ; undefined
     510:	43485f4d 	.inst	0x43485f4d ; undefined
     514:	4c455f52 	.inst	0x4c455f52 ; undefined
     518:	41550032 	.inst	0x41550032 ; undefined
     51c:	725f5452 	.inst	0x725f5452 ; undefined
     520:	00646165 	.inst	0x00646165 ; undefined
     524:	746e6975 	.inst	0x746e6975 ; undefined
     528:	00727470 	.inst	0x00727470 ; undefined
     52c:	69757063 	ldpsw	x3, x28, [x3, #-88]
     530:	415f0064 	.inst	0x415f0064 ; undefined
     534:	4d5f4d52 	.inst	0x4d5f4d52 ; undefined
     538:	52444950 	.inst	0x52444950 ; undefined
     53c:	314c455f 	cmn	w10, #0x311, lsl #12
     540:	4d524100 	.inst	0x4d524100 ; undefined
     544:	7465675f 	.inst	0x7465675f ; undefined
     548:	7570635f 	.inst	0x7570635f ; undefined
     54c:	6666615f 	.inst	0x6666615f ; undefined
     550:	74696e69 	.inst	0x74696e69 ; undefined
     554:	6c650079 	ldnp	d25, d0, [x3, #-432]
     558:	6f6c5f32 	.inst	0x6f6c5f32 ; undefined
     55c:	33615f77 	.inst	0x33615f77 ; undefined
     560:	65735f32 	fnmla	z18.h, p7/m, z25.h, z19.h
     564:	726f7272 	.inst	0x726f7272 ; undefined
     568:	6e61685f 	fcvtxn2	v31.4s, v2.2d
     56c:	72656c64 	.inst	0x72656c64 ; undefined
     570:	326c6500 	.inst	0x326c6500 ; undefined
     574:	7275635f 	.inst	0x7275635f ; undefined
     578:	7870735f 	stuminlh	w16, [x26]
     57c:	7265735f 	.inst	0x7265735f ; undefined
     580:	5f726f72 	.inst	0x5f726f72 ; undefined
     584:	646e6168 	.inst	0x646e6168 ; undefined
     588:	0072656c 	.inst	0x0072656c ; undefined
     58c:	5f326c65 	.inst	0x5f326c65 ; undefined
     590:	5f776f6c 	.inst	0x5f776f6c ; undefined
     594:	5f343661 	.inst	0x5f343661 ; undefined
     598:	72726573 	.inst	0x72726573 ; undefined
     59c:	685f726f 	.inst	0x685f726f ; undefined
     5a0:	6c646e61 	ldnp	d1, d27, [x19, #-448]
     5a4:	65007265 	.inst	0x65007265 ; undefined
     5a8:	6c5f326c 	ldnp	d12, d12, [x19, #496]
     5ac:	615f776f 	.inst	0x615f776f ; undefined
     5b0:	735f3436 	.inst	0x735f3436 ; undefined
     5b4:	5f636e79 	.inst	0x5f636e79 ; undefined
     5b8:	646e6168 	.inst	0x646e6168 ; undefined
     5bc:	0072656c 	.inst	0x0072656c ; undefined
     5c0:	5f326c65 	.inst	0x5f326c65 ; undefined
     5c4:	5f727563 	sqshl	d3, d11, #50
     5c8:	5f307073 	.inst	0x5f307073 ; undefined
     5cc:	5f717269 	sqdmlsl	s9, h19, v1.h[3]
     5d0:	646e6168 	.inst	0x646e6168 ; undefined
     5d4:	0072656c 	.inst	0x0072656c ; undefined
     5d8:	5f326c65 	.inst	0x5f326c65 ; undefined
     5dc:	5f727563 	sqshl	d3, d11, #50
     5e0:	5f307073 	.inst	0x5f307073 ; undefined
     5e4:	72726573 	.inst	0x72726573 ; undefined
     5e8:	685f726f 	.inst	0x685f726f ; undefined
     5ec:	6c646e61 	ldnp	d1, d27, [x19, #-448]
     5f0:	65007265 	.inst	0x65007265 ; undefined
     5f4:	6c5f326c 	ldnp	d12, d12, [x19, #496]
     5f8:	615f776f 	.inst	0x615f776f ; undefined
     5fc:	695f3436 	ldpsw	x22, x13, [x1, #248]
     600:	685f7172 	.inst	0x685f7172 ; undefined
     604:	6c646e61 	ldnp	d1, d27, [x19, #-448]
     608:	65007265 	.inst	0x65007265 ; undefined
     60c:	6c5f326c 	ldnp	d12, d12, [x19, #496]
     610:	615f776f 	.inst	0x615f776f ; undefined
     614:	665f3436 	.inst	0x665f3436 ; undefined
     618:	685f7169 	.inst	0x685f7169 ; undefined
     61c:	6c646e61 	ldnp	d1, d27, [x19, #-448]
     620:	65007265 	.inst	0x65007265 ; undefined
     624:	635f326c 	.inst	0x635f326c ; undefined
     628:	735f7275 	.inst	0x735f7275 ; undefined
     62c:	665f7870 	.inst	0x665f7870 ; undefined
     630:	685f7169 	.inst	0x685f7169 ; undefined
     634:	6c646e61 	ldnp	d1, d27, [x19, #-448]
     638:	65007265 	.inst	0x65007265 ; undefined
     63c:	6c5f326c 	ldnp	d12, d12, [x19, #496]
     640:	615f776f 	.inst	0x615f776f ; undefined
     644:	695f3233 	ldpsw	x19, x12, [x17, #248]
     648:	685f7172 	.inst	0x685f7172 ; undefined
     64c:	6c646e61 	ldnp	d1, d27, [x19, #-448]
     650:	65007265 	.inst	0x65007265 ; undefined
     654:	635f326c 	.inst	0x635f326c ; undefined
     658:	735f7275 	.inst	0x735f7275 ; undefined
     65c:	665f3070 	.inst	0x665f3070 ; undefined
     660:	685f7169 	.inst	0x685f7169 ; undefined
     664:	6c646e61 	ldnp	d1, d27, [x19, #-448]
     668:	65007265 	.inst	0x65007265 ; undefined
     66c:	6c5f326c 	ldnp	d12, d12, [x19, #496]
     670:	615f776f 	.inst	0x615f776f ; undefined
     674:	665f3233 	.inst	0x665f3233 ; undefined
     678:	685f7169 	.inst	0x685f7169 ; undefined
     67c:	6c646e61 	ldnp	d1, d27, [x19, #-448]
     680:	65007265 	.inst	0x65007265 ; undefined
     684:	635f326c 	.inst	0x635f326c ; undefined
     688:	735f7275 	.inst	0x735f7275 ; undefined
     68c:	735f7870 	.inst	0x735f7870 ; undefined
     690:	5f636e79 	.inst	0x5f636e79 ; undefined
     694:	646e6168 	.inst	0x646e6168 ; undefined
     698:	0072656c 	.inst	0x0072656c ; undefined
     69c:	5f326c65 	.inst	0x5f326c65 ; undefined
     6a0:	5f776f6c 	.inst	0x5f776f6c ; undefined
     6a4:	5f323361 	.inst	0x5f323361 ; undefined
     6a8:	636e7973 	.inst	0x636e7973 ; undefined
     6ac:	6e61685f 	fcvtxn2	v31.4s, v2.2d
     6b0:	72656c64 	.inst	0x72656c64 ; undefined
     6b4:	326c6500 	.inst	0x326c6500 ; undefined
     6b8:	7275635f 	.inst	0x7275635f ; undefined
     6bc:	3070735f 	adr	xzr, e1525 <GPR_FRAME_SIZE+0xe1425>
     6c0:	6e79735f 	uabdl2	v31.4s, v26.8h, v25.8h
     6c4:	61685f63 	.inst	0x61685f63 ; undefined
     6c8:	656c646e 	fnmls	z14.h, p1/m, z3.h, z12.h
     6cc:	6c650072 	ldnp	d18, d0, [x3, #-432]
     6d0:	75635f32 	.inst	0x75635f32 ; undefined
     6d4:	70735f72 	adr	x18, e72c3 <GPR_FRAME_SIZE+0xe71c3>
     6d8:	72695f78 	.inst	0x72695f78 ; undefined
     6dc:	61685f71 	.inst	0x61685f71 ; undefined
     6e0:	656c646e 	fnmls	z14.h, p1/m, z3.h, z12.h
     6e4:	645f0072 	fcmla	z18.h, p0/m, z3.h, z31.h, #0
     6e8:	67756265 	.inst	0x67756265 ; undefined
     6ec:	6378655f 	.inst	0x6378655f ; undefined
     6f0:	69747065 	ldpsw	x5, x28, [x3, #-96]
     6f4:	5f736e6f 	.inst	0x5f736e6f ; undefined
     6f8:	61736964 	.inst	0x61736964 ; undefined
     6fc:	00656c62 	.inst	0x00656c62 ; undefined
     700:	7172695f 	cmp	w10, #0xc9a, lsl #12
     704:	6378655f 	.inst	0x6378655f ; undefined
     708:	69747065 	ldpsw	x5, x28, [x3, #-96]
     70c:	5f736e6f 	.inst	0x5f736e6f ; undefined
     710:	61736964 	.inst	0x61736964 ; undefined
     714:	00656c62 	.inst	0x00656c62 ; undefined
     718:	6265645f 	.inst	0x6265645f ; undefined
     71c:	655f6775 	fcmne	p5.h, p1/z, z27.h, z31.h
     720:	70656378 	adr	x24, cb38f <GPR_FRAME_SIZE+0xcb28f>
     724:	6e6f6974 	.inst	0x6e6f6974 ; undefined
     728:	6e655f73 	uqrshl	v19.8h, v27.8h, v5.8h
     72c:	656c6261 	fnmls	z1.h, p0/m, z19.h, z12.h
     730:	65735f00 	fnmla	z0.h, p7/m, z24.h, z19.h
     734:	726f7272 	.inst	0x726f7272 ; undefined
     738:	6378655f 	.inst	0x6378655f ; undefined
     73c:	69747065 	ldpsw	x5, x28, [x3, #-96]
     740:	5f736e6f 	.inst	0x5f736e6f ; undefined
     744:	61736964 	.inst	0x61736964 ; undefined
     748:	00656c62 	.inst	0x00656c62 ; undefined
     74c:	7172695f 	cmp	w10, #0xc9a, lsl #12
     750:	6378655f 	.inst	0x6378655f ; undefined
     754:	69747065 	ldpsw	x5, x28, [x3, #-96]
     758:	5f736e6f 	.inst	0x5f736e6f ; undefined
     75c:	62616e65 	.inst	0x62616e65 ; undefined
     760:	6400656c 	.inst	0x6400656c ; undefined
     764:	00666961 	.inst	0x00666961 ; undefined
     768:	7169665f 	cmp	w18, #0xa59, lsl #12
     76c:	6378655f 	.inst	0x6378655f ; undefined
     770:	69747065 	ldpsw	x5, x28, [x3, #-96]
     774:	5f736e6f 	.inst	0x5f736e6f ; undefined
     778:	62616e65 	.inst	0x62616e65 ; undefined
     77c:	6300656c 	.inst	0x6300656c ; undefined
     780:	65727275 	fnmls	z21.h, p4/m, z19.h, z18.h
     784:	5f00746e 	.inst	0x5f00746e ; undefined
     788:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
     78c:	6f697470 	uqshl	v16.2d, v3.2d, #41
     790:	675f736e 	.inst	0x675f736e ; undefined
     794:	445f7465 	sqrdmlsh	z5.h, z3.h, z31.h
     798:	00464941 	.inst	0x00464941 ; undefined
     79c:	7265735f 	.inst	0x7265735f ; undefined
     7a0:	5f726f72 	.inst	0x5f726f72 ; undefined
     7a4:	65637865 	fnmls	z5.h, p6/m, z3.h, z3.h
     7a8:	6f697470 	uqshl	v16.2d, v3.2d, #41
     7ac:	655f736e 	fcmeq	p14.h, p4/z, z27.h, z31.h
     7b0:	6c62616e 	ldnp	d14, d24, [x11, #-480]
     7b4:	665f0065 	.inst	0x665f0065 ; undefined
     7b8:	655f7169 	fcmeq	p9.h, p4/z, z11.h, z31.h
     7bc:	70656378 	adr	x24, cb42b <GPR_FRAME_SIZE+0xcb32b>
     7c0:	6e6f6974 	.inst	0x6e6f6974 ; undefined
     7c4:	69645f73 	ldpsw	x19, x23, [x27, #-224]
     7c8:	6c626173 	ldnp	d19, d24, [x11, #-480]
     7cc:	73690065 	.inst	0x73690065 ; undefined
     7d0:	6769735f 	.inst	0x6769735f ; undefined
     7d4:	0064656e 	.inst	0x0064656e ; undefined
     7d8:	72706572 	.inst	0x72706572 ; undefined
     7dc:	70657200 	adr	x0, cb61f <GPR_FRAME_SIZE+0xcb51f>
     7e0:	656c5f72 	fnmla	z18.h, p7/m, z27.h, z12.h
     7e4:	5453006e 	b.al	a67f0 <GPR_FRAME_SIZE+0xa66f0>
     7e8:	544e4944 	b.mi	9d110 <GPR_FRAME_SIZE+0x9d010>  // b.first
     7ec:	5341425f 	.inst	0x5341425f ; undefined
     7f0:	45525f45 	usubwt	z5.h, z26.h, z18.b
     7f4:	435f5250 	.inst	0x435f5250 ; undefined
     7f8:	53524148 	.inst	0x53524148 ; undefined
     7fc:	78616d00 	.inst	0x78616d00 ; undefined
     800:	7a69735f 	.inst	0x7a69735f ; undefined
     804:	75620065 	.inst	0x75620065 ; undefined
     808:	656c5f66 	fnmla	z6.h, p7/m, z27.h, z12.h
     80c:	5f6e006e 	.inst	0x5f6e006e ; undefined
     810:	65707974 	fnmls	z20.h, p6/m, z11.h, z16.h
     814:	67696400 	.inst	0x67696400 ; undefined
     818:	75007469 	.inst	0x75007469 ; undefined
     81c:	38746e69 	.inst	0x38746e69 ; undefined
     820:	5f6f745f 	sqshl	d31, d2, #47
     824:	69637361 	ldpsw	x1, x28, [x27, #-232]
     828:	68635f69 	.inst	0x68635f69 ; undefined
     82c:	75007261 	.inst	0x75007261 ; undefined
     830:	6769736e 	.inst	0x6769736e ; undefined
     834:	5f64656e 	.inst	0x5f64656e ; undefined
     838:	756c6176 	.inst	0x756c6176 ; undefined
     83c:	656e0065 	fmla	z5.h, p0/m, z3.h, z14.h
     840:	69746167 	ldpsw	x7, x24, [x11, #-96]
     844:	6d006576 	stp	d22, d25, [x11]
     848:	70636d65 	adr	x5, c75f7 <GPR_FRAME_SIZE+0xc74f7>
     84c:	5f343679 	.inst	0x5f343679 ; undefined
     850:	67696c61 	.inst	0x67696c61 ; undefined
     854:	0064656e 	.inst	0x0064656e ; undefined
     858:	657a6973 	fnmls	z19.h, p2/m, z11.h, z26.h
     85c:	6174735f 	.inst	0x6174735f ; undefined
     860:	5f007472 	.inst	0x5f007472 ; undefined
     864:	636d656d 	.inst	0x636d656d ; undefined
     868:	34367970 	cbz	w16, 6d794 <GPR_FRAME_SIZE+0x6d694>
     86c:	73657400 	.inst	0x73657400 ; undefined
     870:	656d5f74 	fnmla	z20.h, p7/m, z27.h, z13.h
     874:	7970636d 	ldrh	w13, [x27, #6192]
     878:	584d4900 	ldr	x0, 9b198 <GPR_FRAME_SIZE+0x9b098>
     87c:	5f504d38 	.inst	0x5f504d38 ; undefined
     880:	5f515249 	.inst	0x5f515249 ; undefined
     884:	5f31554d 	.inst	0x5f31554d ; undefined
     888:	4700374d 	.inst	0x4700374d ; undefined
     88c:	33564349 	.inst	0x33564349 ; undefined
     890:	756f725f 	.inst	0x756f725f ; undefined
     894:	735f6574 	.inst	0x735f6574 ; undefined
     898:	745f6970 	.inst	0x745f6970 ; undefined
     89c:	70635f6f 	adr	x15, c748b <GPR_FRAME_SIZE+0xc738b>
     8a0:	4d490075 	.inst	0x4d490075 ; undefined
     8a4:	504d3858 	adr	x24, 9afae <GPR_FRAME_SIZE+0x9aeae>
     8a8:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     8ac:	4950475f 	.inst	0x4950475f ; undefined
     8b0:	315f334f 	adds	w15, w26, #0x7cc, lsl #12
     8b4:	31335f36 	adds	w22, w25, #0xcd7
     8b8:	584d4900 	ldr	x0, 9b1d8 <GPR_FRAME_SIZE+0x9b0d8>
     8bc:	5f504d38 	.inst	0x5f504d38 ; undefined
     8c0:	5f515249 	.inst	0x5f515249 ; undefined
     8c4:	45494350 	saddwb	z16.h, z26.h, z9.b
     8c8:	47534d5f 	.inst	0x47534d5f ; undefined
     8cc:	43494700 	.inst	0x43494700 ; undefined
     8d0:	475f3356 	.inst	0x475f3356 ; undefined
     8d4:	5f444349 	.inst	0x5f444349 ; undefined
     8d8:	554f5249 	.inst	0x554f5249 ; undefined
     8dc:	5f524554 	.inst	0x5f524554 ; undefined
     8e0:	74697277 	.inst	0x74697277 ; undefined
     8e4:	69470065 	ldpsw	x5, x0, [x3, #56]
     8e8:	70496463 	adr	x3, 93577 <GPR_FRAME_SIZE+0x93477>
     8ec:	726f6972 	.inst	0x726f6972 ; undefined
     8f0:	00797469 	.inst	0x00797469 ; undefined
     8f4:	64636947 	.inst	0x64636947 ; undefined
     8f8:	65707954 	fnmls	z20.h, p6/m, z10.h, z16.h
     8fc:	616d0072 	.inst	0x616d0072 ; undefined
     900:	70735f78 	adr	x24, e74ef <GPR_FRAME_SIZE+0xe73ef>
     904:	4d490069 	.inst	0x4d490069 ; undefined
     908:	504d3858 	adr	x24, 9b012 <GPR_FRAME_SIZE+0x9af12>
     90c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     910:	4950475f 	.inst	0x4950475f ; undefined
     914:	315f324f 	adds	w15, w18, #0x7cc, lsl #12
     918:	31335f36 	adds	w22, w25, #0xcd7
     91c:	43494700 	.inst	0x43494700 ; undefined
     920:	475f3356 	.inst	0x475f3356 ; undefined
     924:	5f524349 	.inst	0x5f524349 ; undefined
     928:	454b4157 	saddwb	z23.h, z10.h, z11.b
     92c:	65725f52 	fnmla	z18.h, p7/m, z26.h, z18.h
     930:	72006461 	ands	w1, w3, #0x3ffffff
     934:	32336765 	orr	w5, w27, #0xffffe07f
     938:	584d4900 	ldr	x0, 9b258 <GPR_FRAME_SIZE+0x9b158>
     93c:	5f504d38 	.inst	0x5f504d38 ; undefined
     940:	5f515249 	.inst	0x5f515249 ; undefined
     944:	48445355 	ldxrh	w21, [x26]
     948:	49003143 	.inst	0x49003143 ; undefined
     94c:	4d38584d 	.inst	0x4d38584d ; undefined
     950:	52495f50 	.inst	0x52495f50 ; undefined
     954:	53555f51 	.inst	0x53555f51 ; undefined
     958:	32434844 	.inst	0x32434844 ; undefined
     95c:	584d4900 	ldr	x0, 9b27c <GPR_FRAME_SIZE+0x9b17c>
     960:	5f504d38 	.inst	0x5f504d38 ; undefined
     964:	5f515249 	.inst	0x5f515249 ; undefined
     968:	48445355 	ldxrh	w21, [x26]
     96c:	49003343 	.inst	0x49003343 ; undefined
     970:	4d38584d 	.inst	0x4d38584d ; undefined
     974:	52495f50 	.inst	0x52495f50 ; undefined
     978:	57505f51 	.inst	0x57505f51 ; undefined
     97c:	4900314d 	.inst	0x4900314d ; undefined
     980:	4d38584d 	.inst	0x4d38584d ; undefined
     984:	52495f50 	.inst	0x52495f50 ; undefined
     988:	53495f51 	.inst	0x53495f51 ; undefined
     98c:	48435f49 	ldxrh	w9, [x26]
     990:	4d490030 	.inst	0x4d490030 ; undefined
     994:	504d3858 	adr	x24, 9b09e <GPR_FRAME_SIZE+0x9af9e>
     998:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     99c:	4953495f 	.inst	0x4953495f ; undefined
     9a0:	3148435f 	cmn	w26, #0x210, lsl #12
     9a4:	63694700 	.inst	0x63694700 ; undefined
     9a8:	6f724964 	mls	v4.8h, v11.8h, v2.h[7]
     9ac:	72657475 	.inst	0x72657475 ; undefined
     9b0:	584d4900 	ldr	x0, 9b2d0 <GPR_FRAME_SIZE+0x9b1d0>
     9b4:	5f504d38 	.inst	0x5f504d38 ; undefined
     9b8:	5f515249 	.inst	0x5f515249 ; undefined
     9bc:	5f32554d 	.inst	0x5f32554d ; undefined
     9c0:	00333541 	.inst	0x00333541 ; NYI
     9c4:	38584d49 	ldrb	w9, [x10, #-124]!
     9c8:	495f504d 	.inst	0x495f504d ; undefined
     9cc:	535f5152 	.inst	0x535f5152 ; undefined
     9d0:	31414d44 	adds	w4, w10, #0x53, lsl #12
     9d4:	584d4900 	ldr	x0, 9b2f4 <GPR_FRAME_SIZE+0x9b1f4>
     9d8:	5f504d38 	.inst	0x5f504d38 ; undefined
     9dc:	5f515249 	.inst	0x5f515249 ; undefined
     9e0:	5f555056 	.inst	0x5f555056 ; undefined
     9e4:	49003147 	.inst	0x49003147 ; undefined
     9e8:	4d38584d 	.inst	0x4d38584d ; undefined
     9ec:	52495f50 	.inst	0x52495f50 ; undefined
     9f0:	50565f51 	adr	x17, ad5da <GPR_FRAME_SIZE+0xad4da>
     9f4:	32475f55 	.inst	0x32475f55 ; undefined
     9f8:	67657200 	.inst	0x67657200 ; undefined
     9fc:	4700745f 	.inst	0x4700745f ; undefined
     a00:	33564349 	.inst	0x33564349 ; undefined
     a04:	4349475f 	.inst	0x4349475f ; undefined
     a08:	41575f52 	.inst	0x41575f52 ; undefined
     a0c:	5f52454b 	.inst	0x5f52454b ; undefined
     a10:	74697277 	.inst	0x74697277 ; undefined
     a14:	4d490065 	.inst	0x4d490065 ; undefined
     a18:	504d3858 	adr	x24, 9b122 <GPR_FRAME_SIZE+0x9b022>
     a1c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     a20:	4253555f 	.inst	0x4253555f ; undefined
     a24:	4d490031 	.inst	0x4d490031 ; undefined
     a28:	504d3858 	adr	x24, 9b132 <GPR_FRAME_SIZE+0x9b032>
     a2c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     a30:	4253555f 	.inst	0x4253555f ; undefined
     a34:	4d490032 	.inst	0x4d490032 ; undefined
     a38:	504d3858 	adr	x24, 9b142 <GPR_FRAME_SIZE+0x9b042>
     a3c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     a40:	454e455f 	saddwt	z31.h, z10.h, z14.b
     a44:	4f515f54 	.inst	0x4f515f54 ; undefined
     a48:	4d490053 	.inst	0x4d490053 ; undefined
     a4c:	504d3858 	adr	x24, 9b156 <GPR_FRAME_SIZE+0x9b056>
     a50:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     a54:	5345525f 	.inst	0x5345525f ; undefined
     a58:	45565245 	ssubwb	z5.h, z18.h, z22.b
     a5c:	35315f44 	cbnz	w4, 63644 <GPR_FRAME_SIZE+0x63544>
     a60:	69470030 	ldpsw	x16, x0, [x1, #56]
     a64:	67496463 	.inst	0x67496463 ; undefined
     a68:	70756f72 	adr	x18, eb857 <GPR_FRAME_SIZE+0xeb757>
     a6c:	4d490072 	.inst	0x4d490072 ; undefined
     a70:	504d3858 	adr	x24, 9b17a <GPR_FRAME_SIZE+0x9b07a>
     a74:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     a78:	4941535f 	.inst	0x4941535f ; undefined
     a7c:	41535f35 	.inst	0x41535f35 ; undefined
     a80:	49003649 	.inst	0x49003649 ; undefined
     a84:	4d38584d 	.inst	0x4d38584d ; undefined
     a88:	52495f50 	.inst	0x52495f50 ; undefined
     a8c:	41435f51 	.inst	0x41435f51 ; undefined
     a90:	525f4d41 	.inst	0x525f4d41 ; undefined
     a94:	00434954 	.inst	0x00434954 ; undefined
     a98:	38584d49 	ldrb	w9, [x10, #-124]!
     a9c:	495f504d 	.inst	0x495f504d ; undefined
     aa0:	4d5f5152 	.inst	0x4d5f5152 ; undefined
     aa4:	49464349 	.inst	0x49464349 ; undefined
     aa8:	4d49004c 	.inst	0x4d49004c ; undefined
     aac:	504d3858 	adr	x24, 9b1b6 <GPR_FRAME_SIZE+0x9b0b6>
     ab0:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     ab4:	5443535f 	bc.nv	8751c <GPR_FRAME_SIZE+0x8741c>
     ab8:	49003052 	.inst	0x49003052 ; undefined
     abc:	4d38584d 	.inst	0x4d38584d ; undefined
     ac0:	52495f50 	.inst	0x52495f50 ; undefined
     ac4:	43535f51 	.inst	0x43535f51 ; undefined
     ac8:	00315254 	.inst	0x00315254 ; NYI
     acc:	38584d49 	ldrb	w9, [x10, #-124]!
     ad0:	495f504d 	.inst	0x495f504d ; undefined
     ad4:	455f5152 	ssubwb	z18.h, z10.h, z31.b
     ad8:	31414d44 	adds	w4, w10, #0x53, lsl #12
     adc:	3148435f 	cmn	w26, #0x210, lsl #12
     ae0:	31335f36 	adds	w22, w25, #0xcd7
     ae4:	43494700 	.inst	0x43494700 ; undefined
     ae8:	475f3356 	.inst	0x475f3356 ; undefined
     aec:	5f444349 	.inst	0x5f444349 ; undefined
     af0:	554f5249 	.inst	0x554f5249 ; undefined
     af4:	5f524554 	.inst	0x5f524554 ; undefined
     af8:	735f4642 	.inst	0x735f4642 ; undefined
     afc:	415f7465 	.inst	0x415f7465 ; undefined
     b00:	00306666 	.inst	0x00306666 ; NYI
     b04:	38584d49 	ldrb	w9, [x10, #-124]!
     b08:	495f504d 	.inst	0x495f504d ; undefined
     b0c:	535f5152 	.inst	0x535f5152 ; undefined
     b10:	5f53564e 	shl	d14, d18, #19
     b14:	464f4e4f 	.inst	0x464f4e4f ; undefined
     b18:	6d690046 	ldp	d6, d0, [x2, #-368]
     b1c:	706d3878 	adr	x24, db22b <GPR_FRAME_SIZE+0xdb12b>
     b20:	7172695f 	cmp	w10, #0xc9a, lsl #12
     b24:	584d4900 	ldr	x0, 9b444 <GPR_FRAME_SIZE+0x9b344>
     b28:	5f504d38 	.inst	0x5f504d38 ; undefined
     b2c:	5f515249 	.inst	0x5f515249 ; undefined
     b30:	4f495047 	.inst	0x4f495047 ; undefined
     b34:	5f305f33 	.inst	0x5f305f33 ; undefined
     b38:	49003531 	.inst	0x49003531 ; undefined
     b3c:	4d38584d 	.inst	0x4d38584d ; undefined
     b40:	52495f50 	.inst	0x52495f50 ; undefined
     b44:	50475f51 	adr	x17, 8f72e <GPR_FRAME_SIZE+0x8f62e>
     b48:	5f344f49 	.inst	0x5f344f49 ; undefined
     b4c:	35315f30 	cbnz	w16, 63730 <GPR_FRAME_SIZE+0x63630>
     b50:	43494700 	.inst	0x43494700 ; undefined
     b54:	475f3356 	.inst	0x475f3356 ; undefined
     b58:	5f444349 	.inst	0x5f444349 ; undefined
     b5c:	554f5249 	.inst	0x554f5249 ; undefined
     b60:	5f524554 	.inst	0x5f524554 ; undefined
     b64:	735f4642 	.inst	0x735f4642 ; undefined
     b68:	495f7465 	.inst	0x495f7465 ; undefined
     b6c:	7265746e 	.inst	0x7265746e ; undefined
     b70:	74707572 	.inst	0x74707572 ; undefined
     b74:	756f525f 	.inst	0x756f525f ; undefined
     b78:	676e6974 	.inst	0x676e6974 ; undefined
     b7c:	646f4d5f 	.inst	0x646f4d5f ; undefined
     b80:	4d490065 	.inst	0x4d490065 ; undefined
     b84:	504d3858 	adr	x24, 9b28e <GPR_FRAME_SIZE+0x9b18e>
     b88:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     b8c:	5343455f 	.inst	0x5343455f ; undefined
     b90:	00314950 	.inst	0x00314950 ; NYI
     b94:	38584d49 	ldrb	w9, [x10, #-124]!
     b98:	495f504d 	.inst	0x495f504d ; undefined
     b9c:	455f5152 	ssubwb	z18.h, z10.h, z31.b
     ba0:	49505343 	.inst	0x49505343 ; undefined
     ba4:	4d490032 	.inst	0x4d490032 ; undefined
     ba8:	504d3858 	adr	x24, 9b2b2 <GPR_FRAME_SIZE+0x9b1b2>
     bac:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     bb0:	5343455f 	.inst	0x5343455f ; undefined
     bb4:	00334950 	.inst	0x00334950 ; NYI
     bb8:	38584d49 	ldrb	w9, [x10, #-124]!
     bbc:	495f504d 	.inst	0x495f504d ; undefined
     bc0:	525f5152 	.inst	0x525f5152 ; undefined
     bc4:	49004344 	.inst	0x49004344 ; undefined
     bc8:	4d38584d 	.inst	0x4d38584d ; undefined
     bcc:	52495f50 	.inst	0x52495f50 ; undefined
     bd0:	4c465f51 	.inst	0x4c465f51 ; undefined
     bd4:	50535845 	adr	x5, a76de <GPR_FRAME_SIZE+0xa75de>
     bd8:	4d490049 	.inst	0x4d490049 ; undefined
     bdc:	504d3858 	adr	x24, 9b2e6 <GPR_FRAME_SIZE+0x9b1e6>
     be0:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     be4:	5550435f 	.inst	0x5550435f ; undefined
     be8:	554d505f 	.inst	0x554d505f ; undefined
     bec:	69687300 	ldpsw	x0, x28, [x24, #-192]
     bf0:	47007466 	.inst	0x47007466 ; undefined
     bf4:	33564349 	.inst	0x33564349 ; undefined
     bf8:	4349475f 	.inst	0x4349475f ; undefined
     bfc:	50495f44 	adr	x4, 937e6 <GPR_FRAME_SIZE+0x936e6>
     c00:	524f4952 	.inst	0x524f4952 ; undefined
     c04:	52595449 	.inst	0x52595449 ; undefined
     c08:	5f46425f 	.inst	0x5f46425f ; undefined
     c0c:	00746573 	.inst	0x00746573 ; undefined
     c10:	38584d49 	ldrb	w9, [x10, #-124]!
     c14:	495f504d 	.inst	0x495f504d ; undefined
     c18:	495f5152 	.inst	0x495f5152 ; undefined
     c1c:	00315053 	.inst	0x00315053 ; NYI
     c20:	38584d49 	ldrb	w9, [x10, #-124]!
     c24:	495f504d 	.inst	0x495f504d ; undefined
     c28:	495f5152 	.inst	0x495f5152 ; undefined
     c2c:	00325053 	.inst	0x00325053 ; NYI
     c30:	38584d49 	ldrb	w9, [x10, #-124]!
     c34:	495f504d 	.inst	0x495f504d ; undefined
     c38:	555f5152 	.inst	0x555f5152 ; undefined
     c3c:	31545241 	adds	w1, w18, #0x514, lsl #12
     c40:	584d4900 	ldr	x0, 9b560 <GPR_FRAME_SIZE+0x9b460>
     c44:	5f504d38 	.inst	0x5f504d38 ; undefined
     c48:	5f515249 	.inst	0x5f515249 ; undefined
     c4c:	54524155 	bc.pl	a5474 <GPR_FRAME_SIZE+0xa5374>  // bc.nfrst
     c50:	4d490032 	.inst	0x4d490032 ; undefined
     c54:	504d3858 	adr	x24, 9b35e <GPR_FRAME_SIZE+0x9b25e>
     c58:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     c5c:	5241555f 	.inst	0x5241555f ; undefined
     c60:	49003354 	.inst	0x49003354 ; undefined
     c64:	4d38584d 	.inst	0x4d38584d ; undefined
     c68:	52495f50 	.inst	0x52495f50 ; undefined
     c6c:	41555f51 	.inst	0x41555f51 ; undefined
     c70:	00345452 	.inst	0x00345452 ; NYI
     c74:	38584d49 	ldrb	w9, [x10, #-124]!
     c78:	495f504d 	.inst	0x495f504d ; undefined
     c7c:	445f5152 	smlslb	z18.h, z10.b, z31.b
     c80:	455f5244 	ssubwb	z4.h, z18.h, z31.b
     c84:	524f5252 	.inst	0x524f5252 ; undefined
     c88:	584d4900 	ldr	x0, 9b5a8 <GPR_FRAME_SIZE+0x9b4a8>
     c8c:	5f504d38 	.inst	0x5f504d38 ; undefined
     c90:	5f515249 	.inst	0x5f515249 ; undefined
     c94:	414d4453 	.inst	0x414d4453 ; undefined
     c98:	4d490032 	.inst	0x4d490032 ; undefined
     c9c:	504d3858 	adr	x24, 9b3a6 <GPR_FRAME_SIZE+0x9b2a6>
     ca0:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     ca4:	5245505f 	.inst	0x5245505f ; undefined
     ca8:	4e4f4d46 	.inst	0x4e4f4d46 ; undefined
     cac:	4d490031 	.inst	0x4d490031 ; undefined
     cb0:	504d3858 	adr	x24, 9b3ba <GPR_FRAME_SIZE+0x9b2ba>
     cb4:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     cb8:	4d44535f 	.inst	0x4d44535f ; undefined
     cbc:	49003341 	.inst	0x49003341 ; undefined
     cc0:	4d38584d 	.inst	0x4d38584d ; undefined
     cc4:	52495f50 	.inst	0x52495f50 ; undefined
     cc8:	50565f51 	adr	x17, ad8b2 <GPR_FRAME_SIZE+0xad7b2>
     ccc:	4e455f55 	.inst	0x4e455f55 ; undefined
     cd0:	45444f43 	uaddwt	z3.h, z26.h, z4.b
     cd4:	4d490052 	.inst	0x4d490052 ; undefined
     cd8:	504d3858 	adr	x24, 9b3e2 <GPR_FRAME_SIZE+0x9b2e2>
     cdc:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     ce0:	5345525f 	.inst	0x5345525f ; undefined
     ce4:	45565245 	ssubwb	z5.h, z18.h, z22.b
     ce8:	35315f44 	cbnz	w4, 638d0 <GPR_FRAME_SIZE+0x637d0>
     cec:	4d490031 	.inst	0x4d490031 ; undefined
     cf0:	504d3858 	adr	x24, 9b3fa <GPR_FRAME_SIZE+0x9b2fa>
     cf4:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     cf8:	5345525f 	.inst	0x5345525f ; undefined
     cfc:	45565245 	ssubwb	z5.h, z18.h, z22.b
     d00:	35315f44 	cbnz	w4, 638e8 <GPR_FRAME_SIZE+0x637e8>
     d04:	4d490032 	.inst	0x4d490032 ; undefined
     d08:	504d3858 	adr	x24, 9b412 <GPR_FRAME_SIZE+0x9b312>
     d0c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     d10:	5345525f 	.inst	0x5345525f ; undefined
     d14:	45565245 	ssubwb	z5.h, z18.h, z22.b
     d18:	35315f44 	cbnz	w4, 63900 <GPR_FRAME_SIZE+0x63800>
     d1c:	4d490033 	.inst	0x4d490033 ; undefined
     d20:	504d3858 	adr	x24, 9b42a <GPR_FRAME_SIZE+0x9b32a>
     d24:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     d28:	5345525f 	.inst	0x5345525f ; undefined
     d2c:	45565245 	ssubwb	z5.h, z18.h, z22.b
     d30:	35315f44 	cbnz	w4, 63918 <GPR_FRAME_SIZE+0x63818>
     d34:	4d490034 	.inst	0x4d490034 ; undefined
     d38:	504d3858 	adr	x24, 9b442 <GPR_FRAME_SIZE+0x9b342>
     d3c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     d40:	454e455f 	saddwt	z31.h, z10.h, z14.b
     d44:	4d5f3154 	.inst	0x4d5f3154 ; undefined
     d48:	00435349 	.inst	0x00435349 ; undefined
     d4c:	38584d49 	ldrb	w9, [x10, #-124]!
     d50:	495f504d 	.inst	0x495f504d ; undefined
     d54:	525f5152 	.inst	0x525f5152 ; undefined
     d58:	52455345 	.inst	0x52455345 ; undefined
     d5c:	5f444556 	.inst	0x5f444556 ; undefined
     d60:	00363531 	.inst	0x00363531 ; NYI
     d64:	38584d49 	ldrb	w9, [x10, #-124]!
     d68:	495f504d 	.inst	0x495f504d ; undefined
     d6c:	525f5152 	.inst	0x525f5152 ; undefined
     d70:	52455345 	.inst	0x52455345 ; undefined
     d74:	5f444556 	.inst	0x5f444556 ; undefined
     d78:	00373531 	.inst	0x00373531 ; NYI
     d7c:	38584d49 	ldrb	w9, [x10, #-124]!
     d80:	495f504d 	.inst	0x495f504d ; undefined
     d84:	525f5152 	.inst	0x525f5152 ; undefined
     d88:	52455345 	.inst	0x52455345 ; undefined
     d8c:	5f444556 	.inst	0x5f444556 ; undefined
     d90:	00383531 	.inst	0x00383531 ; NYI
     d94:	38584d49 	ldrb	w9, [x10, #-124]!
     d98:	495f504d 	.inst	0x495f504d ; undefined
     d9c:	525f5152 	.inst	0x525f5152 ; undefined
     da0:	52455345 	.inst	0x52455345 ; undefined
     da4:	5f444556 	.inst	0x5f444556 ; undefined
     da8:	00393531 	.inst	0x00393531 ; NYI
     dac:	56434947 	.inst	0x56434947 ; undefined
     db0:	49475f33 	.inst	0x49475f33 ; undefined
     db4:	495f4443 	.inst	0x495f4443 ; undefined
     db8:	52474643 	.inst	0x52474643 ; undefined
     dbc:	5f46425f 	.inst	0x5f46425f ; undefined
     dc0:	00746573 	.inst	0x00746573 ; undefined
     dc4:	56434947 	.inst	0x56434947 ; undefined
     dc8:	65735f33 	fnmla	z19.h, p7/m, z25.h, z19.h
     dcc:	72705f74 	.inst	0x72705f74 ; undefined
     dd0:	69726f69 	ldpsw	x9, x27, [x27, #-112]
     dd4:	49007974 	.inst	0x49007974 ; undefined
     dd8:	4d38584d 	.inst	0x4d38584d ; undefined
     ddc:	52495f50 	.inst	0x52495f50 ; undefined
     de0:	44575f51 	umlslt	z17.h, z26.b, z23.b
     de4:	0031474f 	.inst	0x0031474f ; NYI
     de8:	38584d49 	ldrb	w9, [x10, #-124]!
     dec:	495f504d 	.inst	0x495f504d ; undefined
     df0:	575f5152 	.inst	0x575f5152 ; undefined
     df4:	32474f44 	.inst	0x32474f44 ; undefined
     df8:	584d4900 	ldr	x0, 9b718 <GPR_FRAME_SIZE+0x9b618>
     dfc:	5f504d38 	.inst	0x5f504d38 ; undefined
     e00:	5f515249 	.inst	0x5f515249 ; undefined
     e04:	474f4457 	.inst	0x474f4457 ; undefined
     e08:	4d490033 	.inst	0x4d490033 ; undefined
     e0c:	504d3858 	adr	x24, 9b516 <GPR_FRAME_SIZE+0x9b416>
     e10:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     e14:	0053485f 	.inst	0x0053485f ; undefined
     e18:	56434947 	.inst	0x56434947 ; undefined
     e1c:	49475f33 	.inst	0x49475f33 ; undefined
     e20:	575f5243 	.inst	0x575f5243 ; undefined
     e24:	52454b41 	.inst	0x52454b41 ; undefined
     e28:	5f46425f 	.inst	0x5f46425f ; undefined
     e2c:	5f746573 	.inst	0x5f746573 ; undefined
     e30:	636f7250 	.inst	0x636f7250 ; undefined
     e34:	6f737365 	fcmla	v5.8h, v27.8h, v19.h[1], #270
     e38:	656c5372 	fnmla	z18.h, p4/m, z27.h, z12.h
     e3c:	49007065 	.inst	0x49007065 ; undefined
     e40:	4d38584d 	.inst	0x4d38584d ; undefined
     e44:	52495f50 	.inst	0x52495f50 ; undefined
     e48:	50475f51 	adr	x17, 8fa32 <GPR_FRAME_SIZE+0x8f932>
     e4c:	52495f43 	.inst	0x52495f43 ; undefined
     e50:	49003151 	.inst	0x49003151 ; undefined
     e54:	4d38584d 	.inst	0x4d38584d ; undefined
     e58:	52495f50 	.inst	0x52495f50 ; undefined
     e5c:	50475f51 	adr	x17, 8fa46 <GPR_FRAME_SIZE+0x8f946>
     e60:	47003154 	.inst	0x47003154 ; undefined
     e64:	33564349 	.inst	0x33564349 ; undefined
     e68:	4349475f 	.inst	0x4349475f ; undefined
     e6c:	41575f52 	.inst	0x41575f52 ; undefined
     e70:	5f52454b 	.inst	0x5f52454b ; undefined
     e74:	675f4642 	.inst	0x675f4642 ; undefined
     e78:	435f7465 	.inst	0x435f7465 ; undefined
     e7c:	646c6968 	.inst	0x646c6968 ; undefined
     e80:	416e6572 	.inst	0x416e6572 ; undefined
     e84:	65656c73 	fnmls	z19.h, p3/m, z3.h, z5.h
     e88:	65720070 	fmla	z16.h, p0/m, z3.h, z18.h
     e8c:	5f323367 	.inst	0x5f323367 ; undefined
     e90:	00727470 	.inst	0x00727470 ; undefined
     e94:	69746e69 	ldpsw	x9, x27, [x19, #-96]
     e98:	69470064 	ldpsw	x4, x0, [x3, #56]
     e9c:	61577263 	.inst	0x61577263 ; undefined
     ea0:	0072656b 	.inst	0x0072656b ; undefined
     ea4:	38584d49 	ldrb	w9, [x10, #-124]!
     ea8:	495f504d 	.inst	0x495f504d ; undefined
     eac:	4d5f5152 	.inst	0x4d5f5152 ; undefined
     eb0:	49464349 	.inst	0x49464349 ; undefined
     eb4:	41565f4c 	.inst	0x41565f4c ; undefined
     eb8:	4d490044 	.inst	0x4d490044 ; undefined
     ebc:	504d3858 	adr	x24, 9b5c6 <GPR_FRAME_SIZE+0x9b4c6>
     ec0:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     ec4:	454e455f 	saddwt	z31.h, z10.h, z14.b
     ec8:	525f3154 	.inst	0x525f3154 ; undefined
     ecc:	30585458 	adr	x24, b1955 <GPR_FRAME_SIZE+0xb1855>
     ed0:	584d4900 	ldr	x0, 9b7f0 <GPR_FRAME_SIZE+0x9b6f0>
     ed4:	5f504d38 	.inst	0x5f504d38 ; undefined
     ed8:	5f515249 	.inst	0x5f515249 ; undefined
     edc:	324d5750 	.inst	0x324d5750 ; undefined
     ee0:	584d4900 	ldr	x0, 9b800 <GPR_FRAME_SIZE+0x9b700>
     ee4:	5f504d38 	.inst	0x5f504d38 ; undefined
     ee8:	5f515249 	.inst	0x5f515249 ; undefined
     eec:	334d5750 	.inst	0x334d5750 ; undefined
     ef0:	584d4900 	ldr	x0, 9b810 <GPR_FRAME_SIZE+0x9b710>
     ef4:	5f504d38 	.inst	0x5f504d38 ; undefined
     ef8:	5f515249 	.inst	0x5f515249 ; undefined
     efc:	344d5750 	cbz	w16, 9b9e4 <GPR_FRAME_SIZE+0x9b8e4>
     f00:	584d4900 	ldr	x0, 9b820 <GPR_FRAME_SIZE+0x9b720>
     f04:	5f504d38 	.inst	0x5f504d38 ; undefined
     f08:	5f515249 	.inst	0x5f515249 ; undefined
     f0c:	00504144 	.inst	0x00504144 ; undefined
     f10:	38584d49 	ldrb	w9, [x10, #-124]!
     f14:	495f504d 	.inst	0x495f504d ; undefined
     f18:	415f5152 	.inst	0x415f5152 ; undefined
     f1c:	4f494455 	.inst	0x4f494455 ; undefined
     f20:	5643585f 	.inst	0x5643585f ; undefined
     f24:	49003152 	.inst	0x49003152 ; undefined
     f28:	4d38584d 	.inst	0x4d38584d ; undefined
     f2c:	52495f50 	.inst	0x52495f50 ; undefined
     f30:	44455f51 	umlslt	z17.h, z26.b, z5.b
     f34:	5f31414d 	.inst	0x5f31414d ; undefined
     f38:	5f304843 	.inst	0x5f304843 ; undefined
     f3c:	47003531 	.inst	0x47003531 ; undefined
     f40:	33564349 	.inst	0x33564349 ; undefined
     f44:	7465735f 	.inst	0x7465735f ; undefined
     f48:	76656c5f 	.inst	0x76656c5f ; undefined
     f4c:	735f6c65 	.inst	0x735f6c65 ; undefined
     f50:	69736e65 	ldpsw	x5, x27, [x19, #-104]
     f54:	65766974 	fnmls	z20.h, p2/m, z11.h, z22.h
     f58:	6f6c7300 	fcmla	v0.8h, v24.8h, v12.h[1], #270
     f5c:	4d490074 	.inst	0x4d490074 ; undefined
     f60:	504d3858 	adr	x24, 9b66a <GPR_FRAME_SIZE+0x9b56a>
     f64:	5152495f 	sub	wsp, w10, #0x492, lsl #12
     f68:	564e535f 	.inst	0x564e535f ; undefined
     f6c:	52535f53 	.inst	0x52535f53 ; undefined
     f70:	535f4354 	.inst	0x535f4354 ; undefined
     f74:	43494700 	.inst	0x43494700 ; undefined
     f78:	475f3356 	.inst	0x475f3356 ; undefined
     f7c:	5f444349 	.inst	0x5f444349 ; undefined
     f80:	554f5249 	.inst	0x554f5249 ; undefined
     f84:	5f524554 	.inst	0x5f524554 ; undefined
     f88:	735f4642 	.inst	0x735f4642 ; undefined
     f8c:	415f7465 	.inst	0x415f7465 ; undefined
     f90:	00326666 	.inst	0x00326666 ; NYI
     f94:	38584d49 	ldrb	w9, [x10, #-124]!
     f98:	495f504d 	.inst	0x495f504d ; undefined
     f9c:	4d5f5152 	.inst	0x4d5f5152 ; undefined
     fa0:	415f3355 	.inst	0x415f3355 ; undefined
     fa4:	4f494455 	.inst	0x4f494455 ; undefined
     fa8:	584d4900 	ldr	x0, 9b8c8 <GPR_FRAME_SIZE+0x9b7c8>
     fac:	5f504d38 	.inst	0x5f504d38 ; undefined
     fb0:	5f515249 	.inst	0x5f515249 ; undefined
     fb4:	4643494d 	.inst	0x4643494d ; undefined
     fb8:	455f4c49 	uaddwt	z9.h, z2.h, z31.b
     fbc:	49005252 	.inst	0x49005252 ; undefined
     fc0:	4d38584d 	.inst	0x4d38584d ; undefined
     fc4:	52495f50 	.inst	0x52495f50 ; undefined
     fc8:	4e455f51 	.inst	0x4e455f51 ; undefined
     fcc:	5f315445 	.inst	0x5f315445 ; undefined
     fd0:	38383531 	.inst	0x38383531 ; undefined
     fd4:	43494700 	.inst	0x43494700 ; undefined
     fd8:	735f3356 	.inst	0x735f3356 ; undefined
     fdc:	735f7465 	.inst	0x735f7465 ; undefined
     fe0:	675f6970 	.inst	0x675f6970 ; undefined
     fe4:	70756f72 	adr	x18, ebdd3 <GPR_FRAME_SIZE+0xebcd3>
     fe8:	00736e31 	.inst	0x00736e31 ; undefined
     fec:	56434947 	.inst	0x56434947 ; undefined
     ff0:	65735f33 	fnmla	z19.h, p7/m, z25.h, z19.h
     ff4:	64655f74 	.inst	0x64655f74 ; undefined
     ff8:	745f6567 	.inst	0x745f6567 ; undefined
     ffc:	67676972 	.inst	0x67676972 ; undefined
    1000:	64657265 	.inst	0x64657265 ; undefined
    1004:	584d4900 	ldr	x0, 9b924 <GPR_FRAME_SIZE+0x9b824>
    1008:	5f504d38 	.inst	0x5f504d38 ; undefined
    100c:	5f515249 	.inst	0x5f515249 ; undefined
    1010:	45494350 	saddwb	z16.h, z26.h, z9.b
    1014:	454d505f 	ssubwb	z31.h, z2.h, z13.b
    1018:	72676900 	.inst	0x72676900 ; undefined
    101c:	7270756f 	.inst	0x7270756f ; undefined
    1020:	584d4900 	ldr	x0, 9b940 <GPR_FRAME_SIZE+0x9b840>
    1024:	5f504d38 	.inst	0x5f504d38 ; undefined
    1028:	5f515249 	.inst	0x5f515249 ; undefined
    102c:	43525341 	.inst	0x43525341 ; undefined
    1030:	43494700 	.inst	0x43494700 ; undefined
    1034:	475f3356 	.inst	0x475f3356 ; undefined
    1038:	5f444349 	.inst	0x5f444349 ; undefined
    103c:	4f524749 	.inst	0x4f524749 ; undefined
    1040:	5f525055 	.inst	0x5f525055 ; undefined
    1044:	74697277 	.inst	0x74697277 ; undefined
    1048:	4d490065 	.inst	0x4d490065 ; undefined
    104c:	504d3858 	adr	x24, 9b756 <GPR_FRAME_SIZE+0x9b656>
    1050:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1054:	31554d5f 	cmn	w10, #0x553, lsl #12
    1058:	3335415f 	.inst	0x3335415f ; undefined
    105c:	584d4900 	ldr	x0, 9b97c <GPR_FRAME_SIZE+0x9b87c>
    1060:	5f504d38 	.inst	0x5f504d38 ; undefined
    1064:	5f515249 	.inst	0x5f515249 ; undefined
    1068:	4f495047 	.inst	0x4f495047 ; undefined
    106c:	4e495f31 	.inst	0x4e495f31 ; undefined
    1070:	49003054 	.inst	0x49003054 ; undefined
    1074:	4d38584d 	.inst	0x4d38584d ; undefined
    1078:	52495f50 	.inst	0x52495f50 ; undefined
    107c:	50475f51 	adr	x17, 8fc66 <GPR_FRAME_SIZE+0x8fb66>
    1080:	5f314f49 	.inst	0x5f314f49 ; undefined
    1084:	31544e49 	adds	w9, w18, #0x513, lsl #12
    1088:	584d4900 	ldr	x0, 9b9a8 <GPR_FRAME_SIZE+0x9b8a8>
    108c:	5f504d38 	.inst	0x5f504d38 ; undefined
    1090:	5f515249 	.inst	0x5f515249 ; undefined
    1094:	4f495047 	.inst	0x4f495047 ; undefined
    1098:	4e495f31 	.inst	0x4e495f31 ; undefined
    109c:	49003254 	.inst	0x49003254 ; undefined
    10a0:	4d38584d 	.inst	0x4d38584d ; undefined
    10a4:	52495f50 	.inst	0x52495f50 ; undefined
    10a8:	50475f51 	adr	x17, 8fc92 <GPR_FRAME_SIZE+0x8fb92>
    10ac:	5f314f49 	.inst	0x5f314f49 ; undefined
    10b0:	33544e49 	.inst	0x33544e49 ; undefined
    10b4:	584d4900 	ldr	x0, 9b9d4 <GPR_FRAME_SIZE+0x9b8d4>
    10b8:	5f504d38 	.inst	0x5f504d38 ; undefined
    10bc:	5f515249 	.inst	0x5f515249 ; undefined
    10c0:	4f495047 	.inst	0x4f495047 ; undefined
    10c4:	4e495f31 	.inst	0x4e495f31 ; undefined
    10c8:	49003454 	.inst	0x49003454 ; undefined
    10cc:	4d38584d 	.inst	0x4d38584d ; undefined
    10d0:	52495f50 	.inst	0x52495f50 ; undefined
    10d4:	50475f51 	adr	x17, 8fcbe <GPR_FRAME_SIZE+0x8fbbe>
    10d8:	5f314f49 	.inst	0x5f314f49 ; undefined
    10dc:	35544e49 	cbnz	w9, a9aa4 <GPR_FRAME_SIZE+0xa99a4>
    10e0:	584d4900 	ldr	x0, 9ba00 <GPR_FRAME_SIZE+0x9b900>
    10e4:	5f504d38 	.inst	0x5f504d38 ; undefined
    10e8:	5f515249 	.inst	0x5f515249 ; undefined
    10ec:	4f495047 	.inst	0x4f495047 ; undefined
    10f0:	4e495f31 	.inst	0x4e495f31 ; undefined
    10f4:	49003654 	.inst	0x49003654 ; undefined
    10f8:	4d38584d 	.inst	0x4d38584d ; undefined
    10fc:	52495f50 	.inst	0x52495f50 ; undefined
    1100:	50475f51 	adr	x17, 8fcea <GPR_FRAME_SIZE+0x8fbea>
    1104:	5f314f49 	.inst	0x5f314f49 ; undefined
    1108:	37544e49 	tbnz	w9, #10, ffffffffffff9ad0 <__stack_el2_top+0xffffffffbe9f2ad0>
    110c:	584d4900 	ldr	x0, 9ba2c <GPR_FRAME_SIZE+0x9b92c>
    1110:	5f504d38 	.inst	0x5f504d38 ; undefined
    1114:	5f515249 	.inst	0x5f515249 ; undefined
    1118:	5f555043 	.inst	0x5f555043 ; undefined
    111c:	455f324c 	sabdlb	z12.h, z18.b, z31.b
    1120:	49004343 	.inst	0x49004343 ; undefined
    1124:	4d38584d 	.inst	0x4d38584d ; undefined
    1128:	52495f50 	.inst	0x52495f50 ; undefined
    112c:	50435f51 	adr	x17, 87d16 <GPR_FRAME_SIZE+0x87c16>
    1130:	54435f55 	bc.pl	87d18 <GPR_FRAME_SIZE+0x87c18>  // bc.nfrst
    1134:	4d490049 	.inst	0x4d490049 ; undefined
    1138:	504d3858 	adr	x24, 9b842 <GPR_FRAME_SIZE+0x9b742>
    113c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1140:	50494d5f 	adr	xzr, 93aea <GPR_FRAME_SIZE+0x939ea>
    1144:	53435f49 	.inst	0x53435f49 ; undefined
    1148:	49003249 	.inst	0x49003249 ; undefined
    114c:	4d38584d 	.inst	0x4d38584d ; undefined
    1150:	52495f50 	.inst	0x52495f50 ; undefined
    1154:	41435f51 	.inst	0x41435f51 ; undefined
    1158:	525f4d41 	.inst	0x525f4d41 ; undefined
    115c:	564f4345 	.inst	0x564f4345 ; undefined
    1160:	42415245 	.inst	0x42415245 ; undefined
    1164:	6900454c 	stgp	x12, x17, [x10]
    1168:	6e696c74 	umin	v20.8h, v3.8h, v9.8h
    116c:	49007365 	.inst	0x49007365 ; undefined
    1170:	4d38584d 	.inst	0x4d38584d ; undefined
    1174:	52495f50 	.inst	0x52495f50 ; undefined
    1178:	41535f51 	.inst	0x41535f51 ; undefined
    117c:	49003149 	.inst	0x49003149 ; undefined
    1180:	4d38584d 	.inst	0x4d38584d ; undefined
    1184:	52495f50 	.inst	0x52495f50 ; undefined
    1188:	41535f51 	.inst	0x41535f51 ; undefined
    118c:	49003249 	.inst	0x49003249 ; undefined
    1190:	4d38584d 	.inst	0x4d38584d ; undefined
    1194:	52495f50 	.inst	0x52495f50 ; undefined
    1198:	41535f51 	.inst	0x41535f51 ; undefined
    119c:	49003349 	.inst	0x49003349 ; undefined
    11a0:	4d38584d 	.inst	0x4d38584d ; undefined
    11a4:	52495f50 	.inst	0x52495f50 ; undefined
    11a8:	434c5f51 	.inst	0x434c5f51 ; undefined
    11ac:	31464944 	adds	w4, w10, #0x192, lsl #12
    11b0:	584d4900 	ldr	x0, 9bad0 <GPR_FRAME_SIZE+0x9b9d0>
    11b4:	5f504d38 	.inst	0x5f504d38 ; undefined
    11b8:	5f515249 	.inst	0x5f515249 ; undefined
    11bc:	4944434c 	.inst	0x4944434c ; undefined
    11c0:	49003246 	.inst	0x49003246 ; undefined
    11c4:	4d38584d 	.inst	0x4d38584d ; undefined
    11c8:	52495f50 	.inst	0x52495f50 ; undefined
    11cc:	41535f51 	.inst	0x41535f51 ; undefined
    11d0:	49003749 	.inst	0x49003749 ; undefined
    11d4:	4d38584d 	.inst	0x4d38584d ; undefined
    11d8:	52495f50 	.inst	0x52495f50 ; undefined
    11dc:	32495f51 	.inst	0x32495f51 ; undefined
    11e0:	49003143 	.inst	0x49003143 ; undefined
    11e4:	4d38584d 	.inst	0x4d38584d ; undefined
    11e8:	52495f50 	.inst	0x52495f50 ; undefined
    11ec:	32495f51 	.inst	0x32495f51 ; undefined
    11f0:	49003243 	.inst	0x49003243 ; undefined
    11f4:	4d38584d 	.inst	0x4d38584d ; undefined
    11f8:	52495f50 	.inst	0x52495f50 ; undefined
    11fc:	32495f51 	.inst	0x32495f51 ; undefined
    1200:	49003343 	.inst	0x49003343 ; undefined
    1204:	4d38584d 	.inst	0x4d38584d ; undefined
    1208:	52495f50 	.inst	0x52495f50 ; undefined
    120c:	32495f51 	.inst	0x32495f51 ; undefined
    1210:	49003443 	.inst	0x49003443 ; undefined
    1214:	4d38584d 	.inst	0x4d38584d ; undefined
    1218:	52495f50 	.inst	0x52495f50 ; undefined
    121c:	32495f51 	.inst	0x32495f51 ; undefined
    1220:	47003643 	.inst	0x47003643 ; undefined
    1224:	33564349 	.inst	0x33564349 ; undefined
    1228:	4349475f 	.inst	0x4349475f ; undefined
    122c:	53495f44 	.inst	0x53495f44 ; undefined
    1230:	42414e45 	.inst	0x42414e45 ; undefined
    1234:	5f52454c 	.inst	0x5f52454c ; undefined
    1238:	5f746573 	.inst	0x5f746573 ; undefined
    123c:	00746962 	.inst	0x00746962 ; undefined
    1240:	56434947 	.inst	0x56434947 ; undefined
    1244:	6f725f33 	.inst	0x6f725f33 ; undefined
    1248:	5f657475 	sqshl	d21, d3, #37
    124c:	5f697073 	sqdmlsl	s19, h3, v9.h[2]
    1250:	735f6f74 	.inst	0x735f6f74 ; undefined
    1254:	00666c65 	.inst	0x00666c65 ; undefined
    1258:	38584d49 	ldrb	w9, [x10, #-124]!
    125c:	495f504d 	.inst	0x495f504d ; undefined
    1260:	435f5152 	.inst	0x435f5152 ; undefined
    1264:	44464e41 	umlalt	z1.h, z18.b, z6.b
    1268:	4d490031 	.inst	0x4d490031 ; undefined
    126c:	504d3858 	adr	x24, 9b976 <GPR_FRAME_SIZE+0x9b876>
    1270:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1274:	4950475f 	.inst	0x4950475f ; undefined
    1278:	305f314f 	adr	x15, bf8a1 <GPR_FRAME_SIZE+0xbf7a1>
    127c:	0035315f 	.inst	0x0035315f ; NYI
    1280:	38584d49 	ldrb	w9, [x10, #-124]!
    1284:	495f504d 	.inst	0x495f504d ; undefined
    1288:	455f5152 	ssubwb	z18.h, z10.h, z31.b
    128c:	5f435241 	.inst	0x5f435241 ; undefined
    1290:	49445053 	.inst	0x49445053 ; undefined
    1294:	49470046 	.inst	0x49470046 ; undefined
    1298:	5f335643 	.inst	0x5f335643 ; undefined
    129c:	44434947 	umlalb	z7.h, z10.b, z3.b
    12a0:	5250495f 	.inst	0x5250495f ; undefined
    12a4:	49524f49 	.inst	0x49524f49 ; undefined
    12a8:	5f525954 	.inst	0x5f525954 ; undefined
    12ac:	74697277 	.inst	0x74697277 ; undefined
    12b0:	4d490065 	.inst	0x4d490065 ; undefined
    12b4:	504d3858 	adr	x24, 9b9be <GPR_FRAME_SIZE+0x9b8be>
    12b8:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    12bc:	50494d5f 	adr	xzr, 93c66 <GPR_FRAME_SIZE+0x93b66>
    12c0:	53435f49 	.inst	0x53435f49 ; undefined
    12c4:	49003149 	.inst	0x49003149 ; undefined
    12c8:	4d38584d 	.inst	0x4d38584d ; undefined
    12cc:	52495f50 	.inst	0x52495f50 ; undefined
    12d0:	50475f51 	adr	x17, 8feba <GPR_FRAME_SIZE+0x8fdba>
    12d4:	49003254 	.inst	0x49003254 ; undefined
    12d8:	4d38584d 	.inst	0x4d38584d ; undefined
    12dc:	52495f50 	.inst	0x52495f50 ; undefined
    12e0:	50475f51 	adr	x17, 8feca <GPR_FRAME_SIZE+0x8fdca>
    12e4:	49003354 	.inst	0x49003354 ; undefined
    12e8:	4d38584d 	.inst	0x4d38584d ; undefined
    12ec:	52495f50 	.inst	0x52495f50 ; undefined
    12f0:	50475f51 	adr	x17, 8feda <GPR_FRAME_SIZE+0x8fdda>
    12f4:	49003454 	.inst	0x49003454 ; undefined
    12f8:	4d38584d 	.inst	0x4d38584d ; undefined
    12fc:	52495f50 	.inst	0x52495f50 ; undefined
    1300:	50475f51 	adr	x17, 8feea <GPR_FRAME_SIZE+0x8fdea>
    1304:	49003554 	.inst	0x49003554 ; undefined
    1308:	4d38584d 	.inst	0x4d38584d ; undefined
    130c:	52495f50 	.inst	0x52495f50 ; undefined
    1310:	50475f51 	adr	x17, 8fefa <GPR_FRAME_SIZE+0x8fdfa>
    1314:	49003654 	.inst	0x49003654 ; undefined
    1318:	4d38584d 	.inst	0x4d38584d ; undefined
    131c:	52495f50 	.inst	0x52495f50 ; undefined
    1320:	504e5f51 	adr	x17, 9df0a <GPR_FRAME_SIZE+0x9de0a>
    1324:	4d490055 	.inst	0x4d490055 ; undefined
    1328:	504d3858 	adr	x24, 9ba32 <GPR_FRAME_SIZE+0x9b932>
    132c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1330:	4950475f 	.inst	0x4950475f ; undefined
    1334:	315f344f 	adds	w15, w2, #0x7cd, lsl #12
    1338:	31335f36 	adds	w22, w25, #0xcd7
    133c:	584d4900 	ldr	x0, 9bc5c <GPR_FRAME_SIZE+0x9bb5c>
    1340:	5f504d38 	.inst	0x5f504d38 ; undefined
    1344:	5f515249 	.inst	0x5f515249 ; undefined
    1348:	464e4143 	.inst	0x464e4143 ; undefined
    134c:	455f3144 	sabdlb	z4.h, z10.b, z31.b
    1350:	49005252 	.inst	0x49005252 ; undefined
    1354:	4d38584d 	.inst	0x4d38584d ; undefined
    1358:	52495f50 	.inst	0x52495f50 ; undefined
    135c:	50475f51 	adr	x17, 8ff46 <GPR_FRAME_SIZE+0x8fe46>
    1360:	5f354f49 	.inst	0x5f354f49 ; undefined
    1364:	335f3631 	.inst	0x335f3631 ; undefined
    1368:	79740031 	ldrh	w17, [x1, #6656]
    136c:	00726570 	.inst	0x00726570 ; undefined
    1370:	56434947 	.inst	0x56434947 ; undefined
    1374:	49475f33 	.inst	0x49475f33 ; undefined
    1378:	495f4443 	.inst	0x495f4443 ; undefined
    137c:	54554f52 	bc.cs	abd64 <GPR_FRAME_SIZE+0xabc64>  // bc.hs, bc.nlast
    1380:	425f5245 	.inst	0x425f5245 ; undefined
    1384:	65735f46 	fnmla	z6.h, p7/m, z26.h, z19.h
    1388:	66415f74 	.inst	0x66415f74 ; undefined
    138c:	49003166 	.inst	0x49003166 ; undefined
    1390:	4d38584d 	.inst	0x4d38584d ; undefined
    1394:	52495f50 	.inst	0x52495f50 ; undefined
    1398:	494d5f51 	.inst	0x494d5f51 ; undefined
    139c:	445f4950 	umlalb	z16.h, z10.b, z31.b
    13a0:	61004953 	.inst	0x61004953 ; undefined
    13a4:	65656c73 	fnmls	z19.h, p3/m, z3.h, z5.h
    13a8:	49470070 	.inst	0x49470070 ; undefined
    13ac:	5f335643 	.inst	0x5f335643 ; undefined
    13b0:	44434947 	umlalb	z7.h, z10.b, z3.b
    13b4:	4643495f 	.inst	0x4643495f ; undefined
    13b8:	725f5247 	.inst	0x725f5247 ; undefined
    13bc:	00646165 	.inst	0x00646165 ; undefined
    13c0:	38584d49 	ldrb	w9, [x10, #-124]!
    13c4:	495f504d 	.inst	0x495f504d ; undefined
    13c8:	415f5152 	.inst	0x415f5152 ; undefined
    13cc:	44484250 	smlalb	z16.h, z18.b, z8.b
    13d0:	4900414d 	.inst	0x4900414d ; undefined
    13d4:	4d38584d 	.inst	0x4d38584d ; undefined
    13d8:	52495f50 	.inst	0x52495f50 ; undefined
    13dc:	55415f51 	.inst	0x55415f51 ; undefined
    13e0:	5f4f4944 	.inst	0x5f4f4944 ; undefined
    13e4:	52564358 	.inst	0x52564358 ; undefined
    13e8:	4d490030 	.inst	0x4d490030 ; undefined
    13ec:	504d3858 	adr	x24, 9baf6 <GPR_FRAME_SIZE+0x9b9f6>
    13f0:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    13f4:	4950475f 	.inst	0x4950475f ; undefined
    13f8:	305f354f 	adr	x15, bfaa1 <GPR_FRAME_SIZE+0xbf9a1>
    13fc:	0035315f 	.inst	0x0035315f ; NYI
    1400:	38584d49 	ldrb	w9, [x10, #-124]!
    1404:	495f504d 	.inst	0x495f504d ; undefined
    1408:	435f5152 	.inst	0x435f5152 ; undefined
    140c:	435f374d 	.inst	0x435f374d ; undefined
    1410:	49004954 	.inst	0x49004954 ; undefined
    1414:	4d38584d 	.inst	0x4d38584d ; undefined
    1418:	52495f50 	.inst	0x52495f50 ; undefined
    141c:	50435f51 	adr	x17, 88006 <GPR_FRAME_SIZE+0x87f06>
    1420:	58415f55 	ldr	x21, 84008 <GPR_FRAME_SIZE+0x83f08>
    1424:	52455f49 	.inst	0x52455f49 ; undefined
    1428:	00524f52 	.inst	0x00524f52 ; undefined
    142c:	38584d49 	ldrb	w9, [x10, #-124]!
    1430:	495f504d 	.inst	0x495f504d ; undefined
    1434:	555f5152 	.inst	0x555f5152 ; undefined
    1438:	5f324253 	.inst	0x5f324253 ; undefined
    143c:	454b4157 	saddwb	z23.h, z10.h, z11.b
    1440:	49005055 	.inst	0x49005055 ; undefined
    1444:	4d38584d 	.inst	0x4d38584d ; undefined
    1448:	52495f50 	.inst	0x52495f50 ; undefined
    144c:	43435f51 	.inst	0x43435f51 ; undefined
    1450:	52495f4d 	.inst	0x52495f4d ; undefined
    1454:	49003151 	.inst	0x49003151 ; undefined
    1458:	4d38584d 	.inst	0x4d38584d ; undefined
    145c:	52495f50 	.inst	0x52495f50 ; undefined
    1460:	43435f51 	.inst	0x43435f51 ; undefined
    1464:	52495f4d 	.inst	0x52495f4d ; undefined
    1468:	47003251 	.inst	0x47003251 ; undefined
    146c:	49646369 	.inst	0x49646369 ; undefined
    1470:	72676663 	.inst	0x72676663 ; undefined
    1474:	584d4900 	ldr	x0, 9bd94 <GPR_FRAME_SIZE+0x9bc94>
    1478:	5f504d38 	.inst	0x5f504d38 ; undefined
    147c:	5f515249 	.inst	0x5f515249 ; undefined
    1480:	4d414143 	.inst	0x4d414143 ; undefined
    1484:	30514a5f 	adr	xzr, a3dcd <GPR_FRAME_SIZE+0xa3ccd>
    1488:	584d4900 	ldr	x0, 9bda8 <GPR_FRAME_SIZE+0x9bca8>
    148c:	5f504d38 	.inst	0x5f504d38 ; undefined
    1490:	5f515249 	.inst	0x5f515249 ; undefined
    1494:	544f4f42 	b.cs	9fe7c <GPR_FRAME_SIZE+0x9fd7c>  // b.hs, b.nlast
    1498:	584d4900 	ldr	x0, 9bdb8 <GPR_FRAME_SIZE+0x9bcb8>
    149c:	5f504d38 	.inst	0x5f504d38 ; undefined
    14a0:	5f515249 	.inst	0x5f515249 ; undefined
    14a4:	4643494d 	.inst	0x4643494d ; undefined
    14a8:	455f4c49 	uaddwt	z9.h, z2.h, z31.b
    14ac:	524f5252 	.inst	0x524f5252 ; undefined
    14b0:	584d4900 	ldr	x0, 9bdd0 <GPR_FRAME_SIZE+0x9bcd0>
    14b4:	5f504d38 	.inst	0x5f504d38 ; undefined
    14b8:	5f515249 	.inst	0x5f515249 ; undefined
    14bc:	414d4445 	.inst	0x414d4445 ; undefined
    14c0:	52455f31 	.inst	0x52455f31 ; undefined
    14c4:	00524f52 	.inst	0x00524f52 ; undefined
    14c8:	38584d49 	ldrb	w9, [x10, #-124]!
    14cc:	495f504d 	.inst	0x495f504d ; undefined
    14d0:	535f5152 	.inst	0x535f5152 ; undefined
    14d4:	4900434a 	.inst	0x4900434a ; undefined
    14d8:	4d38584d 	.inst	0x4d38584d ; undefined
    14dc:	52495f50 	.inst	0x52495f50 ; undefined
    14e0:	4e535f51 	.inst	0x4e535f51 ; undefined
    14e4:	535f5356 	.inst	0x535f5356 ; undefined
    14e8:	5f435452 	shl	d18, d2, #3
    14ec:	4700534e 	.inst	0x4700534e ; undefined
    14f0:	33564349 	.inst	0x33564349 ; undefined
    14f4:	6b61775f 	.inst	0x6b61775f ; undefined
    14f8:	65725f65 	fnmla	z5.h, p7/m, z27.h, z18.h
    14fc:	74736964 	.inst	0x74736964 ; undefined
    1500:	75626972 	.inst	0x75626972 ; undefined
    1504:	00726f74 	.inst	0x00726f74 ; undefined
    1508:	38584d49 	ldrb	w9, [x10, #-124]!
    150c:	495f504d 	.inst	0x495f504d ; undefined
    1510:	525f5152 	.inst	0x525f5152 ; undefined
    1514:	52455345 	.inst	0x52455345 ; undefined
    1518:	5f444556 	.inst	0x5f444556 ; undefined
    151c:	00353531 	.inst	0x00353531 ; NYI
    1520:	38584d49 	ldrb	w9, [x10, #-124]!
    1524:	495f504d 	.inst	0x495f504d ; undefined
    1528:	435f5152 	.inst	0x435f5152 ; undefined
    152c:	5f4d4141 	.inst	0x5f4d4141 ; undefined
    1530:	0031514a 	.inst	0x0031514a ; NYI
    1534:	38584d49 	ldrb	w9, [x10, #-124]!
    1538:	495f504d 	.inst	0x495f504d ; undefined
    153c:	525f5152 	.inst	0x525f5152 ; undefined
    1540:	414e5741 	.inst	0x414e5741 ; undefined
    1544:	545f444e 	b.al	bfdcc <GPR_FRAME_SIZE+0xbfccc>
    1548:	4f454d49 	.inst	0x4f454d49 ; undefined
    154c:	49005455 	.inst	0x49005455 ; undefined
    1550:	4d38584d 	.inst	0x4d38584d ; undefined
    1554:	52495f50 	.inst	0x52495f50 ; undefined
    1558:	45505f51 	usubwt	z17.h, z26.h, z16.b
    155c:	4f4d4652 	.inst	0x4f4d4652 ; undefined
    1560:	4900324e 	.inst	0x4900324e ; undefined
    1564:	4d38584d 	.inst	0x4d38584d ; undefined
    1568:	52495f50 	.inst	0x52495f50 ; undefined
    156c:	44485f51 	umlslt	z17.h, z26.b, z8.b
    1570:	545f494d 	b.le	bfe98 <GPR_FRAME_SIZE+0xbfd98>
    1574:	4d490058 	.inst	0x4d490058 ; undefined
    1578:	504d3858 	adr	x24, 9bc82 <GPR_FRAME_SIZE+0x9bb82>
    157c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1580:	454e455f 	saddwt	z31.h, z10.h, z14.b
    1584:	525f3154 	.inst	0x525f3154 ; undefined
    1588:	31585458 	adds	w24, w2, #0x615, lsl #12
    158c:	584d4900 	ldr	x0, 9beac <GPR_FRAME_SIZE+0x9bdac>
    1590:	5f504d38 	.inst	0x5f504d38 ; undefined
    1594:	5f515249 	.inst	0x5f515249 ; undefined
    1598:	45494350 	saddwb	z16.h, z26.h, z9.b
    159c:	5254435f 	.inst	0x5254435f ; undefined
    15a0:	435f314c 	.inst	0x435f314c ; undefined
    15a4:	5f323348 	.inst	0x5f323348 ; undefined
    15a8:	49003336 	.inst	0x49003336 ; undefined
    15ac:	4d38584d 	.inst	0x4d38584d ; undefined
    15b0:	52495f50 	.inst	0x52495f50 ; undefined
    15b4:	55415f51 	.inst	0x55415f51 ; undefined
    15b8:	54483244 	b.mi	91c00 <GPR_FRAME_SIZE+0x91b00>  // b.first
    15bc:	4d490058 	.inst	0x4d490058 ; undefined
    15c0:	504d3858 	adr	x24, 9bcca <GPR_FRAME_SIZE+0x9bbca>
    15c4:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    15c8:	33554d5f 	.inst	0x33554d5f ; undefined
    15cc:	00374d5f 	.inst	0x00374d5f ; NYI
    15d0:	38584d49 	ldrb	w9, [x10, #-124]!
    15d4:	495f504d 	.inst	0x495f504d ; undefined
    15d8:	435f5152 	.inst	0x435f5152 ; undefined
    15dc:	44464e41 	umlalt	z1.h, z18.b, z6.b
    15e0:	4d490032 	.inst	0x4d490032 ; undefined
    15e4:	504d3858 	adr	x24, 9bcee <GPR_FRAME_SIZE+0x9bbee>
    15e8:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    15ec:	5741525f 	.inst	0x5741525f ; undefined
    15f0:	444e414e 	smlalb	z14.h, z10.b, z14.b
    15f4:	4843425f 	ldxrh	wzr, [x18]
    15f8:	43494700 	.inst	0x43494700 ; undefined
    15fc:	475f3356 	.inst	0x475f3356 ; undefined
    1600:	5f444349 	.inst	0x5f444349 ; undefined
    1604:	4f524749 	.inst	0x4f524749 ; undefined
    1608:	5f525055 	.inst	0x5f525055 ; undefined
    160c:	64616572 	.inst	0x64616572 ; undefined
    1610:	584d4900 	ldr	x0, 9bf30 <GPR_FRAME_SIZE+0x9be30>
    1614:	5f504d38 	.inst	0x5f504d38 ; undefined
    1618:	5f515249 	.inst	0x5f515249 ; undefined
    161c:	4d414143 	.inst	0x4d414143 ; undefined
    1620:	32514a5f 	.inst	0x32514a5f ; undefined
    1624:	43494700 	.inst	0x43494700 ; undefined
    1628:	475f3356 	.inst	0x475f3356 ; undefined
    162c:	5f444349 	.inst	0x5f444349 ; undefined
    1630:	554f5249 	.inst	0x554f5249 ; undefined
    1634:	5f524554 	.inst	0x5f524554 ; undefined
    1638:	735f4642 	.inst	0x735f4642 ; undefined
    163c:	415f7465 	.inst	0x415f7465 ; undefined
    1640:	00336666 	.inst	0x00336666 ; NYI
    1644:	56434947 	.inst	0x56434947 ; undefined
    1648:	49475f33 	.inst	0x49475f33 ; undefined
    164c:	495f4443 	.inst	0x495f4443 ; undefined
    1650:	4f495250 	.inst	0x4f495250 ; undefined
    1654:	59544952 	.inst	0x59544952 ; undefined
    1658:	65725f52 	fnmla	z18.h, p7/m, z26.h, z18.h
    165c:	49006461 	.inst	0x49006461 ; undefined
    1660:	4d38584d 	.inst	0x4d38584d ; undefined
    1664:	52495f50 	.inst	0x52495f50 ; undefined
    1668:	53555f51 	.inst	0x53555f51 ; undefined
    166c:	575f3142 	.inst	0x575f3142 ; undefined
    1670:	55454b41 	.inst	0x55454b41 ; undefined
    1674:	4d490050 	.inst	0x4d490050 ; undefined
    1678:	504d3858 	adr	x24, 9bd82 <GPR_FRAME_SIZE+0x9bc82>
    167c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1680:	5244445f 	.inst	0x5244445f ; undefined
    1684:	4343455f 	.inst	0x4343455f ; undefined
    1688:	584d4900 	ldr	x0, 9bfa8 <GPR_FRAME_SIZE+0x9bea8>
    168c:	5f504d38 	.inst	0x5f504d38 ; undefined
    1690:	5f515249 	.inst	0x5f515249 ; undefined
    1694:	32555047 	.inst	0x32555047 ; undefined
    1698:	4d490044 	.inst	0x4d490044 ; undefined
    169c:	504d3858 	adr	x24, 9bda6 <GPR_FRAME_SIZE+0x9bca6>
    16a0:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    16a4:	4950475f 	.inst	0x4950475f ; undefined
    16a8:	315f314f 	adds	w15, w10, #0x7cc, lsl #12
    16ac:	31335f36 	adds	w22, w25, #0xcd7
    16b0:	43494700 	.inst	0x43494700 ; undefined
    16b4:	475f3356 	.inst	0x475f3356 ; undefined
    16b8:	5f444349 	.inst	0x5f444349 ; undefined
    16bc:	47464349 	.inst	0x47464349 ; undefined
    16c0:	72775f52 	.inst	0x72775f52 ; undefined
    16c4:	00657469 	.inst	0x00657469 ; undefined
    16c8:	56434947 	.inst	0x56434947 ; undefined
    16cc:	61765f33 	.inst	0x61765f33 ; undefined
    16d0:	6164696c 	.inst	0x6164696c ; undefined
    16d4:	735f6574 	.inst	0x735f6574 ; undefined
    16d8:	695f6970 	ldpsw	x16, x26, [x11, #248]
    16dc:	4d490064 	.inst	0x4d490064 ; undefined
    16e0:	504d3858 	adr	x24, 9bdea <GPR_FRAME_SIZE+0x9bcea>
    16e4:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    16e8:	454e455f 	saddwt	z31.h, z10.h, z14.b
    16ec:	4f515f54 	.inst	0x4f515f54 ; undefined
    16f0:	4d505f53 	.inst	0x4d505f53 ; undefined
    16f4:	4d490054 	.inst	0x4d490054 ; undefined
    16f8:	504d3858 	adr	x24, 9be02 <GPR_FRAME_SIZE+0x9bd02>
    16fc:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1700:	5244445f 	.inst	0x5244445f ; undefined
    1704:	5245505f 	.inst	0x5245505f ; undefined
    1708:	49470046 	.inst	0x49470046 ; undefined
    170c:	5f335643 	.inst	0x5f335643 ; undefined
    1710:	44434947 	umlalb	z7.h, z10.b, z3.b
    1714:	5059545f 	adr	xzr, b419e <GPR_FRAME_SIZE+0xb409e>
    1718:	725f5245 	.inst	0x725f5245 ; undefined
    171c:	00646165 	.inst	0x00646165 ; undefined
    1720:	56434947 	.inst	0x56434947 ; undefined
    1724:	49475f33 	.inst	0x49475f33 ; undefined
    1728:	495f4443 	.inst	0x495f4443 ; undefined
    172c:	554f5247 	.inst	0x554f5247 ; undefined
    1730:	425f5250 	.inst	0x425f5250 ; undefined
    1734:	65735f46 	fnmla	z6.h, p7/m, z26.h, z19.h
    1738:	4d490074 	.inst	0x4d490074 ; undefined
    173c:	504d3858 	adr	x24, 9be46 <GPR_FRAME_SIZE+0x9bd46>
    1740:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1744:	5745445f 	.inst	0x5745445f ; undefined
    1748:	00505241 	.inst	0x00505241 ; undefined
    174c:	38584d49 	ldrb	w9, [x10, #-124]!
    1750:	495f504d 	.inst	0x495f504d ; undefined
    1754:	515f5152 	sub	w18, w10, #0x7d4, lsl #12
    1758:	4900534f 	.inst	0x4900534f ; undefined
    175c:	4d38584d 	.inst	0x4d38584d ; undefined
    1760:	52495f50 	.inst	0x52495f50 ; undefined
    1764:	52535f51 	.inst	0x52535f51 ; undefined
    1768:	79620043 	ldrh	w3, [x2, #4352]
    176c:	695f6574 	ldpsw	x20, x25, [x11, #248]
    1770:	49007864 	.inst	0x49007864 ; undefined
    1774:	4d38584d 	.inst	0x4d38584d ; undefined
    1778:	52495f50 	.inst	0x52495f50 ; undefined
    177c:	5a545f51 	.inst	0x5a545f51 ; undefined
    1780:	00435341 	.inst	0x00435341 ; undefined
    1784:	38584d49 	ldrb	w9, [x10, #-124]!
    1788:	495f504d 	.inst	0x495f504d ; undefined
    178c:	4d5f5152 	.inst	0x4d5f5152 ; undefined
    1790:	415f3255 	.inst	0x415f3255 ; undefined
    1794:	4f494455 	.inst	0x4f494455 ; undefined
    1798:	43494700 	.inst	0x43494700 ; undefined
    179c:	655f3356 	.inst	0x655f3356 ; undefined
    17a0:	6c62616e 	ldnp	d14, d24, [x11, #-480]
    17a4:	70735f65 	adr	x5, e8393 <GPR_FRAME_SIZE+0xe8293>
    17a8:	4d490069 	.inst	0x4d490069 ; undefined
    17ac:	504d3858 	adr	x24, 9beb6 <GPR_FRAME_SIZE+0x9bdb6>
    17b0:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    17b4:	4332495f 	.inst	0x4332495f ; undefined
    17b8:	4d490035 	.inst	0x4d490035 ; undefined
    17bc:	504d3858 	adr	x24, 9bec6 <GPR_FRAME_SIZE+0x9bdc6>
    17c0:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    17c4:	414e415f 	.inst	0x414e415f ; undefined
    17c8:	5f58494d 	.inst	0x5f58494d ; undefined
    17cc:	504d4554 	adr	x20, 9c076 <GPR_FRAME_SIZE+0x9bf76>
    17d0:	584d4900 	ldr	x0, 9c0f0 <GPR_FRAME_SIZE+0x9bff0>
    17d4:	5f504d38 	.inst	0x5f504d38 ; undefined
    17d8:	5f515249 	.inst	0x5f515249 ; undefined
    17dc:	464e4143 	.inst	0x464e4143 ; undefined
    17e0:	455f3244 	sabdlb	z4.h, z18.b, z31.b
    17e4:	49005252 	.inst	0x49005252 ; undefined
    17e8:	4d38584d 	.inst	0x4d38584d ; undefined
    17ec:	52495f50 	.inst	0x52495f50 ; undefined
    17f0:	50435f51 	adr	x17, 883da <GPR_FRAME_SIZE+0x882da>
    17f4:	44575f55 	umlslt	z21.h, z26.b, z23.b
    17f8:	4900474f 	.inst	0x4900474f ; undefined
    17fc:	4d38584d 	.inst	0x4d38584d ; undefined
    1800:	52495f50 	.inst	0x52495f50 ; undefined
    1804:	53435f51 	.inst	0x53435f51 ; undefined
    1808:	4d490055 	.inst	0x4d490055 ; undefined
    180c:	504d3858 	adr	x24, 9bf16 <GPR_FRAME_SIZE+0x9be16>
    1810:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1814:	4950475f 	.inst	0x4950475f ; undefined
    1818:	305f324f 	adr	x15, bfe61 <GPR_FRAME_SIZE+0xbfd61>
    181c:	0035315f 	.inst	0x0035315f ; NYI
    1820:	38584d49 	ldrb	w9, [x10, #-124]!
    1824:	495f504d 	.inst	0x495f504d ; undefined
    1828:	475f5152 	.inst	0x475f5152 ; undefined
    182c:	44335550 	.inst	0x44335550 ; undefined
    1830:	43494700 	.inst	0x43494700 ; undefined
    1834:	475f3356 	.inst	0x475f3356 ; undefined
    1838:	5f444349 	.inst	0x5f444349 ; undefined
    183c:	45505954 	usubwb	z20.h, z10.h, z16.b
    1840:	46425f52 	.inst	0x46425f52 ; undefined
    1844:	7465675f 	.inst	0x7465675f ; undefined
    1848:	4c54495f 	.inst	0x4c54495f ; undefined
    184c:	73656e69 	.inst	0x73656e69 ; undefined
    1850:	626d754e 	.inst	0x626d754e ; undefined
    1854:	49007265 	.inst	0x49007265 ; undefined
    1858:	4d38584d 	.inst	0x4d38584d ; undefined
    185c:	52495f50 	.inst	0x52495f50 ; undefined
    1860:	53485f51 	.inst	0x53485f51 ; undefined
    1864:	4d490032 	.inst	0x4d490032 ; undefined
    1868:	504d3858 	adr	x24, 9bf72 <GPR_FRAME_SIZE+0x9be72>
    186c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1870:	4943505f 	.inst	0x4943505f ; undefined
    1874:	54435f45 	b.pl	8845c <GPR_FRAME_SIZE+0x8835c>  // b.nfrst
    1878:	5f314c52 	.inst	0x5f314c52 ; undefined
    187c:	4d490030 	.inst	0x4d490030 ; undefined
    1880:	504d3858 	adr	x24, 9bf8a <GPR_FRAME_SIZE+0x9be8a>
    1884:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    1888:	4943505f 	.inst	0x4943505f ; undefined
    188c:	54435f45 	b.pl	88474 <GPR_FRAME_SIZE+0x88374>  // b.nfrst
    1890:	5f314c52 	.inst	0x5f314c52 ; undefined
    1894:	4d490031 	.inst	0x4d490031 ; undefined
    1898:	504d3858 	adr	x24, 9bfa2 <GPR_FRAME_SIZE+0x9bea2>
    189c:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    18a0:	4943505f 	.inst	0x4943505f ; undefined
    18a4:	54435f45 	b.pl	8848c <GPR_FRAME_SIZE+0x8838c>  // b.nfrst
    18a8:	5f314c52 	.inst	0x5f314c52 ; undefined
    18ac:	4d490032 	.inst	0x4d490032 ; undefined
    18b0:	504d3858 	adr	x24, 9bfba <GPR_FRAME_SIZE+0x9beba>
    18b4:	5152495f 	sub	wsp, w10, #0x492, lsl #12
    18b8:	4943505f 	.inst	0x4943505f ; undefined
    18bc:	54435f45 	b.pl	884a4 <GPR_FRAME_SIZE+0x883a4>  // b.nfrst
    18c0:	5f314c52 	.inst	0x5f314c52 ; undefined
    18c4:	41550033 	.inst	0x41550033 ; undefined
    18c8:	725f5452 	.inst	0x725f5452 ; undefined
    18cc:	74657365 	.inst	0x74657365 ; undefined
    18d0:	72615500 	.inst	0x72615500 ; undefined
    18d4:	72635574 	.inst	0x72635574 ; undefined
    18d8:	6c615633 	ldnp	d19, d21, [x17, #-496]
    18dc:	55006575 	.inst	0x55006575 ; undefined
    18e0:	5f545241 	.inst	0x5f545241 ; undefined
    18e4:	32524355 	.inst	0x32524355 ; undefined
    18e8:	6165725f 	.inst	0x6165725f ; undefined
    18ec:	41550064 	.inst	0x41550064 ; undefined
    18f0:	555f5452 	.inst	0x555f5452 ; undefined
    18f4:	5f325243 	fmls	h3, h18, v2.h[3]
    18f8:	735f4642 	.inst	0x735f4642 ; undefined
    18fc:	525f7465 	.inst	0x525f7465 ; undefined
    1900:	004e4558 	.inst	0x004e4558 ; undefined
    1904:	54524155 	bc.pl	a612c <GPR_FRAME_SIZE+0xa602c>  // bc.nfrst
    1908:	5f78745f 	sqshl	d31, d2, #56
    190c:	6f666966 	umlsl2	v6.4s, v11.8h, v6.h[6]
    1910:	6c75665f 	ldnp	d31, d25, [x18, #-176]
    1914:	4155006c 	.inst	0x4155006c ; undefined
    1918:	555f5452 	.inst	0x555f5452 ; undefined
    191c:	425f5354 	.inst	0x425f5354 ; undefined
    1920:	65675f46 	fnmla	z6.h, p7/m, z26.h, z7.h
    1924:	58525f74 	ldr	x20, a6510 <GPR_FRAME_SIZE+0xa6410>
    1928:	54504d45 	b.pl	a22d0 <GPR_FRAME_SIZE+0xa21d0>  // b.nfrst
    192c:	41550059 	.inst	0x41550059 ; undefined
    1930:	555f5452 	.inst	0x555f5452 ; undefined
    1934:	5f315243 	fmls	h3, h18, v1.h[3]
    1938:	74697277 	.inst	0x74697277 ; undefined
    193c:	41550065 	.inst	0x41550065 ; undefined
    1940:	555f5452 	.inst	0x555f5452 ; undefined
    1944:	5f445854 	.inst	0x5f445854 ; undefined
    1948:	74697277 	.inst	0x74697277 ; undefined
    194c:	41550065 	.inst	0x41550065 ; undefined
    1950:	555f5452 	.inst	0x555f5452 ; undefined
    1954:	5f325243 	fmls	h3, h18, v2.h[3]
    1958:	74697277 	.inst	0x74697277 ; undefined
    195c:	41550065 	.inst	0x41550065 ; undefined
    1960:	555f5452 	.inst	0x555f5452 ; undefined
    1964:	5f325243 	fmls	h3, h18, v2.h[3]
    1968:	735f4642 	.inst	0x735f4642 ; undefined
    196c:	575f7465 	.inst	0x575f7465 ; undefined
    1970:	61550053 	.inst	0x61550053 ; undefined
    1974:	63557472 	.inst	0x63557472 ; undefined
    1978:	61563272 	.inst	0x61563272 ; undefined
    197c:	0065756c 	.inst	0x0065756c ; undefined
    1980:	54524155 	bc.pl	a61a8 <GPR_FRAME_SIZE+0xa60a8>  // bc.nfrst
    1984:	5243555f 	.inst	0x5243555f ; undefined
    1988:	46425f33 	.inst	0x46425f33 ; undefined
    198c:	7465735f 	.inst	0x7465735f ; undefined
    1990:	0049525f 	.inst	0x0049525f ; undefined
    1994:	74726155 	.inst	0x74726155 ; undefined
    1998:	72636d55 	.inst	0x72636d55 ; undefined
    199c:	756c6156 	.inst	0x756c6156 ; undefined
    19a0:	41550065 	.inst	0x41550065 ; undefined
    19a4:	555f5452 	.inst	0x555f5452 ; undefined
    19a8:	5f335243 	fmls	h3, h18, v3.h[3]
    19ac:	735f4642 	.inst	0x735f4642 ; undefined
    19b0:	525f7465 	.inst	0x525f7465 ; undefined
    19b4:	554d4458 	.inst	0x554d4458 ; undefined
    19b8:	4c455358 	.inst	0x4c455358 ; undefined
    19bc:	52415500 	.inst	0x52415500 ; undefined
    19c0:	43555f54 	.inst	0x43555f54 ; undefined
    19c4:	775f3352 	.inst	0x775f3352 ; undefined
    19c8:	65746972 	fnmls	z18.h, p2/m, z11.h, z20.h
    19cc:	72615500 	.inst	0x72615500 ; undefined
    19d0:	78725574 	.inst	0x78725574 ; undefined
    19d4:	6c615664 	ldnp	d4, d21, [x19, #-496]
    19d8:	55006575 	.inst	0x55006575 ; undefined
    19dc:	5f545241 	.inst	0x5f545241 ; undefined
    19e0:	52434655 	.inst	0x52434655 ; undefined
    19e4:	6972775f 	ldpsw	xzr, x29, [x26, #-112]
    19e8:	55006574 	.inst	0x55006574 ; undefined
    19ec:	5f545241 	.inst	0x5f545241 ; undefined
    19f0:	52434d55 	.inst	0x52434d55 ; undefined
    19f4:	6972775f 	ldpsw	xzr, x29, [x26, #-112]
    19f8:	55006574 	.inst	0x55006574 ; undefined
    19fc:	5f545241 	.inst	0x5f545241 ; undefined
    1a00:	5f535455 	shl	d21, d2, #19
    1a04:	675f4642 	.inst	0x675f4642 ; undefined
    1a08:	545f7465 	b.pl	c0894 <GPR_FRAME_SIZE+0xc0794>  // b.nfrst
    1a0c:	4c554658 	.inst	0x4c554658 ; undefined
    1a10:	4155004c 	.inst	0x4155004c ; undefined
    1a14:	555f5452 	.inst	0x555f5452 ; undefined
    1a18:	5f325243 	fmls	h3, h18, v2.h[3]
    1a1c:	735f4642 	.inst	0x735f4642 ; undefined
    1a20:	535f7465 	.inst	0x535f7465 ; undefined
    1a24:	00545352 	.inst	0x00545352 ; undefined
    1a28:	54524155 	bc.pl	a6250 <GPR_FRAME_SIZE+0xa6150>  // bc.nfrst
    1a2c:	4452555f 	smlslt	z31.h, z10.b, z18.b
    1a30:	46425f58 	.inst	0x46425f58 ; undefined
    1a34:	7465675f 	.inst	0x7465675f ; undefined
    1a38:	5f58525f 	.inst	0x5f58525f ; undefined
    1a3c:	41544144 	.inst	0x41544144 ; undefined
    1a40:	52415500 	.inst	0x52415500 ; undefined
    1a44:	42555f54 	.inst	0x42555f54 ; undefined
    1a48:	775f524d 	.inst	0x775f524d ; undefined
    1a4c:	65746972 	fnmls	z18.h, p2/m, z11.h, z20.h
    1a50:	52415500 	.inst	0x52415500 ; undefined
    1a54:	43555f54 	.inst	0x43555f54 ; undefined
    1a58:	425f3452 	.inst	0x425f3452 ; undefined
    1a5c:	65735f46 	fnmla	z6.h, p7/m, z26.h, z19.h
    1a60:	54435f74 	bc.mi	8864c <GPR_FRAME_SIZE+0x8854c>  // bc.first
    1a64:	004c5453 	.inst	0x004c5453 ; undefined
    1a68:	54524155 	bc.pl	a6290 <GPR_FRAME_SIZE+0xa6190>  // bc.nfrst
    1a6c:	5852555f 	ldr	xzr, a6514 <GPR_FRAME_SIZE+0xa6414>
    1a70:	65725f44 	fnmla	z4.h, p7/m, z26.h, z18.h
    1a74:	55006461 	.inst	0x55006461 ; undefined
    1a78:	5f545241 	.inst	0x5f545241 ; undefined
    1a7c:	5f535455 	shl	d21, d2, #19
    1a80:	675f4642 	.inst	0x675f4642 ; undefined
    1a84:	535f7465 	.inst	0x535f7465 ; undefined
    1a88:	5254464f 	.inst	0x5254464f ; undefined
    1a8c:	55005453 	.inst	0x55005453 ; undefined
    1a90:	5f545241 	.inst	0x5f545241 ; undefined
    1a94:	5f535455 	shl	d21, d2, #19
    1a98:	64616572 	.inst	0x64616572 ; undefined
    1a9c:	52415500 	.inst	0x52415500 ; undefined
    1aa0:	42555f54 	.inst	0x42555f54 ; undefined
    1aa4:	775f5249 	.inst	0x775f5249 ; undefined
    1aa8:	65746972 	fnmls	z18.h, p2/m, z11.h, z20.h
    1aac:	78747500 	.inst	0x78747500 ; undefined
    1ab0:	72750064 	.inst	0x72750064 ; undefined
    1ab4:	55006478 	.inst	0x55006478 ; undefined
    1ab8:	55747261 	.inst	0x55747261 ; undefined
    1abc:	61567374 	.inst	0x61567374 ; undefined
    1ac0:	0065756c 	.inst	0x0065756c ; undefined
    1ac4:	72636675 	.inst	0x72636675 ; undefined
    1ac8:	52415500 	.inst	0x52415500 ; undefined
    1acc:	43555f54 	.inst	0x43555f54 ; undefined
    1ad0:	425f3352 	.inst	0x425f3352 ; undefined
    1ad4:	65735f46 	fnmla	z6.h, p7/m, z26.h, z19.h
    1ad8:	43445f74 	.inst	0x43445f74 ; undefined
    1adc:	61550044 	.inst	0x61550044 ; undefined
    1ae0:	62557472 	.inst	0x62557472 ; undefined
    1ae4:	61567269 	.inst	0x61567269 ; undefined
    1ae8:	0065756c 	.inst	0x0065756c ; undefined
    1aec:	54524155 	bc.pl	a6314 <GPR_FRAME_SIZE+0xa6214>  // bc.nfrst
    1af0:	4d42555f 	.inst	0x4d42555f ; undefined
    1af4:	46425f52 	.inst	0x46425f52 ; undefined
    1af8:	7465735f 	.inst	0x7465735f ; undefined
    1afc:	444f4d5f 	umlalt	z31.h, z10.b, z15.b
    1b00:	69627500 	ldpsw	x0, x29, [x8, #-240]
    1b04:	63750072 	.inst	0x63750072 ; undefined
    1b08:	75003172 	.inst	0x75003172 ; undefined
    1b0c:	00327263 	.inst	0x00327263 ; NYI
    1b10:	33726375 	.inst	0x33726375 ; undefined
    1b14:	72637500 	.inst	0x72637500 ; undefined
    1b18:	41550034 	.inst	0x41550034 ; undefined
    1b1c:	4e5f5452 	.inst	0x4e5f5452 ; undefined
    1b20:	5341425f 	.inst	0x5341425f ; undefined
    1b24:	61550045 	.inst	0x61550045 ; undefined
    1b28:	66557472 	.inst	0x66557472 ; undefined
    1b2c:	61567263 	.inst	0x61567263 ; undefined
    1b30:	0065756c 	.inst	0x0065756c ; undefined
    1b34:	726d6275 	.inst	0x726d6275 ; undefined
    1b38:	72657000 	.inst	0x72657000 ; undefined
    1b3c:	5f687069 	sqdmlsl	s9, h3, v8.h[2]
    1b40:	65736162 	fnmls	z2.h, p0/m, z11.h, z19.h
    1b44:	52415500 	.inst	0x52415500 ; undefined
    1b48:	42555f54 	.inst	0x42555f54 ; undefined
    1b4c:	425f5249 	.inst	0x425f5249 ; undefined
    1b50:	65735f46 	fnmla	z6.h, p7/m, z26.h, z19.h
    1b54:	4e495f74 	.inst	0x4e495f74 ; undefined
    1b58:	61550043 	.inst	0x61550043 ; undefined
    1b5c:	63557472 	.inst	0x63557472 ; undefined
    1b60:	61563472 	.inst	0x61563472 ; undefined
    1b64:	0065756c 	.inst	0x0065756c ; undefined
    1b68:	54524155 	bc.pl	a6390 <GPR_FRAME_SIZE+0xa6290>  // bc.nfrst
    1b6c:	5243555f 	.inst	0x5243555f ; undefined
    1b70:	46425f32 	.inst	0x46425f32 ; undefined
    1b74:	7465735f 	.inst	0x7465735f ; undefined
    1b78:	5452495f 	bc.nv	a64a0 <GPR_FRAME_SIZE+0xa63a0>
    1b7c:	61550053 	.inst	0x61550053 ; undefined
    1b80:	62557472 	.inst	0x62557472 ; undefined
    1b84:	6156726d 	.inst	0x6156726d ; undefined
    1b88:	0065756c 	.inst	0x0065756c ; undefined
    1b8c:	54524155 	bc.pl	a63b4 <GPR_FRAME_SIZE+0xa62b4>  // bc.nfrst
    1b90:	5243555f 	.inst	0x5243555f ; undefined
    1b94:	46425f31 	.inst	0x46425f31 ; undefined
    1b98:	7465735f 	.inst	0x7465735f ; undefined
    1b9c:	5241555f 	.inst	0x5241555f ; undefined
    1ba0:	004e4554 	.inst	0x004e4554 ; undefined
    1ba4:	72636d75 	.inst	0x72636d75 ; undefined
    1ba8:	52415500 	.inst	0x52415500 ; undefined
    1bac:	43555f54 	.inst	0x43555f54 ; undefined
    1bb0:	775f3452 	.inst	0x775f3452 ; undefined
    1bb4:	65746972 	fnmls	z18.h, p2/m, z11.h, z20.h
    1bb8:	52415500 	.inst	0x52415500 ; undefined
    1bbc:	43555f54 	.inst	0x43555f54 ; undefined
    1bc0:	425f3252 	.inst	0x425f3252 ; undefined
    1bc4:	65735f46 	fnmla	z6.h, p7/m, z26.h, z19.h
    1bc8:	58545f74 	ldr	x20, aa7b4 <GPR_FRAME_SIZE+0xaa6b4>
    1bcc:	55004e45 	.inst	0x55004e45 ; undefined
    1bd0:	55747261 	.inst	0x55747261 ; undefined
    1bd4:	56317263 	.inst	0x56317263 ; undefined
    1bd8:	65756c61 	fnmls	z1.h, p3/m, z3.h, z21.h
    1bdc:	52415500 	.inst	0x52415500 ; undefined
    1be0:	43555f54 	.inst	0x43555f54 ; undefined
    1be4:	425f3352 	.inst	0x425f3352 ; undefined
    1be8:	65735f46 	fnmla	z6.h, p7/m, z26.h, z19.h
    1bec:	53445f74 	.inst	0x53445f74 ; undefined
    1bf0:	61550052 	.inst	0x61550052 ; undefined
    1bf4:	74557472 	.inst	0x74557472 ; undefined
    1bf8:	61566478 	.inst	0x61566478 ; undefined
    1bfc:	0065756c 	.inst	0x0065756c ; undefined

Disassembly of section .debug_rnglists:

0000000000000000 <.debug_rnglists>:
   0:	0000001f 	udf	#31
   4:	00080005 	.inst	0x00080005 ; undefined
   8:	00000000 	udf	#0
   c:	00007007 	udf	#28679
  10:	00000040 	udf	#64
  14:	07129000 	.inst	0x07129000 ; undefined
  18:	40004000 	.inst	0x40004000 ; undefined
  1c:	00000000 	udf	#0
  20:	27000f84 	.inst	0x27000f84 ; undefined
  24:	05000000 	orr	z0.s, z0.s, #0x1
  28:	00000800 	udf	#2048
  2c:	04000000 	add	z0.b, p0/m, z0.b, z0.b
  30:	88047010 	stxr	w4, w16, [x0]
  34:	00018c01 	.inst	0x00018c01 ; undefined
  38:	b807ec04 	str	w4, [x0, #126]!
  3c:	0ef4040a 	.inst	0x0ef4040a ; undefined
  40:	04000efc 	add	z28.b, p3/m, z28.b, z23.b
  44:	0bb80ac0 	.inst	0x0bb80ac0 ; undefined
  48:	800efc04 	.inst	0x800efc04 ; undefined
  4c:	Address 0x4c is out of bounds.


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
  3c:	34323032 	cbz	w18, 64640 <GPR_FRAME_SIZE+0x64540>
  40:	39313131 	strb	w17, [x9, #3148]
	...

Disassembly of section .debug_frame:

0000000000000000 <.debug_frame>:
   0:	0000000c 	udf	#12
   4:	ffffffff 	.inst	0xffffffff ; undefined
   8:	78040001 	sturh	w1, [x0, #64]
   c:	001f0c1e 	.inst	0x001f0c1e ; undefined
  10:	00000024 	udf	#36
  14:	00000000 	udf	#0
  18:	40000c98 	.inst	0x40000c98 ; undefined
  1c:	00000000 	udf	#0
  20:	000000b4 	udf	#180
  24:	00000000 	udf	#0
  28:	9d100e41 	.inst	0x9d100e41 ; undefined
  2c:	6b019e02 	.inst	0x6b019e02 ; undefined
  30:	000eddde 	.inst	0x000eddde ; undefined
  34:	00000000 	udf	#0
  38:	0000001c 	udf	#28
  3c:	00000000 	udf	#0
  40:	40000d4c 	.inst	0x40000d4c ; undefined
  44:	00000000 	udf	#0
  48:	00000118 	udf	#280
  4c:	00000000 	udf	#0
  50:	01e00e41 	.inst	0x01e00e41 ; undefined
  54:	1b9e1c9d 	.inst	0x1b9e1c9d ; undefined
  58:	00000024 	udf	#36
  5c:	00000000 	udf	#0
  60:	40000e64 	.inst	0x40000e64 ; undefined
  64:	00000000 	udf	#0
  68:	00000070 	udf	#112
  6c:	00000000 	udf	#0
  70:	9d200e41 	.inst	0x9d200e41 ; undefined
  74:	42039e04 	.inst	0x42039e04 ; undefined
  78:	de580293 	.inst	0xde580293 ; undefined
  7c:	000ed3dd 	.inst	0x000ed3dd ; undefined
  80:	00000024 	udf	#36
  84:	00000000 	udf	#0
  88:	40000ed4 	.inst	0x40000ed4 ; undefined
  8c:	00000000 	udf	#0
  90:	00000034 	udf	#52
  94:	00000000 	udf	#0
  98:	9d400e41 	.inst	0x9d400e41 ; undefined
  9c:	42079e08 	.inst	0x42079e08 ; undefined
  a0:	00000693 	udf	#1683
  a4:	00000000 	udf	#0
  a8:	00000024 	udf	#36
  ac:	00000000 	udf	#0
  b0:	40000f08 	.inst	0x40000f08 ; undefined
  b4:	00000000 	udf	#0
  b8:	00000124 	udf	#292
  bc:	00000000 	udf	#0
  c0:	9d300e41 	.inst	0x9d300e41 ; undefined
  c4:	02059e06 	.inst	0x02059e06 ; undefined
  c8:	0eddde47 	.inst	0x0eddde47 ; undefined
  cc:	00000000 	udf	#0
  d0:	0000000c 	udf	#12
  d4:	ffffffff 	.inst	0xffffffff ; undefined
  d8:	78040001 	sturh	w1, [x0, #64]
  dc:	001f0c1e 	.inst	0x001f0c1e ; undefined
  e0:	0000001c 	udf	#28
  e4:	000000d0 	udf	#208
  e8:	4000102c 	.inst	0x4000102c ; undefined
  ec:	00000000 	udf	#0
  f0:	00000028 	udf	#40
  f4:	00000000 	udf	#0
  f8:	48100e41 	stxrh	w16, w1, [x18]
  fc:	0000000e 	udf	#14
 100:	0000001c 	udf	#28
 104:	000000d0 	udf	#208
 108:	40001054 	.inst	0x40001054 ; undefined
 10c:	00000000 	udf	#0
 110:	0000005c 	udf	#92
 114:	00000000 	udf	#0
 118:	55200e41 	.inst	0x55200e41 ; undefined
 11c:	0000000e 	udf	#14
 120:	00000024 	udf	#36
 124:	000000d0 	udf	#208
 128:	400010b0 	.inst	0x400010b0 ; undefined
 12c:	00000000 	udf	#0
 130:	00000050 	udf	#80
 134:	00000000 	udf	#0
 138:	9d200e41 	.inst	0x9d200e41 ; undefined
 13c:	42039e04 	.inst	0x42039e04 ; undefined
 140:	de500293 	.inst	0xde500293 ; undefined
 144:	000ed3dd 	.inst	0x000ed3dd ; undefined
 148:	00000024 	udf	#36
 14c:	000000d0 	udf	#208
 150:	40001100 	.inst	0x40001100 ; undefined
 154:	00000000 	udf	#0
 158:	0000015c 	udf	#348
 15c:	00000000 	udf	#0
 160:	04c00e41 	add	z1.d, p3/m, z1.d, z18.d
 164:	9e489d41 	.inst	0x9e489d41 ; undefined
 168:	46934247 	.inst	0x46934247 ; undefined
 16c:	00000000 	udf	#0
 170:	0000000c 	udf	#12
 174:	ffffffff 	.inst	0xffffffff ; undefined
 178:	78040001 	sturh	w1, [x0, #64]
 17c:	001f0c1e 	.inst	0x001f0c1e ; undefined
 180:	00000024 	udf	#36
 184:	00000170 	udf	#368
 188:	4000125c 	.inst	0x4000125c ; undefined
 18c:	00000000 	udf	#0
 190:	00000058 	udf	#88
 194:	00000000 	udf	#0
 198:	9d200e41 	.inst	0x9d200e41 ; undefined
 19c:	54039e04 	b.mi	755c <GPR_FRAME_SIZE+0x745c>  // b.first
 1a0:	000eddde 	.inst	0x000eddde ; undefined
 1a4:	00000000 	udf	#0
 1a8:	0000000c 	udf	#12
 1ac:	ffffffff 	.inst	0xffffffff ; undefined
 1b0:	78040001 	sturh	w1, [x0, #64]
 1b4:	001f0c1e 	.inst	0x001f0c1e ; undefined
 1b8:	0000001c 	udf	#28
 1bc:	000001a8 	udf	#424
 1c0:	400012b4 	.inst	0x400012b4 ; undefined
 1c4:	00000000 	udf	#0
 1c8:	0000004c 	udf	#76
 1cc:	00000000 	udf	#0
 1d0:	9d500e41 	.inst	0x9d500e41 ; undefined
 1d4:	00099e0a 	.inst	0x00099e0a ; undefined
 1d8:	0000000c 	udf	#12
 1dc:	ffffffff 	.inst	0xffffffff ; undefined
 1e0:	78040001 	sturh	w1, [x0, #64]
 1e4:	001f0c1e 	.inst	0x001f0c1e ; undefined
 1e8:	0000001c 	udf	#28
 1ec:	000001d8 	udf	#472
 1f0:	40001300 	.inst	0x40001300 ; undefined
 1f4:	00000000 	udf	#0
 1f8:	0000004c 	udf	#76
 1fc:	00000000 	udf	#0
 200:	9d500e41 	.inst	0x9d500e41 ; undefined
 204:	00099e0a 	.inst	0x00099e0a ; undefined
 208:	0000000c 	udf	#12
 20c:	ffffffff 	.inst	0xffffffff ; undefined
 210:	78040001 	sturh	w1, [x0, #64]
 214:	001f0c1e 	.inst	0x001f0c1e ; undefined
 218:	0000001c 	udf	#28
 21c:	00000208 	udf	#520
 220:	4000134c 	.inst	0x4000134c ; undefined
 224:	00000000 	udf	#0
 228:	0000004c 	udf	#76
 22c:	00000000 	udf	#0
 230:	9d500e41 	.inst	0x9d500e41 ; undefined
 234:	00099e0a 	.inst	0x00099e0a ; undefined
 238:	0000000c 	udf	#12
 23c:	ffffffff 	.inst	0xffffffff ; undefined
 240:	78040001 	sturh	w1, [x0, #64]
 244:	001f0c1e 	.inst	0x001f0c1e ; undefined
 248:	0000001c 	udf	#28
 24c:	00000238 	udf	#568
 250:	40001398 	.inst	0x40001398 ; undefined
 254:	00000000 	udf	#0
 258:	0000004c 	udf	#76
 25c:	00000000 	udf	#0
 260:	9d500e41 	.inst	0x9d500e41 ; undefined
 264:	00099e0a 	.inst	0x00099e0a ; undefined
 268:	0000000c 	udf	#12
 26c:	ffffffff 	.inst	0xffffffff ; undefined
 270:	78040001 	sturh	w1, [x0, #64]
 274:	001f0c1e 	.inst	0x001f0c1e ; undefined
 278:	0000001c 	udf	#28
 27c:	00000268 	udf	#616
 280:	400013e4 	.inst	0x400013e4 ; undefined
 284:	00000000 	udf	#0
 288:	0000004c 	udf	#76
 28c:	00000000 	udf	#0
 290:	9d500e41 	.inst	0x9d500e41 ; undefined
 294:	00099e0a 	.inst	0x00099e0a ; undefined
 298:	0000000c 	udf	#12
 29c:	ffffffff 	.inst	0xffffffff ; undefined
 2a0:	78040001 	sturh	w1, [x0, #64]
 2a4:	001f0c1e 	.inst	0x001f0c1e ; undefined
 2a8:	0000001c 	udf	#28
 2ac:	00000298 	udf	#664
 2b0:	40001430 	.inst	0x40001430 ; undefined
 2b4:	00000000 	udf	#0
 2b8:	0000004c 	udf	#76
 2bc:	00000000 	udf	#0
 2c0:	9d500e41 	.inst	0x9d500e41 ; undefined
 2c4:	00099e0a 	.inst	0x00099e0a ; undefined
 2c8:	0000000c 	udf	#12
 2cc:	ffffffff 	.inst	0xffffffff ; undefined
 2d0:	78040001 	sturh	w1, [x0, #64]
 2d4:	001f0c1e 	.inst	0x001f0c1e ; undefined
 2d8:	0000001c 	udf	#28
 2dc:	000002c8 	udf	#712
 2e0:	4000147c 	.inst	0x4000147c ; undefined
 2e4:	00000000 	udf	#0
 2e8:	0000004c 	udf	#76
 2ec:	00000000 	udf	#0
 2f0:	9d500e41 	.inst	0x9d500e41 ; undefined
 2f4:	00099e0a 	.inst	0x00099e0a ; undefined
 2f8:	0000000c 	udf	#12
 2fc:	ffffffff 	.inst	0xffffffff ; undefined
 300:	78040001 	sturh	w1, [x0, #64]
 304:	001f0c1e 	.inst	0x001f0c1e ; undefined
 308:	0000001c 	udf	#28
 30c:	000002f8 	udf	#760
 310:	400014c8 	.inst	0x400014c8 ; undefined
 314:	00000000 	udf	#0
 318:	0000004c 	udf	#76
 31c:	00000000 	udf	#0
 320:	9d500e41 	.inst	0x9d500e41 ; undefined
 324:	00099e0a 	.inst	0x00099e0a ; undefined
 328:	0000000c 	udf	#12
 32c:	ffffffff 	.inst	0xffffffff ; undefined
 330:	78040001 	sturh	w1, [x0, #64]
 334:	001f0c1e 	.inst	0x001f0c1e ; undefined
 338:	0000001c 	udf	#28
 33c:	00000328 	udf	#808
 340:	40001514 	.inst	0x40001514 ; undefined
 344:	00000000 	udf	#0
 348:	0000004c 	udf	#76
 34c:	00000000 	udf	#0
 350:	9d500e41 	.inst	0x9d500e41 ; undefined
 354:	00099e0a 	.inst	0x00099e0a ; undefined
 358:	0000000c 	udf	#12
 35c:	ffffffff 	.inst	0xffffffff ; undefined
 360:	78040001 	sturh	w1, [x0, #64]
 364:	001f0c1e 	.inst	0x001f0c1e ; undefined
 368:	0000001c 	udf	#28
 36c:	00000358 	udf	#856
 370:	40001560 	.inst	0x40001560 ; undefined
 374:	00000000 	udf	#0
 378:	0000004c 	udf	#76
 37c:	00000000 	udf	#0
 380:	9d500e41 	.inst	0x9d500e41 ; undefined
 384:	00099e0a 	.inst	0x00099e0a ; undefined
 388:	0000000c 	udf	#12
 38c:	ffffffff 	.inst	0xffffffff ; undefined
 390:	78040001 	sturh	w1, [x0, #64]
 394:	001f0c1e 	.inst	0x001f0c1e ; undefined
 398:	0000001c 	udf	#28
 39c:	00000388 	udf	#904
 3a0:	400015ac 	.inst	0x400015ac ; undefined
 3a4:	00000000 	udf	#0
 3a8:	0000004c 	udf	#76
 3ac:	00000000 	udf	#0
 3b0:	9d500e41 	.inst	0x9d500e41 ; undefined
 3b4:	00099e0a 	.inst	0x00099e0a ; undefined
 3b8:	0000000c 	udf	#12
 3bc:	ffffffff 	.inst	0xffffffff ; undefined
 3c0:	78040001 	sturh	w1, [x0, #64]
 3c4:	001f0c1e 	.inst	0x001f0c1e ; undefined
 3c8:	0000001c 	udf	#28
 3cc:	000003b8 	udf	#952
 3d0:	400015f8 	.inst	0x400015f8 ; undefined
 3d4:	00000000 	udf	#0
 3d8:	0000004c 	udf	#76
 3dc:	00000000 	udf	#0
 3e0:	9d500e41 	.inst	0x9d500e41 ; undefined
 3e4:	00099e0a 	.inst	0x00099e0a ; undefined
 3e8:	0000000c 	udf	#12
 3ec:	ffffffff 	.inst	0xffffffff ; undefined
 3f0:	78040001 	sturh	w1, [x0, #64]
 3f4:	001f0c1e 	.inst	0x001f0c1e ; undefined
 3f8:	0000001c 	udf	#28
 3fc:	000003e8 	udf	#1000
 400:	40001644 	.inst	0x40001644 ; undefined
 404:	00000000 	udf	#0
 408:	0000004c 	udf	#76
 40c:	00000000 	udf	#0
 410:	9d500e41 	.inst	0x9d500e41 ; undefined
 414:	00099e0a 	.inst	0x00099e0a ; undefined
 418:	0000000c 	udf	#12
 41c:	ffffffff 	.inst	0xffffffff ; undefined
 420:	78040001 	sturh	w1, [x0, #64]
 424:	001f0c1e 	.inst	0x001f0c1e ; undefined
 428:	0000001c 	udf	#28
 42c:	00000418 	udf	#1048
 430:	40001690 	.inst	0x40001690 ; undefined
 434:	00000000 	udf	#0
 438:	0000004c 	udf	#76
 43c:	00000000 	udf	#0
 440:	9d500e41 	.inst	0x9d500e41 ; undefined
 444:	00099e0a 	.inst	0x00099e0a ; undefined
 448:	0000000c 	udf	#12
 44c:	ffffffff 	.inst	0xffffffff ; undefined
 450:	78040001 	sturh	w1, [x0, #64]
 454:	001f0c1e 	.inst	0x001f0c1e ; undefined
 458:	0000001c 	udf	#28
 45c:	00000448 	udf	#1096
 460:	400016dc 	.inst	0x400016dc ; undefined
 464:	00000000 	udf	#0
 468:	0000004c 	udf	#76
 46c:	00000000 	udf	#0
 470:	9d500e41 	.inst	0x9d500e41 ; undefined
 474:	00099e0a 	.inst	0x00099e0a ; undefined
 478:	0000000c 	udf	#12
 47c:	ffffffff 	.inst	0xffffffff ; undefined
 480:	78040001 	sturh	w1, [x0, #64]
 484:	001f0c1e 	.inst	0x001f0c1e ; undefined
 488:	0000001c 	udf	#28
 48c:	00000478 	udf	#1144
 490:	40001728 	.inst	0x40001728 ; undefined
 494:	00000000 	udf	#0
 498:	0000004c 	udf	#76
 49c:	00000000 	udf	#0
 4a0:	9d500e41 	.inst	0x9d500e41 ; undefined
 4a4:	00099e0a 	.inst	0x00099e0a ; undefined
 4a8:	0000000c 	udf	#12
 4ac:	ffffffff 	.inst	0xffffffff ; undefined
 4b0:	78040001 	sturh	w1, [x0, #64]
 4b4:	001f0c1e 	.inst	0x001f0c1e ; undefined
 4b8:	00000024 	udf	#36
 4bc:	000004a8 	udf	#1192
 4c0:	40001774 	.inst	0x40001774 ; undefined
 4c4:	00000000 	udf	#0
 4c8:	00000094 	udf	#148
 4cc:	00000000 	udf	#0
 4d0:	9d300e41 	.inst	0x9d300e41 ; undefined
 4d4:	42059e06 	.inst	0x42059e06 ; undefined
 4d8:	de610493 	.inst	0xde610493 ; undefined
 4dc:	000ed3dd 	.inst	0x000ed3dd ; undefined
 4e0:	00000024 	udf	#36
 4e4:	000004a8 	udf	#1192
 4e8:	40001808 	.inst	0x40001808 ; undefined
 4ec:	00000000 	udf	#0
 4f0:	00000114 	udf	#276
 4f4:	00000000 	udf	#0
 4f8:	9d600e41 	.inst	0x9d600e41 ; undefined
 4fc:	020b9e0c 	.inst	0x020b9e0c ; undefined
 500:	0eddde43 	.inst	0x0eddde43 ; undefined
 504:	00000000 	udf	#0
 508:	00000024 	udf	#36
 50c:	000004a8 	udf	#1192
 510:	4000191c 	.inst	0x4000191c ; undefined
 514:	00000000 	udf	#0
 518:	00000074 	udf	#116
 51c:	00000000 	udf	#0
 520:	9d200e41 	.inst	0x9d200e41 ; undefined
 524:	5b039e04 	.inst	0x5b039e04 ; undefined
 528:	000eddde 	.inst	0x000eddde ; undefined
 52c:	00000000 	udf	#0
 530:	00000024 	udf	#36
 534:	000004a8 	udf	#1192
 538:	40001990 	.inst	0x40001990 ; undefined
 53c:	00000000 	udf	#0
 540:	00000074 	udf	#116
 544:	00000000 	udf	#0
 548:	9d200e41 	.inst	0x9d200e41 ; undefined
 54c:	5b039e04 	.inst	0x5b039e04 ; undefined
 550:	000eddde 	.inst	0x000eddde ; undefined
 554:	00000000 	udf	#0
 558:	0000000c 	udf	#12
 55c:	ffffffff 	.inst	0xffffffff ; undefined
 560:	78040001 	sturh	w1, [x0, #64]
 564:	001f0c1e 	.inst	0x001f0c1e ; undefined
 568:	0000001c 	udf	#28
 56c:	00000558 	udf	#1368
 570:	40001a04 	.inst	0x40001a04 ; undefined
 574:	00000000 	udf	#0
 578:	00000094 	udf	#148
 57c:	00000000 	udf	#0
 580:	63300e41 	.inst	0x63300e41 ; undefined
 584:	0000000e 	udf	#14
 588:	00000024 	udf	#36
 58c:	00000558 	udf	#1368
 590:	40001a98 	.inst	0x40001a98 ; undefined
 594:	00000000 	udf	#0
 598:	00000070 	udf	#112
 59c:	00000000 	udf	#0
 5a0:	9d600e41 	.inst	0x9d600e41 ; undefined
 5a4:	5a0b9e0c 	.inst	0x5a0b9e0c ; undefined
 5a8:	000eddde 	.inst	0x000eddde ; undefined
 5ac:	00000000 	udf	#0
 5b0:	00000024 	udf	#36
 5b4:	00000558 	udf	#1368
 5b8:	40001b08 	.inst	0x40001b08 ; undefined
 5bc:	00000000 	udf	#0
 5c0:	000006c8 	udf	#1736
 5c4:	00000000 	udf	#0
 5c8:	01f00e41 	.inst	0x01f00e41 ; undefined
 5cc:	1d9e1e9d 	.inst	0x1d9e1e9d ; undefined
 5d0:	de01b003 	.inst	0xde01b003 ; undefined
 5d4:	00000edd 	udf	#3805
 5d8:	0000000c 	udf	#12
 5dc:	ffffffff 	.inst	0xffffffff ; undefined
 5e0:	78040001 	sturh	w1, [x0, #64]
 5e4:	001f0c1e 	.inst	0x001f0c1e ; undefined
 5e8:	00000024 	udf	#36
 5ec:	000005d8 	udf	#1496
 5f0:	400021d0 	.inst	0x400021d0 ; undefined
 5f4:	00000000 	udf	#0
 5f8:	0000013c 	udf	#316
 5fc:	00000000 	udf	#0
 600:	01a00e41 	.inst	0x01a00e41 ; undefined
 604:	139e149d 	extr	w29, w4, w30, #5
 608:	ddde4d02 	.inst	0xddde4d02 ; undefined
 60c:	0000000e 	udf	#14
 610:	00000024 	udf	#36
 614:	000005d8 	udf	#1496
 618:	4000230c 	.inst	0x4000230c ; undefined
 61c:	00000000 	udf	#0
 620:	00000094 	udf	#148
 624:	00000000 	udf	#0
 628:	9d700e41 	.inst	0x9d700e41 ; undefined
 62c:	630d9e0e 	.inst	0x630d9e0e ; undefined
 630:	000eddde 	.inst	0x000eddde ; undefined
 634:	00000000 	udf	#0
 638:	00000024 	udf	#36
 63c:	000005d8 	udf	#1496
 640:	400023a0 	.inst	0x400023a0 ; undefined
 644:	00000000 	udf	#0
 648:	00000228 	udf	#552
 64c:	00000000 	udf	#0
 650:	01b00e41 	.inst	0x01b00e41 ; undefined
 654:	159e169d 	b	67860c8 <GPR_FRAME_SIZE+0x6785fc8>
 658:	ddde8802 	.inst	0xddde8802 ; undefined
 65c:	0000000e 	udf	#14
 660:	0000000c 	udf	#12
 664:	ffffffff 	.inst	0xffffffff ; undefined
 668:	78040001 	sturh	w1, [x0, #64]
 66c:	001f0c1e 	.inst	0x001f0c1e ; undefined
 670:	0000001c 	udf	#28
 674:	00000660 	udf	#1632
 678:	400025c8 	.inst	0x400025c8 ; undefined
 67c:	00000000 	udf	#0
 680:	00000028 	udf	#40
 684:	00000000 	udf	#0
 688:	48100e41 	stxrh	w16, w1, [x18]
 68c:	0000000e 	udf	#14
 690:	0000001c 	udf	#28
 694:	00000660 	udf	#1632
 698:	400025f0 	.inst	0x400025f0 ; undefined
 69c:	00000000 	udf	#0
 6a0:	00000034 	udf	#52
 6a4:	00000000 	udf	#0
 6a8:	4b100e41 	sub	w1, w18, w16, lsl #3
 6ac:	0000000e 	udf	#14
 6b0:	00000024 	udf	#36
 6b4:	00000660 	udf	#1632
 6b8:	40002624 	.inst	0x40002624 ; undefined
 6bc:	00000000 	udf	#0
 6c0:	000000a4 	udf	#164
 6c4:	00000000 	udf	#0
 6c8:	9d600e41 	.inst	0x9d600e41 ; undefined
 6cc:	670b9e0c 	.inst	0x670b9e0c ; undefined
 6d0:	000eddde 	.inst	0x000eddde ; undefined
 6d4:	00000000 	udf	#0
 6d8:	00000014 	udf	#20
 6dc:	00000660 	udf	#1632
 6e0:	400026c8 	.inst	0x400026c8 ; undefined
 6e4:	00000000 	udf	#0
 6e8:	00000010 	udf	#16
 6ec:	00000000 	udf	#0
 6f0:	0000001c 	udf	#28
 6f4:	00000660 	udf	#1632
 6f8:	400026d8 	.inst	0x400026d8 ; undefined
 6fc:	00000000 	udf	#0
 700:	00000020 	udf	#32
 704:	00000000 	udf	#0
 708:	46100e41 	.inst	0x46100e41 ; undefined
 70c:	0000000e 	udf	#14
 710:	0000001c 	udf	#28
 714:	00000660 	udf	#1632
 718:	400026f8 	.inst	0x400026f8 ; undefined
 71c:	00000000 	udf	#0
 720:	00000028 	udf	#40
 724:	00000000 	udf	#0
 728:	48100e41 	stxrh	w16, w1, [x18]
 72c:	0000000e 	udf	#14
 730:	0000001c 	udf	#28
 734:	00000660 	udf	#1632
 738:	40002720 	.inst	0x40002720 ; undefined
 73c:	00000000 	udf	#0
 740:	00000034 	udf	#52
 744:	00000000 	udf	#0
 748:	4b100e41 	sub	w1, w18, w16, lsl #3
 74c:	0000000e 	udf	#14
 750:	00000024 	udf	#36
 754:	00000660 	udf	#1632
 758:	40002754 	.inst	0x40002754 ; undefined
 75c:	00000000 	udf	#0
 760:	00000110 	udf	#272
 764:	00000000 	udf	#0
 768:	01900e41 	.inst	0x01900e41 ; undefined
 76c:	119e129d 	.inst	0x119e129d ; undefined
 770:	ddde4202 	.inst	0xddde4202 ; undefined
 774:	0000000e 	udf	#14
 778:	0000001c 	udf	#28
 77c:	00000660 	udf	#1632
 780:	40002864 	.inst	0x40002864 ; undefined
 784:	00000000 	udf	#0
 788:	00000028 	udf	#40
 78c:	00000000 	udf	#0
 790:	48100e41 	stxrh	w16, w1, [x18]
 794:	0000000e 	udf	#14
 798:	0000001c 	udf	#28
 79c:	00000660 	udf	#1632
 7a0:	4000288c 	.inst	0x4000288c ; undefined
 7a4:	00000000 	udf	#0
 7a8:	00000034 	udf	#52
 7ac:	00000000 	udf	#0
 7b0:	4b100e41 	sub	w1, w18, w16, lsl #3
 7b4:	0000000e 	udf	#14
 7b8:	00000024 	udf	#36
 7bc:	00000660 	udf	#1632
 7c0:	400028c0 	.inst	0x400028c0 ; undefined
 7c4:	00000000 	udf	#0
 7c8:	000000b0 	udf	#176
 7cc:	00000000 	udf	#0
 7d0:	9d700e41 	.inst	0x9d700e41 ; undefined
 7d4:	6a0d9e0e 	.inst	0x6a0d9e0e ; undefined
 7d8:	000eddde 	.inst	0x000eddde ; undefined
 7dc:	00000000 	udf	#0
 7e0:	0000001c 	udf	#28
 7e4:	00000660 	udf	#1632
 7e8:	40002970 	.inst	0x40002970 ; undefined
 7ec:	00000000 	udf	#0
 7f0:	00000034 	udf	#52
 7f4:	00000000 	udf	#0
 7f8:	4b100e41 	sub	w1, w18, w16, lsl #3
 7fc:	0000000e 	udf	#14
 800:	0000001c 	udf	#28
 804:	00000660 	udf	#1632
 808:	400029a4 	.inst	0x400029a4 ; undefined
 80c:	00000000 	udf	#0
 810:	00000038 	udf	#56
 814:	00000000 	udf	#0
 818:	4c100e41 	.inst	0x4c100e41 ; undefined
 81c:	0000000e 	udf	#14
 820:	0000001c 	udf	#28
 824:	00000660 	udf	#1632
 828:	400029dc 	.inst	0x400029dc ; undefined
 82c:	00000000 	udf	#0
 830:	00000038 	udf	#56
 834:	00000000 	udf	#0
 838:	4c100e41 	.inst	0x4c100e41 ; undefined
 83c:	0000000e 	udf	#14
 840:	0000001c 	udf	#28
 844:	00000660 	udf	#1632
 848:	40002a14 	.inst	0x40002a14 ; undefined
 84c:	00000000 	udf	#0
 850:	00000038 	udf	#56
 854:	00000000 	udf	#0
 858:	4c100e41 	.inst	0x4c100e41 ; undefined
 85c:	0000000e 	udf	#14
 860:	0000001c 	udf	#28
 864:	00000660 	udf	#1632
 868:	40002a4c 	.inst	0x40002a4c ; undefined
 86c:	00000000 	udf	#0
 870:	00000038 	udf	#56
 874:	00000000 	udf	#0
 878:	4c100e41 	.inst	0x4c100e41 ; undefined
 87c:	0000000e 	udf	#14
 880:	0000001c 	udf	#28
 884:	00000660 	udf	#1632
 888:	40002a84 	.inst	0x40002a84 ; undefined
 88c:	00000000 	udf	#0
 890:	00000030 	udf	#48
 894:	00000000 	udf	#0
 898:	4a100e41 	eor	w1, w18, w16, lsl #3
 89c:	0000000e 	udf	#14
 8a0:	00000024 	udf	#36
 8a4:	00000660 	udf	#1632
 8a8:	40002ab4 	.inst	0x40002ab4 ; undefined
 8ac:	00000000 	udf	#0
 8b0:	00000094 	udf	#148
 8b4:	00000000 	udf	#0
 8b8:	9d600e41 	.inst	0x9d600e41 ; undefined
 8bc:	630b9e0c 	.inst	0x630b9e0c ; undefined
 8c0:	000eddde 	.inst	0x000eddde ; undefined
 8c4:	00000000 	udf	#0
 8c8:	0000001c 	udf	#28
 8cc:	00000660 	udf	#1632
 8d0:	40002b48 	.inst	0x40002b48 ; undefined
 8d4:	00000000 	udf	#0
 8d8:	00000028 	udf	#40
 8dc:	00000000 	udf	#0
 8e0:	48100e41 	stxrh	w16, w1, [x18]
 8e4:	0000000e 	udf	#14
 8e8:	0000001c 	udf	#28
 8ec:	00000660 	udf	#1632
 8f0:	40002b70 	.inst	0x40002b70 ; undefined
 8f4:	00000000 	udf	#0
 8f8:	00000034 	udf	#52
 8fc:	00000000 	udf	#0
 900:	4b100e41 	sub	w1, w18, w16, lsl #3
 904:	0000000e 	udf	#14
 908:	0000001c 	udf	#28
 90c:	00000660 	udf	#1632
 910:	40002ba4 	.inst	0x40002ba4 ; undefined
 914:	00000000 	udf	#0
 918:	00000024 	udf	#36
 91c:	00000000 	udf	#0
 920:	47100e41 	.inst	0x47100e41 ; undefined
 924:	0000000e 	udf	#14
 928:	0000001c 	udf	#28
 92c:	00000660 	udf	#1632
 930:	40002bc8 	.inst	0x40002bc8 ; undefined
 934:	00000000 	udf	#0
 938:	00000038 	udf	#56
 93c:	00000000 	udf	#0
 940:	4c100e41 	.inst	0x4c100e41 ; undefined
 944:	0000000e 	udf	#14
 948:	00000024 	udf	#36
 94c:	00000660 	udf	#1632
 950:	40002c00 	.inst	0x40002c00 ; undefined
 954:	00000000 	udf	#0
 958:	000000a0 	udf	#160
 95c:	00000000 	udf	#0
 960:	9d700e41 	.inst	0x9d700e41 ; undefined
 964:	660d9e0e 	.inst	0x660d9e0e ; undefined
 968:	000eddde 	.inst	0x000eddde ; undefined
 96c:	00000000 	udf	#0
 970:	00000024 	udf	#36
 974:	00000660 	udf	#1632
 978:	40002ca0 	.inst	0x40002ca0 ; undefined
 97c:	00000000 	udf	#0
 980:	00000070 	udf	#112
 984:	00000000 	udf	#0
 988:	9d300e41 	.inst	0x9d300e41 ; undefined
 98c:	5a059e06 	.inst	0x5a059e06 ; undefined
 990:	000eddde 	.inst	0x000eddde ; undefined
 994:	00000000 	udf	#0
 998:	00000024 	udf	#36
 99c:	00000660 	udf	#1632
 9a0:	40002d10 	.inst	0x40002d10 ; undefined
 9a4:	00000000 	udf	#0
 9a8:	0000007c 	udf	#124
 9ac:	00000000 	udf	#0
 9b0:	9d300e41 	.inst	0x9d300e41 ; undefined
 9b4:	5d059e06 	.inst	0x5d059e06 ; undefined
 9b8:	000eddde 	.inst	0x000eddde ; undefined
 9bc:	00000000 	udf	#0
 9c0:	00000024 	udf	#36
 9c4:	00000660 	udf	#1632
 9c8:	40002d8c 	.inst	0x40002d8c ; undefined
 9cc:	00000000 	udf	#0
 9d0:	00000028 	udf	#40
 9d4:	00000000 	udf	#0
 9d8:	9d200e41 	.inst	0x9d200e41 ; undefined
 9dc:	48039e04 	stlxrh	w3, w4, [x16]
 9e0:	000eddde 	.inst	0x000eddde ; undefined
 9e4:	00000000 	udf	#0
 9e8:	00000024 	udf	#36
 9ec:	00000660 	udf	#1632
 9f0:	40002db4 	.inst	0x40002db4 ; undefined
 9f4:	00000000 	udf	#0
 9f8:	00000050 	udf	#80
 9fc:	00000000 	udf	#0
 a00:	9d300e41 	.inst	0x9d300e41 ; undefined
 a04:	52059e06 	eor	w6, w16, #0xf807f807
 a08:	000eddde 	.inst	0x000eddde ; undefined
 a0c:	00000000 	udf	#0
 a10:	00000024 	udf	#36
 a14:	00000660 	udf	#1632
 a18:	40002e04 	.inst	0x40002e04 ; undefined
 a1c:	00000000 	udf	#0
 a20:	00000070 	udf	#112
 a24:	00000000 	udf	#0
 a28:	9d300e41 	.inst	0x9d300e41 ; undefined
 a2c:	5a059e06 	.inst	0x5a059e06 ; undefined
 a30:	000eddde 	.inst	0x000eddde ; undefined
 a34:	00000000 	udf	#0
 a38:	00000024 	udf	#36
 a3c:	00000660 	udf	#1632
 a40:	40002e74 	.inst	0x40002e74 ; undefined
 a44:	00000000 	udf	#0
 a48:	0000006c 	udf	#108
 a4c:	00000000 	udf	#0
 a50:	9d300e41 	.inst	0x9d300e41 ; undefined
 a54:	59059e06 	.inst	0x59059e06 ; undefined
 a58:	000eddde 	.inst	0x000eddde ; undefined
 a5c:	00000000 	udf	#0
 a60:	00000024 	udf	#36
 a64:	00000660 	udf	#1632
 a68:	40002ee0 	.inst	0x40002ee0 ; undefined
 a6c:	00000000 	udf	#0
 a70:	0000006c 	udf	#108
 a74:	00000000 	udf	#0
 a78:	9d300e41 	.inst	0x9d300e41 ; undefined
 a7c:	59059e06 	.inst	0x59059e06 ; undefined
 a80:	000eddde 	.inst	0x000eddde ; undefined
 a84:	00000000 	udf	#0
 a88:	00000024 	udf	#36
 a8c:	00000660 	udf	#1632
 a90:	40002f4c 	.inst	0x40002f4c ; undefined
 a94:	00000000 	udf	#0
 a98:	0000009c 	udf	#156
 a9c:	00000000 	udf	#0
 aa0:	9d400e41 	.inst	0x9d400e41 ; undefined
 aa4:	65079e08 	bfmin	z8.h, p7/m, z8.h, z16.h
 aa8:	000eddde 	.inst	0x000eddde ; undefined
 aac:	00000000 	udf	#0
 ab0:	0000000c 	udf	#12
 ab4:	ffffffff 	.inst	0xffffffff ; undefined
 ab8:	78040001 	sturh	w1, [x0, #64]
 abc:	001f0c1e 	.inst	0x001f0c1e ; undefined
 ac0:	0000001c 	udf	#28
 ac4:	00000ab0 	udf	#2736
 ac8:	40002fe8 	.inst	0x40002fe8 ; undefined
 acc:	00000000 	udf	#0
 ad0:	00000028 	udf	#40
 ad4:	00000000 	udf	#0
 ad8:	48100e41 	stxrh	w16, w1, [x18]
 adc:	0000000e 	udf	#14
 ae0:	0000001c 	udf	#28
 ae4:	00000ab0 	udf	#2736
 ae8:	40003010 	.inst	0x40003010 ; undefined
 aec:	00000000 	udf	#0
 af0:	00000030 	udf	#48
 af4:	00000000 	udf	#0
 af8:	4a100e41 	eor	w1, w18, w16, lsl #3
 afc:	0000000e 	udf	#14
 b00:	0000001c 	udf	#28
 b04:	00000ab0 	udf	#2736
 b08:	40003040 	.inst	0x40003040 ; undefined
 b0c:	00000000 	udf	#0
 b10:	00000028 	udf	#40
 b14:	00000000 	udf	#0
 b18:	48100e41 	stxrh	w16, w1, [x18]
 b1c:	0000000e 	udf	#14
 b20:	0000001c 	udf	#28
 b24:	00000ab0 	udf	#2736
 b28:	40003068 	.inst	0x40003068 ; undefined
 b2c:	00000000 	udf	#0
 b30:	00000030 	udf	#48
 b34:	00000000 	udf	#0
 b38:	4a100e41 	eor	w1, w18, w16, lsl #3
 b3c:	0000000e 	udf	#14
 b40:	0000001c 	udf	#28
 b44:	00000ab0 	udf	#2736
 b48:	40003098 	.inst	0x40003098 ; undefined
 b4c:	00000000 	udf	#0
 b50:	00000028 	udf	#40
 b54:	00000000 	udf	#0
 b58:	48100e41 	stxrh	w16, w1, [x18]
 b5c:	0000000e 	udf	#14
 b60:	0000001c 	udf	#28
 b64:	00000ab0 	udf	#2736
 b68:	400030c0 	.inst	0x400030c0 ; undefined
 b6c:	00000000 	udf	#0
 b70:	00000030 	udf	#48
 b74:	00000000 	udf	#0
 b78:	4a100e41 	eor	w1, w18, w16, lsl #3
 b7c:	0000000e 	udf	#14
 b80:	0000001c 	udf	#28
 b84:	00000ab0 	udf	#2736
 b88:	400030f0 	.inst	0x400030f0 ; undefined
 b8c:	00000000 	udf	#0
 b90:	0000001c 	udf	#28
 b94:	00000000 	udf	#0
 b98:	45100e41 	.inst	0x45100e41 ; undefined
 b9c:	0000000e 	udf	#14
 ba0:	0000001c 	udf	#28
 ba4:	00000ab0 	udf	#2736
 ba8:	4000310c 	.inst	0x4000310c ; undefined
 bac:	00000000 	udf	#0
 bb0:	00000028 	udf	#40
 bb4:	00000000 	udf	#0
 bb8:	48100e41 	stxrh	w16, w1, [x18]
 bbc:	0000000e 	udf	#14
 bc0:	0000001c 	udf	#28
 bc4:	00000ab0 	udf	#2736
 bc8:	40003134 	.inst	0x40003134 ; undefined
 bcc:	00000000 	udf	#0
 bd0:	00000038 	udf	#56
 bd4:	00000000 	udf	#0
 bd8:	4c100e41 	.inst	0x4c100e41 ; undefined
 bdc:	0000000e 	udf	#14
 be0:	0000001c 	udf	#28
 be4:	00000ab0 	udf	#2736
 be8:	4000316c 	.inst	0x4000316c ; undefined
 bec:	00000000 	udf	#0
 bf0:	00000038 	udf	#56
 bf4:	00000000 	udf	#0
 bf8:	4c100e41 	.inst	0x4c100e41 ; undefined
 bfc:	0000000e 	udf	#14
 c00:	0000001c 	udf	#28
 c04:	00000ab0 	udf	#2736
 c08:	400031a4 	.inst	0x400031a4 ; undefined
 c0c:	00000000 	udf	#0
 c10:	00000038 	udf	#56
 c14:	00000000 	udf	#0
 c18:	4c100e41 	.inst	0x4c100e41 ; undefined
 c1c:	0000000e 	udf	#14
 c20:	0000001c 	udf	#28
 c24:	00000ab0 	udf	#2736
 c28:	400031dc 	.inst	0x400031dc ; undefined
 c2c:	00000000 	udf	#0
 c30:	00000038 	udf	#56
 c34:	00000000 	udf	#0
 c38:	4c100e41 	.inst	0x4c100e41 ; undefined
 c3c:	0000000e 	udf	#14
 c40:	0000001c 	udf	#28
 c44:	00000ab0 	udf	#2736
 c48:	40003214 	.inst	0x40003214 ; undefined
 c4c:	00000000 	udf	#0
 c50:	00000030 	udf	#48
 c54:	00000000 	udf	#0
 c58:	4a100e41 	eor	w1, w18, w16, lsl #3
 c5c:	0000000e 	udf	#14
 c60:	0000001c 	udf	#28
 c64:	00000ab0 	udf	#2736
 c68:	40003244 	.inst	0x40003244 ; undefined
 c6c:	00000000 	udf	#0
 c70:	00000028 	udf	#40
 c74:	00000000 	udf	#0
 c78:	48100e41 	stxrh	w16, w1, [x18]
 c7c:	0000000e 	udf	#14
 c80:	0000001c 	udf	#28
 c84:	00000ab0 	udf	#2736
 c88:	4000326c 	.inst	0x4000326c ; undefined
 c8c:	00000000 	udf	#0
 c90:	00000038 	udf	#56
 c94:	00000000 	udf	#0
 c98:	4c100e41 	.inst	0x4c100e41 ; undefined
 c9c:	0000000e 	udf	#14
 ca0:	0000001c 	udf	#28
 ca4:	00000ab0 	udf	#2736
 ca8:	400032a4 	.inst	0x400032a4 ; undefined
 cac:	00000000 	udf	#0
 cb0:	00000038 	udf	#56
 cb4:	00000000 	udf	#0
 cb8:	4c100e41 	.inst	0x4c100e41 ; undefined
 cbc:	0000000e 	udf	#14
 cc0:	0000001c 	udf	#28
 cc4:	00000ab0 	udf	#2736
 cc8:	400032dc 	.inst	0x400032dc ; undefined
 ccc:	00000000 	udf	#0
 cd0:	00000038 	udf	#56
 cd4:	00000000 	udf	#0
 cd8:	4c100e41 	.inst	0x4c100e41 ; undefined
 cdc:	0000000e 	udf	#14
 ce0:	0000001c 	udf	#28
 ce4:	00000ab0 	udf	#2736
 ce8:	40003314 	.inst	0x40003314 ; undefined
 cec:	00000000 	udf	#0
 cf0:	00000038 	udf	#56
 cf4:	00000000 	udf	#0
 cf8:	4c100e41 	.inst	0x4c100e41 ; undefined
 cfc:	0000000e 	udf	#14
 d00:	0000001c 	udf	#28
 d04:	00000ab0 	udf	#2736
 d08:	4000334c 	.inst	0x4000334c ; undefined
 d0c:	00000000 	udf	#0
 d10:	00000028 	udf	#40
 d14:	00000000 	udf	#0
 d18:	48100e41 	stxrh	w16, w1, [x18]
 d1c:	0000000e 	udf	#14
 d20:	0000001c 	udf	#28
 d24:	00000ab0 	udf	#2736
 d28:	40003374 	.inst	0x40003374 ; undefined
 d2c:	00000000 	udf	#0
 d30:	00000038 	udf	#56
 d34:	00000000 	udf	#0
 d38:	4c100e41 	.inst	0x4c100e41 ; undefined
 d3c:	0000000e 	udf	#14
 d40:	0000001c 	udf	#28
 d44:	00000ab0 	udf	#2736
 d48:	400033ac 	.inst	0x400033ac ; undefined
 d4c:	00000000 	udf	#0
 d50:	00000028 	udf	#40
 d54:	00000000 	udf	#0
 d58:	48100e41 	stxrh	w16, w1, [x18]
 d5c:	0000000e 	udf	#14
 d60:	0000001c 	udf	#28
 d64:	00000ab0 	udf	#2736
 d68:	400033d4 	.inst	0x400033d4 ; undefined
 d6c:	00000000 	udf	#0
 d70:	00000028 	udf	#40
 d74:	00000000 	udf	#0
 d78:	48100e41 	stxrh	w16, w1, [x18]
 d7c:	0000000e 	udf	#14
 d80:	0000001c 	udf	#28
 d84:	00000ab0 	udf	#2736
 d88:	400033fc 	.inst	0x400033fc ; undefined
 d8c:	00000000 	udf	#0
 d90:	00000018 	udf	#24
 d94:	00000000 	udf	#0
 d98:	44100e41 	.inst	0x44100e41 ; undefined
 d9c:	0000000e 	udf	#14
 da0:	0000001c 	udf	#28
 da4:	00000ab0 	udf	#2736
 da8:	40003414 	.inst	0x40003414 ; undefined
 dac:	00000000 	udf	#0
 db0:	00000018 	udf	#24
 db4:	00000000 	udf	#0
 db8:	44100e41 	.inst	0x44100e41 ; undefined
 dbc:	0000000e 	udf	#14
 dc0:	0000001c 	udf	#28
 dc4:	00000ab0 	udf	#2736
 dc8:	4000342c 	.inst	0x4000342c ; undefined
 dcc:	00000000 	udf	#0
 dd0:	0000001c 	udf	#28
 dd4:	00000000 	udf	#0
 dd8:	45100e41 	.inst	0x45100e41 ; undefined
 ddc:	0000000e 	udf	#14
 de0:	0000001c 	udf	#28
 de4:	00000ab0 	udf	#2736
 de8:	40003448 	.inst	0x40003448 ; undefined
 dec:	00000000 	udf	#0
 df0:	00000024 	udf	#36
 df4:	00000000 	udf	#0
 df8:	47100e41 	.inst	0x47100e41 ; undefined
 dfc:	0000000e 	udf	#14
 e00:	0000001c 	udf	#28
 e04:	00000ab0 	udf	#2736
 e08:	4000346c 	.inst	0x4000346c ; undefined
 e0c:	00000000 	udf	#0
 e10:	00000024 	udf	#36
 e14:	00000000 	udf	#0
 e18:	47100e41 	.inst	0x47100e41 ; undefined
 e1c:	0000000e 	udf	#14
 e20:	0000001c 	udf	#28
 e24:	00000ab0 	udf	#2736
 e28:	40003490 	.inst	0x40003490 ; undefined
 e2c:	00000000 	udf	#0
 e30:	00000024 	udf	#36
 e34:	00000000 	udf	#0
 e38:	47100e41 	.inst	0x47100e41 ; undefined
 e3c:	0000000e 	udf	#14
 e40:	0000001c 	udf	#28
 e44:	00000ab0 	udf	#2736
 e48:	400034b4 	.inst	0x400034b4 ; undefined
 e4c:	00000000 	udf	#0
 e50:	00000028 	udf	#40
 e54:	00000000 	udf	#0
 e58:	48100e41 	stxrh	w16, w1, [x18]
 e5c:	0000000e 	udf	#14
 e60:	00000024 	udf	#36
 e64:	00000ab0 	udf	#2736
 e68:	400034dc 	.inst	0x400034dc ; undefined
 e6c:	00000000 	udf	#0
 e70:	0000002c 	udf	#44
 e74:	00000000 	udf	#0
 e78:	9d300e41 	.inst	0x9d300e41 ; undefined
 e7c:	49059e06 	.inst	0x49059e06 ; undefined
 e80:	000eddde 	.inst	0x000eddde ; undefined
 e84:	00000000 	udf	#0
 e88:	00000024 	udf	#36
 e8c:	00000ab0 	udf	#2736
 e90:	40003508 	.inst	0x40003508 ; undefined
 e94:	00000000 	udf	#0
 e98:	00000068 	udf	#104
 e9c:	00000000 	udf	#0
 ea0:	9d300e41 	.inst	0x9d300e41 ; undefined
 ea4:	58059e06 	ldr	x6, c264 <GPR_FRAME_SIZE+0xc164>
 ea8:	000eddde 	.inst	0x000eddde ; undefined
 eac:	00000000 	udf	#0
 eb0:	00000024 	udf	#36
 eb4:	00000ab0 	udf	#2736
 eb8:	40003570 	.inst	0x40003570 ; undefined
 ebc:	00000000 	udf	#0
 ec0:	00000050 	udf	#80
 ec4:	00000000 	udf	#0
 ec8:	9d200e41 	.inst	0x9d200e41 ; undefined
 ecc:	52039e04 	eor	w4, w16, #0xe01fe01f
 ed0:	000eddde 	.inst	0x000eddde ; undefined
 ed4:	00000000 	udf	#0
 ed8:	00000024 	udf	#36
 edc:	00000ab0 	udf	#2736
 ee0:	400035c0 	.inst	0x400035c0 ; undefined
 ee4:	00000000 	udf	#0
 ee8:	00000098 	udf	#152
 eec:	00000000 	udf	#0
 ef0:	9d400e41 	.inst	0x9d400e41 ; undefined
 ef4:	64079e08 	.inst	0x64079e08 ; undefined
 ef8:	000eddde 	.inst	0x000eddde ; undefined
 efc:	00000000 	udf	#0
 f00:	00000024 	udf	#36
 f04:	00000ab0 	udf	#2736
 f08:	40003658 	.inst	0x40003658 ; undefined
 f0c:	00000000 	udf	#0
 f10:	0000014c 	udf	#332
 f14:	00000000 	udf	#0
 f18:	9d700e41 	.inst	0x9d700e41 ; undefined
 f1c:	020d9e0e 	.inst	0x020d9e0e ; undefined
 f20:	0eddde51 	.inst	0x0eddde51 ; undefined
 f24:	00000000 	udf	#0
 f28:	00000024 	udf	#36
 f2c:	00000ab0 	udf	#2736
 f30:	400037a4 	.inst	0x400037a4 ; undefined
 f34:	00000000 	udf	#0
 f38:	00000074 	udf	#116
 f3c:	00000000 	udf	#0
 f40:	9d300e41 	.inst	0x9d300e41 ; undefined
 f44:	5b059e06 	.inst	0x5b059e06 ; undefined
 f48:	000eddde 	.inst	0x000eddde ; undefined
 f4c:	00000000 	udf	#0
