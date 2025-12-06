#include "tendrillion_logging.hpp"
#include <cstddef>
#include <ctime>
#include <format>
#include <fstream>
#include <functional>
#include <iostream>
#include <string>
#include <thread>
#define STARTING_YEAR 1900

tendrillion::tendrillion_logging::tendrillion_logging() {
  this->log_this_to_output("Initializing Logger!");
}

void tendrillion::tendrillion_logging::log_this_to_output(
    std::string log_information) {
  // very confusing logger
  time_t timestamp = time(&timestamp);
  struct tm current_time;
  localtime_s(&current_time, &timestamp);
  std::string u_year = std::to_string(STARTING_YEAR + current_time.tm_year),
              u_month = std::to_string(current_time.tm_mon + 1),
              u_day = std::to_string(current_time.tm_mday);
  // get the current thread id as a size_t
  size_t thread_id = std::hash<std::thread::id>{}(std::this_thread::get_id());
  std::string formatted =
      std::format("[{}/{}/{}: thread {}]: {}\n", u_year, u_month, u_day,
                  thread_id, log_information);
  const char *txt = formatted.c_str();
  std::cout << formatted;
  this->current_file_stream << txt;
}

tendrillion::tendrillion_logging::~tendrillion_logging() {
  this->log_this_to_output("Closing Logger...");
  this->current_file_stream.close();
}