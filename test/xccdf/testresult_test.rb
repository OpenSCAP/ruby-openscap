# frozen_string_literal: true

require 'openscap'
require 'openscap/source'
require 'openscap/xccdf/benchmark'
require 'openscap/xccdf/testresult'
require 'common/testcase'

class TestTestResult < OpenSCAP::TestCase
  def test_testresult_new_bad
    source = OpenSCAP::Source.new('../data/xccdf.xml')
    assert !source.nil?
    msg = nil
    begin
      OpenSCAP::Xccdf::TestResult.new(source)
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("Expected 'TestResult' element while found 'Benchmark'."),
           'Message was: ' + msg
  end

  def test_result_create_and_query_properties
    tr = new_tr
    assert tr.id == 'xccdf_org.open-scap_testresult_xccdf_org.ssgproject.content_profile_common',
           "TestResult.id was '#{tr.id}"
    assert tr.profile == 'xccdf_org.ssgproject.content_profile_common',
           "TestResult.profile was '#{tr.profile}'"
    tr.destroy
  end

  def test_result_create_and_query_rr
    tr = new_tr
    assert tr.rr.size == 28
    assert tr.rr.key?('xccdf_org.ssgproject.content_rule_disable_prelink')
    assert tr.rr.key?('xccdf_org.ssgproject.content_rule_no_direct_root_logins')
    assert tr.rr['xccdf_org.ssgproject.content_rule_disable_prelink'].result == 'fail'
    assert tr.rr['xccdf_org.ssgproject.content_rule_no_direct_root_logins'].result == 'notchecked'
    tr.destroy
  end

  def test_override
    tr = new_tr
    rr = tr.rr['xccdf_org.ssgproject.content_rule_disable_prelink']
    assert rr.result == 'fail'
    rr.override!(:new_result => :pass,
                 :time => 'yesterday',
                 :authority => 'John Hacker',
                 :raw_text => 'We are testing prelink on this machine')
    assert rr.result == 'pass'
    tr.destroy
  end

  def test_score
    tr = new_tr
    assert_default_score tr.score, 34, 35
    tr.destroy
  end

  def test_waive_and_score
    tr = new_tr
    benchmark = benchmark_for_tr

    assert_default_score tr.score, 34, 35
    assert_default_score tr.score!(benchmark), 34, 35

    rr = tr.rr['xccdf_org.ssgproject.content_rule_disable_prelink']
    assert rr.result == 'fail'
    rr.override!(:new_result => :pass,
                 :time => 'yesterday',
                 :authority => 'John Hacker',
                 :raw_text => 'We are testing prelink on this machine')
    assert rr.result == 'pass'

    assert_default_score tr.score, 34, 35
    assert_default_score tr.score!(benchmark), 47, 48

    benchmark.destroy
    tr.destroy
  end

  private

  def benchmark_for_tr
    source = OpenSCAP::Source.new('../data/xccdf.xml')
    benchmark = OpenSCAP::Xccdf::Benchmark.new source
    source.destroy
    benchmark
  end

  def new_tr
    source = OpenSCAP::Source.new('../data/testresult.xml')
    assert !source.nil?
    tr = OpenSCAP::Xccdf::TestResult.new(source)
    source.destroy
    tr
  end
end
