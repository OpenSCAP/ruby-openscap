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
    class << self
      def startup
        OpenSCAP.oscap_init
      end

      def shutdown
        OpenSCAP.oscap_cleanup
      end
    end

    def setup
      workdir = "test/output"
      FileUtils.rm_rf workdir
      Dir.mkdir workdir
      Dir.chdir workdir
    end

    def cleanup
      Dir.chdir "../.."
      OpenSCAP.raise! if OpenSCAP.error?
    end
  end
end
