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

module OpenSCAP
  class Source
    def initialize(param)
      case param
      when nil
        raise OpenSCAPError, "No filename specified!"
      when String
        @s = OpenSCAP.oscap_source_new_from_file(param)
      when Hash
        @s = OpenSCAP.oscap_source_new_from_memory param[:content], param[:content].length, param[:path]
      else
        raise OpenSCAP::OpenSCAPError, "Cannot initialize OpenSCAP::Source with '#{param}'"
      end
      OpenSCAP.raise! if @s.null?
    end

    def raw
      @s
    end

    def destroy
      OpenSCAP.oscap_source_free(@s)
      @s = nil
    end
  end

  attach_function :oscap_source_new_from_file, [:string], :pointer
  attach_function :oscap_source_new_from_memory, [:string, :int, :string], :pointer
  attach_function :oscap_source_free, [:pointer], :void
end