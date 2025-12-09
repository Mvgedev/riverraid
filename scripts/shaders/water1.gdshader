shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 10.0) = 3.5;
uniform float wave_strength : hint_range(0.0, 10.0) = 5.0;
uniform float wave_frequency : hint_range(0.0, 20.0) = 20.0;

void fragment() {
    // UV haute précision = évite les artefacts en Compatibility
    highp vec2 uv = UV;

    // Déformation sinus simple (pas de scrolling, pas de repeat)
    uv.x += sin(uv.y * wave_frequency + TIME * wave_speed) * (wave_strength / 100.0);

    COLOR = texture(TEXTURE, uv);
}