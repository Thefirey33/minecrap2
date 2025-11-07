// This is catastrophically bad, don't do this.
// Someone needs to fix this.

y -= _current_gravity * get_current_deltatime()
var
    _x_sprite_width = x + sprite_width,
    _y_sprite_height = y + sprite_height;

var _bottom_collision = collision_rectangle(x, y + sprite_height - sprite_height / COLLISION_SPACE, x + sprite_width, y + sprite_height, ACCEPTABLE_COLLISIONS, true, true)
if _bottom_collision {
    y = _bottom_collision.bbox_top - sprite_height
    _current_gravity = 0
}
else {
    _current_gravity -= global.BASE_GRAVITY_EFFECT
}
var _top_collision = collision_rectangle(x, y, x + sprite_width, y + sprite_height / COLLISION_SPACE, ACCEPTABLE_COLLISIONS, true, true)
if _top_collision {
    y = _top_collision.bbox_bottom
    _current_gravity = -_current_gravity / 2.0;
}
var _right_collision = collision_rectangle(x + sprite_width - global.COLLISION_MARGIN, y, x + sprite_width + global.COLLISION_MARGIN, y + sprite_height, ACCEPTABLE_COLLISIONS, true, true)
if _right_collision and _current_horizontal_velocity > 0.0 {
    x = _right_collision.bbox_left - sprite_width
    _current_horizontal_velocity = 0
}
var _left_collision = collision_rectangle(x - global.COLLISION_MARGIN, y, x + global.COLLISION_MARGIN, y + sprite_height, ACCEPTABLE_COLLISIONS, true, true)
if _left_collision and _current_horizontal_velocity < 0.0 {
    x = _left_collision.bbox_right
    _current_horizontal_velocity = 0
}
x += _current_horizontal_velocity * get_current_deltatime()

draw_self()