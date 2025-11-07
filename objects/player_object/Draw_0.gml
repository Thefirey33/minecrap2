draw_self()
// This is catastrophically bad, don't do this.
// Someone needs to fix this.
var _isGamepad = global.CURRENT_CONTROL_METHOD == control_methods.gamepad

// if we are using a gamepad, then switch the current focus.
if _isGamepad {
    _current_horizontal_velocity = tte_gamepad_axis(
        global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
        global.GAMEPAD_SYSTEM.gamepad_configurations.player.right,
        global.GAMEPAD_SYSTEM.gamepad_configurations.player.left
    );
    _running_speed = 1 + tte_get_gamepad_held(
        global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
        global.GAMEPAD_SYSTEM.gamepad_configurations.player.run
    )
    // up and down for gamepads
    var _upAndDown = tte_gamepad_axis(
        global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
        global.GAMEPAD_SYSTEM.gamepad_configurations.player.down_look,
        global.GAMEPAD_SYSTEM.gamepad_configurations.player.up_look
    )
    // left and right for gamepads
    var _leftAndRight = tte_gamepad_axis(
        global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
        global.GAMEPAD_SYSTEM.gamepad_configurations.player.right_look,
        global.GAMEPAD_SYSTEM.gamepad_configurations.player.left_look
    )
    var _centeredX = x + sprite_width / 2
    var _centeredY = y + sprite_height / 2
    global.VIRTUAL_MOUSE_CURSOR = [
        _centeredX + (_leftAndRight * sprite_width),
        _centeredY + (_upAndDown * sprite_height)
    ]
    draw_rectangle_colour(global.VIRTUAL_MOUSE_CURSOR[0], global.VIRTUAL_MOUSE_CURSOR[1], global.VIRTUAL_MOUSE_CURSOR[0] + 5, global.VIRTUAL_MOUSE_CURSOR[1] + 5, c_green, c_green, c_green, c_green, false)
    _current_horizontal_velocity = _current_horizontal_velocity * player_speed * _running_speed;
}
else {
    global.VIRTUAL_MOUSE_CURSOR = [
        mouse_x,
        mouse_y
    ]
	_current_horizontal_velocity = tte_do_axis("player", "right", "left") * player_speed * _running_speed;
    _running_speed = 1 + tte_check_if_key_held(global.KEYBOARD_CONFIGURATION.player.run) * 0.5
}

y -= _current_gravity * get_current_deltatime()
var
    _x_sprite_width = x + sprite_width,
    _y_sprite_height = y + sprite_height;

var _bottom_collision = collision_rectangle(x, y + sprite_height - sprite_height / COLLISION_SPACE, x + sprite_width, y + sprite_height, ACCEPTABLE_COLLISIONS, true, true)
if _bottom_collision {
    y = _bottom_collision.bbox_top - sprite_height
    // if a gamepad is currently being used, then switch over the controls.
    if not _isGamepad {
        _current_gravity = tte_check_if_key_held(global.KEYBOARD_CONFIGURATION.player.jump) * jump_power
    }
    else {
    	_current_gravity = tte_get_gamepad_held(
            global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
            global.GAMEPAD_SYSTEM.gamepad_configurations.player.jump
        ) * jump_power
    }
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