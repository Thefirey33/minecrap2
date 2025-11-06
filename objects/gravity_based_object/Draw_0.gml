
if (check_if_key_held(global.KEYBOARD_CONFIGURATION.debug.show))
{
    displaying_text = string("marg: {0}\ngravity: {1}\n", _collision_margin, _current_gravity);
    switch (_currentCollision) {
	   case current_collision_types.Bottom:
            displaying_text += "bottom\n";
            break;
        case current_collision_types.Left:
            displaying_text += "left\n";
            break;
        case current_collision_types.Right:
            displaying_text += "right\n";
            break;
        case current_collision_types.Top:
            displaying_text += "top\n";
            break;
    }
    draw_text(x, y - sprite_height - string_height(displaying_text), displaying_text)
}
draw_self()