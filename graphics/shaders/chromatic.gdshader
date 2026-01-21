shader_type canvas_item;

uniform float strength = 1.;
instance uniform float offset = 0;

void fragment() {
	if (abs(strength - 0.) > 0.0001){
	float h_offset = FRAGCOORD.x - 640.;
	float v_offset = FRAGCOORD.y - 360.;
	float strength_s = .006*strength;
	float strength_t = .003*strength;
	float time_speed = 10.;

	vec2 offset_from_position = vec2(h_offset*TEXTURE_PIXEL_SIZE.x*strength_s,v_offset*TEXTURE_PIXEL_SIZE.y*strength_s);
	vec2 offset_from_time = vec2(sin(TIME*time_speed*E/2.+offset)*strength_t,cos(TIME*time_speed*PI/3.+offset)*strength_t);
	vec4 image1 = texture(TEXTURE, UV+offset_from_position+offset_from_time);
	vec4 image2 = texture(TEXTURE, UV);
	vec4 image3 = texture(TEXTURE, UV-offset_from_position-offset_from_time);
	if (abs(image1.a - 0.) < 0.0001){
		image1.r = 0.;
	}
	if (abs(image2.a - 0.) < 0.0001){
		image2.g = 0.;
	}
	if (abs(image3.a - 0.) < 0.0001){
		image3.b = 0.;
	}
	float transparency = image1.a+image2.a+image3.a;
	COLOR = vec4(image1.r,image2.g,image3.b,transparency*0.3);
	}
}
