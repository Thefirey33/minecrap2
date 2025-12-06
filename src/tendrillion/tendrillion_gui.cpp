#pragma once
#include "tendrillion_gui.hpp"
#include "raylib.h"
#include "tendrillion.hpp"
#include <cassert>
#include <functional>

tendrillion::tendrillion_gui::tendrillion_base_gui_object::
    tendrillion_base_gui_object(
        tendrillion::tendrillion_gui::gui_position pos) {
  this->position_on_screen = pos;
}

tendrillion::tendrillion_gui *tendrillion::tendrillion_gui::instance;
Font tendrillion::tendrillion_gui::main_font;
tendrillion::tendrillion_gui::tendrillion_gui() {
  auto font_file_location =
      (tendrillion::tendrillion_game_engine::TENDRILLION_ASSET_PATH +
       "\\determination-mono.ttf");
  tendrillion_gui::main_font = LoadFont(font_file_location.c_str());
  tendrillion_gui::instance = this;
}
tendrillion::tendrillion_gui::~tendrillion_gui() {
  if (&(tendrillion_gui::main_font) != nullptr)
    UnloadFont(tendrillion_gui::main_font);
}

// Math.

inline tendrillion::tendrillion_gui::gui_position
tendrillion::tendrillion_gui::gui_position::operator+(
    tendrillion_gui::gui_position other) {
  return {this->x + other.x, this->y + other.y};
}

inline tendrillion::tendrillion_gui::gui_position
tendrillion::tendrillion_gui::gui_position::operator-(
    tendrillion_gui::gui_position other) {
  return {this->x - other.x, this->y - other.y};
}

inline tendrillion::tendrillion_gui::gui_position
tendrillion::tendrillion_gui::gui_position::operator*(
    tendrillion_gui::gui_position other) {
  return {this->x * other.x, this->y * other.y};
}

void tendrillion::tendrillion_gui::tendrillion_screen::loop_over_gui_components(
    std::function<void(tendrillion_gui::tendrillion_base_gui_object *)> f) {
  for (tendrillion_gui::tendrillion_base_gui_object *object : this->objects)
    f(object);
}

void tendrillion::tendrillion_gui::tendrillion_base_gui_object::update() {
  DrawTextEx(tendrillion_gui::instance->main_font,
             "WARN: THIS IS A BASE GUI OBJECT, MAKE ANOTHER ONE", {50, 50}, 20,
             1, WHITE);
}

void tendrillion::tendrillion_gui::render_gui_handler() {
  if (this->current_screen != nullptr)
    this->current_screen->render_screen();
}

void tendrillion::tendrillion_gui::tendrillion_screen::render_screen() {
  this->loop_over_gui_components([](auto *f) { f->update(); });
}

void tendrillion::tendrillion_gui::tendrillion_screen::initialize_all() {
  this->loop_over_gui_components([](auto *f) { f->init(); });
}