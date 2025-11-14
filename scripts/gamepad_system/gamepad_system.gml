#macro gamepad_config_location working_directory + "tte_gamepad.json"

global.GAMEPAD_SYSTEM = {
    is_supported: false,
    connected_gamepads: 0,
    gamepad_info: [],
    gamepad_configurations: {
        currently_using: 0,
        player: {
            right: gp_padr,          
            left: gp_padl, 
            down_look: gp_padd,
            up_look: gp_padu,
            left_look: gp_shoulderlb,
            right_look: gp_shoulderrb,
            jump: gp_face1,
            run: [gp_face2, gp_shoulderr],   
            interact: gp_face3,
        }
    }
}


/// @description this function loops over global.GAMEPAD_SYSTEM.gamepad_configurations.
/// @param {Function} gamepad_fields_function This shows basic GamePad config data. values are "field" and "button"
function tte_loop_over_gamepad(gamepad_fields_function){
    for (var i = 0; i < array_length(global.GAMEPAD_SYSTEM.gamepad_configurations); i++) {
    	var _currentGamepadConfig = array_get(global.GAMEPAD_SYSTEM.gamepad_configurations, i);
        gamepad_fields_function(_currentGamepadConfig)
    }
}
/// @description this initializes and readies the configuration file for the gamepads.
/// @param {Boolean} override if forced saving should be done
function tte_gamepad_config_init(override = false){
    // if the gamepad system is ok, then create tte_gamepad.json
    if not file_exists(gamepad_config_location) or override
    {
        var _gamepadConfig = json_stringify(global.GAMEPAD_SYSTEM.gamepad_configurations, true)
        var _file = file_text_open_write(gamepad_config_location)
        file_text_write_string(_file, _gamepadConfig)
        file_text_close(_file)
        show_debug_message("{0}/INFO: gamepad configuration has been saved.", GAME_NAME)
    }
    else {
        // load and check the gamepad config please
    	var _loadedGamepadConfig = tte_load_file_all_lines(gamepad_config_location)
        var _parsed = json_parse(_loadedGamepadConfig)
        tte_check_json(global.GAMEPAD_SYSTEM.gamepad_configurations, _parsed, "gamepad")
        if global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using > global.GAMEPAD_SYSTEM.connected_gamepads {
            show_debug_message("{0}/WARN: gamepad connections over limit, defaulting to 0", GAME_NAME)
            global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using = 0
        }
        tte_gamepad_config_init(true)
    }
}
/// @description this initializes the gamepad.
function tte_gamepad_system_init(){
    global.GAMEPAD_SYSTEM.is_supported = true
    if not gamepad_is_supported()
    {
        show_debug_message("{0}/WARN: gamepad is not supported. Skipping gamepad initialization...", GAME_NAME)
        global.GAMEPAD_SYSTEM.is_supported = false
        return;
    } else {
        global.GAMEPAD_SYSTEM.connected_gamepads = gamepad_get_device_count()
        var _isConnected = false
        for (var i = 0; i < global.GAMEPAD_SYSTEM.connected_gamepads; i++) {
        	if (gamepad_is_connected(i))
            {
                _isConnected = true
                break
            }
        }
        
        if (_isConnected)
        {
            for (var i = 0; i < global.GAMEPAD_SYSTEM.connected_gamepads; i++) {
                var _desc = gamepad_get_description(i)
                if _desc != ""
            	 array_push(global.GAMEPAD_SYSTEM.gamepad_info, _desc);
            }
            show_debug_message("{0}/INFO: connected gamepads: {1}", GAME_NAME, global.GAMEPAD_SYSTEM.gamepad_info)
            show_debug_message("{0}/INFO: using gamepad: {1}", GAME_NAME, global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using)
        }
        else {
        	show_debug_message("{0}/INFO: no gamepad available, skipping", GAME_NAME)
        }
        tte_gamepad_config_init()
    } 
}
function tte_is_stick(stick_pos, stick_down){
    return array_length(tte_get_stick(stick_pos, stick_down)) > 0
}
/// @description get the analog stick, please
/// @param {Constant.GamepadAxis} stick_1 horizontal/vertical
/// @param {Constant.GamepadAxis} stick_2 horizontal/vertical
function tte_get_stick(stick_1, stick_2){
    var _inUse = global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using
    if not gamepad_is_connected(_inUse)
        return []

    // return the specified axis value...
    return [
            gamepad_axis_value(
                _inUse, 
                stick_1
            ),
            gamepad_axis_value(
                _inUse,
                stick_2
            )
    ]
}
function tte_check_if_gamepad_is_being_used(field) {
    var _isUsed = false
    if not gamepad_is_connected(global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using)
        return false
    if not struct_exists(global.GAMEPAD_SYSTEM.gamepad_configurations, field)
    {
        handle_error("gamepad field doesn't exist")
        return;
    }
    var _field = struct_get(global.GAMEPAD_SYSTEM.gamepad_configurations, field)
    var _names = struct_get_names(_field)
    for (var i = 0; i < array_length(_names); i++) {
    	var _currentName = struct_get(_field, _names[i])
        if (not _isUsed and tte_get_gamepad_held(global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using, _currentName))
            _isUsed = true
    }
    // check if we are 
    return _isUsed
}
/// @description this checks if a gamepad button is being held down.
//  @param {Real} device_name the device ID.
function tte_get_gamepad_held(device_name, button_idx, is_pressed = false){
    if not gamepad_is_connected(device_name) or global.CURRENT_CONTROL_METHOD != control_methods.gamepad
        return 0
    if is_array(button_idx)
    {
        var _isHeld = false
        for (var i = 0; i < array_length(button_idx); i++) {
        	var _button = array_get(button_idx, i)
            if is_pressed
            {
                if gamepad_button_check_pressed(device_name, _button)
                    _isHeld = true
            }
            else { 
                if gamepad_button_check(device_name, _button)
                    _isHeld = true
            }
        }
        return _isHeld
    }
    else {
        if is_pressed  {
            return gamepad_button_check_pressed(device_name, button_idx)
        }
        else {
        	return gamepad_button_check(device_name, button_idx)
        }
    }
}

/// @description this checks if a gamepad button is being held down.
//  @param {Real} device_name the device ID.
function tte_get_gamepad_pressed(device_name, button_idx){
    if not gamepad_is_connected(device_name) or global.CURRENT_CONTROL_METHOD != control_methods.gamepad
        return 0
    if is_array(button_idx)
    {
        var _isHeld = false
        for (var i = 0; i < array_length(button_idx); i++) {
        	var _button = array_get(button_idx, i)
            if (gamepad_button_check_pressed(device_name, _button))
                _isHeld = true
        }
        return _isHeld
    }
    else {
        return gamepad_button_check_pressed(device_name, button_idx)
    }
}

function tte_gamepad_axis(device_name, positive_axis, negative_axis, is_pressed = false){
    if not gamepad_is_connected(device_name)
        return 0
    return tte_get_gamepad_held(device_name, positive_axis, is_pressed) + tte_get_gamepad_held(device_name, negative_axis, is_pressed) * -1
}

tte_gamepad_system_init();