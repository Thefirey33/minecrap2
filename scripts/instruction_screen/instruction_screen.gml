
/// @param {Struct} screen_group the current group the screen is in.
/// @param {Id.Instance} gui_handler the current gui_handler
function sc_instruction_screen(screen_group, gui_handler){
    var _instructionText = new tte_gui_text(
        gui_handler.x, 
        gui_handler.y, 
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            global.CURRENT_CONTROL_METHOD == control_methods.gamepad ? "instruction_gamepad" : "instruction"
        ),
        screen_group,
        c_gray
    )
    var _okayText = new tte_selectable_button_text(
        gui_handler.x,
        gui_handler.y + _instructionText.get_measurements()[1] * 2,
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "ok"
        ),
        screen_group,
        0,
        function triggerer(screen_group){ 
            global.CURRENT_SCREEN = "titlescreen"
            screen_group.disabled_group = true
            with (gui_handler) {
            	self.switch_screens()
            }
        }
    )
}