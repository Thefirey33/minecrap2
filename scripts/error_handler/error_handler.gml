#macro GAME_NAME "minecrap2" 
/// @description Handle an error, then end the game.
/// @param {String} error_msg The Error - MSG.
function handle_error(error_msg) {
    show_message(string("WHOOPS! Minecrap 2 has thrown a fatal error!\nHere's the error: {0}", error_msg));
    game_end(1);
}