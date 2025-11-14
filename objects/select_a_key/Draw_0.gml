matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 1, _transitionValue, 1))
_transitionValue = lerp(_transitionValue, _currentlyActive, 3 * get_current_deltatime())

var _textToDraw = 
typeOfAssignment == control_methods.keyboard ? 
tte_get_localization(
    global.CURRENT_LANGUAGE,
    "pick_a_key"
) :
tte_get_localization(
    global.CURRENT_LANGUAGE,
    "pick_a_button"
)
var _screenWidthHalf = view_get_wport(view_current) / 2
var _screenHeightHalf = view_get_hport(view_current) / 2
// set the font and continue drawing.
draw_set_font(global.CURRENT_FONTS.bold_xl)
var _textWidth = string_width(_textToDraw)
var _textHeight = string_height(_textToDraw)
var 
    _x = _screenWidthHalf - _textWidth / 2,
    _y = _screenHeightHalf;
if not _currentlyActive
    draw_set_alpha(_transitionValue)
draw_set_colour(c_black)
function draw_rectangle_m(_x, _y, _textWidth, _textHeight, _outline, _margin = 5){
    draw_rectangle(
        _x - _margin,
        _y - _margin,
        _x + _textWidth + _margin,
        _y + _textHeight + _margin,
        _outline
    )
}
draw_rectangle_m(_x, _y, _textWidth, _textHeight, false)
draw_set_colour(_currentlyActive ? c_white : c_yellow)
draw_rectangle_m(_x, _y, _textWidth, _textHeight, true)
draw_text(
    _x,
    _y,
    _textToDraw
)
draw_set_font(global.CURRENT_FONTS.normal)
if keyboard_key != 0 and _currentlyActive {
    struct_set(global.KEYBOARD_CONFIGURATION.player, assignmentName, keyboard_key)
    tte_change_screen(global.CURRENT_SCREEN)
    tte_setup_keymapping(true)
    _currentlyActive = 0
    global.FREEZE_GUI_CONTROLS = false
}
if _currentlyActive != 1 and _transitionValue <= math_get_epsilon() {
    instance_destroy(self)
}
matrix_set(matrix_world, matrix_build_identity())
draw_set_alpha(1)