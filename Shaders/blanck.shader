shader_type canvas_item;

uniform vec4 colour : hint_color;

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV);
	COLOR.rgb = colour.rgb;
}