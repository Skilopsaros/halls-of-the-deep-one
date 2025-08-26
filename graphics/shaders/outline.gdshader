shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.,1.,1.,1.);
instance uniform bool do_outline = false;

void fragment() {
	if (do_outline){
	float pixelation_size = 1.;
	vec2 uv_pixelsize = vec2(TEXTURE_PIXEL_SIZE.x*pixelation_size,TEXTURE_PIXEL_SIZE.y*pixelation_size);

	vec4 image = texture(TEXTURE, UV);
	if (image.a != 0.){
		COLOR = image;
	}else{
		vec4 image_0 = texture(TEXTURE, UV+vec2(0,uv_pixelsize[1]));
		vec4 image_1 = texture(TEXTURE, UV+vec2(0,-uv_pixelsize[1]));
		vec4 image_2 = texture(TEXTURE, UV+vec2(uv_pixelsize[0],0));
		vec4 image_3 = texture(TEXTURE, UV+vec2(-uv_pixelsize[0],0));
		vec4 image_4 = texture(TEXTURE, UV+vec2(uv_pixelsize[0],uv_pixelsize[1]));
		vec4 image_5 = texture(TEXTURE, UV+vec2(uv_pixelsize[0],-uv_pixelsize[1]));
		vec4 image_6 = texture(TEXTURE, UV+vec2(-uv_pixelsize[0],uv_pixelsize[1]));
		vec4 image_7 = texture(TEXTURE, UV+vec2(-uv_pixelsize[0],-uv_pixelsize[1]));
		if ((image_0+image_1+image_2+image_3+image_4+image_5+image_6+image_7).a != 0.){
			COLOR = outline_color;
		}else{
			COLOR = vec4(0,0,0,0);
		}
	}
	}else{
		COLOR = texture(TEXTURE, UV);
	}
}
