_offset = 10
for (var i = 0; i < _offset; i++) {
	audio_play_sound(snd_glitch, 100, true, 1.0, i)
}
_wind_x = window_get_x()
_wind_y = window_get_y()
_time_before = current_time
window_set_caption("")
shader_set(weirdShader)
_uni_pos = shader_get_uniform(weirdShader, "scale_ratio_pos")