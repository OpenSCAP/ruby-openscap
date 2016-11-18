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
