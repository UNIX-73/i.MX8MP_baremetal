use core::ffi::c_void;

pub mod init;
pub mod malloc;

#[repr(C)]
pub struct DriverHandle {
    pub base: usize,
    pub state: *mut c_void,
}
