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
require 'openscap/xccdf/benchmark'

module OpenSCAP
  module Xccdf
    class PolicyModel
      def initialize(b)
        case b
        when OpenSCAP::Xccdf::Benchmark
          @raw = OpenSCAP.xccdf_policy_model_new(b.raw)
        else
          fail OpenSCAP::OpenSCAPError,
               "Cannot initialize OpenSCAP::Xccdf::PolicyModel with '#{b}'"
        end
        OpenSCAP.raise! if @raw.null?
      end

      def destroy
        OpenSCAP.xccdf_policy_model_free @raw
        @raw = nil
      end
    end
  end

  attach_function :xccdf_policy_model_new, [:pointer], :pointer
  attach_function :xccdf_policy_model_free, [:pointer], :void
end
