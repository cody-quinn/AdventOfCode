const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

pub fn main() !void {
    var enabled = true;
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        for (0..line.len - 4) |i| {
            if (std.mem.eql(u8, line[i .. i + 4], "mul(")) {
                var lhs: i64 = 0;
                var rhs: i64 = 0;

                var j: usize = i + 4;
                while (j < line.len and std.ascii.isDigit(line[j])) : (j += 1) {
                    lhs = lhs * 10 + line[j] - '0';
                }

                if (j >= line.len or line[j] != ',') {
                    continue;
                }

                j += 1;
                while (j < line.len and std.ascii.isDigit(line[j])) : (j += 1) {
                    rhs = rhs * 10 + line[j] - '0';
                }

                if (j >= line.len or line[j] != ')') {
                    continue;
                }

                part1 += lhs * rhs;
                part2 += if (enabled) lhs * rhs else 0;
            } else if (std.mem.eql(u8, line[i .. i + 4], "do()")) {
                enabled = true;
            } else if (i + 7 < line.len and std.mem.eql(u8, line[i .. i + 7], "don't()")) {
                enabled = false;
            }
        }
    }

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}
