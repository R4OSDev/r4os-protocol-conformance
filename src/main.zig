const r4os = @import("r4os");

comptime {
    asm (r4os.r4dev.protocolEntriesAsm("conformance_init", "conformance_shutdown", "conformance_query", "conformance_dispatch"));
}

export fn conformance_init(api: *const r4os.r4dev.ProtocolApi) callconv(.c) i32 {
    var ctx = r4os.r4dev.ProtocolContext.init(api);
    ctx.logInfo("CONF.R4P init");
    _ = ctx.registerRole("misc.conformance", .misc, 0);
    _ = ctx.setStatus(.active, "conformance protocol active");
    return 0;
}

export fn conformance_shutdown() callconv(.c) i32 {
    return 0;
}

export fn conformance_query(out: *r4os.abi.ProtocolStatus) callconv(.c) i32 {
    out.* = .{
        .state = @intFromEnum(r4os.abi.ProtocolState.active),
        .flags = 0,
        .last_error = 0,
        .reserved = 0,
        .note = note("conformance protocol ready"),
    };
    return 0;
}

export fn conformance_dispatch(op: u32, in_buffer: *const r4os.abi.ProtocolBuffer, out_buffer: *r4os.abi.ProtocolBuffer) callconv(.c) i32 {
    _ = op;
    _ = in_buffer;
    _ = out_buffer;
    return -4;
}

fn note(comptime text: []const u8) [64]u8 {
    var out: [64]u8 = .{0} ** 64;
    @memcpy(out[0..text.len], text);
    return out;
}
