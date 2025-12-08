#include "introduction_screen.hpp"
#include "raylib.h"
#include "tendrillion.hpp"
#include <chrono>
#include <cmath>
#include <cstdlib>
#include <limits>

#define MAXIMUM_PARALLAX 300.0
#define tendri_instance                                                        \
  tendrillion::tendrillion_game_engine *instance =                             \
      tendrillion::tendrillion_game_engine::tendrillion_instance;
void minecrap2::screens::introduction_screen::render_screen() {
  tendri_instance;
  if (fmod(GetTime(), 1.0) <= std::numeric_limits<float>::epsilon() + 0.01)
    this->parallax_backgrounds.push_back(0);
  for (int i = 0; i < this->parallax_backgrounds.size(); i++) {
    this->parallax_backgrounds[i] += GetFrameTime() * MAXIMUM_PARALLAX / 10.0;
    float ref = static_cast<float>(this->parallax_backgrounds[i]);
    float ref_2 = ref * 2;
    unsigned char dist =
        ((MAXIMUM_PARALLAX - abs(ref - MAXIMUM_PARALLAX)) / MAXIMUM_PARALLAX) *
        255;
    DrawTexturePro(this->background_img,
                   {0, 0, static_cast<float>(this->background_img.width),
                    static_cast<float>(this->background_img.height)},
                   {-ref, -ref, instance->game_window_width + ref_2,
                    instance->game_window_height + ref_2},
                   {0, 0}, 0.0, {255, 255, 255, dist});
    if (ref > MAXIMUM_PARALLAX * 2)
      this->parallax_backgrounds.erase(this->parallax_backgrounds.begin() + i);
  }
}

void minecrap2::screens::introduction_screen::initialize_all() {}

minecrap2::screens::introduction_screen::introduction_screen() {
  tendri_instance;
  this->background_theme = instance->get_sound("snd_introduction");
  this->background_img = instance->get_texture("img_depth");
}