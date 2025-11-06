_current_gravity -= global.BASE_GRAVITY_EFFECT * get_current_deltatime()
y -= _current_gravity
var
    _x_sprite_width = x + sprite_width,
    _y_sprite_height = y + sprite_height;
_currentCollision = current_collision_types.NoCol 
_collision_margin = 3
var _bottom_collision = collision_line(x + _collision_margin, _y_sprite_height, _x_sprite_width - _collision_margin, _y_sprite_height, solid_object, true, true)
if _bottom_collision {
    y = _bottom_collision.y - _bottom_collision.sprite_height
    _current_gravity = 5.0
    _currentCollision = current_collision_types.Bottom
}
var _top_collision = collision_line(x + _collision_margin, y, _x_sprite_width - _collision_margin, y, solid_object, true, true)
if _top_collision {
    y = _top_collision.y + _top_collision.sprite_height
    _current_gravity = -_current_gravity / 2.0
    _currentCollision = current_collision_types.Top
}
var _right_collision = collision_line(_x_sprite_width, y + _collision_margin, _x_sprite_width, _y_sprite_height - _collision_margin, solid_object, true, true)
if _right_collision {
    x = _right_collision.x - _right_collision.sprite_width
    _currentCollision = current_collision_types.Right
}
var _left_collision = collision_line(x, y + _collision_margin, x, y - _collision_margin, solid_object, true, true)
if _left_collision {
    x = _left_collision.x + _left_collision.sprite_width
    _currentCollision = current_collision_types.Left
}

if (_currentCollision != current_collision_types.Left)
    x -= 100 * get_current_deltatime()