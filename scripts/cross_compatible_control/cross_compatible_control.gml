enum control_methods {
    not_available, 
    keyboard,
    gamepad,
}

global.IS_COMPUTER = (os_type == os_windows or os_type == os_linux)