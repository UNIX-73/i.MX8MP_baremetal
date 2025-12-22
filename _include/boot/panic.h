#pragma once
#include <lib/stdbool.h>
#include <lib/stdint.h>

extern uint64 PANIC_MESSAGE_BUF_SIZE;
extern uint64 PANIC_FILE_BUF_SIZE;

extern uint8 *PANIC_MESSAGE_BUF_PTR;
extern uint8 *PANIC_FILE_BUF_PTR;

extern uint32 PANIC_LINE;
extern uint32 PANIC_COL;

extern uint32 PANIC_REASON;

extern uint64 PANIC_x0;
extern uint64 PANIC_x1;

extern uint64 PANIC_x0;
extern uint64 PANIC_x1;
extern uint64 PANIC_x2;
extern uint64 PANIC_x3;
extern uint64 PANIC_x4;
extern uint64 PANIC_x5;
extern uint64 PANIC_x6;
extern uint64 PANIC_x7;
extern uint64 PANIC_x8;
extern uint64 PANIC_x9;
extern uint64 PANIC_x10;
extern uint64 PANIC_x11;
extern uint64 PANIC_x12;
extern uint64 PANIC_x13;
extern uint64 PANIC_x14;
extern uint64 PANIC_x15;
extern uint64 PANIC_x16;
extern uint64 PANIC_x17;
extern uint64 PANIC_x18;
extern uint64 PANIC_x19;
extern uint64 PANIC_x20;
extern uint64 PANIC_x21;
extern uint64 PANIC_x22;
extern uint64 PANIC_x23;
extern uint64 PANIC_x24;
extern uint64 PANIC_x25;
extern uint64 PANIC_x26;
extern uint64 PANIC_x27;
extern uint64 PANIC_x28;
extern uint64 PANIC_x29; /* FP */
extern uint64 PANIC_x30; /* LR */
extern uint64 PANIC_sp;

typedef enum {
	PANIC_REASON_UNDEFINED = 0,
	PANIC_REASON_EXCEPTION = 1,
	PANIC_REASON_MANUAL_ABORT = 2,
	PANIC_REASON_RUST_PANIC = 3,
} PanicReason;

typedef struct {
	char *file;
	uint32 line;
	uint32 col;
} PanicLocation;

typedef struct {
	char *message;
	PanicLocation location;
	PanicReason panic_reason;
} PanicInfo;

void init_panic();

void set_panic(PanicInfo panic_info);
_Noreturn void set_and_throw_panic(PanicInfo panic_info);
_Noreturn void panic();

#define PANIC(panic_message)                       \
	set_and_throw_panic((PanicInfo){               \
		.message = panic_message,                  \
		.location =                                \
			(PanicLocation){                       \
				.file = __FILE__,                  \
				.line = __LINE__,                  \
				.col = 0,                          \
			},                                     \
		.panic_reason = PANIC_REASON_MANUAL_ABORT, \
	})

/// In the case of an exception panic, saves all the register in the extern
/// savers
void _panic_exception_save_gpr();