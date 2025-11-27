/// @desc this creates information for audios.
/// @param {Id.Sound} _audio_instance the audio instance itself.
/// @param {Id.AudioEmitter} _audio_emitter_instance the audio emitter instance itself.
/// @param {Struct.AudioBus} _audio_bus_instance the audio bus instance itself.
function tte_audio_information(_audio_instance, _audio_emitter_instance, _audio_bus_instance) constructor {
    audio_instance = _audio_instance
    audio_emitter_instance = _audio_emitter_instance
    audio_bus_instance = _audio_bus_instance
}

/// @desc this creates a sound with specified effects.
/// @param {Array.Struct.AudioEffect} effects the effects to use.
/// @param {asset.gmsound} audio the audio itself.
/// @param {bool} audio_loop should the audio loop
/// @param {real} pr the priority of the audio.
/// @returns {Struct.tte_audio_information} the audio id
function tte_create_audio_with_effects(effects, audio, audio_loop, pr){
    emitter = audio_emitter_create()
    emitter_bus = audio_bus_create()
    for (var i = 0; i < array_length(effects); i++) {
    	emitter_bus.effects[0] = effects[0]
    }
    audio_emitter_bus(emitter, emitter_bus);
    return new tte_audio_information(audio_play_sound_on(emitter, audio, audio_loop, pr), emitter, emitter_bus);
}