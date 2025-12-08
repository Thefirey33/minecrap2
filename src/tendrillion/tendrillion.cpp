

#include <exception>
#include <filesystem>
#include <format>
#include <introduction_screen.hpp>
#include <iostream>
#include <memory>
#include <raylib.h>
#include <string>
#include <tendrillion.hpp>
#include <tendrillion_gui.hpp>
#include <tendrillion_helper.hpp>
#include <tendrillion_memory_monitor.hpp>
#include <utility>

#define GAMEPAD_INDX 0

void tendrillion::tendrillion_game_engine::initialize_tendrillion() {}
namespace fs = std::filesystem;
tendrillion::tendrillion_game_engine
    *tendrillion::tendrillion_game_engine::tendrillion_instance;
std::string tendrillion::tendrillion_game_engine::TENDRILLION_ASSET_PATH;

bool tendrillion::tendrillion_game_engine::asset_exists_sound(
    std::string asset_name) {
  return this->sounds.contains(asset_name);
}

bool tendrillion::tendrillion_game_engine::asset_exists_texture(
    std::string asset_name) {
  return this->textures.contains(asset_name);
}

tendrillion::tendrillion_game_engine::tendrillion_game_engine(

    int game_window_width, int game_window_height,
    const char *title_game_window) {
  tendrillion_game_engine::tendrillion_instance = this;
  // create the initial contexts.
  this->tendrillion_logging =
      std::make_unique<tendrillion::tendrillion_logging>();
  this->TENDRILLION_ASSET_PATH =
      tendrillion::tendrillion_helper::combine_two_strings(
          GetApplicationDirectory(), "assets");
  // create the window
  this->game_window_width = game_window_width;
  this->game_window_height = game_window_height;
  InitWindow(this->game_window_width, this->game_window_height, "Minecrap 2");
  InitAudioDevice();
  this->import_all_assets();
  SetTargetFPS(FRAME_MAX);
  // initialize everything else
  this->current_gui_handler = std::make_unique<tendrillion::tendrillion_gui>();
  this->current_gui_handler->current_screen =
      new minecrap2::screens::introduction_screen();
}
tendrillion::tendrillion_game_engine::~tendrillion_game_engine() {
  for (auto texture : this->textures) {
    this->tendrillion_logging->log_this_to_output(
        std::format("Unloading texture: {}", texture.first));
    UnloadTexture(texture.second);
  }
  for (std::pair<std::string, Sound> sound : this->sounds) {
    this->tendrillion_logging->log_this_to_output(
        std::format("Unloading sound: {}", sound.first));
    UnloadSound(sound.second);
  }
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
    this->tendrillion_logging->log_this_to_output(
        std::format("Loaded: {} as asset", filename_direct));
    if (ext == ".png") {
      this->textures.insert(
          std::make_pair(filename_direct, LoadTexture(filename)));
    } else if (ext == ".wav") {
      this->sounds.insert(std::make_pair(filename_direct, LoadSound(filename)));
    } else {
      this->tendrillion_logging->log_this_to_output(
          std::format("Not supported asset-type: {}, skipping", ext.string()));
    }
  }
}

Texture2D &
tendrillion::tendrillion_game_engine::get_texture(std::string asset_name) {
  auto iterator = this->textures.find(asset_name);
  if (iterator == this->textures.end()) {
    throw std::exception("Texture Asset Not!");
  } else {
    this->tendrillion_logging->log_this_to_output(
        std::format("Retrieve T asset: {}..", asset_name));
    return iterator->second;
  }
}

Sound &tendrillion::tendrillion_game_engine::get_sound(std::string asset_name) {
  auto iterator = this->sounds.find(asset_name);
  if (iterator == this->sounds.end()) {
    throw std::exception("Sound Asset Not!");
  } else {
    this->tendrillion_logging->log_this_to_output(
        std::format("Retrieve S asset: {}..", asset_name));
    return iterator->second;
  }
}

void handle_virtual_cursor_input(tendrillion::tendrillion_game_engine *engine) {
  // TODO: Handle virtual mouse
}

void tendrillion::tendrillion_game_engine::window_loop() {
  while (!WindowShouldClose()) {
    BeginDrawing();
    if (GetGamepadButtonPressed() == GAMEPAD_BUTTON_UNKNOWN) {
      this->virtual_cursor.get_from_vector2(GetMousePosition());
    } else {
      DrawRectangle(this->virtual_cursor.x, this->virtual_cursor.y, 5, 5,
                    WHITE);
      handle_virtual_cursor_input(this);
    }
    // gamepad check
    this->is_gamepad_available = IsGamepadAvailable(GAMEPAD_INDX);
    ClearBackground(BLACK);
    // this renders the gui
    this->current_gui_handler->render_gui_handler();
    DrawTextEx(
        this->current_gui_handler->main_font,
        std::format(
            "**ENGINE STATS**\nFPS: {}\n***MEMORY***\nTOTAL: {}GB\nUSED: "
            "{}GB ",
            GetFPS(),
            tendrillion::tendrillion_memory_monitor::get_total_memory(),
            tendrillion::tendrillion_memory_monitor::get_total_memory_usage())
            .c_str(),
        {0, 0}, 30, 1, WHITE);
    EndDrawing();
  }
}
