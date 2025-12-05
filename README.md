# Minecrap 2

The parody of all knock-offs of indie-games.
This project is still under works, so expect some *extreme* code-changes in the future.

This is a project that uses the custom-built, Raylib wrapper for C++ *(Tendrillion)*, that i made for this game only.

## Getting Started

Make sure you have these dependencies installed on your system:

- XMake (v3.0.5)
- C++20
- clangd (21.1.6) or Microsoft Visual C++ Tools

*I recommend clangd, if you are starting in C++ development, as it recognizes and formats your code accordingly.*

## Building and Details

This project contains two important folders. The "include" and "src" folder. The "include" folder is where all the C / C++ header files are contained. The "src" folder is where all the C++ files (\*.cpp) are contained.

After verifying that the project is layed out correctly, for clangd or other C++ tooling system, Use:

```bash
xmake project -k compile_commands 
```

To generate the specified `compile_commands.json` file for the project. After the `compile_commands.json` is generated, you can use

### For Building

For building the project, use this command below.

```bash
xmake
```

### For Running

For running the project under your operating system, use this command below.

```bash
xmake run minecrap2
```
