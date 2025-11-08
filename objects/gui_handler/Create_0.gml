_currentGroups = []
function switch_screens(){
    switch (global.CURRENT_SCREEN) {
	   case "starting_screen":
            var _starting_screen = new tte_screen_group(tte_gui_alignment.vertical)
            // create the first initial instruction screen.
            sc_instruction_screen(_starting_screen, self)
            array_insert(_currentGroups, 0, _starting_screen)
            break;
        case "titlescreen":
            var _title_screen = new tte_screen_group(tte_gui_alignment.horizontal)
            // create the first initial instruction screen.
            array_insert(_currentGroups, 0, _title_screen)
            break;
    }
}
switch_screens()