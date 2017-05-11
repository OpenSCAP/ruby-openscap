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

require 'test/unit'

module OpenSCAP
  class TestCase < Test::Unit::TestCase
    def setup
      workdir = 'test/output'
      if Dir.pwd.end_with? 'test/output'
        cleanup # Older TestCase do not run cleanup method.
      end
      FileUtils.rm_rf workdir
      Dir.mkdir workdir
      Dir.chdir workdir
      @s = nil
      OpenSCAP.oscap_init
    end

    def cleanup
      @s.destroy if @s
      Dir.chdir '../..'
      OpenSCAP.raise! if OpenSCAP.error?
      OpenSCAP.oscap_cleanup
    end

    protected

    def assert_default_score(scores, low, high)
      assert scores.size == 1
      s = scores['urn:xccdf:scoring:default']
      assert !s.nil?
      assert s[:system] == 'urn:xccdf:scoring:default'
      assert low < s[:value]
      assert s[:value] < high
      assert s[:max] == 100
    end
  end
end
