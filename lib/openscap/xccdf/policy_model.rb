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
require 'openscap/xccdf/policy'

module OpenSCAP
  module Xccdf
    class PolicyModel
      attr_reader :raw

      def initialize(b)
        case b
        when OpenSCAP::Xccdf::Benchmark
          @raw = OpenSCAP.xccdf_policy_model_new(b.raw)
        else
          raise OpenSCAP::OpenSCAPError,
                "Cannot initialize OpenSCAP::Xccdf::PolicyModel with '#{b}'"
        end
        OpenSCAP.raise! if @raw.null?
      end

      def policies
        @policies ||= policies_init
      end

      def destroy
        OpenSCAP.xccdf_policy_model_free @raw
        @raw = nil
      end

      private

      def policies_init
        policies = {}
        OpenSCAP.raise! unless OpenSCAP.xccdf_policy_model_build_all_useful_policies(raw).zero?
        polit = OpenSCAP.xccdf_policy_model_get_policies raw
        while OpenSCAP.xccdf_policy_iterator_has_more polit
          policy_p = OpenSCAP.xccdf_policy_iterator_next polit
          policy = OpenSCAP::Xccdf::Policy.new policy_p
          policies[policy.id] = policy
        end
        OpenSCAP.xccdf_policy_iterator_free polit
        policies
      end
    end
  end

  attach_function :xccdf_policy_model_new, [:pointer], :pointer
  attach_function :xccdf_policy_model_free, [:pointer], :void
  attach_function :xccdf_policy_model_build_all_useful_policies, [:pointer], :int

  attach_function :xccdf_policy_model_get_policies, [:pointer], :pointer
  attach_function :xccdf_policy_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_policy_iterator_next, [:pointer], :pointer
  attach_function :xccdf_policy_iterator_free, [:pointer], :void
end
