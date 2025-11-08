// start drawing please.
var _first = array_first(_currentGroups)
_first[$ "render_this_group"]()


if array_length(_currentGroups) > 0 {
    for (var i = 1; i < array_length(_currentGroups); i++) {
    	var _val = _currentGroups[i]
        _val.opacity -= get_current_deltatime()
        _val[$ "render_this_group"]() 
        if _val.opacity < 0 {
            array_delete(_currentGroups, i, 1) 
            delete _val
        }
    }
}