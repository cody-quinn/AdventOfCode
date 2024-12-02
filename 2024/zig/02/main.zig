const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

fn is_safe(levels: []i64) bool {
    var prev = levels[0];

    var incr = false;
    var decr = false;

    for (levels[1..]) |curr| {
        if (@abs(curr - prev) > 3) {
            return false;
        }

        if (curr > prev) {
            if (decr) {
                return false;
            }
            incr = true;
        } else if (curr < prev) {
            if (incr) {
                return false;
            }
            decr = true;
        } else {
            return false;
        }

        prev = curr;
    }

    return true;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var lines = std.mem.splitScalar(u8, input, '\n');
    var part1: i64 = 0;
    var part2: i64 = 0;
    while (lines.next()) |line| {
        var levels = std.mem.tokenizeScalar(u8, line, ' ');

        var level = std.ArrayList(i64).init(allocator);
        while (levels.next()) |str| {
            try level.append(try std.fmt.parseInt(i64, str, 10));
        }

        if (is_safe(level.items)) {
            part1 += 1;
            part2 += 1;
        } else {
            for (0..level.items.len) |i| {
                var dampened_level = try level.clone();
                _ = dampened_level.orderedRemove(i);

                if (is_safe(dampened_level.items)) {
                    part2 += 1;
                    break;
                }
            }
        }
    }

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}
