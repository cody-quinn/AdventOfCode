const std = @import("std");
const mem = std.mem;
const math = std.math;

pub fn main() !void {
    const input: []const u8 = @embedFile("input.txt");
    const part1, const part2 = try solution(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}

const Operation = struct {
    operation: u8,
    width: usize,
};

fn solution(input: []const u8) !struct { u64, u64 } {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var op_table = std.ArrayList(Operation).init(alloc);

    const ops_start = @min(mem.indexOfScalar(u8, input, '*').?, mem.indexOfScalar(u8, input, '+').?);
    const ops_end = mem.indexOfScalarPos(u8, input, ops_start, '\n').?;

    var op_start = ops_start;
    while (op_start < ops_end) {
        const op_end =
            mem.indexOfAnyPos(u8, input, op_start + 1, "+*") orelse
            mem.indexOfScalarPos(u8, input, op_start + 1, '\n').? + 1;

        try op_table.append(.{
            .operation = input[op_start],
            .width = op_end - op_start - 1,
        });

        op_start = op_end;
    }

    return .{
        try solutionPart1(alloc, op_table.items, input[0..ops_start]),
        try solutionPart2(alloc, op_table.items, input[0..ops_start]),
    };
}

fn solutionPart1(alloc: mem.Allocator, op_table: []const Operation, numbers: []const u8) !u64 {
    var part1: u64 = 0;
    var results = try alloc.alloc(u64, op_table.len);
    @memset(results, 0);

    var lines = mem.tokenizeScalar(u8, numbers, '\n');
    while (lines.next()) |line| {
        var start: usize = 0;
        for (op_table, 0..) |op, j| {
            const slice = mem.trim(u8, line[start .. start + op.width], " ");
            const value = try std.fmt.parseInt(u64, slice, 10);
            if (results[j] == 0) {
                results[j] = value;
            } else if (op.operation == '*') {
                results[j] *= value;
            } else if (op.operation == '+') {
                results[j] += value;
            }

            start += op.width + 1;
        }
    }

    for (results) |value| {
        part1 += value;
    }

    return part1;
}

fn solutionPart2(alloc: mem.Allocator, op_table: []const Operation, numbers: []const u8) !u64 {
    var part2: u64 = 0;
    var results = try alloc.alloc(u64, op_table.len);
    @memset(results, 0);

    var lines = mem.tokenizeScalar(u8, numbers, '\n');
    var start: usize = 0;
    for (op_table, 0..) |op, j| {
        for (0..op.width) |i| {
            lines.reset();
            var value: u64 = 0;
            while (lines.next()) |line| {
                const digit = line[start + i];
                if (digit == ' ') {
                    continue;
                }

                value *= 10;
                value += digit - '0';
            }

            if (results[j] == 0) {
                results[j] = value;
            } else if (op.operation == '*') {
                results[j] *= value;
            } else if (op.operation == '+') {
                results[j] += value;
            }
        }

        start += op.width + 1;
    }

    for (results) |value| {
        part2 += value;
    }

    return part2;
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try solution(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(4277556, part1);
    try std.testing.expectEqual(3263827, part2);
}
