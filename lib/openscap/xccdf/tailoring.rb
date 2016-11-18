#
# Copyright (c) 2016 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

require 'openscap/source'
require 'openscap/xccdf/profile'

module OpenSCAP
  module Xccdf
    class Tailoring
      attr_reader :raw

      def initialize(source, benchmark)
        case source
        when OpenSCAP::Source
          @raw = OpenSCAP.xccdf_tailoring_import_source source.raw, benchmark
        else
          raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with '#{source}'"
        end
        OpenSCAP.raise! if @raw.null?
      end

      def profiles
        @profiles ||= profiles_init
      end

      def destroy
        OpenSCAP.xccdf_tailoring_free @raw
        @raw = nil
      end

      private

      def profiles_init
        profiles = {}
        profit = OpenSCAP.xccdf_tailoring_get_profiles raw
        while OpenSCAP.xccdf_profile_iterator_has_more profit
          profile_p = OpenSCAP.xccdf_profile_iterator_next profit
          profile = OpenSCAP::Xccdf::Profile.new profile_p
          profiles[profile.id] = profile
        end
        OpenSCAP.xccdf_profile_iterator_free profit
        profiles
      end
    end
  end

  attach_function :xccdf_tailoring_import_source, [:pointer, :pointer], :pointer
  attach_function :xccdf_tailoring_free, [:pointer], :void

  attach_function :xccdf_tailoring_get_profiles, [:pointer], :pointer
  attach_function :xccdf_profile_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_profile_iterator_next, [:pointer], :pointer
  attach_function :xccdf_profile_iterator_free, [:pointer], :void
end
