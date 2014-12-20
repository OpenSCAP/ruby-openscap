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

require 'openscap/source'

module OpenSCAP
  module DS
    class Sds
      attr_reader :raw

      def initialize(param)
        @raw = case param
               when OpenSCAP::Source
                 OpenSCAP.ds_sds_session_new_from_source param.raw
               when Hash
                 OpenSCAP.ds_sds_session_new_from_source param[:source].raw
               end
        OpenSCAP.raise! if @raw.null?
      end

      def select_checklist(p = {})
        source_p = OpenSCAP.ds_sds_session_select_checklist(@raw, p[:datastream_id], p[:component_id], nil)
        OpenSCAP::Source.new source_p
      end

      def select_checklist!(p = {})
        checklist = select_checklist(p)
        OpenSCAP.raise! if checklist.nil? or checklist.raw.null?
        checklist
      end

      def html_guide(profile = nil)
        html = OpenSCAP.ds_sds_session_get_html_guide(@raw, profile)
        OpenSCAP.raise! if html.nil?
        html
      end

      def destroy
        OpenSCAP.ds_sds_session_free(@raw)
        @raw = nil
      end
    end
  end

  attach_function :ds_sds_session_new_from_source, [:pointer], :pointer
  attach_function :ds_sds_session_free, [:pointer], :void
  attach_function :ds_sds_session_select_checklist, [:pointer, :string, :string, :string], :pointer
  attach_function :ds_sds_session_get_html_guide, [:pointer, :string], :string
end
