
#include "raylib.h"
#include <map>
#include <string>

namespace tendrillion {
class tendrillion_game_engine {
public:
  tendrillion_game_engine *tendrillion_instance;
  int game_window_width = 800;
  int game_window_height = 600;
  std::map<std::string, Texture2D> textures = {};
  std::map<std::string, Sound> sounds = {};
  tendrillion_game_engine(int game_window_width, int game_window_height,
                          const char *title_game_window);
  ~tendrillion_game_engine();
  void initialize_tendrillion();
  void import_all_assets();
  void window_loop();
};
} // namespace tendrillion