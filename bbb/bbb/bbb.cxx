#include <bbb/bbb.hxx>

#include <ostream>
#include <stdexcept>

#include <ccc/ccc.hxx>

using namespace std;

namespace bbb
{
  void say_hello (ostream& o, const string& n)
  {
    return ccc::say_hello(o, n);
  }

  boost::container::flat_set<std::string> names() { return { "kikoo", "lol" }; }
}
