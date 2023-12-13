shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float scale;
uniform sampler2D texture_albedo:source_color;
uniform vec2 time_scale;

void fragment(){
	float v = (texture(texture_albedo,SCREEN_UV+vec2(TIME,TIME)*time_scale).r - 0.5) * scale;
	vec2 uv = SCREEN_UV + vec2(v,v);
	COLOR = texture(SCREEN_TEXTURE,uv) * COLOR;
}	