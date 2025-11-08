#macro GAME_NAME "minecrap2" 
/// @description Handle an error, then end the game.
/// @param {String} error_msg The Error - MSG.
function handle_error(error_msg) {
    show_error(string("FATAL!!!\n{0}", error_msg), true)
    game_end(1);
}