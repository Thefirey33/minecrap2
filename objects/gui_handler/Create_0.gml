
global.CURRENT_SCREEN = "titlescreen"
global._currentGroups = []
currentMatrix = matrix_build_identity()

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