# frozen_string_literal: true

require 'openscap'
require 'openscap/text'
require 'common/testcase'

class TestText < OpenSCAP::TestCase
  def test_text_new
    t = OpenSCAP::Text.new
    t.destroy
  end

  def test_text_set_text
    t = OpenSCAP::Text.new
    t.text = 'blah'
    assert t.text == 'blah', "Text was: #{t.text}"
    t.destroy
  end
end
