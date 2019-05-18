# frozen_string_literal: true

require 'ffi'

module OpenSCAP
  module LibC
    extend FFI::Library

    ffi_lib FFI::Library::LIBC

    attach_function :free, [:pointer], :void
  end
end
