/// @param {Struct} screen_group the current group the screen is in.
/// @param {Id.Instance} gui_handler the current gui_handler
function sc_settings(screen_group, gui_handler){
    var _fullscreen_button = new tte_checkbox(
        gui_handler.x,
        gui_handler.y,
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "fullscreen"
        ),
        tte_get_config_value("game", "is_fullscreen"),
        screen_group,
        0,
        function triggerer_function(group, self_current){
			self_current.is_enabled = not self_current.is_enabled
            tte_save_config_with_field("game", {
                is_fullscreen: self_current.is_enabled
            })
            tte_save_or_load_configuration(true)
            window_set_fullscreen(self_current.is_enabled)
        }
    )
    var _is_controller = new tte_checkbox(
        gui_handler.x,
        _fullscreen_button.y + _fullscreen_button.get_measurements().y + OUTLINE_MARGIN * 2,
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "gamepad"
        ),
        tte_get_config_value("game", "is_gamepad"),
        screen_group,
        1,
        function change_input_type(sc, _self){
			if global.GAMEPAD_SYSTEM.connected_gamepads > 0 {
				global.CURRENT_CONTROL_METHOD = global.CURRENT_CONTROL_METHOD == control_methods.keyboard ? control_methods.gamepad : control_methods.keyboard
				tte_save_config_with_field("game", {
					is_gamepad: global.CURRENT_CONTROL_METHOD == control_methods.gamepad
				})
				tte_save_or_load_configuration(true)
				_self.is_enabled = global.CURRENT_CONTROL_METHOD == control_methods.gamepad 
                tte_change_screen("settings")
			}
        },
        global.GAMEPAD_SYSTEM.is_supported
    )
    var _is_gamepad = global.CURRENT_CONTROL_METHOD == control_methods.gamepad
    var _keybinding = new tte_gui_text(
        gui_handler.x, 
        _is_controller.y + _is_controller.get_measurements().y + OUTLINE_MARGIN * 2, 
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            _is_gamepad ? "controllers" : "keybinding"
        ),
        screen_group,
        c_white,
        32
    ) 
    var _fullMaxGroupVal = 2
    if (not _is_gamepad)
    {
        var _assignmentNames = struct_get_names(global.KEYBOARD_CONFIGURATION.player)
        for (var i = 0; i < array_length(_assignmentNames); i++) {
    	var _val = _assignmentNames[i]
        var _lastValue = array_last(screen_group.objects_in_group)
        var _currentKeyValue = struct_get(global.KEYBOARD_CONFIGURATION.player, _val)
        if is_real(_currentKeyValue)
            _currentKeyValue = tte_vk_to_keycode(_currentKeyValue)
            var _keybinding_button = new tte_selectable_button_text(
                gui_handler.x,
                _lastValue.y + _lastValue.get_measurements().y + OUTLINE_MARGIN * 2,
                string("{0} -> {1}", _val, _currentKeyValue),
                screen_group,
                _fullMaxGroupVal,
                function keybinding_function(screen_group, current_self){
                    var _currentViewport = view_camera[view_current];
                    var _viewportXHalf = camera_get_view_width(_currentViewport) / 2;
                    var _viewportYHalf = camera_get_view_height(_currentViewport) / 2;
                    // create the key selecting instance
                    instance_create_layer(
                        _viewportXHalf,
                        _viewportYHalf,
                        "Instances_1",
                        select_a_key,
                        {
                            assignmentName: current_self.tag,
                            assignmentField: "player",
                            typeOfAssignment: control_methods.keyboard
                        }
                    )
                    global.FREEZE_GUI_CONTROLS = true
                    },
                _val
            )
            _fullMaxGroupVal++
        }
    }
    
    var _lastValue = array_last(screen_group.objects_in_group)
    var _back = new tte_selectable_button_text(
        gui_handler.x,
        _lastValue.y + _lastValue.get_measurements().y + OUTLINE_MARGIN * 2,
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "back"
        ),
        screen_group,
        _fullMaxGroupVal,
        function back_button(){
            tte_change_screen("titlescreen")   
        }
    )
    screen_group.max_group_val = _fullMaxGroupVal
}