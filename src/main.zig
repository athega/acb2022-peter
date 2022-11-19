const w4 = @import("wasm4.zig");

var sound = Sound{
    .frequency = 255,
    .duration = 10,
    .volume = 2,
    .flags = 0b1010,
};

const Player = struct {
    const Self = @This();

    i: i32 = 0,
    x: i32 = 0,
    y: i32 = 0,
    p: *const u8,

    fn update(self: Self) void {
        if (self.btn(w4.BUTTON_RIGHT)) {
            self.x += 1;
        }

        //if (self.btn(w4.BUTTON_LEFT)) {
        //    self.x -= 1;
        //}

        //if (self.btn(w4.BUTTON_DOWN)) {
        //    self.y += 1;
        //}

        //if (self.btn(w4.BUTTON_UP)) {
        //    self.y -= 1;
        //}
    }

    fn btn(self: Self, b: u8) bool {
        return (self.p.* & b != 0);
    }
};

const Game = struct {
    x: i32 = 0,
    y: i32 = 0,

    palette: [4]u32 = .{
        0xe9efec,
        0xa0a08b,
        0x555568,
        0x211e20,
    },

    players: [4]*Player = .{
        &.{ .i = 0, .p = w4.GAMEPAD1 },
        &.{ .i = 1, .p = w4.GAMEPAD2 },
        &.{ .i = 2, .p = w4.GAMEPAD3 },
        &.{ .i = 3, .p = w4.GAMEPAD4 },
    },

    fn update(self: *Game) void {
        for (self.players) |player| {
            player.update();
        }

        // Get the mouse coordinates
        // self.x = @intCast(i32, w4.MOUSE_X.*);
        // self.y = @intCast(i32, w4.MOUSE_Y.*);
    }

    fn draw(self: *Game) void {
        w4.DRAW_COLORS.* = 0x23;

        self.text("AthegaCodeBase 2022", 4, 4);

        for (self.players) |player| {
            var x = player.x;
            var y = player.y;

            if (x > 140) {
                x = 140;
            }

            if (x < 20) {
                x = 20;
            }

            if (y > 149) {
                y = 149;
            }

            if (y < 10) {
                y = 10;
            }

            self.line(0, 15, x, y);
            self.line(160, 15, x, y);
            self.line(0, 145, x, y);
            self.line(160, 145, x, y);

            w4.DRAW_COLORS.* = 0x43;

            w4.oval(x - 10, y - 5, 20, 10);
        }

        //if (self.btn(w4.BUTTON_1)) {
        //    w4.DRAW_COLORS.* = 0x43;
        //    self.text("beep", self.x - 16, self.y - 4);

        //    sound.play();
        //}
    }

    fn line(_: *Game, x1: i32, y1: i32, x2: i32, y2: i32) void {
        w4.line(x1, y1, x2, y2);
    }

    fn text(_: *Game, str: []const u8, x: i32, y: i32) void {
        w4.text(str, x, y);
    }

    fn pixel(_: *Game, x: i32, y: i32) void {
        // The byte index into the framebuffer that contains (x, y)
        const idx = (@intCast(usize, y) * 160 + @intCast(usize, x)) >> 2;

        // Calculate the bits within the byte that corresponds to our position
        const shift = @intCast(u3, (x & 0b11) * 2);
        const mask = @as(u8, 0b11) << shift;

        // Use the first DRAW_COLOR as the pixel color
        const palette_color = @intCast(u8, w4.DRAW_COLORS.* & 0b1111);
        if (palette_color == 0) {
            // Transparent
            return;
        }
        const color = (palette_color - 1) & 0b11;

        // Write to the framebuffer
        w4.FRAMEBUFFER[idx] = (color << shift) | (w4.FRAMEBUFFER[idx] & ~mask);
    }
};

// Global game state
var g = Game{};

const Sound = struct {
    frequency: u8,
    duration: u8,
    volume: u8,
    flags: u8,

    fn play(self: *Sound) void {
        w4.tone(
            self.frequency,
            self.duration,
            self.volume,
            self.flags,
        );
    }
};

// start called by WASM-4
export fn start() void {
    w4.SYSTEM_FLAGS.* = w4.SYSTEM_HIDE_GAMEPAD_OVERLAY;
    w4.PALETTE.* = g.palette;
}

// update called by WASM-4 (60 times a second)
export fn update() void {
    // Update the state
    g.update();

    // Draw the state
    g.draw();
}
