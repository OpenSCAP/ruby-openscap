#
# Copyright (c) 2016 Red Hat Inc.
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
require 'openscap/xccdf/policy'
require 'openscap/xccdf/policy_model'

class TestPolicy < OpenSCAP::TestCase
  def test_new_policy_model
    @s = OpenSCAP::Source.new '../data/xccdf.xml'
    b = OpenSCAP::Xccdf::Benchmark.new @s
    pm = OpenSCAP::Xccdf::PolicyModel.new b
    assert !b.nil?
    assert pm.policies.size == 1, pm.policies.to_s
    assert pm.policies['xccdf_org.ssgproject.content_profile_common']
    pm.destroy
  end
end
