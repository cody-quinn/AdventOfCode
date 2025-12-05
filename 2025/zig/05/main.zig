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

    var part1: u64 = 0;
    var part2: u64 = 0;

    var fresh = std.ArrayList(struct { u64, u64 }).init(alloc);

    const divider = mem.indexOf(u8, input, "\n\n").?;
    var lines = mem.tokenizeScalar(u8, input[0..divider], '\n');
    while (lines.next()) |line| {
        const dash = mem.indexOfScalar(u8, line, '-').?;
        var start = try std.fmt.parseInt(u64, line[0..dash], 10);
        var end = try std.fmt.parseInt(u64, line[dash + 1..], 10);

        var i: usize = 0;
        while (i < fresh.items.len) {
            const t_start, const t_end = fresh.items[i];
            if (start >= t_start and start <= t_end) {
                start = t_end + 1;
                i = 0;
            } else if (end >= t_start and end <= t_end) {
                end = t_start - 1;
                i = 0;
            } else if (start <= t_start and end >= t_end) {
                _ = fresh.swapRemove(i);
                i = 0;
            } else {
                i += 1;
            }
        }

        if (start > end) {
            continue;
        }

        try fresh.append(.{ start, end });
    }

    lines = mem.tokenizeScalar(u8, input[divider + 2..], '\n');
    while (lines.next()) |line| {
        const value = try std.fmt.parseInt(u64, line, 10);

        for (fresh.items) |pair| {
            const start, const end = pair;
            if (value >= start and value <= end) {
                part1 += 1;
                break;
            }
        }
    }

    for (fresh.items) |pair| {
        const start, const end = pair;
        part2 += end - start + 1;
    }

    return .{ part1, part2 };
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try solution(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(3, part1);
    try std.testing.expectEqual(14, part2);
}
