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
