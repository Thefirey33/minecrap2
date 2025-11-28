global.CONFIGURATION = {}
#macro configuration_file string("{0}.ini", GAME_NAME)
global.CURRENT_CONTROL_METHOD = control_methods.keyboard

/// @param {String} field the field to assign to.
/// @param {Struct} config_data configuration data.
function tte_save_config_with_field(field, config_data){
    
    if not struct_exists(global.CONFIGURATION, field) {
        struct_set(global.CONFIGURATION, field, config_data)
    } else {
        // merge the two structs together
        var _struct_field_to_merge = struct_get(global.CONFIGURATION, field)
        var _names_of_merger = struct_get_names(config_data)
        for (var i = 0; i < array_length(_names_of_merger); i++) {
            var _nm = _names_of_merger[i]
        	struct_set(_struct_field_to_merge, _nm, struct_get(config_data, _nm))
        }
        struct_set(global.CONFIGURATION, field, _struct_field_to_merge)
    }
    show_debug_message("{0}/INFO: add field to config: {1}", GAME_NAME, field)
}

/// @description this function loops over the provided configuration data for saving or loading.
/// @param {Function} triggerer_function the function that provides the values: (field, var_name, var)
function tte_loop_over_configuration_data(triggerer_function){
    
    var _names = struct_get_names(global.CONFIGURATION)
    for (var i = 0; i < array_length(_names); i++) {
    	var _currentFieldIdentifier = _names[i]
        var _currentField = struct_get(global.CONFIGURATION, _currentFieldIdentifier)
        
        var _namesField = struct_get_names(_currentField)
        for (var j = 0; j < array_length(_namesField); j++) {
        	var _currentDataIdentifier = _namesField[j]
            var _currentData = struct_get(_currentField, _currentDataIdentifier)
            
            // trigger the function please.
            triggerer_function(
                _currentFieldIdentifier, 
                _currentDataIdentifier, 
                _currentData
            )
        }
    }
}

/// @description load or save the configuration file.
/// @param {Bool} force_save should the configuration be forced to be saved?
function tte_save_or_load_configuration(force_save = false){
    // open the configuration file and start writing.
    ini_open(configuration_file)
    
    if not file_exists(configuration_file) or force_save {
        tte_loop_over_configuration_data(function loop_over_save(_field, _varName, _var){
            show_debug_message("{0}/INFO: saving config variable {1}", GAME_NAME, _varName)
            if is_real(_var) or is_bool(_var)
            	ini_write_real(_field, _varName, _var)
            else if is_string(_var)
                ini_write_string(_field, _varName, _var)
            else
                handle_error("unsupported configuration file type")
        })
        ini_close()
    } else {
    	tte_loop_over_configuration_data(function loop_over_load(_field, _varName, _var){
            show_debug_message("{0}/INFO: loading config variable {1}", GAME_NAME, _varName)
            var _currentFieldData = struct_get(global.CONFIGURATION, _field)
            if is_real(_var) or is_bool(_var) {
                var _readValue = ini_read_real(_field, _varName, _var)
                struct_set(_currentFieldData, _varName, _readValue)
            } else if is_string(_var) {
                var _readValue = ini_read_string(_field, _varName, _var)
                struct_set(_currentFieldData, _varName, _readValue)
            } else
            	handle_error("unsupported configuration file type")
            struct_set(global.CONFIGURATION, _field, _currentFieldData)
        })
        ini_close()
        tte_save_or_load_configuration(true)
    }
}

function tte_get_config_value(field, key){
    var _val = global.CONFIGURATION[$ field] [$ key]
    // return if the configuration value, in fact does exist
    if _val != undefined
        return _val
    else
        handle_error("configuration value doesn't exist.")
}

/// @description this function gets the configuration ready.
function tte_ready_config(){
    tte_save_config_with_field("game", {
        is_fullscreen: false,
        game_name: "Minecrap 2",
        volume: 100,
        is_gamepad: global.CURRENT_CONTROL_METHOD == control_methods.gamepad
    })
    tte_save_or_load_configuration(false)
    // load the base game configurations...
    window_set_fullscreen(tte_get_config_value("game", "is_fullscreen"))
    window_set_caption(tte_get_config_value("game", "game_name"))
    global.CURRENT_CONTROL_METHOD = tte_get_config_value("game", "is_gamepad") ? control_methods.gamepad : control_methods.keyboard
}

// get the configuration system ready please.
tte_ready_config()