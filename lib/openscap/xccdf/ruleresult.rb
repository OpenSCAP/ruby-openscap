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

require 'openscap/exceptions'

module OpenSCAP
  module Xccdf
    class RuleResult
      def initialize(t)
        case t
        when FFI::Pointer
          @rr = t
        else
          raise OpenSCAP::OpenSCAPError, "Cannot initialize TestResult with #{t}"
        end
      end

      def id
        OpenSCAP.xccdf_rule_result_get_idref @rr
      end

      def destroy
        OpenSCAP.xccdf_rule_result_free @rr
      end
    end
  end

  attach_function :xccdf_rule_result_get_idref, [:pointer], :string
  attach_function :xccdf_rule_result_free, [:pointer], :void
end
