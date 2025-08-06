shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = vec4(0.4, 0.6, 0.9, 1.0);
	float h_offset = FRAGCOORD.x - 640.;
	float v_offset = FRAGCOORD.y - 460.;
	float strength_s = .04;
	float strength_t = .01;
	float time_speed = 10.;

	vec2 offset_from_position = vec2(h_offset*TEXTURE_PIXEL_SIZE.x*strength_s,v_offset*TEXTURE_PIXEL_SIZE.y*strength_s);
	vec2 offset_from_time = vec2(sin(TIME*time_speed*E/2.)*strength_t,cos(TIME*time_speed*PI/3.)*strength_t);
	vec4 image1 = texture(TEXTURE, UV+offset_from_position+offset_from_time);
	vec4 image2 = texture(TEXTURE, UV);
	vec4 image3 = texture(TEXTURE, UV-offset_from_position-offset_from_time);
	float transparency = image1.a*0.3333+image2.a*0.3333+image3.a*0.3333;
	COLOR = vec4(image1.r,image2.g,image3.b,transparency);
}
