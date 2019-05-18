# frozen_string_literal: true

require 'openscap/text'

module OpenSCAP
  module Xccdf
    class Profile
      attr_reader :raw

      def initialize(p)
        case p
        when FFI::Pointer
          @raw = p
        else
          raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with #{p}"
        end
      end

      def id
        OpenSCAP.xccdf_profile_get_id raw
      end

      def title(prefered_lang = nil)
        textlist = OpenSCAP::TextList.new(OpenSCAP.xccdf_profile_get_title(@raw))
        title = textlist.plaintext(prefered_lang)
        textlist.destroy
        title
      end
    end
  end

  attach_function :xccdf_profile_get_id, [:pointer], :string
  attach_function :xccdf_profile_get_title, [:pointer], :pointer
end
