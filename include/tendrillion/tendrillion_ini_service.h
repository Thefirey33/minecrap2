

#define TENDRILLION_INI_NAME "assets/engine_configuration.ini"
#include "SimpleIni.h"
#pragma once

namespace tendrillion {
class tendrillion_ini_service {
public:
  static CSimpleIniA ini;
  tendrillion_ini_service();
  const char *get_char_key_value_safe(const char *header, const char *key);
  int get_int_key_value_safe(const char *header, const char *key);
  void is_key_exists(const char *header, const char *key);
};
} // namespace tendrillion