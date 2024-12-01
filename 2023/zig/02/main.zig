const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

pub fn main() !void {
    var part1: u32 = 0;
    var part2: u32 = 0;

    var game: u32 = 1;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| : (game += 1) {
        var sections = std.mem.splitSequence(u8, line, ": ");
        _ = sections.next();
        const sets_string = sections.next().?;

        var rl: u32 = 0;
        var gl: u32 = 0;
        var bl: u32 = 0;

        var impossible = false;
        var rounds = std.mem.splitSequence(u8, sets_string, "; ");
        while (rounds.next()) |round| {
            var r: u32 = 0;
            var g: u32 = 0;
            var b: u32 = 0;

            var cubes = std.mem.splitSequence(u8, round, ", ");
            while (cubes.next()) |cube| {
                var tup = std.mem.splitScalar(u8, cube, ' ');
                const value = try std.fmt.parseInt(u32, tup.next().?, 10);
                const color = tup.next().?;

                switch (color[0]) {
                    'r' => r += value,
                    'g' => g += value,
                    'b' => b += value,
                    else => unreachable,
                }
            }

            rl = @max(rl, r);
            gl = @max(gl, g);
            bl = @max(bl, b);

            if (r > 12 or g > 13 or b > 14) {
                impossible = true;
            }
        }

        if (!impossible) {
            part1 += game;
        }

        part2 += rl * gl * bl;
    }

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}
