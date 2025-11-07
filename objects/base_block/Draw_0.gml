draw_self();

if (global.VIRTUAL_MOUSE_CURSOR[0] > x and global.VIRTUAL_MOUSE_CURSOR[1] > y and global.VIRTUAL_MOUSE_CURSOR[0] < x + sprite_width and global.VIRTUAL_MOUSE_CURSOR[1] < y + sprite_height)
{
    draw_set_colour(c_green)
    // draw the rectangular outline to highlight the block please.
    var _x_1 = x + _selectionLineWidth / 2.0
    var _y_1 = y + sprite_height - _selectionLineWidth / 2.0
    var _x_2 = x + sprite_width - _selectionLineWidth / 2.0
    var _y_2 = y + _selectionLineWidth / 2.0
    draw_line_width(_x_1, y, _x_1, _y_1, _selectionLineWidth)
    draw_line_width(_x_1, _y_1, _x_2, _y_1, _selectionLineWidth)
    draw_line_width(_x_2, _y_1, _x_2, _y_2, _selectionLineWidth)
    draw_line_width(_x_2, _y_2, _x_1, _y_2, _selectionLineWidth)
    // reset the drawing color.
    draw_set_colour(c_white)
}