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
    var part1: u64 = 0;
    var part2: u64 = 0;

    var ranges = mem.tokenizeScalar(u8, input[0 .. mem.indexOfScalar(u8, input, '\n') orelse input.len], ',');
    while (ranges.next()) |range| {
        const split = mem.indexOfScalar(u8, range, '-').?;
        const start = try std.fmt.parseInt(u64, range[0..split], 10);
        const end = try std.fmt.parseInt(u64, range[split + 1 ..], 10);

        for (start..end + 1) |id| {
            const digits: u64 = @intFromFloat(@floor(math.log10(@as(f64, @floatFromInt(id)))) + 1);

            const lhs = id / math.pow(u64, 10, digits / 2);
            const rhs = id % math.pow(u64, 10, digits / 2);

            for (1..digits / 2 + 1) |size| {
                if (digits % size != 0) continue;

                const f = math.pow(u64, 10, size);
                const pattern = id % f;

                var m = f;
                for (1..digits / size) |_| {
                    const group = id / m % f;
                    if (group != pattern) {
                        break;
                    }
                    m *= f;
                } else {
                    part2 += id;
                    break;
                }
            }

            if (lhs == rhs) {
                part1 += @intCast(id);
            }
        }
    }

    return .{ part1, part2 };
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(1227775554, part1);
    try std.testing.expectEqual(4174379265, part2);
}
