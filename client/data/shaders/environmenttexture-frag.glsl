#version 120

uniform sampler2D specularmap;
uniform sampler2D diffusemap;
uniform sampler2D texturemap;

// input
varying vec3 eye;
varying vec2 uv;
varying vec3 nrm;

vec4 textureSphere(sampler2D map, vec3 dir)
{
   vec3 t= dir + vec3(0.0, 0.0, 1.0);
   float m= 0.5 / sqrt(dot(t,t));
   t= vec3(0.5, 0.5, 0.5) + vec3(t.x, -t.y, t.z)*m;
   return texture2D(map, t.xy);
}

void main()
{
   // reflection vector
   vec3 n= normalize( nrm );
   vec3 e= normalize( eye );
   vec3 refl= e - n * 2.0 * dot(n, e);

   vec4 spec= textureSphere(specularmap, refl);
   vec4 diff= textureSphere(diffusemap, n);
   vec4 tex= texture2D(texturemap, uv);

   vec4 final= (diff * tex) + (spec * tex.a);
   gl_FragColor = vec4(final.rgb, 1.0);
}
