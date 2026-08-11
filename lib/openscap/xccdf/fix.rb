# frozen_string_literal: true

module OpenSCAP
  module Xccdf
    class Fix
      def initialize(raw)
        raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with '#{raw}'" \
          unless raw.is_a?(FFI::Pointer)

        @raw = raw
      end

      def id
        OpenSCAP.xccdf_fix_get_id(@raw)
      end

      def platform
        OpenSCAP.xccdf_fix_get_platform(@raw)
      end

      # system is a reserved word in Rails, so didn't use it
      def fix_system
        OpenSCAP.xccdf_fix_get_system(@raw)
      end

      def content
        OpenSCAP.xccdf_fix_get_content(@raw)
      end

      def to_hash
        {
          id:,
          platform:,
          system: fix_system,
          content:
        }
      end
    end
  end
  attach_function :xccdf_fix_get_id, [:pointer], :string
  attach_function :xccdf_fix_get_platform, [:pointer], :string
  attach_function :xccdf_fix_get_system, [:pointer], :string
  attach_function :xccdf_fix_get_content, [:pointer], :string
end
