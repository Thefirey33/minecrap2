
global.CURRENT_SCREEN = "titlescreen"
global._currentGroups = []
tte_initialize_font_system()
var _reverb_effect = audio_effect_create(AudioEffectType.Reverb1)
_reverb_effect.size = 10.0
_reverb_effect.mix = 0.5
global.current_music = tte_create_audio_with_effects([_reverb_effect], AUDIO_ANOTHERHIM, true, 100)
_currentEmitterInstance = global.current_music[$ "audio_emitter_instance"]
audio_emitter_gain(_currentEmitterInstance, -100.0)
currentMatrix = matrix_build_identity()
_uni = shader_get_uniform(wavy_text, "TIME")
global.current_screens = {
    "titlescreen": function create_titlescreen(){
        sc_titlescreen(tte_create_and_insert(), self)
    },
    "settings": function create_settings() {
        sc_settings(tte_create_and_insert(), self)
    },
    "name_your_guy": function create_name_your_guy(){
        sc_name_your_guy(tte_create_and_insert(), self)
    }
}


function switch_screens(){
    if struct_exists(global.current_screens, global.CURRENT_SCREEN)
        struct_get(global.current_screens, global.CURRENT_SCREEN)()
    else 
        // if the screen does not exist, just ignore it and move on.
    	array_insert(global._currentGroups, 0, new tte_screen_group(tte_gui_alignment.vertical))
}
switch_screens()
