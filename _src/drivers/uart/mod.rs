use crate::{drivers::uart::buffers::RingBuffer, kernel::DriverHandle};

mod buffers;

pub const UART_TX_BUF_SIZE: usize = 8192;
pub const UART_RX_BUF_SIZE: usize = 1024;

const_assert!(UART_TX_BUF_SIZE.is_power_of_two());
const_assert!(UART_RX_BUF_SIZE.is_power_of_two());

pub type bitfield32 = u32;

#[repr(C)]
pub struct UartState {
    pub irq_status: bitfield32,
    pub tx: RingBuffer<UART_TX_BUF_SIZE>,
    pub rx: RingBuffer<UART_RX_BUF_SIZE>,
}

#[inline(always)]
fn uart_state_from_handle<'a>(h: *mut DriverHandle) -> &'a mut UartState {
    unsafe { &mut *((*h).state as *mut UartState) }
}

#[unsafe(no_mangle)]
extern "C" fn UART_txbuf_push(h: *mut DriverHandle, v: u8) -> bool {
    let state = uart_state_from_handle(h);

    state.tx.push(v)
}

#[unsafe(no_mangle)]
extern "C" fn UART_rxbuf_push(h: *mut DriverHandle, v: u8) -> bool {
    let state = uart_state_from_handle(h);

    state.rx.push(v)
}

#[unsafe(no_mangle)]
extern "C" fn UART_txbuf_pop(h: *mut DriverHandle, v: *mut u8) -> bool {
    let state = uart_state_from_handle(h);

    if let Some(res) = state.tx.pop() {
        if let Some(v) = unsafe { v.as_mut() } {
            *v = res;
            return true;
        } else {
            panic!()
        }
    }

    false
}

#[unsafe(no_mangle)]
extern "C" fn UART_rxbuf_pop(h: *mut DriverHandle, v: *mut u8) -> bool {
    let state = uart_state_from_handle(h);

    if let Some(res) = state.rx.pop() {
        if let Some(v) = unsafe { v.as_mut() } {
            *v = res;
            return true;
        } else {
            panic!()
        }
    }

    false
}

unsafe extern "C" {
    fn UART_putc(h: *const DriverHandle, c: u8);
}

pub fn UART_put_str(h: *const DriverHandle, s: &str) {
    for c in s.as_bytes().iter() {
        unsafe {
            UART_putc(h, *c);
        }
    }
}
