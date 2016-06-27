//
// pseudo_ntsc_shader_test.pde
//
// github:
//     https://github.com/yoggy/pseudo_ntsc_shader_test.git
//
// license:
//     Copyright (c) 2016 yoggy <yoggy0@gmail.com>
//     Released under the MIT license
//     http://opensource.org/licenses/mit-license.php;
//
PShader shader;
PImage img;

boolean shader_enable = true;

void setup() {
  size(640, 425, P2D);
  shader = loadShader("pseudo_ntsc_frag.glsl"); 
  shader.set("resolution", (float)width, (float)height);
  img = loadImage("test_img.jpg");
}

void draw() {
  image(img, 0, 0);
  
  if (shader_enable) {
    filter(shader);
  }
}

void keyPressed() {
  if (key == ' ') {
    shader_enable = !shader_enable;
  }
}