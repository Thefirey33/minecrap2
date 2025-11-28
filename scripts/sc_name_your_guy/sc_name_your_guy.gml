global.response_map = ds_map_create()
ds_map_add(global.response_map, "gay", "first_response")
ds_map_add(global.response_map, "femboy", "first_response")

/// @param {Struct} screen_group the current group the screen is in.
/// @param {Id.Instance} gui_handler the current gui_handler
function sc_name_your_guy(screen_group, gui_handler){
    global.TEMP_KEEPERS[$ "a3"] = gui_handler
    var localization_text = tte_get_localization(
            global.CURRENT_LANGUAGE,
            "name_your_guy"
    )
    var _x_averag = camera_get_view_width(CURRENT_CAMERA) / 2
    var _x_orig = _x_averag - string_width(localization_text)
    var _lastObject = new tte_gui_text(
        _x_orig, 
        gui_handler.y,
        localization_text,
        screen_group,
        c_white,
        30
    )
    global.TEMP_KEEPERS.a2 = new tte_gui_selectable_and_editable(
        _x_orig,
        _lastObject.y + (_lastObject.get_measurements().y + OUTLINE_MARGIN * 2) + 50,
        screen_group,
        0,
        new tte_coordinate_system(
            _lastObject.get_measurements().x,
            16
        ),
        function _ignore(){},
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "input_name"
        )
    )
    var _tte_localization = tte_get_localization(
            global.CURRENT_LANGUAGE,
            "ok"
    )
    new tte_selectable_button_text(
        _x_averag - string_width(_tte_localization) / 2,
        global.TEMP_KEEPERS.a2.y + (global.TEMP_KEEPERS.a2.get_measurements().y + OUTLINE_MARGIN * 2),
        _tte_localization,
        screen_group,
        1,
        function trigger_ok(current_screen_group, self){
            var _inpText = global.TEMP_KEEPERS.a2.input_text 
            if string_lower(_inpText) == "thefirey33" {
                audio_stop_all()
                global.FREEZE_GUI_CONTROLS = true
                instance_create_layer(
                    0,
                    0,
                    "GlitchLayer",
                    glitch_controller
                )
                return
            }
            var _resp = ds_map_exists(global.response_map, _inpText)
            if _resp {
                global.TEMP_KEEPERS.a1 = tte_get_localization(
                    global.CURRENT_LANGUAGE,
                    ds_map_find_value(global.response_map, _inpText)
                )
                tte_advanced_screen_switcher(function trigger_switch(m_gui_handler){ 
                    sc_messagebox(tte_create_and_insert(tte_gui_alignment.horizontal), m_gui_handler, global.TEMP_KEEPERS.a1, "name_your_guy")
                })
            }
            else { 
                audio_stop_all()
                global.FREEZE_GUI_CONTROLS = true
                instance_create_layer(
                    0,
                    0,
                    "GlitchLayer",
                    first_transition_controller
                )
            }
        }
    )
    screen_group.max_group_val = 1
    
}