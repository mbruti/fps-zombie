attribute vec3 position;
attribute vec2 uv;
varying vec2 uvVarying;
uniform mat4 agk_World;
uniform mat4 agk_ViewProj;
uniform vec4 uvBounds0;
uniform vec2 repetitions;
 
void main()
{ 
    vec4 pos = agk_World * vec4(position,1.0);
    gl_Position = agk_ViewProj * pos;   
    uvVarying =  uv*uvBounds0.xy * vec2(repetitions.x,repetitions.x) + uvBounds0.zw * vec2(repetitions.y,repetitions.y);
}
