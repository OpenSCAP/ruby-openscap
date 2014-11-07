#
# Copyright (c) 2014 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

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
