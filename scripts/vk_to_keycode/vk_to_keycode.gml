#region translation keys for all gamepad buttons

    global._key_translation = ds_map_create()
    // keys
    ds_map_add(global._key_translation, vk_right, "key_right")
    ds_map_add(global._key_translation, vk_left, "key_left")
    ds_map_add(global._key_translation, vk_up, "key_up")
    ds_map_add(global._key_translation, vk_down, "key_down")
    // gamepad buttons
    ds_map_add(global._key_translation, gp_face1, "gamepad_face_1")
    ds_map_add(global._key_translation, gp_face2, "gamepad_face_2")
    ds_map_add(global._key_translation, gp_face3, "gamepad_face_3")
    ds_map_add(global._key_translation, gp_face4, "gamepad_face_3")
    // gamepad d-pad
    ds_map_add(global._key_translation, gp_padr, "gamepad_pad_r")
    ds_map_add(global._key_translation, gp_padd, "gamepad_pad_d")
    ds_map_add(global._key_translation, gp_padl, "gamepad_pad_l")
    ds_map_add(global._key_translation, gp_padu, "gamepad_pad_l")
    // gamepad shoulder buttons and triggers
    ds_map_add(global._key_translation, gp_shoulderl, "gamepad_left_sh")
    ds_map_add(global._key_translation, gp_shoulderr, "gamepad_right_sh")
    ds_map_add(global._key_translation, gp_shoulderlb, "gamepad_left_st")
    ds_map_add(global._key_translation, gp_shoulderlb, "gamepad_left_st")

#endregion

/// @description larry.
function tte_vk_to_keycode(keycode){
    if not is_real(keycode)
        return keycode
    else 
        // wow cool
        var _untranslated_keycode_name = keycode
        if ds_map_exists(global._key_translation, keycode)
            _untranslated_keycode_name = ds_map_find_value(global._key_translation, keycode)
        // check if there's localization for this crap
        var _val = tte_get_localization( global.CURRENT_LANGUAGE, _untranslated_keycode_name)
        if _val == undefined
            return chr(keycode)
        else 
            return _val
}