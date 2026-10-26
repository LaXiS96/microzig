const std = @import("std");

const debug_data0: *volatile u32 = @ptrFromInt(0xE000_00F4);
const debug_data1: *volatile u32 = @ptrFromInt(0xE000_00F8);

pub fn sdi_print(str: []const u8) void {
    var offset: usize = 0;
    while (offset < str.len) : (offset += 7) {
        while (debug_data0.* != 0) {}

        const chunk = str[offset..@min(offset + 7, str.len)];

        // 8 bytes in memory, written as two u32 words (little endian)
        // First byte (data0 LSB) is the number of bytes to send, then up to 7 bytes of data
        var d0: u32 = chunk.len;
        if (chunk.len > 0) d0 |= @as(u32, chunk[0]) << 8;
        if (chunk.len > 1) d0 |= @as(u32, chunk[1]) << 16;
        if (chunk.len > 2) d0 |= @as(u32, chunk[2]) << 24;
        var d1: u32 = 0;
        if (chunk.len > 3) d1 |= @as(u32, chunk[3]);
        if (chunk.len > 4) d1 |= @as(u32, chunk[4]) << 8;
        if (chunk.len > 5) d1 |= @as(u32, chunk[5]) << 16;
        if (chunk.len > 6) d1 |= @as(u32, chunk[6]) << 24;

        debug_data1.* = d1;
        debug_data0.* = d0;
    }
}

// TODO log function for microzig logFn, do we need to implement a writer?
