
/// @param {Struct} screen_group the current group the screen is in.
/// @param {Id.Instance} gui_handler the current gui_handler
function sc_name_your_guy(screen_group, gui_handler){
    var localization_text = tte_get_localization(
            global.CURRENT_LANGUAGE,
            "name_your_guy"
    )
    var _x_orig = (camera_get_view_width(CURRENT_CAMERA) / 2) - string_width(localization_text)
    var _lastObject = new tte_gui_text(
        _x_orig, 
        gui_handler.y,
        localization_text,
        screen_group,
        c_white,
        30
    )
    var _textbox = new tte_gui_selectable_and_editable(
        _x_orig,
        _lastObject.y + (_lastObject.get_measurements()[1] + OUTLINE_MARGIN * 2) + 50,
        screen_group,
        0,
        sha1_string_utf8(current_time)
    )
    new tte_selectable_button_text(
        _x_orig,
        _textbox.y + (_textbox.get_measurements()[1] + OUTLINE_MARGIN * 2),
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "ok"
        ),
        screen_group,
        1,
        function trigger_ok(){
            
        }
    )
    screen_group.max_group_val = 1
    
}