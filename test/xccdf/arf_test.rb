# frozen_string_literal: true

require 'common/testcase'
require 'openscap'
require 'openscap/ds/sds'
require 'openscap/source'
require 'openscap/xccdf/benchmark'

class TestArf < OpenSCAP::TestCase
  def test_new_from_file
    b = benchmark_from_arf_file
    b.destroy
  end

  def test_idents
    b = benchmark_from_arf_file
    item = b.items['xccdf_com.redhat.rhsa_rule_oval-com.redhat.rhsa-def-20140675']
    idents = item.idents
    assert idents.size == 25
  end

  def test_ident_title_url
    b = benchmark_from_arf_file
    item = b.items['xccdf_com.redhat.rhsa_rule_oval-com.redhat.rhsa-def-20140678']
    idents = item.idents
    assert idents.size == 2
    ident = idents[0]
    expected_id = 'RHSA-2014-0678'
    expected_system = 'https://rhn.redhat.com/errata'
    assert_equal(expected_id, ident.id)
    assert_equal(expected_system, ident.system)
  end

  private

  def benchmark_from_arf_file
    arf = OpenSCAP::DS::Arf.new('../data/arf.xml')
    _test_results = arf.test_result
    source_datastream = arf.report_request
    bench_source = source_datastream.select_checklist!
    benchmark = OpenSCAP::Xccdf::Benchmark.new(bench_source)
    benchmark
  end
end
