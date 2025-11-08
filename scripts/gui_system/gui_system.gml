enum tte_gui_alignment {
	horizontal,
    vertical
}
global.CURRENT_SCREEN = "starting_screen"
#macro BASE_SPRITE no_texture
 
/// @param {Real} _gui_alignment where the gui is aligned to, (controls) 0 -> horizontal 1 -> vertical.
function tte_screen_group(_gui_alignment) constructor {
    objects_in_group = []
    tab_index = 0
    opacity = 1
    disabled_group = false
    m_gui_alignment = _gui_alignment
    
    render_this_group = function (){
        draw_set_alpha(opacity)
        var _g = 1 + (1 - opacity)
        matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 1, _g, 1))
        for (var i = 0; i < array_length(self.objects_in_group); i++) {
        	var _idx = array_get(self.objects_in_group, i);
            if _idx[$ "render_this_object"] != undefined
                _idx.render_this_object()
            else 
            	show_debug_message("{0}/ERROR: rendering failure for screen group: {1}", GAME_NAME, self)
        }
        matrix_set(matrix_world, matrix_build_identity())
        draw_set_alpha(1)
    }
    
    /// @description reset the objects in group back to zero.
    clear_group = function (){
        objects_in_group = []
    }
}

/// @param {Real} _x x-coordinate.
/// @param {Real} _y y-coordinate.
/// @param {Struct} _screen_group the current screen-group.
function tte_gui_object(_x, _y, _screen_group) constructor  {
    x = _x
    y = _y
    current_screen_group = _screen_group
    if current_screen_group == undefined
        handle_error("wrong screen group value.")
    else
        array_push(current_screen_group.objects_in_group, self)
    
    /// @description render this object to the screen please.
    render_this_object = function() {
        // ignore
    }
    
    /// @description this function returns the measurements for the gui_object and how it should be made.
    /// @return {Array<Real>} returnee.
    get_measurements = function (){
        return [
            sprite_get_width(BASE_SPRITE),
            sprite_get_height(BASE_SPRITE)
        ]
    }
}

function tte_gui_text(_x, _y, _text, _screen_group, _color) : tte_gui_object(_x, _y, _screen_group) constructor {
    text = _text
    color = _color
    /// @description render this text to the screen.
    render_this_object = function (){
        draw_set_colour(color)
        draw_text(x, y, text)
        draw_set_colour(c_white)
    }
    
    /// @description get the measurements please.
    get_measurements = function (){
        return [
            string_width(text),
            string_height(text)
        ]
    }
}

/// @description base selectable class
function tte_selectable_object(_x, _y, _screen_group, _tab_index_for_object) : tte_gui_object(_x, _y, _screen_group) constructor {
    tab_index_for_object = _tab_index_for_object
    is_selected = false
    render_this_object = function(){
        is_selected = (self.current_screen_group[$ "tab_index"] == tab_index_for_object)
        // draw this to indicate that this is a base object
        var _beforeColor = draw_get_colour()
        draw_set_colour(is_selected ? c_orange : c_white)
        draw_sprite_ext(BASE_SPRITE, 0, x, y, 1, 1, 0, draw_get_colour(), 255)
        draw_set_colour(_beforeColor)
    }
}

/// @description this displays a selectable, text-button to the screen.
/// @param {Real} _x x-coordinate.
/// @param {Real} _y y-coordinate.
/// @param {String} _text text to display.
/// @param {Struct} _screen_group the group the screen is in currently.
/// @param {Real} _tab_index_for_object the tab index, basically what IDX the object is in.
/// @param {Function} _function_to_trigger what function will this object trigger when it's pressed on?
function tte_selectable_button_text(_x, _y, _text, _screen_group, _tab_index_for_object, _function_to_trigger) : tte_selectable_object(_x, _y, _screen_group, _tab_index_for_object) constructor  {
    text = _text
    function_to_trigger = _function_to_trigger
    render_this_object = function (){
        is_selected = (self.current_screen_group[$ "tab_index"] == tab_index_for_object)
        draw_text_transformed(x, y, text, 1, 1, random(10) * is_selected)
        if current_screen_group.disabled_group
            return
        // if we have successfully pressed on the thing, or interacted with it...
        // do stuff!
        if tte_check_if_key_held(
            global.KEYBOARD_CONFIGURATION.player.jump
        ) or tte_get_gamepad_pressed (
            global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
            global.GAMEPAD_SYSTEM.gamepad_configurations.player.jump
        ) {
            function_to_trigger(current_screen_group)
        }
    }
    get_measurements = function (){
        return [
            string_width(text),
            string_height(text)
        ]
    }
}

