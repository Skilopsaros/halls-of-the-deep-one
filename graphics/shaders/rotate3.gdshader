shader_type canvas_item;

void fragment() {
	vec2 uv = vec2(1.0-UV[1],UV[0]);
	COLOR = texture(TEXTURE,uv);
}
