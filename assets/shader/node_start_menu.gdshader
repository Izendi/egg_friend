shader_type canvas_item;

// set the left 0.0 to 10 to start scrolling
uniform vec2 pixels_per_second = vec2(10, 10.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment()
{
	// Convert pixels/sec to UV/sec using the actual texture size
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 uv_scroll = (pixels_per_second / tex_size) * TIME;

    vec2 uv = UV + uv_scroll;
    COLOR = texture(TEXTURE, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
