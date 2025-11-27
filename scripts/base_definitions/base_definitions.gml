global.BASE_GRAVITY_EFFECT = 10

///@description the collision system's types....
enum current_collision_types {
    NoCol,
	Right,
    Left,
    Top,
    Bottom
}

global.COLLISION_MARGIN = 3
#macro COLLISION_SPACE 8.0 
#macro ACCEPTABLE_COLLISIONS [solid_object, gravity_based_object]
#macro BASE_TILE_SIZE 32 
#macro BASE_GAME_WIDTH 800
#macro BASE_GAME_HEIGHT 600  
#macro CURRENT_CAMERA camera_get_default()

/// @description this loads a file, with all the lines.
/// @param {String} file_name the filename.
function tte_load_file_all_lines(file_name){
    var _file = file_text_open_read(file_name)
    var _fileStr = "";
    while (not file_text_eoln(_file)) {
    	_fileStr += file_text_readln(_file)
    }
    file_text_close(_file)
    return _fileStr
}
/// @desc this creates an advanced context for screen switching.
/// @param {function} _function the function that contains the gui_handler as the first object as a parameter.
function tte_advanced_screen_switcher(_function){
    with (gui_handler)
    {
        _function(gui_handler)
    }
}
/// @description these are the temporary variable keepers.
global.TEMP_KEEPERS = {
    a1 : undefined,
    a2 : undefined,
    a3 : undefined,
    a4 : undefined,
    a5 : undefined
}

global.VIRTUAL_MOUSE_CURSOR = [0, 0]
global.CURRENT_PLAYER = undefined
global.CURRENT_CAMERA_ID = 0
