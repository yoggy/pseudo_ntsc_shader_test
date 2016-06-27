//
// pseudo_ntsc_frag.glsl
//
// github:
//     https://github.com/yoggy/pseudo_ntsc_shader_test.git
//
// license:
//     Copyright (c) 2016 yoggy <yoggy0@gmail.com>
//     Released under the MIT license
//     http://opensource.org/licenses/mit-license.php;
//

uniform sampler2D texture;
uniform vec2 resolution;

vec4 rgb2yuv(vec4 c) {
	float y =  0.299   * c.r + 0.587   * c.g + 0.114   * c.b; // 0～1.0
	float u = -0.14713 * c.r - 0.28886 * c.g + 0.436   * c.b; // -0.5～0.5
	float v =  0.615   * c.r - 0.51499 * c.g - 0.10001 * c.b; // -0.5～0.5
	return vec4(y, u, v, 1);
}

vec4 yuv2rgb(float y, float u, float v) {
	float r = y + 1.13983 * v;
	float g = y - 0.39465 * u - 0.58060 * v;
	float b = y + 2.03211 * u;
	return vec4(r, g, b, 1);
}

void main() {
	vec4 total_yuv;
	int w = 1;

	// 平均をとってぼかす
	for (int dy = -w; dy <= w; ++dy) {
		for (int dx = -w; dx <= w; ++dx) {
			vec2 p = (gl_FragCoord.xy + vec2(dx, dy)) / resolution.xy;
			vec4 c = texture2D(texture, p);
			total_yuv += rgb2yuv(c);
		} 
	} 

	vec4 avg_yuv = total_yuv / total_yuv.w; // total_yuv.wに合計回数が入っている

	float y = avg_yuv.x;
	float u = avg_yuv.y;
	float v = avg_yuv.z;

	// 色を薄める
	u *= 0.4;
	v *= 0.4;

	// スキャンライン風の横筋を入れる
	y *= 0.8 + 0.5 * sin( (int(gl_FragCoord.y) % 3) / 3.0 * 3.14159 );

	// YUV -> RGB
	gl_FragColor = yuv2rgb(y, u, v);
}