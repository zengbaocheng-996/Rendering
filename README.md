# Rendering

| Index | Content                    | Detail                                                       |
| ----- | -------------------------- | ------------------------------------------------------------ |
| 01    | Matrices                   | Create a cube grid<br />Support scaling, positioning, and rotating<br />Work with transformation matrices<br />Create simple camera projections |
| 02    | Shader Fundamentals        | Transform vertices<br />Color pixels<br />Use shader properties<br />Pass data from vertices to fragments<br />Inspect compiled shader code<br />Sample a texture, with tiling and offset |
| 03    | Combining Textures         | Sample multiple textures<br />Apply a detail texture<br />Deal with colors in linear space<br />Use a splat map |
| 04    | The First Light            | Transform normals from object to world space<br />Work with a directional light<br />Compute diffuse and specular reflections<br />Enforce energy conservation<br />Use a metallic workflow<br />Take advantage of Unity's PBS algorithms |
| 05    | Multiple Lights            | Render multiple lights per object<br />Support different light types<br />Use light cookies<br />Compute vertex lights<br />Include spherical harmonics |
| 06    | Bumpiness                  | Perturb normals to simulate bumps<br />Compute normals from a height field<br />Sample and blend normal maps<br />Convert from tangent space to world space |
| 07    | Shadows                    | Investigate how Unity renders shadows<br />Cast directional shadows<br />Receive directional shadows<br />Add support for spotlight and point light shadows |
| 08    | Reflections                | Sample the environment<br />Use reflection probes<br />Create rough and smooth mirrors<br />Perform box projection cube map sampling<br />Blend between reflection probes |
| 09    | Complex Materials          | Create a custom shader GUI<br />Mix metals and nonmetals<br />Use nonuniform smoothness<br />Support emissive surfaces |
| 10    | More Complexity            | Bake self-shadowing into a material<br />Add details to part of a surface<br />Support more efficient shader variants<br />Edit multiple materials at once |
| 11    | Transparency               | Cut holes with a shader<br />Use a different render queue<br />Support semitransparent materials<br />Combine reflections and transparency |
| 12    | Semitransparent Shadows    | Support cutout shadows<br />Use dithering<br />Approximate semitransparent shadow<br />Toggle between semitransparent and cutout shadows |
| 13    | Deferred Shading           | Explore deferred shading<br />Fill Geometry Buffers<br />Support both HDR and LDR<br />Work with Deferred Reflections |
| 14    | Fog                        | Apply fog to objects<br />Base fog on either distance or depth<br />Create an image effect<br />Support deferred fog |
| 15    | Deffered Lights            | Use a custom light shader<br />Decode LDR colors<br />Add lighting in a separate pass<br />Support directional, spotlight, and point lights<br />Manually sample shadow maps |
| 16    | Static Lighting            | Sample from and render to lightmaps<br />Make baked light work with normal maps<br />Use a light probe group |
| 17    | Mixed Lighting             | Bake only indirect light<br />Mix baked and realtime shadows<br />Deal with code changes and bugs<br />Support subtractive lighting |
| 18    | Realtime GI and LOD Groups | Support Realtime Global Illumination<br />Animate emissive light contribution to GI<br />Work with light probe proxy volumes<br />Use LOD groups in combination with GI<br />Cross-fade between LOD levels |
| 19    | GPU instancing             | Render a boatload of spheres<br />Add support for GPU instancing<br />Use material property blocks<br />Make instancing work with LOD groups |
| 20    | Parallax                   | Shift texture coordinates based on view direction<br />Use a height field to create the illusion of depth<br />Trace a ray through a height field<br />Approximate or search for an intersection point |

