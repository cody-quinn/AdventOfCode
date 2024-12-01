const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var lhs = std.ArrayList(i64).init(allocator);
    var rhs = std.ArrayList(i64).init(allocator);

    var iter = std.mem.splitScalar(u8, input, '\n');
    while (iter.next()) |line| {
        try lhs.append(try std.fmt.parseInt(i64, line[0..5], 10));
        try rhs.append(try std.fmt.parseInt(i64, line[8..13], 10));
    }

    std.mem.sort(i64, lhs.items, {}, std.sort.asc(i64));
    std.mem.sort(i64, rhs.items, {}, std.sort.asc(i64));

    var part1: i64 = 0;
    for (lhs.items, rhs.items) |i, j| {
        part1 += @intCast(@abs(j - i));
    }

    var part2: i64 = 0;
    for (lhs.items) |i| {
        var occurances: i64 = 0;
        for (rhs.items) |j| {
            if (i == j) {
                occurances += 1;
            }
        }
        part2 += i * occurances;
    }

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}
