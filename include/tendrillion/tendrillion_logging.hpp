#pragma once
#include <fstream>
#include <string>

namespace tendrillion {
class tendrillion_logging {
public:
  std::ofstream current_file_stream = std::ofstream("current.log");
  tendrillion_logging();
  ~tendrillion_logging();
  void log_this_to_output(std::string log_information);
};

} // namespace tendrillion