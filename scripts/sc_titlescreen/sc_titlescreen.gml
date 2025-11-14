
/// @param {Struct} screen_group the current group the screen is in.
/// @param {Id.Instance} gui_handler the current gui_handler
function sc_titlescreen(screen_group, gui_handler){
    // the play button
    var _play = new tte_selectable_button_text(
        gui_handler.x,
        gui_handler.y,
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "play"
        ),
        screen_group,
        0,
        function play(){
            tte_change_screen("")
            room_goto(main_game_room)
        }
    )
    // the settings button
    var _settings = new tte_selectable_button_text(
        gui_handler.x,
        _play.y + _play.get_measurements()[1] + OUTLINE_MARGIN * 2,
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "settings"
        ),
        screen_group,
        1,
        function on_settings(){
            tte_change_screen("settings")
        }
    )
    // the settings button
    var _end_program = new tte_selectable_button_text(
        gui_handler.x,
        _settings.y + _settings.get_measurements()[1] + OUTLINE_MARGIN * 2,
        tte_get_localization(
            global.CURRENT_LANGUAGE,
            "end_program"
        ),
        screen_group,
        2,
        function on_end(){
            game_end(0)
        }
    )
    screen_group.max_group_val = 2
}