var loaded_keyboard_file = tte_load_file_all_lines("onscreen_keyboard.txt")
var heightOfKeyboard = string_count("\n", loaded_keyboard_file) + 1
var _letters = string_replace_all(loaded_keyboard_file, "\n", "")
var _i = 1
_g = 0
_currentX = 0
_currentY = 0
_keyboardSpeed = 10
_cooldown = 1
_base_keyboard_layout = ds_grid_create(string_pos("\n", loaded_keyboard_file) - 1, heightOfKeyboard)

for (var _y = 0; _y < ds_grid_height(_base_keyboard_layout); _y++) {
	for (var _x = 0; _x < ds_grid_width(_base_keyboard_layout); _x++) {
        ds_grid_set(_base_keyboard_layout, _x, _y, string_char_at(_letters, _i))
        _i++
    }
}

_padding = 20
_isActive = false
_backgroundWidth = (ds_grid_width(_base_keyboard_layout) * _padding)
_backgroundHeight = (ds_grid_height(_base_keyboard_layout) * _padding)

