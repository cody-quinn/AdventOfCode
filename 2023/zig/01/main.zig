const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

const words: [10][]const u8 = .{
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};

pub fn main() !void {
    var part1: u32 = 0;
    var part2: u32 = 0;

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var fst: u32 = 0;
        var lst: u32 = 0;

        var fst_s: u32 = 0;
        var lst_s: u32 = 0;

        for (line, 0..) |c, i| {
            if (std.ascii.isDigit(c)) {
                if (fst == 0) {
                    fst = c - '0';
                    if (fst_s == 0) {
                        fst_s = fst;
                    }
                }

                lst = c - '0';
                lst_s = lst;
            } else {
                for (words, 0..) |word, j| {
                    if (word.len > line.len - i) {
                        // Skip the word if it's longer than the remainder of the line
                        continue;
                    }

                    if (std.mem.eql(u8, line[i .. i + word.len], word)) {
                        if (fst_s == 0) {
                            fst_s = @intCast(j);
                        }

                        lst_s = @intCast(j);
                    }
                }
            }
        }

        part1 += fst * 10 + lst;
        part2 += fst_s * 10 + lst_s;
    }

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}
