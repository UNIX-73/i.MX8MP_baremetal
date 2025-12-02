#pragma once
/* Standard bitfield types */

/// Standard 8 bit bitfield
typedef unsigned char bitfield8;
/// Standard 16 bit bitfield
typedef unsigned short bitfield16;
/// Standard 32 bit bitfield
typedef unsigned int bitfield32;
/// Standard 64 bit bitfield
typedef unsigned long long bitfield64;

/* 8 */

#define BITFIELD8_GET(bm, field) ((bool)(((bitfield8)(bm) >> (field)) & 1u))

#define BITFIELD8_SET(bm_ptr, field) (*(bm_ptr) |= (bitfield8)(1u << (field)))

#define BITFIELD8_CLEAR(bm_ptr, field) \
	(*(bm_ptr) &= (bitfield8) ~(1u << (field)))

#define BITFIELD8_TOGGLE(bm_ptr, field) \
	(*(bm_ptr) ^= (bitfield8)(1u << (field)))

/* 16 */

#define BITFIELD16_GET(bm, field) ((bool)(((bitfield16)(bm) >> (field)) & 1u))

#define BITFIELD16_SET(bm_ptr, field) (*(bm_ptr) |= (bitfield16)(1u << (field)))

#define BITFIELD16_CLEAR(bm_ptr, field) \
	(*(bm_ptr) &= (bitfield16) ~(1u << (field)))

#define BITFIELD16_TOGGLE(bm_ptr, field) \
	(*(bm_ptr) ^= (bitfield16)(1u << (field)))

/* 32 */

#define BITFIELD32_GET(bm, field) ((bool)(((bitfield32)(bm) >> (field)) & 1u))

#define BITFIELD32_SET(bm_ptr, field) (*(bm_ptr) |= (bitfield32)(1u << (field)))

#define BITFIELD32_CLEAR(bm_ptr, field) \
	(*(bm_ptr) &= (bitfield32) ~(1u << (field)))

#define BITFIELD32_TOGGLE(bm_ptr, field) \
	(*(bm_ptr) ^= (bitfield32)(1u << (field)))

/* 64 */

#define BITFIELD64_GET(bm, field) ((bool)(((bitfield64)(bm) >> (field)) & 1ull))

#define BITFIELD64_SET(bm_ptr, field) \
	(*(bm_ptr) |= (bitfield64)(1ull << (field)))

#define BITFIELD64_CLEAR(bm_ptr, field) \
	(*(bm_ptr) &= (bitfield64) ~(1ull << (field)))

#define BITFIELD64_TOGGLE(bm_ptr, field) \
	(*(bm_ptr) ^= (bitfield64)(1ull << (field)))
