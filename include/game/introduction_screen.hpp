#include "raylib.h"
#include "tendrillion_gui.hpp"
#include <vector>
#pragma once
namespace minecrap2 {
namespace screens {
class introduction_screen
    : public tendrillion::tendrillion_gui::tendrillion_screen {
public:
  void initialize_all() override;
  void render_screen() override;
  std::vector<float> parallax_backgrounds = {0};
  introduction_screen();
  Sound background_theme;
  Texture2D background_img;
};
} // namespace screens
} // namespace minecrap2