const std = @import("std");
const mem = std.mem;

pub fn main() !void {
    const input: []const u8 = @embedFile("input.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}

fn problem(input: []const u8) !struct { u32, u32 } {
    var part1: u32 = 0;
    var part2: u32 = 0;
    var dial: i32 = 50;

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const sign: i32 = if (line[0] == 'L') -1 else 1;
        const delta = try std.fmt.parseInt(u16, line[1..], 10);

        for (0..delta) |_| {
            dial += sign;

            if (dial < 0) {
                dial = 99;
            } else if (dial > 99) {
                dial = 0;
            }

            if (dial == 0) {
                part2 += 1;
            }
        }

        if (dial == 0) {
            part1 += 1;
        }
    }

    return .{ part1, part2 };
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(3, part1);
    try std.testing.expectEqual(6, part2);
}
