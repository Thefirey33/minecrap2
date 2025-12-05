#include "tendrillion_ini_service.h"
#include "tendrillion_errors.h"
#include "tendrillion_helper.h"
#include <stdexcept>

CSimpleIniA tendrillion::tendrillion_ini_service::ini;
tendrillion::tendrillion_ini_service::tendrillion_ini_service() {
  ini.SetUnicode();
  SI_Error rc = ini.LoadFile(TENDRILLION_INI_NAME);
  if (rc < 0) {
    tendrillion::tendrillion_error_service::show_error(
        "Failed to load the INI file!");
  }
}
const char *tendrillion::tendrillion_ini_service::get_char_key_value_safe(
    const char *header, const char *key) {
  this->is_key_exists(header, key);
  return ini.GetValue(header, key);
}

int tendrillion::tendrillion_ini_service::get_int_key_value_safe(
    const char *header, const char *key) {
  this->is_key_exists(header, key);
  return ini.GetDoubleValue(header, key);
}

void tendrillion::tendrillion_ini_service::is_key_exists(const char *header,
                                                         const char *key) {
  if (!ini.KeyExists(header, key)) {
    throw std::runtime_error(
        tendrillion_helper::combine_two_strings("No Key Called: ", key));
  }
}