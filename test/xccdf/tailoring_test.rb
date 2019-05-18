# frozen_string_literal: true

require 'openscap'
require 'openscap/source'
require 'openscap/xccdf/tailoring'
require 'common/testcase'

class TailoringTest < OpenSCAP::TestCase
  def test_new_from_file
    tailoring = tailoring_from_file
    tailoring.destroy
    refute tailoring.raw
  end

  def test_profiles
    profiles = tailoring_from_file.profiles
    assert_equal 1, profiles.length
    assert profiles.values.first.is_a?(OpenSCAP::Xccdf::Profile)
  end

  private

  def tailoring_from_file
    source = OpenSCAP::Source.new '../data/tailoring.xml'
    tailoring = OpenSCAP::Xccdf::Tailoring.new source, nil
    source.destroy
    assert tailoring
    tailoring
  end
end
