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

global.VIRTUAL_MOUSE_CURSOR = [0, 0]
global.CURRENT_PLAYER = undefined