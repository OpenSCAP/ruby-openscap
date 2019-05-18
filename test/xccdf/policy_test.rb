# frozen_string_literal: true

require 'common/testcase'
require 'openscap'
require 'openscap/source'
require 'openscap/xccdf/benchmark'
require 'openscap/xccdf/policy'
require 'openscap/xccdf/policy_model'

class TestPolicy < OpenSCAP::TestCase
  def test_new_policy_model
    @s = OpenSCAP::Source.new '../data/xccdf.xml'
    b = OpenSCAP::Xccdf::Benchmark.new @s
    pm = OpenSCAP::Xccdf::PolicyModel.new b
    assert !b.nil?
    assert pm.policies.size == 1, pm.policies.to_s
    assert pm.policies['xccdf_org.ssgproject.content_profile_common']
    pm.destroy
  end
end
