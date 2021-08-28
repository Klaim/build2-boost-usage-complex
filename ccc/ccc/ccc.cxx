#include <ccc/ccc.hxx>

#include <ostream>
#include <stdexcept>

#include <boost/array.hpp>
#include <boost/graph/grid_graph.hpp>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics/stats.hpp>
#include <boost/accumulators/statistics/mean.hpp>
#include <boost/accumulators/statistics/moment.hpp>

using namespace std;

namespace ccc
{
  void say_hello (ostream& o, const string& n)
  {
    boost::array<int, 2> lengths = { { 3, 3 } };
    boost::grid_graph<2, int> graph(lengths);

    using namespace boost::accumulators;
    accumulator_set<double, stats<tag::mean, tag::moment<2> > > acc;

    if (n.empty ())
      throw invalid_argument ("empty name");

    o << "Hello, " << n << '!' << endl;
  }
}
