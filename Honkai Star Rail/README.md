# Honkai: Star Rail
REST config for Honkai: Star Rail

## Requirements
* [REST v1.3.15](https://github.com/4lex4nder/ReshadeEffectShaderToggler/releases/tag/v1.3.15)
* [ReShade](https://reshade.me/) >= 5.9.2
* Rendering Quality 1.0, TAA

## What does it do
* Applies SSGI effects before fog etc. 

## Notes
* Use `honkai_crashpad.fx` as the motion vector provider
* It's preconfigured for RTGI. In case you're using something else, add them manually to the `Albedo` group
* Depth buffer will be flipped if you use any other screen space effects. It is what it is.

## Batteries included
Some extra stuff

### honkai_common.fxh
If you know your way around shaders, you can use this header file to access some game engine data in your ReShade effects. Including:
* Motion vectors
* Normal buffer

### honkai_crashpad.fx
A helper shader providing the game's normals and motion vectors in known formats (DRME/Launchpad).
