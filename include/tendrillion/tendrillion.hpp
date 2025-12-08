#pragma once
#include "raylib.h"
#include "tendrillion_gui.hpp"
#include "tendrillion_logging.hpp"
#include <map>
#include <memory>
#include <string>
#define FRAME_MAX 144

namespace tendrillion {
class tendrillion_game_engine {
public:
  static tendrillion_game_engine *tendrillion_instance;
  static std::string TENDRILLION_ASSET_PATH;
  int game_window_width = 800;
  int game_window_height = 600;
  bool is_gamepad_available = false;
  std::map<std::string, Texture2D> textures = {};
  std::map<std::string, Sound> sounds = {};
  std::unique_ptr<tendrillion::tendrillion_gui> current_gui_handler;
  std::unique_ptr<tendrillion::tendrillion_logging> tendrillion_logging;
  tendrillion_gui::gui_position virtual_cursor = {0, 0};
  tendrillion_game_engine(int game_window_width, int game_window_height,
                          const char *title_game_window);
  ~tendrillion_game_engine();
  bool asset_exists_texture(std::string asset_name);
  bool asset_exists_sound(std::string asset_name);
  Sound &get_sound(std::string asset_name);
  Texture2D &get_texture(std::string asset_name);
  void initialize_tendrillion();
  void import_all_assets();
  void window_loop();
};
} // namespace tendrillion