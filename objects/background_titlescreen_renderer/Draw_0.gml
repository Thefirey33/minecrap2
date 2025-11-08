if (current_time % 20 < 1) {
	array_insert(_zoomedInRendering, 0, 0)
}
array_foreach(_zoomedInRendering, function (_val, _indx){
    var _opacityCalculation = _val / 500
    draw_sprite_stretched_ext(imgdepth, 0, x - _val, y - _val, view_get_wport(view_current) + _val * 2, view_get_hport(view_current) + _val * 2, c_green, 0.5 - _opacityCalculation)
    _zoomedInRendering[_indx] += get_current_deltatime() * 50 
    if _opacityCalculation < 0 {
        array_delete(_zoomedInRendering, _indx, 1)
    }
    })