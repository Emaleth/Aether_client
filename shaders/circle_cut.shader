shader_type canvas_item;

void fragment() 
{
	if (distance(UV, vec2(0.5, 0.5)) > 0.5) 
	{
		COLOR = vec4(0.0);
	}
	else 
	{
		COLOR = texture(TEXTURE, UV);
	}
}