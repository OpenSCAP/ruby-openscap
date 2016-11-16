#
# Copyright (c) 2014--2016 Red Hat Inc.
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
require 'openscap/xccdf/tailoring'
require 'common/testcase'

class TailoringTest < OpenSCAP::TestCase
  def test_new_from_file
    tailoring = tailoring_from_file
    tailoring.destroy
    refute tailoring.raw
  end

  def test_profiles
    profiles = tailoring_from_file.profiles
    assert_equal 1, profiles.length
    assert profiles.values.first.is_a?(OpenSCAP::Xccdf::Profile)
  end

  private

  def tailoring_from_file
    source = OpenSCAP::Source.new '../data/tailoring.xml'
    tailoring = OpenSCAP::Xccdf::Tailoring.new source, nil
    source.destroy
    assert tailoring
    tailoring
  end
end
