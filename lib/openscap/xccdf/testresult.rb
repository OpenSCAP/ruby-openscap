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
require 'openscap/xccdf'
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

      def score
        @score ||= score_init
      end

      def score!(benchmark)
        #recalculate the scores in the scope of given benchmark
        @score = nil
        OpenSCAP.raise! unless OpenSCAP.xccdf_result_recalculate_scores(@tr, benchmark.raw) == 0
        score
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

      def score_init
        scores = Hash.new
        scorit = OpenSCAP.xccdf_result_get_scores(@tr)
        while OpenSCAP.xccdf_score_iterator_has_more(scorit) do
          s = OpenSCAP.xccdf_score_iterator_next(scorit)
          scores[OpenSCAP.xccdf_score_get_system(s)] = {
            :system => OpenSCAP.xccdf_score_get_system(s),
            :value => OpenSCAP.xccdf_score_get_score(s),
            :max => OpenSCAP.xccdf_score_get_maximum(s)
            }
        end
        OpenSCAP.xccdf_score_iterator_free(scorit)
        scores
      end
    end
  end

  attach_function :xccdf_result_import_source, [:pointer], :pointer
  attach_function :xccdf_result_free, [:pointer], :void
  attach_function :xccdf_result_get_id, [:pointer], :string
  attach_function :xccdf_result_get_profile, [:pointer], :string
  attach_function :xccdf_result_recalculate_scores, [:pointer, :pointer], :int

  attach_function :xccdf_result_get_rule_results, [:pointer] ,:pointer
  attach_function :xccdf_rule_result_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_rule_result_iterator_free, [:pointer], :void
  attach_function :xccdf_rule_result_iterator_next, [:pointer], :pointer

  attach_function :xccdf_result_get_scores, [:pointer], :pointer
  attach_function :xccdf_score_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_score_iterator_free, [:pointer], :void
  attach_function :xccdf_score_iterator_next, [:pointer], :pointer
  attach_function :xccdf_score_get_system, [:pointer], :string
  attach_function :xccdf_score_get_score, [:pointer], OpenSCAP::Xccdf::NUMERIC
  attach_function :xccdf_score_get_maximum, [:pointer], OpenSCAP::Xccdf::NUMERIC
end
