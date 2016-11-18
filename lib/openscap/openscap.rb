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

require 'ffi'

module OpenSCAP
  extend FFI::Library
  ffi_lib ['libopenscap.so.8', 'openscap']

  def self.error?
    oscap_err
  end

  def self.full_error
    err = oscap_err_get_full_error
    err.null? ? nil : err.read_string
  end

  def self.raise!(msg = nil)
    err = full_error
    if err.nil?
      err = msg.nil? ? '(unknown error)' : msg
    else
      err += "\n#{msg}"
    end
    raise OpenSCAPError, err
  end

  attach_function :oscap_init, [], :void
  attach_function :oscap_cleanup, [], :void
  attach_function :oscap_get_version, [], :string

  attach_function :oscap_document_type_to_string, [:int], :string

  attach_function :oscap_err, [], :bool
  attach_function :oscap_err_get_full_error, [], :pointer
  private_class_method :oscap_err, :oscap_err_get_full_error
end
