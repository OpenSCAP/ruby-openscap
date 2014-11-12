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
        @raw = OpenSCAP.ds_sds_session_new_from_source param[:source].raw
        OpenSCAP.raise! if @raw.null?
      end

      def destroy
        OpenSCAP.ds_rds_session_free(@raw)
        @raw = nil
      end
    end
  end

  attach_function :ds_sds_session_new_from_source, [:pointer], :pointer
  attach_function :ds_sds_session_free, [:pointer], :void
end