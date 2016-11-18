#
# Copyright (c) 2014--2016 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

require 'openscap/ds/sds'
require 'openscap/source'
require 'openscap/xccdf/testresult'
require 'openscap/libc'

module OpenSCAP
  module DS
    class Arf
      attr_reader :source

      def initialize(param)
        case param
        when String, Hash
          @source = OpenSCAP::Source.new(param)
          @session = OpenSCAP.ds_rds_session_new_from_source @source.raw
        else
          raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with '#{param}'"
        end
        OpenSCAP.raise! if @session.null?
      end

      def destroy
        OpenSCAP.ds_rds_session_free(@session)
        @session = nil
        @source.destroy
      end

      def test_result(id = nil)
        source = OpenSCAP.ds_rds_session_select_report(@session, id)
        OpenSCAP.raise! if source.nil?
        OpenSCAP::Xccdf::TestResult.new(source)
      end

      def test_result=(tr)
        source = tr.source
        OpenSCAP.raise! unless OpenSCAP.ds_rds_session_replace_report_with_source(@session, source.raw).zero?
      end

      def report_request(id = nil)
        source_p = OpenSCAP.ds_rds_session_select_report_request(@session, id)
        source = OpenSCAP::Source.new source_p
        OpenSCAP::DS::Sds.new(source)
      end

      def html
        html_p = OpenSCAP.ds_rds_session_get_html_report @session
        OpenSCAP.raise! if OpenSCAP.error?
        return nil if html_p.null?
        html = html_p.read_string
        OpenSCAP::LibC.free html_p
        html
      end
    end
  end

  attach_function :ds_rds_session_new_from_source, [:pointer], :pointer
  attach_function :ds_rds_session_free, [:pointer], :void
  attach_function :ds_rds_session_select_report, [:pointer, :string], :pointer
  attach_function :ds_rds_session_replace_report_with_source, [:pointer, :pointer], :int
  attach_function :ds_rds_session_select_report_request, [:pointer, :string], :pointer
  attach_function :ds_rds_session_get_html_report, [:pointer], :pointer
end
