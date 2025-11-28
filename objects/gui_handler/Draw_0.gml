audio_emitter_gain(_currentEmitterInstance,  
    min(1, audio_emitter_get_gain(_currentEmitterInstance) + get_current_deltatime() / 100)
)
var _is_shader_glitch = shader_current() == weird_shader
if !_is_shader_glitch
{
    shader_set(wavy_text)
    shader_set_uniform_f(_uni, current_time)
}
// start drawing please.
var _first = array_first(global._currentGroups)
if array_length(global._currentGroups) > 0 {
    for (var i = 1; i < array_length(global._currentGroups); i++) {
    	var _val = global._currentGroups[i]
        _val.opacity -= get_current_deltatime() 
        if _val.max_group_val <= _first.max_group_val and not _val.disabled_group {
            _first.tab_index = _val.tab_index
        }
        _val.disabled_group = true
        _val[$ "render_this_group"]() 
        if _val.opacity < 0 {
            array_delete(global._currentGroups, i, 1) 
            delete _val
        }
    }
}
_first.opacity = lerp(_first.opacity, 1, get_current_deltatime() * 5)
_first[$ "render_this_group"]()
if !_is_shader_glitch
    shader_reset()