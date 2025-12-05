#include "tendrillion_helper.h"
#include <string>

std::string
tendrillion::tendrillion_helper::combine_two_strings(const char *first,
                                                     const char *second) {
  return std::string(first) + std::string(second);
};
