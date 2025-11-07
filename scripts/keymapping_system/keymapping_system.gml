global.KEYBOARD_CONFIGURATION = {
    player: {
        left: vk_left,
        right: vk_right,
        jump: "Z",
        run: "X",
        interact: "E"
    },
    game: {
        switch_method: "Q"
    },
    debug: {
        show: "P"
    }
}
global.no_key_currently = 0.0;

#macro keyboard_config_name "tte_keyboard.json"
#macro keyboard_config_location working_directory + keyboard_config_name 

/// @description this returns a number value that is used for axis.
/// @param {String} field_name field
/// @param {String} positive_axis the positive axis keycode to use
/// @param {String} negative_axis the negative axis keycode to use
/// @returns {Real} the axis number
function tte_do_axis(field_name, positive_axis, negative_axis){
    
    if not struct_exists(global.KEYBOARD_CONFIGURATION, field_name)
    {
        show_debug_message("{0}/WARN: NO KEY FIELD {1}", GAME_NAME, field_name);
        return global.no_key_currently;
    }
    else {
    	var _currentField = struct_get(global.KEYBOARD_CONFIGURATION, field_name);
        if struct_exists(_currentField, positive_axis) or struct_exists(_currentField, negative_axis)
        {
            var _positiveAxis = struct_get(_currentField, positive_axis);
            var _negativeAxis = struct_get(_currentField, negative_axis);
            return tte_check_if_key_held(_positiveAxis) + tte_check_if_key_held(_negativeAxis) * -1
        }
        else {
            show_debug_message("{0}/WARN: NO KEY {1} {2}", GAME_NAME, positive_axis, negative_axis)
            return global.no_key_currently;
        }
    }
}
/// @description this checks if a key is currently being held.
function tte_check_if_key_held(key_name){
    if is_real(key_name)
        return keyboard_check(key_name)
    else
        return keyboard_check(ord(key_name))
}
/// @description this checks if a key is right NOW pressed.
function tte_check_if_key_pressed(key_name){
    if is_real(key_name)
        return keyboard_check_pressed(key_name)
    else
        return keyboard_check_pressed(ord(key_name))
}

/// @description Set a struct value.
/// @param {String} current_field the field to use.
/// @param {String} variable_name the variable name currently.
/// @param {String} variable_value the original variable value.
/// @param {String} current_value The value to set to.
function tte_set_keymapping_struct_value(current_field, variable_name, current_value){ 
    if (struct_exists(global.KEYBOARD_CONFIGURATION, current_field))  { 
        var _fieldToSet = struct_get(global.KEYBOARD_CONFIGURATION, current_field);
        struct_set(_fieldToSet, variable_name, current_value);
    }
    else
        handle_error("Struct Field Doesn't Exist!");
}
/// @description this system checks if a parsed configuration file json is missing some arguments, if it is, skip, but it if it doesn't, set the target json to those values
/// @param {Struct} target_json the target json to reference from
/// @param {Struct} _parsed the json we are checking for
/// @param {String} check_name what file are we checking for
function tte_check_json(target_json, _parsed, check_name = "keymapping"){
    // show seperated debug message
    show_debug_message("{0}: checking for {1} JSON...", GAME_NAME, check_name)
    var _fields = struct_get_names(target_json)
    // piecing the data and checking one by one if we have a missing keyboard argument
    for (var i = 0; i < array_length(_fields); i++) {
        var _currentFieldIdentifier = _fields[i] 
        var _parsedField = struct_get(_parsed, _currentFieldIdentifier)
        var _currentField = struct_get(target_json, _currentFieldIdentifier)
            
        var _data = struct_get_names(_currentField)
        for (var j = 0; j < array_length(_data); j++) {
            var _dataIdentifier = _data[j]
            var _dataItself = struct_get(_currentField, _dataIdentifier)
                
            if _parsedField != undefined {
                var _parsedData = struct_get(_parsedField, _dataIdentifier)
                if _parsedData != undefined {
                    struct_set(_currentField, _dataIdentifier, _parsedData)
                    show_debug_message("{0}/INFO -> {3}: writing to configuration from json: {1}/{2}", GAME_NAME, _currentFieldIdentifier, _dataIdentifier, check_name)
                }
                else 
                    show_debug_message("{0}/WARN -> {3}: {1} data in field {2} is undefined, using provided value", GAME_NAME, _dataIdentifier, _currentFieldIdentifier, check_name)
            }
            else 
                show_debug_message("{0}/WARN -> {3}: {1} field is undefined, using provided value", GAME_NAME, _currentFieldIdentifier, check_name)
        }
    }
}
/// @description a bit of a more smarter configuration system
function tte_setup_keymapping(override = false){
    // checks if the keymapping.ini file exists or not.
    if (not file_exists(keyboard_config_location) or override)
    {
        // just write it directly, no ini
        show_debug_message("{0}/INFO: saving keyboard config...", GAME_NAME)
        var _keymappingData = json_stringify(global.KEYBOARD_CONFIGURATION, true)
        var _file = file_text_open_write(keyboard_config_location)
        file_text_write_string(_file, _keymappingData)
        file_text_close(_file)
    }
    else {
    	var _loadedKeymapping = tte_load_file_all_lines(keyboard_config_location)
        var _parsed = json_parse(_loadedKeymapping)
        tte_check_json(global.KEYBOARD_CONFIGURATION, _parsed)
        // save and check if we have any leftover values to save.
        tte_setup_keymapping(true)
    }
}