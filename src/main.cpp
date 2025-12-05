
#include "tendrillion_driver.h"
#include "tendrillion_errors.h"
#include "tendrillion_ini_service.h"
#include <memory>
#include <stdexcept>

#define HEADER "game"
#define K_GAME_NAME "game_name"
#define K_GAME_WIDTH "game_width"
#define K_GAME_HEIGHT "game_height"
int main(int argc, char **argv) {
  try {
    std::unique_ptr<tendrillion::tendrillion_ini_service>
        tendrillion_ini_service =
            std::make_unique<tendrillion::tendrillion_ini_service>();

    return tendrillion::tendrillion_driver::start_tendrillion_instance(
        tendrillion_ini_service->get_int_key_value_safe(HEADER, K_GAME_WIDTH),
        tendrillion_ini_service->get_int_key_value_safe(HEADER, K_GAME_HEIGHT),
        tendrillion_ini_service->get_char_key_value_safe(HEADER, K_GAME_NAME));
  } catch (std::runtime_error err) {
    tendrillion::tendrillion_error_service::show_error(err.what());
  }
}
