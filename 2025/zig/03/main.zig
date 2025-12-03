const std = @import("std");
const mem = std.mem;
const math = std.math;

pub fn main() !void {
    const input: []const u8 = @embedFile("input.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}

fn problem(input: []const u8) !struct { u64, u64 } {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var part1: u64 = 0;
    var part2: u64 = 0;

    var lines = mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        part1 += try std.fmt.parseInt(u64, try findGreatestNumericalJoey(alloc, line, 2), 10);
        part2 += try std.fmt.parseInt(u64, try findGreatestNumericalJoey(alloc, line, 12), 10);
    }

    return .{ part1, part2 };
}

fn findGreatestNumericalJoey(alloc: mem.Allocator, slice: []const u8, target_length: usize) ![]u8 {
    var buffer = try alloc.dupe(u8, slice);
    defer alloc.free(buffer);

    const output = try alloc.alloc(u8, slice.len);
    errdefer alloc.free(output);

    var length = buffer.len;
    for (1..buffer.len) |i| {
        const value = buffer[i] - '0';

        var j: isize = @intCast(i - 1);
        while (j >= 0 and length != target_length) : (j -= 1) {
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

    _ = mem.replace(u8, buffer, " ", "", output);
    return output[0..target_length];
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(357, part1);
    try std.testing.expectEqual(3121910778619, part2);
}
