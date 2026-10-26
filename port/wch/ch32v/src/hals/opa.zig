const std = @import("std");
const microzig = @import("microzig");
const EXTEN = microzig.chip.peripherals.EXTEN;

/// Output GPIO: PD4
/// Default GPIOs: OPN0 = PA1, OPP0 = PA2
/// Remapped GPIOs: OPN1 = PD0, OPP1 = PD7
pub fn init(comptime remap: bool) void {
    // TODO allow per-pin remap
    // TODO gpio port clock enable and setup
    EXTEN.EXTEN_CTR.modify(.{
        .OPANSEL = if (remap) 1 else 0,
        .OPAPSEL = if (remap) 1 else 0,
        .OPAEN = 1,
    });
}
