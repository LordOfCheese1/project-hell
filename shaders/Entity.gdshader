shader_type canvas_item;
uniform vec3 color: source_color = vec3(1.0);
uniform float fac: hint_range(0, 1) = 0;
void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	tex.rgb = mix(tex.rgb, color, fac);
	COLOR = tex;
}
