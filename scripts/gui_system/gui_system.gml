enum tte_gui_alignment {
	horizontal,
    vertical
}
global.CURRENT_SCREEN = ""
global.FREEZE_GUI_CONTROLS = false
#macro BASE_SPRITE no_texture
#macro MAIN_FONT "determination-mono.ttf"  
/// @desc special coordinate system for simplifying processes.
/// @param {any*} _x x-coordinate, can also be a width.
/// @param {any*} _y y-coordinate, can also be a height.
function tte_coordinate_system(_x, _y) constructor {
    x = _x
    y = _y
}
// all of the fonts defined...
global.CURRENT_FONTS = {
    normal: font_add(MAIN_FONT, 15, false, false, 32, 128),
    bold: font_add(MAIN_FONT, 15, true, false, 32, 128),
    italic: font_add(MAIN_FONT, 15, false, true, 32, 128),
    normal_xl: font_add(MAIN_FONT, 30, false, false, 32, 128),
    bold_xl: font_add(MAIN_FONT, 30, true, false, 32, 128),
    italic_xl: font_add(MAIN_FONT, 30, false, true, 32, 128),
}
/// @desc seperate initializer.
function tte_initialize_font_system(){
    // all of the fonts defined...
    global.CURRENT_FONTS = {
        normal: font_add(MAIN_FONT, 15, false, false, 32, 128),
        bold: font_add(MAIN_FONT, 15, true, false, 32, 128),
        italic: font_add(MAIN_FONT, 15, false, true, 32, 128),
        normal_xl: font_add(MAIN_FONT, 30, false, false, 32, 128),
        bold_xl: font_add(MAIN_FONT, 30, true, false, 32, 128),
        italic_xl: font_add(MAIN_FONT, 30, false, true, 32, 128),
    }
}
/// @desc this creates a new screen_group.
/// @param {real} [alignment]=tte_gui_alignment.vertical the alignment.
/// @returns {Struct.tte_screen_group} the screen group itself
function tte_create_and_insert(alignment = tte_gui_alignment.vertical){
    var _newScreenGroup = new tte_screen_group(alignment)
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
    opacity = 0
    disabled_group = false
    max_group_val = 0
    m_gui_alignment = _gui_alignment
    
    render_this_group = function (){
        if not (disabled_group or global.FREEZE_GUI_CONTROLS) {
            var _b = self.m_gui_alignment == tte_gui_alignment.vertical
            if global.CURRENT_CONTROL_METHOD == control_methods.keyboard { 
                self.tab_index += tte_do_axis(
                        "player",
                        _b ? "down" : "left",
                        _b ? "up" : "right",
                        true
                    )
                } else { 
                    self.tab_index += tte_gamepad_axis(
                        global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
                        _b ? 
                        global.GAMEPAD_SYSTEM.gamepad_configurations.player.down_look : 
                        global.GAMEPAD_SYSTEM.gamepad_configurations.player.left,
                        _b ? 
                        global.GAMEPAD_SYSTEM.gamepad_configurations.player.up_look :
                        global.GAMEPAD_SYSTEM.gamepad_configurations.player.right,
                        true
                )
            }
        }
        self.tab_index = clamp(self.tab_index, 0, max_group_val)
        
        draw_set_alpha(opacity)
        var _g = 1 + (1 - opacity)
        // cool matrice stuff
        matrix_set(matrix_world, matrix_build( 0, 0, 0, 0, 0, 0, 1, _g, 1 ) )
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
    /// @return {Struct.tte_coordinate_system} returnee.
    get_measurements = function (){
        return new tte_coordinate_system(sprite_get_width(BASE_SPRITE), sprite_get_height(BASE_SPRITE))
    }
}
/// @desc Function Description
/// @param {any*} _x Description
/// @param {any*} _y Description
/// @param {any*} _screen_group Description
/// @param {any*} _sprite Description
function tte_gui_image(_x, _y, _screen_group, _sprite): tte_gui_object(_x, _y, _screen_group) constructor  {
    sprite = _sprite
    
    render_this_object = function() {
        draw_sprite(sprite, 0, x, y)
    }
    /// @description get measurements
    /// @return {Struct.tte_coordinate_system} measurement
    get_measurements = function (){
        return new tte_coordinate_system(sprite_get_width(sprite), sprite_get_height(sprite))
    }
}
/// @desc Function Description
/// @param {any*} _x Description
/// @param {any*} _y Description
/// @param {any*} _text Description
/// @param {any*} _screen_group Description
/// @param {any*} _color Description
/// @param {real} [_font_size]=16 Description
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
    /// @return {Struct.tte_coordinate_system} measurement
    get_measurements = function (){
        var _beforeFont = draw_get_font()
        draw_set_font(font_to_use)
        var _val = new tte_coordinate_system(string_width(text), string_height(text))
        draw_set_font(_beforeFont)
        return _val
    }
}
/// @desc this is the base selectable struct 
/// @param {any*} _x x-coordinate.
/// @param {any*} _y y-coordinate.
/// @param {any*} _screen_group the screen group it is registered to.
/// @param {any*} _tab_index_for_object the up and down, tab index for the object.
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
/// @desc this creates a selectable and editable, textbox object.
/// @param {any*} _x x-coordinate.
/// @param {any*} _y y-coordinate.
/// @param {any*} _screen_group the screen group it is registered to.
/// @param {any*} _tab_index_for_object the tab, up and down index for the object.
/// @param {Struct.tte_coordinate_system} _max_size this is the sizing array.
/// @param {Function} _function_to_trigger function to trigger when the text is submitted. (self, screen_group)
/// @param {string} [_placeholder] the placeholder that the object can take.
function tte_gui_selectable_and_editable(_x, _y, _screen_group, _tab_index_for_object, _max_size, _function_to_trigger, _placeholder = "placeholder") : tte_selectable_object(_x, _y, _screen_group, _tab_index_for_object) constructor  {
    max_size = _max_size
    MAXIMUM_SIZE_TEXT = max_size.x / 9
    function_to_trigger = _function_to_trigger
    show_debug_message(MAXIMUM_SIZE_TEXT)
    placeholder = _placeholder
    input_text = ""
    is_currently_being_edited = false
    show_red_seconds = 0.0
    _base_padding = 16
    
    render_rectangle = function (is_outline = false){
        draw_rectangle(
            self.x - self._base_padding, 
            self.y - self._base_padding, 
            self.x + self.max_size.x + self._base_padding, 
            self.y + self.max_size.y + (OUTLINE_MARGIN * 2) + self._base_padding, 
            is_outline
        )
    }
    
    /// @description return general measurements.
    /// @return {Struct.tte_coordinate_system} name description
    get_measurements = function (){
        return new tte_coordinate_system(self.max_size.x + self._base_padding, string_height(keyboard_string) + self.max_size.y + self._base_padding + OUTLINE_MARGIN * 2)
    }
    function get_if_active(){
        with (virtual_keyboard) {
            if global.CURRENT_CONTROL_METHOD == control_methods.gamepad {
                return self._isActive
            }
        }
        return false
    }
    /// @description do init of the input system of the textbox
    /// @param {Bool} _val the value to init to
    function initializer_pls(_val){
        global.FREEZE_GUI_CONTROLS = _val
        is_currently_being_edited = _val
        with (virtual_keyboard) {
            if global.CURRENT_CONTROL_METHOD == control_methods.gamepad {
                self._isActive = _val
                self._cooldown = 1
            }
        }
        if not _val
            self.function_to_trigger(self, self.current_screen_group)
    }
    
    render_this_object = function (){
        is_selected = (self.current_screen_group[$ "tab_index"] == tab_index_for_object)
        var _isKeyboardPressed = (global.CURRENT_CONTROL_METHOD == control_methods.gamepad ? tte_get_gamepad_pressed(
            global.GAMEPAD_SYSTEM.gamepad_configurations.currently_using,
            global.GAMEPAD_SYSTEM.gamepad_configurations.player.jump
        ) and !get_if_active() : keyboard_check_pressed(vk_enter)) 
        if is_selected and not is_currently_being_edited and _isKeyboardPressed {
            self.initializer_pls(true)
            keyboard_string = input_text
        }
        else if is_currently_being_edited and global.FREEZE_GUI_CONTROLS and (global.CURRENT_CONTROL_METHOD == control_methods.gamepad and !get_if_active()) or _isKeyboardPressed {
            self.initializer_pls(false)
        } 
        if is_currently_being_edited {
            self.input_text = string_copy(keyboard_string, 0, 100)
            keyboard_string = self.input_text
            if keyboard_check(vk_anykey) and string_length(keyboard_string) >= 100
                show_red_seconds = 255.0
        }
        // draw what the user is currently editing, also activate the virtual keyboard if possible 
        draw_set_colour(c_black)
        render_rectangle(false) 
        show_red_seconds = max(0, show_red_seconds - get_current_deltatime() * 200)
        draw_set_colour(self.is_selected ? make_colour_rgb(255.0, 255.0 - show_red_seconds, 0.0) : c_white)
        render_rectangle(true)
        var _maxSizeKeyb = string_length(self.input_text)
        var _currentStr = string_copy(self.input_text, _maxSizeKeyb - MAXIMUM_SIZE_TEXT, MAXIMUM_SIZE_TEXT + 1)
        // allow editing when it's currently being edited.
        if string_length(_currentStr) == 0 {
            draw_set_alpha(0.5)
            draw_text(self.x, self.y, self.placeholder)
            draw_set_alpha(1.0)
        }
        draw_text(self.x, self.y, _currentStr)
        // draw the selection thing
        draw_set_colour(c_white)
        var _leftPos = self.x + string_width(_currentStr)
        if floor(current_time / 100) % 6 < 3 and self.is_currently_being_edited {    
            draw_rectangle(_leftPos, self.y, _leftPos + 2, self.y + 16 + OUTLINE_MARGIN * 2, false)
        }

        if not is_currently_being_edited and is_selected {
            draw_set_alpha(0.5)
            draw_text(
                x + self.get_measurements().x,
                y,
                tte_get_localization(
                global.CURRENT_LANGUAGE,
                "keyboard_instruction"
            ))
            draw_set_alpha(1.0)
        }
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
            draw_rectangle(x - OUTLINE_MARGIN, y - OUTLINE_MARGIN, x + _measurements.x + OUTLINE_MARGIN, y + _measurements.y + OUTLINE_MARGIN, true)
        }
        draw_set_font(global.CURRENT_FONTS.normal)
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
        return new tte_coordinate_system(string_width(text), string_height(text))
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
            draw_rectangle(x - OUTLINE_MARGIN, y - OUTLINE_MARGIN, x + _measurements.x + OUTLINE_MARGIN, y + _measurements.y + OUTLINE_MARGIN, true)
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
            function_to_trigger(current_screen_group, self)
        }
    }
}




