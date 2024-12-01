const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

pub fn main() void {
    var lines: u32 = 0;
    var palindromes: u32 = 0;

    var iter = std.mem.splitScalar(u8, input, '\n');
    while (iter.next()) |line| : (lines += 1) {
        for (0..line.len) |i| {
            const c1 = std.ascii.toLower(line[i]);
            const c2 = std.ascii.toLower(line[line.len - i - 1]);

            if (c1 != c2) {
                break;
            }
        } else {
            palindromes += 1;
        }
    }

    std.debug.print("Part 1: {}\n", .{lines});
    std.debug.print("Part 2: {}\n", .{palindromes});
}
