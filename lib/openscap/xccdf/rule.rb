#
# Copyright (c) 2015 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

require 'openscap/exceptions'
require 'openscap/xccdf/item'

module OpenSCAP
  module Xccdf
    class Rule < Item
      def severity
        severity = OpenSCAP.xccdf_rule_get_severity(@raw)
        severity_mapping = {
          :xccdf_level_not_defined => 'Not defined',
          :xccdf_unknown => 'Unknown',
          :xccdf_info => 'Info',
          :xccdf_low => 'Low',
          :xccdf_medium => 'Medium',
          :xccdf_high => 'High'
        }
        severity_mapping[severity] ? severity_mapping[severity] : severity_mapping[:xccdf_unknown]
      end
    end
  end
  XccdfSeverity = enum(
    :xccdf_level_not_defined, 0,
    :xccdf_unknown, 1,
    :xccdf_info,
    :xccdf_low,
    :xccdf_medium,
    :xccdf_high
  )
  attach_function :xccdf_rule_get_severity, [:pointer], XccdfSeverity
end
