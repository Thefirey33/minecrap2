#pragma once
#include "raylib.h"
#include <functional>
#include <vector>

namespace tendrillion {
class tendrillion_gui {
public:
  struct gui_position {
    int x;
    int y;
    gui_position(int x, int y) {
      this->x = x;
      this->y = y;
    }
    void get_from_vector2(Vector2 other);
    // addition
    inline tendrillion_gui::gui_position
    operator+(tendrillion_gui::gui_position other);
    // negation
    inline tendrillion_gui::gui_position
    operator-(tendrillion_gui::gui_position other);
    // multiplication
    inline tendrillion_gui::gui_position
    operator*(tendrillion_gui::gui_position other);
  };
  class tendrillion_base_gui_object {
  public:
    tendrillion_base_gui_object(
        tendrillion::tendrillion_gui::gui_position &position_on_screen);
    tendrillion_gui::gui_position position_on_screen = {0, 0};
    virtual tendrillion_gui::gui_position get_measurements() { return {0, 0}; }
    virtual void init() {}
    virtual void update();
  };
  class tendrillion_screen {
  public:
    std::vector<tendrillion_gui::tendrillion_base_gui_object *> objects = {};

    virtual void initialize_all();
    virtual void render_screen();
    void loop_over_gui_components(
        std::function<void(tendrillion_gui::tendrillion_base_gui_object *)>);
  };
  static Font main_font;
  static tendrillion_gui *instance;
  tendrillion_screen *current_screen = nullptr;
  void render_gui_handler();
  tendrillion_gui();
  ~tendrillion_gui();
};
} // namespace tendrillion