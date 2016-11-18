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

require 'openscap/exceptions'

module OpenSCAP
  module Xccdf
    class Policy
      attr_reader :raw

      def initialize(p)
        case p
        when FFI::Pointer
          @raw = p
        else
          raise OpenSCAP::OpenSCAPError,
                "Cannot initialize OpenSCAP::Xccdf::Policy with '#{p}'"
        end
        OpenSCAP.raise! if @raw.null?
      end

      def id
        OpenSCAP.xccdf_policy_get_id raw
      end
    end
  end

  attach_function :xccdf_policy_get_id, [:pointer], :string
end
