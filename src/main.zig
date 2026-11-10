const r4os = @import("r4os");

comptime {
    if (!@import("builtin").is_test) asm (r4os.technical2.protocolEntriesAsm("conformance_init", "conformance_shutdown", "conformance_query", "conformance_dispatch"));
}

export fn conformance_init(api: *const r4os.r4dev.ProtocolApi2) callconv(.c) i32 {
    const ctx = r4os.r4dev.ProtocolContext2.init(api);
    if (!ctx.requires(.{ "register_role", "set_status" })) return r4os.abi.err_no_fn;
    const registered = ctx.registerRole("misc.conformance", .misc, 0);
    if (registered != 0) return registered;
    return ctx.setStatus(.active, "conformance protocol active");
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
