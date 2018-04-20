// https://raw.githubusercontent.com/inaes-tic/tv-moldeo/master/data/samples/Shader%20Example/shaders/Sharpen.glsl

#define KERNEL_SIZE 9

// Sharpen kernel
// -1 -1 -1
// -1 +9 -1
// -1 -1 -1
float kernel[KERNEL_SIZE];

uniform sampler2D texture;
uniform vec3 iResolution; 
uniform float iGlobalTime;
uniform vec4 iMouse;

//uniform vec2 tempo_angle;

vec2 offset[KERNEL_SIZE];

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    int i = 0;
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    vec4 sum = vec4(0.0);
    vec2 src_tex_offset = vec2(0.0002, 0.0002);

    offset[0] = vec2(-src_tex_offset.s, -src_tex_offset.t);
    offset[1] = vec2(0.0, -src_tex_offset.t);
    offset[2] = vec2(src_tex_offset.s, -src_tex_offset.t);

    offset[3] = vec2(-src_tex_offset.s, 0.0);
    offset[4] = vec2(0.0, 0.0);
    offset[5] = vec2(src_tex_offset.s, 0.0);

    offset[6] = vec2(-src_tex_offset.s, src_tex_offset.t);
    offset[7] = vec2(0.0, src_tex_offset.t);
    offset[8] = vec2(src_tex_offset.s, src_tex_offset.t);

    kernel[0] = -1.0;   kernel[1] = -1.0;   kernel[2] = -1.0;
    kernel[3] = -1.0;   kernel[4] = +9.0;   kernel[5] = -1.0;
    kernel[6] = -1.0;   kernel[7] = -1.0;   kernel[8] = -1.0;

    for (i = 0; i < KERNEL_SIZE; i++) {
        vec4 tmp = texture2D(texture, uv + offset[i]);
        sum += tmp * kernel[i];
    }

    fragColor = vec4(sum.rgb, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}