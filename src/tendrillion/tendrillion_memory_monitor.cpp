#include "tendrillion_memory_monitor.hpp"
#ifdef _WIN32
#include <Windows.h>
#include <sysinfoapi.h>
#include <winnt.h>
#define CALC (1024 * 1024 * 1024)
MEMORYSTATUSEX return_mem_usage() {
  MEMORYSTATUSEX memoryStatEx;
  memoryStatEx.dwLength = sizeof(MEMORYSTATUSEX);
  GlobalMemoryStatusEx(&memoryStatEx);
  return memoryStatEx;
}
unsigned long tendrillion::tendrillion_memory_monitor::get_total_memory() {
  return return_mem_usage().ullTotalPageFile / CALC;
  ;
}

unsigned long
tendrillion::tendrillion_memory_monitor::get_total_memory_usage() {
  MEMORYSTATUSEX memStatEx = return_mem_usage();
  return (memStatEx.ullTotalPageFile - memStatEx.ullAvailPageFile) / CALC;
}
#endif

#ifdef __linux__
// TODO
#endif