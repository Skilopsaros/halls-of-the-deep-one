shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixelation_size = 2;

void fragment() {

	//1280 x 720 is viewport size
	vec2 uv_pixelsize = vec2(1./1280.*pixelation_size,1./720.*pixelation_size);
	vec2 multiplier = vec2(round(SCREEN_UV.x/uv_pixelsize.x)-.5,round(SCREEN_UV.y/uv_pixelsize.y)-.5);
	vec4 grabbed_color = texture(screen_texture,vec2(multiplier.x*uv_pixelsize.x,multiplier.y*uv_pixelsize.y));
//
	COLOR = grabbed_color;

}
