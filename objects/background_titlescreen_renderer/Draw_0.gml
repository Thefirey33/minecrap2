if (_currentTime % 200 <= 2) {
	array_insert(_zoomedInRendering, 0, 0)
}
draw_set_alpha(0.3)
array_foreach(_zoomedInRendering, function (_val, _indx){
    if _indx > 0 and _indx < array_length(_zoomedInRendering)
    {
        var _beforeCalc = abs((_val - 400) / 400)
        var _opacityCalculation = clamp(_beforeCalc, 0, 1)
        draw_sprite_stretched_ext(
            imgdepth, 
            0, 
            x - _val, 
            y - _val, 
            view_get_wport(view_current) + _val * 2, 
            view_get_hport(view_current) + _val * 2, 
            c_white, 
            (0.5 - _opacityCalculation) / 2
        )
        _zoomedInRendering[_indx] += get_current_deltatime() * 40
        if _val > 2000 and _indx < array_length(_zoomedInRendering) - 1 {
        
            array_pop(_zoomedInRendering)
        }
    }
})
_currentTime += get_current_deltatime() * 100
draw_set_alpha(1.0)