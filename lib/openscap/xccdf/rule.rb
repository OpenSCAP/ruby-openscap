# frozen_string_literal: true

require 'openscap/exceptions'
require 'openscap/xccdf/item'
require 'openscap/xccdf/fix'
require 'openscap/xccdf/ident'

module OpenSCAP
  module Xccdf
    class Rule < Item
      def severity
        severity = OpenSCAP.xccdf_rule_get_severity(@raw)
        severity_mapping = {
          :xccdf_level_not_defined => 'Not defined',
          :xccdf_unknown => 'Unknown',
          :xccdf_info => 'Info',
          :xccdf_low => 'Low',
          :xccdf_medium => 'Medium',
          :xccdf_high => 'High'
        }
        severity_mapping[severity] || severity_mapping[:xccdf_unknown]
      end

      def fixes
        fixes = []
        items_it = OpenSCAP.xccdf_rule_get_fixes(@raw)
        while OpenSCAP.xccdf_fix_iterator_has_more items_it
          fixes << OpenSCAP::Xccdf::Fix.new(OpenSCAP.xccdf_fix_iterator_next(items_it))
        end
        OpenSCAP.xccdf_fix_iterator_free items_it
        fixes
      end

      def idents
        idents = []
        idents_it = OpenSCAP.xccdf_rule_get_idents(@raw)
        while OpenSCAP.xccdf_ident_iterator_has_more idents_it
          idents << OpenSCAP::Xccdf::Ident.new(OpenSCAP.xccdf_ident_iterator_next(idents_it))
        end
        OpenSCAP.xccdf_ident_iterator_free idents_it
        idents
      end
    end
  end
  XccdfSeverity = enum(
    :xccdf_level_not_defined, 0,
    :xccdf_unknown, 1,
    :xccdf_info,
    :xccdf_low,
    :xccdf_medium,
    :xccdf_high
  )
  attach_function :xccdf_rule_get_severity, [:pointer], XccdfSeverity
  attach_function :xccdf_rule_get_fixes, [:pointer], :pointer
  attach_function :xccdf_fix_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_fix_iterator_next, [:pointer], :pointer
  attach_function :xccdf_fix_iterator_free, [:pointer], :void

  attach_function :xccdf_rule_get_idents, [:pointer], :pointer
  attach_function :xccdf_ident_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_ident_iterator_next, [:pointer], :pointer
  attach_function :xccdf_ident_iterator_free, [:pointer], :void
end
