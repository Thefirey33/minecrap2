

#include "tendrillion.h"
#include "raylib.h"
#include "tendrillion_helper.h"
#include <filesystem>
#include <string>
#include <utility>

void tendrillion::tendrillion_game_engine::initialize_tendrillion() {}
namespace fs = std::filesystem;

tendrillion::tendrillion_game_engine::tendrillion_game_engine(

    int game_window_width, int game_window_height,
    const char *title_game_window) {
  this->game_window_width = game_window_width;
  this->game_window_height = game_window_height;
  InitWindow(this->game_window_width, this->game_window_height, "Minecrap 2");
}
tendrillion::tendrillion_game_engine::~tendrillion_game_engine() {
  for (auto texture : this->textures)
    UnloadTexture(texture.second);
  for (std::pair<std::string, Sound> sound : this->sounds)
    UnloadSound(sound.second);
  CloseWindow();
}
void tendrillion::tendrillion_game_engine::import_all_assets() {
  std::string str = tendrillion_helper::combine_two_strings(
      GetApplicationDirectory(), "assets");
  FilePathList filePathList = LoadDirectoryFiles(str.c_str());

  for (int i = 0; i < filePathList.count; i++) {
    const char *filename = filePathList.paths[i];
    const fs::path path(filename);
    const fs::path ext = path.extension();
    const std::string filename_direct = path.stem().string();
    if (ext == ".png") {
      this->textures.insert(
          std::make_pair(filename_direct, LoadTexture(filename)));
    } else if (ext == ".wav") {
      this->sounds.insert(std::make_pair(filename_direct, LoadSound(filename)));
    }
  }
}
void tendrillion::tendrillion_game_engine::window_loop() {
  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(BLACK);
    EndDrawing();
  }
}