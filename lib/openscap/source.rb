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

require 'openscap'

module OpenSCAP
  class Source
    attr_reader :raw

    def initialize(param)
      case param
      when nil
        raise OpenSCAPError, "No filename specified!"
      when String
        @raw = OpenSCAP.oscap_source_new_from_file(param)
      when Hash
        @raw = OpenSCAP.oscap_source_new_from_memory param[:content], param[:content].length, param[:path]
      when FFI::Pointer
        @raw = param
      else
        raise OpenSCAP::OpenSCAPError, "Cannot initialize OpenSCAP::Source with '#{param}'"
      end
      OpenSCAP.raise! if @raw.null?
    end

    def type
      OpenSCAP.oscap_document_type_to_string(OpenSCAP.oscap_source_get_scap_type(@raw))
    end

    def validate!
      e = FFI::MemoryPointer.new(:char, 4096)
      if 0 != OpenSCAP.oscap_source_validate(@raw, XmlReporterCallback, e)
        OpenSCAP.raise! e.read_string
      end

    end

    def save(filepath=nil)
      OpenSCAP.raise! unless OpenSCAP.oscap_source_save_as(@raw, filepath) == 0
    end

    def destroy
      OpenSCAP.oscap_source_free(@raw)
      @raw = nil
    end
  end

  attach_function :oscap_source_new_from_file, [:string], :pointer
  attach_function :oscap_source_new_from_memory, [:string, :int, :string], :pointer
  attach_function :oscap_source_get_scap_type, [:pointer], :int
  attach_function :oscap_source_free, [:pointer], :void
  attach_function :oscap_source_save_as, [:pointer, :string], :int

  callback :xml_reporter, [:string, :int, :string, :pointer], :int
  attach_function :oscap_source_validate, [:pointer, :xml_reporter, :pointer], :int
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