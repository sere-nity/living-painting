## Living Painting Project

This project recreates the innovative 2D/3D rendering techniques from *Pillars of Eternity* and *Disco Elysium* . These are two of my favourite games that pushed the boundaries of visual storytelling in unique ways.

### Research & Development

Using graphics debugging tools I learned during my time as a graphics intern at PlayStation, I analyzed both games with **RenderDoc** and **NVIDIA NSight**. I documented the entire reverse-engineering process in a [digital diary](https://shiny-lung-fd8.notion.site/19-06-26-Good-Insight-Into-DE-Graphics-54ed5048eeb74caaaefcacbbf5c13a32?source=copy_link), tracking experiments, dead ends, and breakthroughs over the course of a month.

### How It Works

The core technique creates the illusion of depth within a 2D plane through custom shader manipulation:

![Demo 1](https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExdnJrdGg0YzZoMGdtMGhwZTVodzR6Znkzc3c3ZWt3eXdsNnc3eTJsOSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/NnmyOcGBBojcNV2bVB/giphy.gif)

*The painting is actually a flat 2D plane, but the sphere appears correctly positioned behind the well and in front of the cube through depth map manipulation.*

![Demo 2](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNGMzdjFtbXRrdnZvcjVjeTF1b3I2Z25xdGF4d2k5MjQ5N2x4cDFrZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/wxcCe6UM7E7M1TEWG2/giphy.gif)

*The 2D painting responds dynamically to scene lighting changes.*

### Technical Implementation

The main shader code is in `BackgroundShader.shader`. The shader combines multiple rendering passes (albedo, normal, depth) and exposes key parameters for artistic control:

**Depth Offset**

![Depth offset demo](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjNiZ29qODk5eXBwdWw2MXAxOGhmaXl0aGhrMjVudHZwMGk1dHA5ZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/TYVExKHcBwpoW7IZRB/giphy.gif)

*Controls how fragment depth is compared against the depth map, allowing precise placement of 3D objects within the 2D scene.*

**Bump Power**

![Bump power demo](https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExMnk1c3ViOHh5cTFxeDkxN2RhdGpza3JhNDJnbHoyNzAzNjZxcmE0ZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/RwQdeND7MjfXDaTL2G/giphy.gif)

*Adjusts normal map strength to control the painting's light sensitivity.*

### Full Scene Test

To test the technique at scale, I created a complete bedroom scene (100+ hours from concept to completion):

<img src="https://drive.google.com/uc?export=view&id=1kIco7MWHv6ngO94ZghFUmkop6qxnOGYa" alt="Bedroom concept art" width="500"/>

*Concept art*

![Modeling in Blender](https://media.giphy.com/media/WL7Ii9A62gENwyrwiG/giphy.gif)

*Modeling process in Blender*

![Unity result](https://media.giphy.com/media/URnJbZvc5Mrk7zLeSO/giphy.gif)

*Final result in Unity*

### Art Style Experiments

Inspired by *Arcane*'s painterly aesthetic, I experimented with paint-over techniques on the 3D render:

| My Paint-Over | Arcane Reference |
|:--:|:--:|
| <img src="https://media.giphy.com/media/Yu0GBtdY6YSDSvPx2V/giphy.gif" alt="Paint-over" width="400"/> | <img src="https://drive.google.com/uc?export=view&id=1Dts6T9DUJfQiNIh5pklHwwijAqoc9Khe" alt="Arcane style" width="300"/> |
