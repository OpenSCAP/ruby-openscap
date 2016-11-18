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

require 'openscap/text'

module OpenSCAP
  module Xccdf
    class Profile
      attr_reader :raw

      def initialize(p)
        case p
        when FFI::Pointer
          @raw = p
        else
          raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with #{p}"
        end
      end

      def id
        OpenSCAP.xccdf_profile_get_id raw
      end

      def title(prefered_lang = nil)
        textlist = OpenSCAP::TextList.new(OpenSCAP.xccdf_profile_get_title(@raw))
        title = textlist.plaintext(prefered_lang)
        textlist.destroy
        title
      end
    end
  end

  attach_function :xccdf_profile_get_id, [:pointer], :string
  attach_function :xccdf_profile_get_title, [:pointer], :pointer
end
