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
  module Xccdf

    class Session
      def initialize(input_filename)
        @input_filename = input_filename
        @s = OpenSCAP.xccdf_session_new(input_filename)
        if @s.null?
          OpenSCAP.raise!
        end
      end

      def sds?
        return OpenSCAP.xccdf_session_is_sds(@s)
      end

      def load
        if OpenSCAP.xccdf_session_load(@s) != 0
          OpenSCAP.raise!
        end
      end

      def evaluate
        if OpenSCAP.xccdf_session_evaluate(@s) != 0
          OpenSCAP.raise!
        end
      end

      def export_results(rds_file=nil, xccdf_file=nil, report_file=nil,
        oval_results=false, oval_variables=false, engines_results=false)
        OpenSCAP.raise! unless OpenSCAP.xccdf_session_set_arf_export(@s, rds_file)
        OpenSCAP.raise! unless OpenSCAP.xccdf_session_set_xccdf_export(@s, xccdf_file)
        OpenSCAP.raise! unless OpenSCAP.xccdf_session_set_report_export(@s, report_file)
        OpenSCAP.xccdf_session_set_oval_results_export(@s, oval_results)
        OpenSCAP.xccdf_session_set_oval_variables_export(@s, oval_variables)
        OpenSCAP.xccdf_session_set_check_engine_plugins_results_export(@s, engines_results)

        OpenSCAP.raise! unless OpenSCAP.xccdf_session_export_oval(@s) == 0
        OpenSCAP.raise! unless OpenSCAP.xccdf_session_export_check_engine_plugins(@s) == 0
        OpenSCAP.raise! unless OpenSCAP.xccdf_session_export_xccdf(@s) == 0
        OpenSCAP.raise! unless OpenSCAP.xccdf_session_export_arf(@s) == 0
      end

      def finalize(s)
        OpenSCAP.xccdf_session_free(s.s)
      end
    end
  end

  attach_function :xccdf_session_new, [:string], :pointer
  attach_function :xccdf_session_free, [:pointer], :void
  attach_function :xccdf_session_load, [:pointer], :int
  attach_function :xccdf_session_evaluate, [:pointer], :int
  attach_function :xccdf_session_export_oval, [:pointer], :int
  attach_function :xccdf_session_export_check_engine_plugins, [:pointer], :int
  attach_function :xccdf_session_export_xccdf, [:pointer], :int
  attach_function :xccdf_session_export_arf, [:pointer], :int

  attach_function :xccdf_session_is_sds, [:pointer], :bool

  attach_function :xccdf_session_set_arf_export, [:pointer, :string], :bool
  attach_function :xccdf_session_set_xccdf_export, [:pointer, :string], :bool
  attach_function :xccdf_session_set_report_export, [:pointer, :string], :bool
  attach_function :xccdf_session_set_oval_variables_export, [:pointer, :bool], :void
  attach_function :xccdf_session_set_oval_results_export, [:pointer, :bool], :void
  attach_function :xccdf_session_set_check_engine_plugins_results_export, [:pointer, :bool], :void
end