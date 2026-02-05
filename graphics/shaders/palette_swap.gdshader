shader_type canvas_item;

uniform sampler2D input_palette : filter_nearest;
uniform sampler2D output_palette : filter_nearest;

uniform int palette_width;
uniform int palette_height;

uniform vec4 error_color : source_color;

void fragment() {
	vec4 local_color = texture(TEXTURE, UV);
	bool done = false;
	if (local_color.a == 0.){
		done = true;
		COLOR = vec4(0,0,0,0);
	}
	for (int i = 0; i < palette_height; i++){
		for (int j = 0; j < palette_height; j++){
			vec2 texture_coordinate = vec2(float(i)/float(palette_height),float(j)/float(palette_width));
			vec4 palette_color = texture(input_palette,texture_coordinate);
			if (palette_color == local_color){
				COLOR = texture(output_palette,texture_coordinate);
				done = true;
				break;
			}
		}
		if (done) {
			break;
		}
	}
	if (!done) {
		COLOR = error_color;
	}
}

