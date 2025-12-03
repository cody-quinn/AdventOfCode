const std = @import("std");
const mem = std.mem;
const math = std.math;

pub fn main() !void {
    const input: []const u8 = @embedFile("input.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}

const Pair = struct { u32, usize };

fn problem(input: []const u8) !struct { u64, u64 } {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var part1: u64 = 0;
    var part2: u64 = 0;

    var lines = mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        // Part 1
        const largest, const pos = findLargestDigit(line[0..line.len - 1]);
        const second, _ = findLargestDigit(line[pos + 1..]);
        part1 += largest * 10 + second;

        // Part 2
        var buffer = try alloc.dupe(u8, line);
        var length = buffer.len;
        for (1..buffer.len) |i| {
            const value = buffer[i] - '0';

            var j: isize = @intCast(i - 1);
            while (j >= 0 and length != 12) : (j -= 1) {
                if (buffer[@intCast(j)] == ' ') {
                    continue;
                }

                const prev = buffer[@intCast(j)] - '0';
                if (prev >= value) {
                    break;
                }

                buffer[@intCast(j)] = ' ';
                length -= 1;
            }
        }

        const output = try alloc.alloc(u8, line.len);
        _ = mem.replace(u8, buffer, " ", "", output);
        part2 += try std.fmt.parseInt(u64, output[0..12], 10);
    }

    return .{ part1, part2 };
}

fn findLargestDigit(slice: []const u8) Pair {
    var largest: u32 = 0;
    var pos: usize = 0;

    for (slice, 0..) |digit, i| {
        const value: u32 = digit - '0';
        if (value > largest) {
            largest = value;
            pos = i;
        }
    }

    return .{ largest, pos };
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(357, part1);
    try std.testing.expectEqual(3121910778619, part2);
}
