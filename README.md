## Living Painting Project
This project is inspired by two of my favourite games: Pillars of Eternity and Disco Elysium. Both these games innovated on what was possible with 2D and 3D rendering. 

I wanted to recreate this effect. I learnt how to use graphics debugging tools effectively during my time as a graphics intern at PlayStation. 
so I analysed these games with RenderDoc (love this piece of software sm) and NVIDIA NSight. 

I kept a digital diary of this process. Here is a snippet of my stream of consciousness thoughts - [Notion Diary Entry](https://shiny-lung-fd8.notion.site/19-06-26-Good-Insight-Into-DE-Graphics-54ed5048eeb74caaaefcacbbf5c13a32?source=copy_link) 

A month later and I finally had a result. Most of the time I didn't even know if it was possible. 

### The Magic
![GIF 1](https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExdnJrdGg0YzZoMGdtMGhwZTVodzR6Znkzc3c3ZWt3eXdsNnc3eTJsOSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/NnmyOcGBBojcNV2bVB/giphy.gif)

In the top window you can see the picture is actually just a 2D plane. And the sphere is below the plane in 3D space... 
By shader magic, the sphere can appear behind the well but in front of the cube, as if the picture was actually a 3D scene!! 

![GIF 2](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNGMzdjFtbXRrdnZvcjVjeTF1b3I2Z25xdGF4d2k5MjQ5N2x4cDFrZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/wxcCe6UM7E7M1TEWG2/giphy.gif)

Here I am changing the directional light's y-value. We can see by shader magic again the 2D picture responds to this lighting change! 


### Main Shader Code
The main shader code is found in `BackgroundShader.shader`. In the same folder, you can find all my other failed attempts and experiments :D I sure learnt perseverance from this process. 

The shader itself combines all the rendering maps together and tries to make things parametrisable. So that we can have *maximum creative control!!* 

![GIF 3](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjNiZ29qODk5eXBwdWw2MXAxOGhmaXl0aGhrMjVudHZwMGk1dHA5ZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/TYVExKHcBwpoW7IZRB/giphy.gif)

Here we are parametrising the depth offset. DepthOffset allows you to adjust how the fragment’s real position in the scene (its distance from the camera) is compared to the reference depth value from the depth map texture. The result is the sphere being placed at the correct depth level. 

![GIF 4](https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExMnk1c3ViOHh5cTFxeDkxN2RhdGpza3JhNDJnbHoyNzAzNjZxcmE0ZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/RwQdeND7MjfXDaTL2G/giphy.gif)

.. And here we are paraemtrising the bump power. This control the strength of the normal map and controls how sensitive the painting is to light. 
