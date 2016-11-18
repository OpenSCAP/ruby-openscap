#
# Copyright (c) 2015--2016 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

module OpenSCAP
  module Xccdf
    class Fix
      def initialize(raw)
        raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with '#{raw}'" \
          unless raw.is_a?(FFI::Pointer)
        @raw = raw
      end

      def id
        OpenSCAP.xccdf_fix_get_id(@raw)
      end

      def platform
        OpenSCAP.xccdf_fix_get_platform(@raw)
      end

      # system is a reserved word in Rails, so didn't use it
      def fix_system
        OpenSCAP.xccdf_fix_get_system(@raw)
      end

      def content
        OpenSCAP.xccdf_fix_get_content(@raw)
      end

      def to_hash
        {
          :id => id,
          :platform => platform,
          :system => fix_system,
          :content => content
        }
      end
    end
  end
  attach_function :xccdf_fix_get_id, [:pointer], :string
  attach_function :xccdf_fix_get_platform, [:pointer], :string
  attach_function :xccdf_fix_get_system, [:pointer], :string
  attach_function :xccdf_fix_get_content, [:pointer], :string
end
