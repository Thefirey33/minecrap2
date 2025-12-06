#pragma once
namespace tendrillion {
class tendrillion_driver {
public:
  static int start_tendrillion_instance(int game_width, int game_height,
                                        const char *title);
};
} // namespace tendrillion