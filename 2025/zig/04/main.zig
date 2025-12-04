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

    const columns = mem.indexOfScalar(u8, input, '\n').? + 2;
    const rows = input.len / (columns - 2) + 2;
    var table = try alloc.alloc(u8, columns * rows);
    @memset(table, '.');

    var lines = mem.tokenizeScalar(u8, input, '\n');
    var row: usize = 1;
    while (lines.next()) |line| : (row += 1) {
        @memcpy(table[row * columns + 1 .. (row + 1) * columns - 1], line);
    }

    var part1: u64 = 0;
    var part2: u64 = 0;

    var removed_rolls: u32 = 1;
    while (removed_rolls > 0) {
        removed_rolls = 0;

        for (1..rows - 1) |y| {
            for (1..columns - 1) |x| {
                const center = indexOf(columns, x, y);
                if (table[center] != '@') {
                    continue;
                }

                var count: u32 = 0;
                for (neighbors(x, y)) |neighbor| {
                    const nx, const ny = neighbor;
                    const idx = indexOf(columns, nx, ny);

                    if (table[idx] == '@' or table[idx] == 'x') {
                        count += 1;
                    }
                }

                if (count < 4) {
                    removed_rolls += 1;
                    table[center] = 'x';
                }
            }
        }

        mem.replaceScalar(u8, table, 'x', '.');

        part2 += removed_rolls;
        if (part1 == 0) {
            part1 = removed_rolls;
        }
    }

    return .{ part1, part2 };
}

fn neighbors(x: usize, y: usize) [8]struct { usize, usize } {
    return .{
        .{ x - 1, y - 1 }, .{ x - 1, y }, .{ x - 1, y + 1 }, .{ x, y - 1 },
        .{ x + 1, y + 1 }, .{ x + 1, y }, .{ x + 1, y - 1 }, .{ x, y + 1 },
    };
}

fn indexOf(columns: usize, x: usize, y: usize) usize {
    return y * columns + x;
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try solution(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(13, part1);
    try std.testing.expectEqual(43, part2);
}
