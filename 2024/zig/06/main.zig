const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

const Dir = enum {
    north,
    east,
    south,
    west,

    fn rotate(self: Dir) Dir {
        return switch (self) {
            .north => .east,
            .east => .south,
            .south => .west,
            .west => .north,
        };
    }

    fn move(self: Dir, row: usize, col: usize) struct { usize, usize } {
        return switch (self) {
            .north => .{ row - 1, col },
            .east => .{ row, col + 1 },
            .south => .{ row + 1, col },
            .west => .{ row, col - 1 },
        };
    }
};

// Returns true if in loop
fn traverse(allocator: std.mem.Allocator, table: [][]u8, initial_pos_row: usize, initial_pos_col: usize) !struct { u32, bool } {
    var visited_positions = std.ArrayList(struct { usize, usize, Dir }).init(allocator);

    var pos_row: usize = initial_pos_row;
    var pos_col: usize = initial_pos_col;
    var direction: Dir = .north;

    var visited: u32 = 0;

    while (true) {
        for (visited_positions.items) |position| {
            if (position[0] == pos_row and position[1] == pos_col) {
                if (position[2] == direction) {
                    return .{ visited, true };
                }

                visited -|= 1;
            }
        }

        visited += 1;
        try visited_positions.append(.{ pos_row, pos_col, direction });

        var pos_new = direction.move(pos_row, pos_col);
        switch (table[pos_new[0]][pos_new[1]]) {
            '~' => break,
            '#' => {
                direction = direction.rotate();
                pos_new = direction.move(pos_row, pos_col);
            },
            else => {},
        }

        pos_row = pos_new[0];
        pos_col = pos_new[1];
    }

    return .{ visited, false };
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var pos_row: usize = 0;
    var pos_col: usize = 0;

    const rows = std.mem.count(u8, input, "\n") + 3;
    var cols: usize = 0;
    var table: [][]u8 = try allocator.alloc([]u8, rows);

    // Setting up a table
    {
        var row: usize = 1;
        var lines = std.mem.splitScalar(u8, input, '\n');
        while (lines.next()) |line| : (row += 1) {
            cols = @max(line.len + 2, cols);
            table[row] = try allocator.alloc(u8, cols);
            @memset(table[row], '~');
            for (line, 1..) |c, col| {
                table[row][col] = c;

                if (c == '^') {
                    pos_row = row;
                    pos_col = col;
                }
            }
        }

        // Allocate & set the first and last row
        table[0] = try allocator.alloc(u8, cols);
        table[row] = try allocator.alloc(u8, cols);

        @memset(table[0], '~');
        @memset(table[row], '~');
    }

    const part1 = try traverse(allocator, table, pos_row, pos_col);

    std.debug.print("\n", .{});
    var part2: u32 = 0;
    for (1..rows - 1) |row| {
        for (1..cols - 1) |col| {
            if (table[row][col] == '.') {
                table[row][col] = '#';
                std.debug.print("\x1b[F{} ({}/{})\n", .{ part2, row * cols + col, rows * cols });
                if ((try traverse(allocator, table, pos_row, pos_col))[1]) {
                    part2 += 1;
                }
                table[row][col] = '.';
            }
        }
    }

    std.debug.print("Part 1: {}\n", .{part1[0]});
    std.debug.print("Part 2: {}\n", .{part2});
}
