shader_type canvas_item;

uniform vec4 danger_color : source_color = vec4(1.0, 0.1, 0.1, 1.0);
uniform float danger_intensity : hint_range(0.0, 2.0) = 0.6;
uniform float pulse_speed : hint_range(0.5, 5.0) = 3.0;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	float pulse = (sin(TIME * pulse_speed) + 1.0) * 0.5;
	float danger = pulse * danger_intensity;
	vec3 tinted = mix(original.rgb, danger_color.rgb, danger * 0.5);
	tinted += danger_color.rgb * danger * 0.3 * original.a;
	COLOR = vec4(tinted, original.a);
}
