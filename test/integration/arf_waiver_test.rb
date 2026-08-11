# frozen_string_literal: true

require 'openscap'
require 'openscap/xccdf/benchmark'
require 'openscap/xccdf/ruleresult'
require 'openscap/xccdf/session'
require 'openscap/xccdf/testresult'
require 'openscap/ds/arf'
require 'openscap/ds/sds'
require 'common/testcase'

class TestArfWaiver < OpenSCAP::TestCase
  def test_waiver_and_score
    assert_default_score tr.score, -1, 1
    assert_default_score tr.score!(benchmark), -1, 1

    rr.override!(new_result: :pass,
                 time: 'yesterday',
                 authority: 'John Hacker',
                 raw_text: 'This should have passed')
    assert rr.result == 'pass'

    assert_default_score tr.score, -1, 1
    assert_default_score tr.score!(benchmark), 99, 101

    # create updated DOM (that includes the override element and new score)
    arf.test_result = tr
    arf.source.save('modified.rds.xml')
    tr.destroy
    arf.destroy

    arf2 = OpenSCAP::DS::Arf.new('modified.rds.xml')
    tr2 = arf2.test_result('xccdf1')
    assert_default_score tr.score, 99, 101
    rr2 = tr2.rr['xccdf_moc.elpmaxe.www_rule_first']
    assert rr2.result == 'pass'
    tr2.destroy
    arf2.destroy
  end

  private

  def benchmark
    @benchmark ||= benchmark_init
  end

  def benchmark_init
    sds = arf.report_request
    bench_source = sds.select_checklist!
    bench = OpenSCAP::Xccdf::Benchmark.new bench_source
    sds.destroy
    bench
  end

  def rr
    @rr ||= rr_init
  end

  def rr_init
    assert tr.rr.size == 1
    rr = tr.rr['xccdf_moc.elpmaxe.www_rule_first']
    assert rr.result == 'fail'
    rr
  end

  def tr
    @tr ||= tr_init
  end

  def tr_init
    tr = arf.test_result
    assert tr.score.size == 1
    score = tr.score['urn:xccdf:scoring:default']
    assert score[:system] == 'urn:xccdf:scoring:default'
    assert score[:max] == 100.0
    assert score[:value] == 0.0
    tr
  end

  def arf
    @arf ||= arf_init
  end

  def arf_init
    @s = OpenSCAP::Xccdf::Session.new('../data/sds-complex.xml')
    @s.load
    @s.evaluate
    @s.export_results(rds_file: 'report.rds.xml')
    OpenSCAP::DS::Arf.new('report.rds.xml')
  end
end
