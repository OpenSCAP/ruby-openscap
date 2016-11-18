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
    class Reference
      def initialize(raw)
        raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with '#{raw}'" \
          unless raw.is_a?(FFI::Pointer)
        @raw = raw
      end

      def title
        OpenSCAP.oscap_reference_get_title(@raw)
      end

      def href
        OpenSCAP.oscap_reference_get_href(@raw)
      end

      def html_link
        "<a href='#{href}'>#{title}</a>"
      end

      def to_hash
        {
          :title => title,
          :href => href,
          :html_link => html_link
        }
      end
    end
  end
  attach_function :oscap_reference_get_href, [:pointer], :string
  attach_function :oscap_reference_get_title, [:pointer], :string
end
