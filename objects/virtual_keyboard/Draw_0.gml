_g = lerp(_g, _isActive ? 1 : 0, get_current_deltatime() * 10)
if not _isActive and _g <= 0
    return
draw_set_alpha(_g)
var _leftX = (BASE_GAME_WIDTH / 2) - _backgroundWidth / 2
var 
    _bX = _leftX - _padding,
    _bY = y - _padding,
    _bW = _leftX + _backgroundWidth + _padding,
    _bH = y + _backgroundHeight + _padding;
draw_set_colour(c_black)
draw_rectangle(_bX, _bY, _bW, _bH, false)
// draw the outline
draw_set_colour(c_white)
draw_rectangle(_bX, _bY, _bW, _bH, true)

// draw the keyboard itself
for (var _x = 0; _x < ds_grid_width(_base_keyboard_layout); _x++) {
    for (var _y = 0; _y < ds_grid_height(_base_keyboard_layout); _y++) {
        var _xA = _leftX + _x * _padding
        var _yA = y + _y * _padding
        var _val = ds_grid_get(_base_keyboard_layout, _x, _y)
    	draw_text(_xA + font_get_size(draw_get_font()) / 2, _yA, _val)
        if _x == floor(_currentX) and _y == floor(_currentY) {
            draw_rectangle(_xA, _yA, _xA + _padding, _yA + _padding, true)
            if tte_get_gamepad_pressed(
                global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
                global.GAMEPAD_SYSTEM.gamepad_configurations.player.jump
            ) and _cooldown <= 0 {
                keyboard_string += _val
            }
        }
    }
}
_currentX += tte_gamepad_axis(
    global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
    global.GAMEPAD_SYSTEM.gamepad_configurations.player.right,
    global.GAMEPAD_SYSTEM.gamepad_configurations.player.left,
    true
)
_currentY += tte_gamepad_axis(
    global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
    global.GAMEPAD_SYSTEM.gamepad_configurations.player.down_look,
    global.GAMEPAD_SYSTEM.gamepad_configurations.player.up_look,
    true
)
_cooldown = max(0, _cooldown - get_current_deltatime())
if _cooldown <= 0 {
    if tte_get_gamepad_pressed(global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using, global.GAMEPAD_SYSTEM.gamepad_configurations.player.interact) {
        self._isActive = false
    }
    if tte_get_gamepad_pressed(global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using, global.GAMEPAD_SYSTEM.gamepad_configurations.player.backspace) {
        keyboard_key_press(vk_backspace)
    }
    if tte_get_gamepad_pressed(global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using, global.GAMEPAD_SYSTEM.gamepad_configurations.player.space) {
        keyboard_key_press(vk_space)
    }
}
_currentX = clamp(_currentX, 0, ds_grid_width(_base_keyboard_layout) - 1)
_currentY = clamp(_currentY, 0, ds_grid_height(_base_keyboard_layout) - 1)
draw_set_alpha(1.0)