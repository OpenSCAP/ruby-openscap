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

require 'openscap/source'
require 'openscap/exceptions'
require 'openscap/xccdf/ruleresult'

module OpenSCAP
  module Xccdf
    class TestResult
      attr_reader :rr

      def initialize(t)
        case t
        when OpenSCAP::Source
          @tr = OpenSCAP.xccdf_result_import_source(t.raw)
          OpenSCAP.raise! if @tr.null?
        when FFI::Pointer
          @tr = OpenSCAP.xccdf_result_import_source(t)
          OpenSCAP.raise! if @tr.null?
        else
          raise OpenSCAP::OpenSCAPError, "Cannot initialize TestResult with #{t}"
        end
        init_ruleresults
      end

      def id
        return OpenSCAP.xccdf_result_get_id(@tr)
      end

      def profile
        return OpenSCAP.xccdf_result_get_profile(@tr)
      end

      def destroy
        OpenSCAP.xccdf_result_free @tr
        @tr = nil
      end

      private
      def init_ruleresults
        @rr = Hash.new
        rr_it = OpenSCAP.xccdf_result_get_rule_results(@tr)
        while OpenSCAP.xccdf_rule_result_iterator_has_more(rr_it) do
          rr_raw = OpenSCAP.xccdf_rule_result_iterator_next(rr_it)
          rr = OpenSCAP::Xccdf::RuleResult.new rr_raw
          @rr[rr.id] = rr
        end
        OpenSCAP.xccdf_rule_result_iterator_free(rr_it)
      end
    end
  end

  attach_function :xccdf_result_import_source, [:pointer], :pointer
  attach_function :xccdf_result_free, [:pointer], :void
  attach_function :xccdf_result_get_id, [:pointer], :string
  attach_function :xccdf_result_get_profile, [:pointer], :string

  attach_function :xccdf_result_get_rule_results, [:pointer] ,:pointer
  attach_function :xccdf_rule_result_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_rule_result_iterator_free, [:pointer], :void
  attach_function :xccdf_rule_result_iterator_next, [:pointer], :pointer
end