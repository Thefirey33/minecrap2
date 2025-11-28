var _alph = 1.0
if audio_is_playing(_init_sound) {
    var _pos = audio_sound_get_track_position(_init_sound)
    _alph = _pos / _max_width_audio
}
var _mul = _alph * 30
camera_set_view_pos(
    _active_cam,
    _active_cam_pos_x + random_range(-_mul, _mul),
    _active_cam_pos_y + random_range(-_mul, _mul)
)
draw_set_alpha(_alph)
draw_set_colour(c_white)
if _alph >= 1.0 {
    tte_change_screen("")
    room_goto(main_game_room)
}
draw_rectangle(0, 0, BASE_GAME_WIDTH, BASE_GAME_HEIGHT, false)