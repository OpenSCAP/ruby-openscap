# frozen_string_literal: true

require 'openscap'
require 'common/testcase'

class TestSession < OpenSCAP::TestCase
  def test_session_new_bad
    msg = nil
    begin
      OpenSCAP::Xccdf::Session.new('')
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("Unable to open file: ''"), 'Message was: ' + msg
  end

  def test_session_new_nil
    msg = nil
    begin
      OpenSCAP::Xccdf::Session.new(nil)
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('No filename specified!'), 'Message was: ' + msg
  end

  def test_sds_false
    @s = OpenSCAP::Xccdf::Session.new('../data/xccdf.xml')
    refute @s.sds?
  end
end
