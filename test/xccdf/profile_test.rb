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
