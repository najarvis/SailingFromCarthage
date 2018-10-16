shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR.rgb == vec3(1.0, 0.0, 1.0)) {
		COLOR.a = 0.0;
	}
}