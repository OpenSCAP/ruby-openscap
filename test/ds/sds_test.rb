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
require 'openscap/source'
require 'openscap/ds/sds'
require 'common/testcase'

class TestSds < OpenSCAP::TestCase
  def test_new
    filename = '../data/sds-complex.xml'
    @s = OpenSCAP::Source.new filename
    assert !@s.nil?
    sds = OpenSCAP::DS::Sds.new :source => @s
    assert !sds.nil?
    sds.destroy
  end

  def test_new_non_sds
    filename = '../data/xccdf.xml'
    @s = OpenSCAP::Source.new filename
    assert !@s.nil?
    msg = nil
    begin
      sds = OpenSCAP::DS::Sds.new :source => @s
      assert false
    rescue OpenSCAP::OpenSCAPError => e
      msg = e.to_s
    end
    assert msg.start_with?('Could not create Source DataStream session: File is not Source DataStream.'), msg
  end
end