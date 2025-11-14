enum tte_gui_alignment {
	horizontal,
    vertical
}
global.CURRENT_SCREEN = ""
global.FREEZE_GUI_CONTROLS = false
#macro BASE_SPRITE no_texture
#macro MAIN_FONT "determination-mono.ttf"  

// all of the fonts defined...
global.CURRENT_FONTS = {
    normal: font_add(MAIN_FONT, 15, false, false, 32, 128),
    bold: font_add(MAIN_FONT, 15, true, false, 32, 128),
    italic: font_add(MAIN_FONT, 15, false, true, 32, 128),
    normal_xl: font_add(MAIN_FONT, 30, false, false, 32, 128),
    bold_xl: font_add(MAIN_FONT, 30, true, false, 32, 128),
    italic_xl: font_add(MAIN_FONT, 30, false, true, 32, 128),
}

function tte_create_and_insert(){
    var _newScreenGroup = new tte_screen_group(tte_gui_alignment.vertical)
    array_insert(global._currentGroups, 0, _newScreenGroup)
    return _newScreenGroup
}

draw_set_font(global.CURRENT_FONTS.normal)

/// @description this changes the screen.
/// @param {String} new_screen the screen to change to.
function tte_change_screen(new_screen){
    global.CURRENT_SCREEN = new_screen
    with (gui_handler) {
        self.switch_screens()
    }
}

/// @param {Real} _gui_alignment where the gui is aligned to, (controls) 0 -> horizontal 1 -> vertical.
function tte_screen_group(_gui_alignment) constructor {
    objects_in_group = []
    tab_index = 0
    opacity = 1
    disabled_group = false
    max_group_val = 0
    m_gui_alignment = _gui_alignment
    
    render_this_group = function (){
        if not (disabled_group or global.FREEZE_GUI_CONTROLS) {
            if global.CURRENT_CONTROL_METHOD == control_methods.keyboard { 
                self.tab_index += tte_do_axis(
                        "player",
                        self.m_gui_alignment == tte_gui_alignment.vertical ? "down" : "left",
                        self.m_gui_alignment == tte_gui_alignment.vertical ? "up" : "right",
                        true
                    )
                } else { 
                    self.tab_index += tte_gamepad_axis(
                        global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
                        self.m_gui_alignment == tte_gui_alignment.vertical ? 
                        global.GAMEPAD_SYSTEM.gamepad_configurations.player.down_look : 
                        global.GAMEPAD_SYSTEM.gamepad_configurations.player.left,
                        self.m_gui_alignment == tte_gui_alignment.vertical ? 
                        global.GAMEPAD_SYSTEM.gamepad_configurations.player.up_look :
                        global.GAMEPAD_SYSTEM.gamepad_configurations.player.right,
                        true
                )
            }
        }
        self.tab_index = clamp(self.tab_index, 0, max_group_val)
        
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

function tte_gui_image(_x, _y, _screen_group, _sprite): tte_gui_object(_x, _y, _screen_group) constructor  {
    sprite = _sprite
    
    render_this_object = function() {
        draw_sprite(sprite, 0, x, y)
    }
    
    get_measurements = function (){
        return [
            sprite_get_width(sprite),
            sprite_get_height(sprite)
        ]
    }
}
function tte_gui_text(_x, _y, _text, _screen_group, _color, _font_size = 16) : tte_gui_object(_x, _y, _screen_group) constructor {
    text = _text
    color = _color
    font_size = _font_size
    font_to_use = font_add(MAIN_FONT, font_size, false, false, 32, 128)
    /// @description render this text to the screen.
    render_this_object = function (){
        draw_set_colour(color)
        var _beforeFont = draw_get_font()
        draw_set_font(font_to_use)
        draw_text(x, y, text)
        draw_set_font(_beforeFont)
        draw_set_colour(c_white)
    }
    
    /// @description get the measurements please.
    get_measurements = function (){
        var _beforeFont = draw_get_font()
        draw_set_font(font_to_use)
        var _val = [
            string_width(text),
            string_height(text)
        ]
        draw_set_font(_beforeFont)
        return _val
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
#macro OUTLINE_MARGIN 3
#macro CHECKBOX_IF_ELSE ? "+" : "-" 
/// @description this displays a selectable, text-button to the screen.
/// @param {Real} _x x-coordinate.
/// @param {Real} _y y-coordinate.
/// @param {String} _text text to display.
/// @param {Struct} _screen_group the group the screen is in currently.
/// @param {Real} _tab_index_for_object the tab index, basically what IDX the object is in.
/// @param {Function} _function_to_trigger what function will this object trigger when it's pressed on? (current_screen_group, self)
function tte_selectable_button_text(_x, _y, _text, _screen_group, _tab_index_for_object, _function_to_trigger, _tag = undefined, _is_allowed = true) : tte_selectable_object(_x, _y, _screen_group, _tab_index_for_object) constructor  {
    text = _text
    function_to_trigger = _function_to_trigger
    is_allowed = _is_allowed
    tag = _tag
    color = c_white
    render_this_object = function (){
        is_selected = (self.current_screen_group[$ "tab_index"] == tab_index_for_object)
        draw_set_colour(is_allowed ? color : c_red)
        if is_selected {
            var _measurements = self.get_measurements()
            draw_rectangle(x - OUTLINE_MARGIN, y - OUTLINE_MARGIN, x + _measurements[0] + OUTLINE_MARGIN, y + _measurements[1] + OUTLINE_MARGIN, true)
        }
        draw_text_transformed(x, y, text, 1, 1, 0)
        draw_set_colour(c_white)
        if current_screen_group.disabled_group
            return
        // if we have successfully pressed on the thing, or interacted with it...
        // do stuff!
        if (tte_check_if_key_pressed(
            global.KEYBOARD_CONFIGURATION.player.jump
        ) or tte_get_gamepad_pressed (
            global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
            global.GAMEPAD_SYSTEM.gamepad_configurations.player.jump
        )) and 
        is_selected and 
        is_allowed and
         not global.FREEZE_GUI_CONTROLS {
            function_to_trigger(current_screen_group, self)
        }
    }
    get_measurements = function (){
        return [
            string_width(text),
            string_height(text)
        ]
    }
}

function tte_checkbox(_x, _y, _text, _is_enabled, _screen_group, _tab_index_for_object, _function_to_trigger, _is_allowed = true) : tte_selectable_button_text(_x, _y, _text, _screen_group, _tab_index_for_object, _function_to_trigger, _is_allowed) constructor  {
    stored_text = _text
    is_enabled = _is_enabled
    render_this_object = function () {
        // set the text to the current checkbox thing
        self.text = string("[{0}] {1}", is_enabled CHECKBOX_IF_ELSE, stored_text)
        is_selected = (self.current_screen_group[$ "tab_index"] == tab_index_for_object)
        draw_set_colour(is_enabled ? c_yellow : (is_allowed ? color : c_red))
        if is_selected {
            var _measurements = self.get_measurements()
            draw_rectangle(x - OUTLINE_MARGIN, y - OUTLINE_MARGIN, x + _measurements[0] + OUTLINE_MARGIN, y + _measurements[1] + OUTLINE_MARGIN, true)
        }
        draw_text_transformed(x, y, self.text, 1, 1, 0)
        draw_set_colour(c_white)
        if current_screen_group.disabled_group
            return
        // if we have successfully pressed on the thing, or interacted with it...
        // do stuff!
        if (tte_check_if_key_pressed(
            global.KEYBOARD_CONFIGURATION.player.jump
        ) or tte_get_gamepad_pressed (
            global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
            global.GAMEPAD_SYSTEM.gamepad_configurations.player.jump
        )) 
        and is_selected 
        and is_allowed and
         not global.FREEZE_GUI_CONTROLS {
            is_enabled = not is_enabled
            function_to_trigger(current_screen_group, self)
        }
    }
}


