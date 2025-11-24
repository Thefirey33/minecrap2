
/// @param {Struct} screen_group the current group the screen is in.
/// @param {Id.Instance} gui_handler the current gui_handler
function sc_titlescreen(screen_group, gui_handler){
    // the actual titlescreen logo, VERY COOLLLL HOLEE SHEEt
    
    var _logo_text_inner_text = tte_get_localization(
        global.CURRENT_LANGUAGE,
        "gamename"
    )
    new tte_gui_text(
        BASE_GAME_WIDTH - string_width(_logo_text_inner_text) * 3,
        (BASE_GAME_HEIGHT / 2) + string_height(_logo_text_inner_text),
        _logo_text_inner_text,
        screen_group,
        c_white,
        32
    )
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
            tte_change_screen("name_your_guy")
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