#pragma once

#include <iosfwd>
#include <string>

#include <ccc/export.hxx>

namespace ccc
{
  // Print a greeting for the specified name into the specified
  // stream. Throw std::invalid_argument if the name is empty.
  //
  CCC_SYMEXPORT void
  say_hello (std::ostream&, const std::string& name);
}
