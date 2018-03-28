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
    class Ident 
      def initialize(raw)
        raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with '#{raw}'" \
          unless raw.is_a?(FFI::Pointer)
        @raw = raw
      end

      def system
        OpenSCAP.xccdf_ident_get_system(@raw)
      end

      def id
        OpenSCAP.xccdf_ident_get_id(@raw)
      end


    end
  end
  attach_function :xccdf_ident_get_system, [:pointer], :string
  attach_function :xccdf_ident_get_id, [:pointer], :string
end



