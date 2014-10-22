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
require 'openscap/ds/arf'
require 'common/testcase'

class TestSession < OpenSCAP::TestCase
  def test_arf_new_nil
    msg = nil
    begin
      s = OpenSCAP::DS::Arf.new(nil)
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?("No filename specified!"), "Message was: " + msg
  end

  def test_arf_new_wrong_format
    msg = nil
    begin
      s = OpenSCAP::DS::Arf.new("data/xccdf.xml")
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('failed to load external entity "data/xccdf.xml"'), "Message was: " + msg
    assert msg.include?('Could not create Result DataStream session: File is not Result DataStream.'),
        "Message was: " + msg
  end
end