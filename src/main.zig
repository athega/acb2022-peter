const w4 = @import("wasm4.zig");

var sound = Sound{
    .frequency = 255,
    .duration = 10,
    .volume = 2,
    .flags = 0b1010,
};

const State = struct {
    x: i32 = 0,
    y: i32 = 0,
    p: *const u8 = w4.GAMEPAD1,

    palette: [4]u32 = .{
        0xe9efec,
        0xa0a08b,
        0x555568,
        0x211e20,
    },

    fn update(self: *State) void {
        // Get the mouse coordinates
        self.x = @intCast(i32, w4.MOUSE_X.*);
        self.y = @intCast(i32, w4.MOUSE_Y.*);
    }

    fn draw(self: *State) void {
        w4.DRAW_COLORS.* = 0x23;

        self.text("AthegaCodeBase 2022", 4, 4);

        var x = s.x;
        var y = s.y;

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
        self.line(0, 144, x, y);
        self.line(160, 144, x, y);

        w4.DRAW_COLORS.* = 0x43;

        w4.oval(x - 20, y - 10, 40, 20);

        if (self.btn(w4.BUTTON_1)) {
            w4.DRAW_COLORS.* = 0x43;
            self.text("beep", s.x - 16, s.y - 4);

            sound.play();
        }
    }

    fn btn(self: *State, b: u8) bool {
        return (self.p.* & b != 0);
    }

    fn line(_: *State, x1: i32, y1: i32, x2: i32, y2: i32) void {
        w4.line(x1, y1, x2, y2);
    }

    fn text(_: *State, str: []const u8, x: i32, y: i32) void {
        w4.text(str, x, y);
    }
};

// Global state
var s = State{};

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
    w4.PALETTE.* = s.palette;
}

// update called by WASM-4 (60 times a second)
export fn update() void {
    // Update the state
    s.update();

    // Draw the state
    s.draw();
}
