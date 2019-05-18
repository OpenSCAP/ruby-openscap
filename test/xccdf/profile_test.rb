# frozen_string_literal: true

require 'common/testcase'
require 'openscap'
require 'openscap/source'
require 'openscap/xccdf/benchmark'
require 'openscap/xccdf/profile'

class TestProfile < OpenSCAP::TestCase
  def test_new_from_file
    @s = OpenSCAP::Source.new '../data/xccdf.xml'
    b = OpenSCAP::Xccdf::Benchmark.new @s
    assert !b.nil?
    assert b.profiles.size == 1, b.profiles.to_s
    profile1 = b.profiles['xccdf_org.ssgproject.content_profile_common']
    assert profile1
    assert profile1.title == 'Common Profile for General-Purpose Fedora Systems'
    b.destroy
  end
end
