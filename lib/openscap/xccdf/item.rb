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

      def sub_items
        @sub_items ||= sub_items_init
      end

      def destroy
        OpenSCAP.xccdf_item_free @raw
        @raw = nil
      end

      def sub_items_init
        collect = {}
        items_it = OpenSCAP.xccdf_item_get_content @raw
        while OpenSCAP.xccdf_item_iterator_has_more items_it
          item_p = OpenSCAP.xccdf_item_iterator_next items_it
          item = OpenSCAP::Xccdf::Item.new item_p
          collect.merge! item.sub_items
          collect[item.id] = item
        end
        OpenSCAP.xccdf_item_iterator_free items_it
        collect
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
