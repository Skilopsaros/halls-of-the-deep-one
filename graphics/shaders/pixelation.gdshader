shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	// Called for every pixel the material is visible on.
	float pixelation_size = 2.;

//1280 x 720
	vec2 uv_pixelsize = vec2(1./1280.*pixelation_size,1./720.*pixelation_size);
	vec2 multiplier = vec2(round(SCREEN_UV.x/uv_pixelsize.x)-.5,round(SCREEN_UV.y/uv_pixelsize.y)-.5);
	vec4 grabbed_color = texture(screen_texture,vec2(multiplier.x*uv_pixelsize.x,multiplier.y*uv_pixelsize.y));
//
	COLOR = grabbed_color;
	//COLOR = textureLod(screen_texture,vec2(SCREEN_UV.x,SCREEN_UV.y),0);

}
