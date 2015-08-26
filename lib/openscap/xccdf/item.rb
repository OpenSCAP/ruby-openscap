#
# Copyright (c) 2015 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

require 'openscap/exceptions'
require 'openscap/text'

module OpenSCAP
  module Xccdf
    class Item
      def initialize(t)
        case t
        when FFI::Pointer
          @raw = t
        else
          fail OpenSCAP::OpenSCAPError, "Cannot initialize OpenSCAP::Xccdf::Item with #{t}"
        end
      end

      def id
        OpenSCAP.xccdf_item_get_id @raw
      end

      def destroy
        OpenSCAP.xccdf_item_free @raw
        @raw = nil
      end
    end
  end

  attach_function :xccdf_item_get_id, [:pointer], :string
  attach_function :xccdf_item_get_content, [:pointer], :pointer
  attach_function :xccdf_item_free, [:pointer], :void

  attach_function :xccdf_item_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_item_iterator_next, [:pointer], :pointer
  attach_function :xccdf_item_iterator_free, [:pointer], :void
end
