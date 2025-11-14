#macro localization_location "localization.json" 
global.LOCAL_KEYS = {}
global.CURRENT_LANGUAGE = "en"

function tte_import_localization_from_json(){
    var _importedLocalizationFile = tte_load_file_all_lines(localization_location)
    global.LOCAL_KEYS = json_parse(_importedLocalizationFile)
    show_debug_message("{0}/INFO: loaded localization...", GAME_NAME)
}

function tte_get_localization(lang, key) {
    var _currentLanguageField = struct_get(global.LOCAL_KEYS, lang)
    if _currentLanguageField == undefined
        handle_error("language doesn't exist.")
    return struct_get(_currentLanguageField, key)
}

tte_import_localization_from_json();