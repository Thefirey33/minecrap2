global.KEYBOARD_CONFIGURATION = {
    player: {
        left: "A",
        right: "D",
        up: "W",
        down: "S",
        interact: "E"
    },
    debug: {
        show: "P"
    }
}
global.no_key_currently = 0.0;

#macro keyboard_config_name "keymapping.ini"
#macro keyboard_config_location working_directory + keyboard_config_name 

/// @description this returns a number value that is used for axis.
/// @param {String} positive_axis the positive axis keycode to use
/// @param {String} negative_axis the negative axis keycode to use
/// @returns {Real} the axis number
function do_axis(field_name, positive_axis, negative_axis){
    
    if not struct_exists(global.KEYBOARD_CONFIGURATION, field_name)
    {
        show_debug_message("{0}: NO KEY FIELD {1}", GAME_NAME, field_name);
        return global.no_key_currently;
    }
    else {
    	var _currentField = struct_get(global.KEYBOARD_CONFIGURATION, field_name);
        if struct_exists(_currentField, positive_axis) or struct_exists(_currentField, negative_axis)
        {
            var _positiveAxis = struct_get(_currentField, positive_axis);
            var _negativeAxis = struct_get(_currentField, negative_axis);
            return keyboard_check(ord(_positiveAxis)) + keyboard_check(ord(_negativeAxis)) * -1
        }
        else {
            show_debug_message("{0}: NO KEY {1} {2}", GAME_NAME, positive_axis, negative_axis)
            return global.no_key_currently;
        }
    }
}
/// @description this checks if a key is currently being held.
function check_if_key_held(key_name){
    return keyboard_check(ord(key_name))
}
/// @description this checks if a key is right NOW pressed.
function check_if_key_pressed(key_name){
    return keyboard_check_pressed(ord(key_name))
}
/// @description this function saves the current keymapping to the system.
/// @param {Function} trigger_and_processor_function values: the current field, the current var-name, the current value
function do_keymapping_functions(triggerer_and_processor_function){
    ini_open(keyboard_config_location);
    var _structNames = struct_get_names(global.KEYBOARD_CONFIGURATION);
    for (var i = 0; i < array_length(_structNames); i++) {
        var _currentName = _structNames[i];
        var _currentField = struct_get(global.KEYBOARD_CONFIGURATION, _currentName);
        
        // all the fields in the global.KEYBOARD_CONFIGURATION
        var _innerStructNames = struct_get_names(_currentField);
        for (var j = 0; j < array_length(_innerStructNames); j++) {
            var _currentInnerName = _innerStructNames[j];
        	var _currentValue = struct_get(_currentField, _currentInnerName);
            
            triggerer_and_processor_function(_currentName, _currentInnerName, _currentValue);
        }
    }
    // close the configuration file.
    ini_close()
}

/// @description Set a struct value.
/// @param {String} current_field the field to use.
/// @param {String} variable_name the variable name currently.
/// @param {String} variable_value the original variable value.
/// @param {String} current_value The value to set to.
function set_keymapping_struct_value(current_field, variable_name, current_value){ 
    if (struct_exists(global.KEYBOARD_CONFIGURATION, current_field))  { 
        var _fieldToSet = struct_get(global.KEYBOARD_CONFIGURATION, current_field);
        struct_set(_fieldToSet, variable_name, current_value);
    }
    else
        handle_error("Struct Field Doesn't Exist!");
}

/// @description a bit of a more smarter configuration system
function setup_keymapping(){
    // checks if the keymapping.ini file exists or not.
    if (not file_exists(keyboard_config_location))
    {
        // do *.ini file saving.
        do_keymapping_functions(function save_function(current_field, variable_name, variable_value){
            if is_real(variable_value)
                ini_write_real(current_field, variable_name, variable_value);
            else if is_string(variable_value)
                ini_write_string(current_field, variable_name, variable_value);
        });
    }
    else {
        // do *.ini file loading.
    	do_keymapping_functions(function load_functions(current_field, variable_name, variable_value){
            var _currentValue = undefined;
            
            // write to the keymapper. 
            show_debug_message("{0}: writing {1} to {2}", GAME_NAME, variable_name, current_field);
            if is_real(variable_value)
            {
                _currentValue = ini_read_real(current_field, variable_name, variable_value);
                if ini_key_exists(current_field, variable_name){
                    ini_write_real(current_field, variable_name, _currentValue);
                }
            }
            else if is_string(variable_value)
            {
                _currentValue = ini_read_string(current_field, variable_name, variable_value);
                if ini_key_exists(current_field, variable_name){
                    ini_write_string(current_field, variable_name, _currentValue);
                }
            }
            set_keymapping_struct_value(current_field, variable_name, _currentValue);
        });
    }
}