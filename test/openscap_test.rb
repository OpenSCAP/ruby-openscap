# frozen_string_literal: true

require 'common/testcase'
require 'openscap'

class TestOscapVersion < OpenSCAP::TestCase
  def test_oscap_version
    OpenSCAP.oscap_init
    version = OpenSCAP.oscap_get_version
    OpenSCAP.oscap_cleanup
    assert version.include?('.')
  end

  def test_double_read_error
    assert !OpenSCAP.error?
    msg = OpenSCAP.full_error
    assert msg.nil?
    msg = OpenSCAP.full_error
    assert msg.nil?
  end
end
