# frozen_string_literal: true

module OpenSCAP
  class Text
    attr_reader :raw

    def initialize
      @raw = OpenSCAP.oscap_text_new
    end

    def text=(str)
      OpenSCAP.raise! unless OpenSCAP.oscap_text_set_text(raw, str)
    end

    def text
      OpenSCAP.oscap_text_get_text(raw)
    end

    def destroy
      OpenSCAP.oscap_text_free(raw)
      @raw = nil
    end
  end

  class TextList
    def initialize(oscap_text_iterator)
      @raw = oscap_text_iterator
    end

    def plaintext(lang = nil)
      OpenSCAP.oscap_textlist_get_preferred_plaintext @raw, lang
    end

    def destroy
      OpenSCAP.oscap_text_iterator_free @raw
    end
  end

  attach_function :oscap_text_new, [], :pointer
  attach_function :oscap_text_set_text, [:pointer, :string], :bool
  attach_function :oscap_text_get_text, [:pointer], :string
  attach_function :oscap_text_free, [:pointer], :void

  attach_function :oscap_textlist_get_preferred_plaintext, [:pointer, :string], :string
  attach_function :oscap_text_iterator_free, [:pointer], :void
end
