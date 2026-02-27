shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.84, 0.0, 1.0);
uniform float glow_intensity : hint_range(0.0, 2.0) = 0.8;
uniform float pulse_speed : hint_range(0.5, 5.0) = 2.0;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	float pulse = (sin(TIME * pulse_speed) + 1.0) * 0.5;
	float glow = pulse * glow_intensity;
	vec3 glowed = original.rgb + glow_color.rgb * glow * original.a;
	COLOR = vec4(glowed, original.a);
}
