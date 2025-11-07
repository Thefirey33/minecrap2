if global.IS_COMPUTER and debug_mode
{
    var _currentSinnedColourValue = abs(sin(current_time / _sinDivide)) * 255
    var _isPressed = tte_check_if_key_held(global.KEYBOARD_CONFIGURATION.game.switch_method)
    var _notYellowOv = _isPressed ? 0 : _currentSinnedColourValue
    
    draw_set_colour(make_colour_rgb(_currentSinnedColourValue, _currentSinnedColourValue, _notYellowOv))
    if tte_check_if_key_pressed(global.KEYBOARD_CONFIGURATION.game.switch_method)
    {
        switch (global.CURRENT_CONTROL_METHOD) {
        	case control_methods.keyboard:
                global.CURRENT_CONTROL_METHOD = control_methods.gamepad
                break;
            case control_methods.gamepad:
                global.CURRENT_CONTROL_METHOD = control_methods.keyboard
                break;
        }
    }
    draw_text(x, y, string("[{0}]", global.KEYBOARD_CONFIGURATION.game.switch_method))
    draw_set_colour(c_white)
}