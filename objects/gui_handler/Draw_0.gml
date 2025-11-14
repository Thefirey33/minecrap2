// start drawing please.
var _first = array_first(global._currentGroups)
_first[$ "render_this_group"]()

if array_length(global._currentGroups) > 0 {
    for (var i = 1; i < array_length(global._currentGroups); i++) {
    	var _val = global._currentGroups[i]
        _val.opacity -= get_current_deltatime() 
        if _val.max_group_val <= _first.max_group_val and not _val.disabled_group {
            _first.tab_index = _val.tab_index
        }
        _val.disabled_group = true
        _val[$ "render_this_group"]() 
        if _val.opacity < 0 {
            array_delete(global._currentGroups, i, 1) 
            delete _val
        }
    }
}