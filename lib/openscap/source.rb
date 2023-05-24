# frozen_string_literal: true

require 'openscap'

module OpenSCAP
  class Source
    attr_reader :raw

    def initialize(param)
      case param
      when nil
        raise OpenSCAPError, 'No filename specified!'
      when String
        @raw = OpenSCAP.oscap_source_new_from_file(param)
      when Hash
        @raw = create_from_memory param
      when FFI::Pointer
        @raw = param
      else
        raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with '#{param}'"
      end
      OpenSCAP.raise! if @raw.null?
    end

    def type
      OpenSCAP.oscap_document_type_to_string(OpenSCAP.oscap_source_get_scap_type(@raw))
    end

    def validate!
      e = FFI::MemoryPointer.new(:char, 4096)
      OpenSCAP.raise!(e.read_string) unless OpenSCAP.oscap_source_validate(@raw, XmlReporterCallback, e).zero?
    end

    def save(filepath = nil)
      OpenSCAP.raise! unless OpenSCAP.oscap_source_save_as(@raw, filepath).zero?
    end

    def destroy
      OpenSCAP.oscap_source_free(@raw)
      @raw = nil
    end

    private

    def create_from_memory(param)
      param[:length] = param[:content].length unless param[:length]
      buf = FFI::MemoryPointer.new(:char, param[:length])
      buf.put_bytes(0, param[:content])
      OpenSCAP.oscap_source_new_from_memory param[:content], param[:length], param[:path]
    end
  end

  attach_function :oscap_source_new_from_file, [:string], :pointer
  attach_function :oscap_source_new_from_memory, %i[pointer int string], :pointer
  attach_function :oscap_source_get_scap_type, [:pointer], :int
  attach_function :oscap_source_free, [:pointer], :void
  attach_function :oscap_source_save_as, %i[pointer string], :int

  callback :xml_reporter, %i[string int string pointer], :int
  attach_function :oscap_source_validate, %i[pointer xml_reporter pointer], :int
  XmlReporterCallback = proc do |filename, line_number, error_message, e|
    offset = e.get_string(0).length
    msg = "#{filename}:#{line_number}: #{error_message}"
    if msg.length + offset + 1 < e.size
      e.put_string(offset, msg)
      0
    else
      1
    end
  end
end
