shader_set(weird_shader)
var _time_diff = ((current_time - _time_before) + _offset) * get_current_deltatime()
var _min = min(20, _time_diff)
window_set_position(_wind_x + random_range(-_min, _min), _wind_y + random_range(-_min, _min))
if _time_diff > 150 {
    audio_stop_all()
    game_end(1)
}
shader_set_uniform_f(_uni_pos, random_range(-_time_diff, _time_diff) / 50, random_range(-_time_diff, _time_diff) / 50)