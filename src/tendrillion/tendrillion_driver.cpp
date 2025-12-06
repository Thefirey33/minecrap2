#include "tendrillion_driver.hpp"
#include "tendrillion.hpp"
#include <memory>

int tendrillion::tendrillion_driver::start_tendrillion_instance(
    int game_width, int game_height, const char *title) {
  std::unique_ptr<tendrillion::tendrillion_game_engine> tendrillion_ge =
      std::make_unique<tendrillion::tendrillion_game_engine>(
          game_width, game_height, title);
  tendrillion_ge->initialize_tendrillion();
  tendrillion_ge->import_all_assets();
  tendrillion_ge->window_loop();
  CloseWindow();
  return 0;
}