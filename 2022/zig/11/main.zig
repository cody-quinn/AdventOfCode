const std = @import("std");
const mem = std.mem;
const math = std.math;

pub fn main() !void {
    const input: []const u8 = @embedFile("input.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}

const Monkey = struct {
    items: std.ArrayList(u128),
    operation: struct {
        rhs: union(enum) {
            previous,
            literal: u32,
        },
        op: enum { add, mul },
    },

    divisor: u32,
    if_true: usize,
    if_false: usize,

    inspections: u64,

    pub fn applyOperation(self: *Monkey, item: *u128) void {
        const rhs = switch (self.operation.rhs) {
            .previous => item.*,
            .literal => |value| value,
        };

        switch (self.operation.op) {
            .add => item.* = item.* + rhs,
            .mul => item.* = item.* * rhs,
        }
    }
};

fn problem(input: []const u8) !struct { u64, u64 } {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const part1: u64 = try solution(alloc, input, false);
    const part2: u64 = try solution(alloc, input, true);

    return .{ part1, part2 };
}

fn solution(alloc: mem.Allocator, input: []const u8, part2: bool) !u64 {
    const monkeys = try parseInput(alloc, input);

    var product: u32 = 1;
    for (monkeys.items) |monkey| {
        product *= monkey.divisor;
    }

    for (0..if (part2) 10_000 else 20) |_| {
        for (monkeys.items) |*monkey| {
            const items: []u128 = monkey.items.items;
            for (0..items.len) |j| {
                const idx = items.len - j - 1;

                var item = monkey.items.orderedRemove(idx);
                monkey.applyOperation(&item);

                if (part2) {
                    item %= product;
                } else {
                    item /= 3;
                }

                if (item % monkey.divisor == 0) {
                    try monkeys.items[monkey.if_true].items.append(item);
                } else {
                    try monkeys.items[monkey.if_false].items.append(item);
                }

                monkey.inspections += 1;
            }
        }
    }

    mem.sort(Monkey, monkeys.items, {}, struct {
        pub fn inner(_: void, lhs: Monkey, rhs: Monkey) bool {
            return lhs.inspections > rhs.inspections;
        }
    }.inner);

    return monkeys.items[0].inspections * monkeys.items[1].inspections;
}

fn parseInput(alloc: mem.Allocator, input: []const u8) !std.ArrayList(Monkey) {
    var monkeys = std.ArrayList(Monkey).init(alloc);
    var sections = mem.tokenizeSequence(u8, input, "\n\n");
    while (sections.next()) |section| {
        var monkey = try monkeys.addOne();
        monkey.items = .init(alloc);
        monkey.inspections = 0;

        var lines = mem.tokenizeScalar(u8, section, '\n');
        _ = lines.next();

        // Parse items
        const items_line = lines.next().?;
        const items_idx = mem.indexOfScalar(u8, items_line, ':').? + 2;
        var items_iter = mem.tokenizeSequence(u8, items_line[items_idx..], ", ");
        while (items_iter.next()) |item| {
            try monkey.items.append(try std.fmt.parseInt(u128, item, 10));
        }

        // Parse operation
        const op_line = lines.next().?;
        const op_idx = mem.indexOf(u8, op_line, "old ").? + 4;
        const op_rhs = op_line[op_idx + 2 ..];

        monkey.operation = .{
            .op = if (op_line[op_idx] == '+')
                .add
            else if (op_line[op_idx] == '*')
                .mul
            else
                unreachable,
            .rhs = if (mem.eql(u8, op_rhs, "old"))
                .previous
            else
                .{ .literal = try std.fmt.parseInt(u32, op_rhs, 10) },
        };

        {
            // Parse test
            const test_line = lines.next().?;
            const test_idx = mem.lastIndexOfScalar(u8, test_line, ' ').? + 1;
            monkey.divisor = try std.fmt.parseInt(u32, test_line[test_idx..], 10);
        }
        {
            // Parse test true
            const true_line = lines.next().?;
            const true_idx = mem.lastIndexOfScalar(u8, true_line, ' ').? + 1;
            monkey.if_true = try std.fmt.parseInt(usize, true_line[true_idx..], 10);
        }
        {
            // Parse test false
            const false_line = lines.next().?;
            const false_idx = mem.lastIndexOfScalar(u8, false_line, ' ').? + 1;
            monkey.if_false = try std.fmt.parseInt(usize, false_line[false_idx..], 10);
        }
    }

    return monkeys;
}

test "Sample Input" {
    const input: []const u8 = @embedFile("input_sample.txt");
    const part1, const part2 = try problem(input);
    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
    try std.testing.expectEqual(10605, part1);
    try std.testing.expectEqual(2713310158, part2);
}
