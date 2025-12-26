pub type KernelInitcall = fn();

const RUST_KERNEL_INITCALLS_STAGE0: &[KernelInitcall] = &[];
const RUST_KERNEL_INITCALLS_STAGE1: &[KernelInitcall] = &[];
const RUST_KERNEL_INITCALLS_STAGE2: &[KernelInitcall] = &[];

#[unsafe(no_mangle)]
extern "C" fn rust_kernel_initcalls_stage0() {
    for f in RUST_KERNEL_INITCALLS_STAGE0.iter() {
        f();
    }
}

#[unsafe(no_mangle)]
extern "C" fn rust_kernel_initcalls_stage1() {
    for f in RUST_KERNEL_INITCALLS_STAGE1.iter() {
        f();
    }
}

#[unsafe(no_mangle)]
extern "C" fn rust_kernel_initcalls_stage2() {
    for f in RUST_KERNEL_INITCALLS_STAGE2.iter() {
        f();
    }
}
