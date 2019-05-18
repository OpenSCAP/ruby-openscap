# frozen_string_literal: true

require 'openscap/exceptions'
require 'openscap/text'

module OpenSCAP
  module Xccdf
    class RuleResult
      def initialize(t)
        case t
        when FFI::Pointer
          @rr = t
        else
          raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with #{t}"
        end
      end

      def id
        OpenSCAP.xccdf_rule_result_get_idref @rr
      end

      def result
        OpenSCAP.xccdf_test_result_type_get_text \
          OpenSCAP.xccdf_rule_result_get_result(@rr)
      end

      def override!(param)
        validate_xccdf_result! param[:new_result]
        t = OpenSCAP::Text.new
        t.text = param[:raw_text]
        unless OpenSCAP.xccdf_rule_result_override(@rr,
                                                   OpenSCAP::XccdfResult[param[:new_result]],
                                                   param[:time], param[:authority], t.raw)
          OpenSCAP.raise!
        end
      end

      def destroy
        OpenSCAP.xccdf_rule_result_free @rr
      end

      private

      def validate_xccdf_result!(result_label)
        if OpenSCAP::XccdfResult[result_label] > OpenSCAP::XccdfResult[:fixed]
          raise OpenSCAPError, "Could not recognize result type: '#{result_label}'"
        end
      end
    end
  end

  attach_function :xccdf_rule_result_get_idref, [:pointer], :string
  attach_function :xccdf_rule_result_free, [:pointer], :void
  attach_function :xccdf_rule_result_get_result, [:pointer], :int
  attach_function :xccdf_test_result_type_get_text, [:int], :string

  XccdfResult = enum(:pass, 1,
                     :fail,
                     :error,
                     :unknown,
                     :notapplicable,
                     :notchecked,
                     :notselected,
                     :informational,
                     :fixed)
  attach_function :xccdf_rule_result_override,
                  [:pointer, XccdfResult, :string, :string, :pointer], :bool
end
