/// @desc Function Description
/// @param {Struct.tte_screen_group} screen_group Description
/// @param {Id.gui_handler} gui_handler Description
/// @param {String} msg message
/// @param {String} before_screen the screen before this
function sc_messagebox(screen_group, gui_handler, msg, before_screen){
    var _label = new tte_gui_text(
        gui_handler.x,
        gui_handler.y,
        global.TEMP_KEEPERS[$ "a1"],
        screen_group,
        c_white,
        32
    )
    global.TEMP_KEEPERS[$ "a1"] = before_screen
    var _button = new tte_selectable_button_text(
        gui_handler.x,
        gui_handler.y + _label.get_measurements().y + OUTLINE_MARGIN * 2,
        "OK",
        screen_group,
        0,
        function triggerer(){
            tte_change_screen(global.TEMP_KEEPERS[$ "a1"])
        }
    )
    screen_group.max_group_val = 0
}