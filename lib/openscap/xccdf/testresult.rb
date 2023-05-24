# frozen_string_literal: true

require 'openscap/source'
require 'openscap/exceptions'
require 'openscap/xccdf'
require 'openscap/xccdf/ruleresult'

module OpenSCAP
  module Xccdf
    class TestResult
      attr_reader :rr, :raw

      def initialize(t)
        case t
        when OpenSCAP::Source
          @raw = OpenSCAP.xccdf_result_import_source(t.raw)
          OpenSCAP.raise! if @raw.null?
        when FFI::Pointer
          @raw = OpenSCAP.xccdf_result_import_source(t)
          OpenSCAP.raise! if @raw.null?
        else
          raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with #{t}"
        end
        init_ruleresults
      end

      def id
        OpenSCAP.xccdf_result_get_id(@raw)
      end

      def profile
        OpenSCAP.xccdf_result_get_profile(@raw)
      end

      def score
        @score ||= score_init
      end

      def score!(benchmark)
        # recalculate the scores in the scope of given benchmark
        @score = nil
        OpenSCAP.raise! unless OpenSCAP.xccdf_result_recalculate_scores(@raw, benchmark.raw).zero?
        score
      end

      def source
        source_p = OpenSCAP.xccdf_result_export_source(raw, nil)
        OpenSCAP::Source.new source_p
      end

      def destroy
        OpenSCAP.xccdf_result_free @raw
        @raw = nil
      end

      private

      def init_ruleresults
        @rr = {}
        rr_it = OpenSCAP.xccdf_result_get_rule_results(@raw)
        while OpenSCAP.xccdf_rule_result_iterator_has_more(rr_it)
          rr_raw = OpenSCAP.xccdf_rule_result_iterator_next(rr_it)
          rr = OpenSCAP::Xccdf::RuleResult.new rr_raw
          @rr[rr.id] = rr
        end
        OpenSCAP.xccdf_rule_result_iterator_free(rr_it)
      end

      def score_init
        scores = {}
        scorit = OpenSCAP.xccdf_result_get_scores(@raw)
        while OpenSCAP.xccdf_score_iterator_has_more(scorit)
          s = OpenSCAP.xccdf_score_iterator_next(scorit)
          scores[OpenSCAP.xccdf_score_get_system(s)] = {
            system: OpenSCAP.xccdf_score_get_system(s),
            value: OpenSCAP.xccdf_score_get_score(s),
            max: OpenSCAP.xccdf_score_get_maximum(s)
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
  attach_function :xccdf_result_recalculate_scores, %i[pointer pointer], :int
  attach_function :xccdf_result_export_source, %i[pointer string], :pointer

  attach_function :xccdf_result_get_rule_results, [:pointer], :pointer
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
