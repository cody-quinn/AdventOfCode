const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

const Rule = struct { u32, u32 };

fn validate(rule: Rule, buffer: []u32, fixed: []u32) bool {
    var violated = false;

    var fst: isize = -1;
    var snd: isize = -1;

    for (0..buffer.len) |i| {
        if (buffer[i] == rule[0] and fst == -1) fst = @intCast(i);
        if (buffer[i] == rule[1] and snd == -1) snd = @intCast(i);

        if (fst == -1 and snd != -1) {
            violated = true;
        }
    }

    if (fst != -1 and snd != -1 and violated) {
        const temp = fixed[@intCast(fst)];
        fixed[@intCast(fst)] = fixed[@intCast(snd)];
        fixed[@intCast(snd)] = temp;

        return false;
    }

    return true;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var rules = std.ArrayList(Rule).init(allocator);

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0 or std.ascii.isWhitespace(line[0])) {
            break;
        }

        var segments = std.mem.splitScalar(u8, line, '|');
        const fst = try std.fmt.parseInt(u32, segments.next().?, 10);
        const snd = try std.fmt.parseInt(u32, segments.next().?, 10);

        try rules.append(.{ fst, snd });
    }

    var part1: u32 = 0;
    var part2: u32 = 0;

    while (lines.next()) |line| {
        var buffer: [100]u32 = undefined;
        var fixed: [100]u32 = undefined;

        const middle = (line.len + 1) / 2 - 1;
        const middle_digit = try std.fmt.parseInt(u32, line[middle .. middle + 2], 10);

        const len = (line.len + 1) / 3;

        var pos: usize = 0;
        var segments = std.mem.splitScalar(u8, line, ',');
        while (segments.next()) |segment| : (pos += 1) {
            const value = try std.fmt.parseInt(u32, segment, 10);

            buffer[pos] = value;
            fixed[pos] = value;
        }

        var incorrect = false;
        for (rules.items) |rule| {
            incorrect = incorrect or !validate(rule, buffer[0..], fixed[0..]);
        }

        if (incorrect) {
            while (incorrect) {
                incorrect = false;
                for (rules.items) |rule| {
                    incorrect = incorrect or !validate(rule, fixed[0..], fixed[0..]);
                }
            }

            const fixed_middle_digit = fixed[len / 2];
            part2 += fixed_middle_digit;
        } else {
            part1 += middle_digit;
        }
    }

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}
