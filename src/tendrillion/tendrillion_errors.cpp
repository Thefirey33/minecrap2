#include <cstdlib>

#ifdef _WIN32
#include <Windows.h>
#include <winnt.h>
#include <winuser.h>
#endif

#include "tendrillion_errors.hpp"

void tendrillion::tendrillion_error_service::show_error(
    const char *error_message) {
#ifdef _WIN32
  MessageBoxA(NULL, (LPCSTR)error_message, (LPCSTR) "Tendrillion Exception",
              MB_OK | MB_ICONERROR);
  exit(1);
#endif

#ifdef __linux__
  std::cerr << "Error: " << error_message << std::endl;
  exit(1);
#endif
}