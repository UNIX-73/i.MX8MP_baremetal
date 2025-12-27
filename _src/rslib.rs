#![no_std]
#![allow(non_snake_case)]
#![allow(non_camel_case_types)]
#![allow(special_module_name)]

#[macro_use]
extern crate static_assertions;

mod drivers;
mod kernel;
mod lib;

use core::panic::PanicInfo;

// -- Panic handler ---

unsafe extern "C" {
    fn panic() -> !;

    static mut PANIC_MESSAGE_BUF_PTR: *mut u8;
    static mut PANIC_FILE_BUF_PTR: *mut u8;

    static mut PANIC_LINE: u32;
    static mut PANIC_COL: u32;

    static PANIC_MESSAGE_BUF_SIZE: u64;
    static PANIC_FILE_BUF_SIZE: u64;

    static mut PANIC_REASON: u32;
}

const PANIC_REASON_RUST_PANIC: u32 = 3; // Full enum defined in _include/boot/panic.h

#[unsafe(no_mangle)]
extern "C" fn rust_test_panic() -> ! {
    panic!("Test working :)");
}

#[panic_handler]
fn rust_panic(info: &PanicInfo) -> ! {
    let msg_len: usize = unsafe { PANIC_MESSAGE_BUF_SIZE } as usize;
    let file_len: usize = unsafe { PANIC_FILE_BUF_SIZE } as usize;

    if msg_len == 0 || file_len == 0 {
        loop {}
    }

    if let Some(msg) = info.message().as_str() {
        let copy_bytes = core::cmp::min(msg.len(), msg_len - 1);

        unsafe {
            core::ptr::copy_nonoverlapping(msg.as_ptr(), PANIC_MESSAGE_BUF_PTR, copy_bytes);
            *PANIC_MESSAGE_BUF_PTR.add(copy_bytes) = b'\0';
        }
    }

    if let Some(location) = info.location() {
        unsafe {
            PANIC_LINE = location.line();
            PANIC_COL = location.column();
        }

        let copy_bytes = core::cmp::min(location.file().len(), file_len - 1);

        unsafe {
            core::ptr::copy_nonoverlapping(
                location.file().as_ptr(),
                PANIC_FILE_BUF_PTR,
                copy_bytes,
            );
            *PANIC_FILE_BUF_PTR.add(copy_bytes) = b'\0';
        }
    }

    unsafe {
        PANIC_REASON = PANIC_REASON_RUST_PANIC;
    }

    unsafe { panic() };
}
