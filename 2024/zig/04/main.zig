const std = @import("std");

const input: []const u8 = @embedFile("input.txt");

fn scan_direction_p1(table: [][]u8, row_idx: usize, col_idx: usize, d_row: i32, d_col: i32, chars: []const u8) bool {
    if (chars.len == 0) {
        return true;
    }

    if (table[row_idx][col_idx] == chars[0]) {
        const n_row_idx: usize = @intCast(@as(i32, @intCast(row_idx)) + d_row);
        const n_col_idx: usize = @intCast(@as(i32, @intCast(col_idx)) + d_col);

        return scan_direction_p1(table, n_row_idx, n_col_idx, d_row, d_col, chars[1..]);
    }

    return false;
}

fn scan_p1(table: [][]u8, row_idx: usize, col_idx: usize) u32 {
    var count: u32 = 0;

    if (table[row_idx][col_idx] == 'X') {
        inline for (.{ -1, 0, 1 }) |d_row| {
            inline for (.{ -1, 0, 1 }) |d_col| {
                if (d_row == 0 and d_col == 0) continue;

                if (scan_direction_p1(table, row_idx, col_idx, d_row, d_col, "XMAS")) {
                    count += 1;
                }
            }
        }
    }

    return count;
}

fn scan_p2(table: [][]u8, row_idx: usize, col_idx: usize) u32 {
    if (table[row_idx][col_idx] == 'A') {
        if ((table[row_idx - 1][col_idx - 1] == 'M' and table[row_idx - 1][col_idx + 1] == 'M' and
            table[row_idx + 1][col_idx - 1] == 'S' and table[row_idx + 1][col_idx + 1] == 'S') or
            (table[row_idx - 1][col_idx - 1] == 'S' and table[row_idx - 1][col_idx + 1] == 'S' and
            table[row_idx + 1][col_idx - 1] == 'M' and table[row_idx + 1][col_idx + 1] == 'M') or
            (table[row_idx - 1][col_idx - 1] == 'M' and table[row_idx + 1][col_idx - 1] == 'M' and
            table[row_idx - 1][col_idx + 1] == 'S' and table[row_idx + 1][col_idx + 1] == 'S') or
            (table[row_idx - 1][col_idx - 1] == 'S' and table[row_idx + 1][col_idx - 1] == 'S' and
            table[row_idx - 1][col_idx + 1] == 'M' and table[row_idx + 1][col_idx + 1] == 'M'))
        {
            return 1;
        }
    }

    return 0;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const rows = std.mem.count(u8, input, "\n") + 7;
    var cols: usize = 0;
    var table: [][]u8 = try allocator.alloc([]u8, rows);

    // Create a table
    {
        var row: usize = 3;
        var lines = std.mem.splitScalar(u8, input, '\n');
        while (lines.next()) |line| : (row += 1) {
            cols = @max(line.len + 6, cols);
            table[row] = try allocator.alloc(u8, cols);
            for (line, 3..) |c, col| {
                table[row][col] = c;
            }
        }

        for (0..3) |i| {
            table[i] = try allocator.alloc(u8, cols);
            @memset(table[i], 0);
        }

        for (row..row + 3) |i| {
            table[i] = try allocator.alloc(u8, cols);
            @memset(table[i], 0);
        }
    }

    var part1: u32 = 0;
    var part2: u32 = 0;

    for (3..rows - 3) |row_idx| {
        for (3..cols - 3) |col_idx| {
            part1 += scan_p1(table, row_idx, col_idx);
            part2 += scan_p2(table, row_idx, col_idx);
        }
    }

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}
