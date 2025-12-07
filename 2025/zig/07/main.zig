const std = @import("std");
const mem = std.mem;
const math = std.math;

pub fn main() !void {
    const input: []const u8 = @embedFile("input.txt");
    const part1, const part2 = try solution(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}

fn solution(input: []const u8) !struct { u64, u64 } {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const start = mem.indexOfScalar(u8, input, 'S').?;
    var rows = try alloc.alloc([]const u8, mem.count(u8, input, "\n") / 2 - 1);
    var lines = mem.tokenizeScalar(u8, input, '\n');
    _ = lines.next();
    _ = lines.next();
    for (0..rows.len) |i| {
        const line = lines.next() orelse break;
        rows[i] = line;
        _ = lines.next();
    }

    var part1: u64 = 0;
    var part2: u64 = 0;

    var active: [1024]u64 = @splat(0);
    active[start] = 1;

    for (rows) |row| {
        var i: usize = 0;
        while (mem.indexOfScalarPos(u8, row, i, '^')) |j| : (i = j + 1) {
            const count = active[j];
            active[j - 1] += count;
            active[j + 1] += count;
            active[j] = 0;
            part1 += math.sign(count);
        }
    }

    for (active) |i| {
        part2 += i;
    }

    return .{ part1, part2 };
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try solution(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(21, part1);
    try std.testing.expectEqual(40, part2);
}
