
shader_type canvas_item;
void fragment(){
	
	float r,g,b,a;
	if ((UV.y  < 0.05*(1.0+sin(1.0*TIME-UV.x*30.0)*cos(1.0*TIME)))){
		r = 0.50;
		g = 0.5;
		b = 1.0;
		a = 0.0;
	}
	
	else {
		r = 0.0;
		g = 0.5;
		b = 1.0;
		a = 0.6;
	}
	COLOR = vec4(r,g,b,a);
}
