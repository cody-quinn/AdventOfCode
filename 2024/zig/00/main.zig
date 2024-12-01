const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

pub fn main() void {
    var lines: u32 = 1;
    var palindromes: u32 = 0;
    var word1: [256]u8 = undefined;
    var word2: [256]u8 = undefined;
    var i: u32 = 0;
    for (input, 0..) |c, j| {
        if (c == '\n') {
            for (0..i) |k| {
                if (std.ascii.toLower(word1[k]) != std.ascii.toLower(word2[256 - i + k])) {
                    break;
                }
            } else {
                palindromes += 1;
            }
            lines += 1;
            i = 0;
            continue;
        }

        word1[i] = input[j];
        word2[255 - i] = input[j];
        i += 1;
    }
    std.debug.print("Part 1: {}\n", .{lines});
    std.debug.print("Part 2: {}\n", .{palindromes});
}
