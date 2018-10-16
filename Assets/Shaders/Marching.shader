shader_type canvas_item;

uniform sampler2D primary_tex;
uniform sampler2D secondary_tex;

void fragment() {
	float t = texture(TEXTURE, UV).r; // Assuming grayscale
	COLOR = texture(primary_tex, UV) * (1.0 - t) + texture(secondary_tex, UV) * t;

}