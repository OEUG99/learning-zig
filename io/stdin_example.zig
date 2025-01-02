const std = @import("std");

const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    try stdout.writeAll("Input your name!\n");

    // Creating allocator
    const allocator = std.heap.page_allocator;

    // Buffer to store input
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    // Reading from STDIN
    while (true) {
        // reading 1 byte at a time.
        var byte: u8 = 0;

        byte = stdin.readByte() catch |err| {
            if (err == error.EndOfStream) {
                break; // Exit the loop if the end of stream is reached
            } else {
                return err; // Propagate other errors
            }
        };
        if (byte == '\n') {
            break;
        } // If a new line is detected, we know the user is ready to print.

        try list.append(byte);
    }
    // Output the collected data
    std.debug.print("Collected Data: {s}\n", .{list.items});
}
