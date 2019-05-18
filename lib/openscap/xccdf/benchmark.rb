# frozen_string_literal: true

require 'openscap/source'
require 'openscap/xccdf/profile'
require 'openscap/xccdf/item'

module OpenSCAP
  module Xccdf
    class Benchmark
      attr_reader :raw

      def initialize(p)
        case p
        when OpenSCAP::Source
          @raw = OpenSCAP.xccdf_benchmark_import_source p.raw
        else
          raise OpenSCAP::OpenSCAPError,
                "Cannot initialize OpenSCAP::Xccdf::Benchmark with '#{p}'"
        end
        OpenSCAP.raise! if @raw.null?
      end

      def profiles
        @profiles ||= profiles_init
      end

      def items
        @items ||= items_init
      end

      def destroy
        OpenSCAP.xccdf_benchmark_free @raw
        @raw = nil
      end

      private

      def profiles_init
        profiles = {}
        profit = OpenSCAP.xccdf_benchmark_get_profiles raw
        while OpenSCAP.xccdf_profile_iterator_has_more profit
          profile_p = OpenSCAP.xccdf_profile_iterator_next profit
          profile = OpenSCAP::Xccdf::Profile.new profile_p
          profiles[profile.id] = profile
        end
        OpenSCAP.xccdf_profile_iterator_free profit
        profiles
      end

      def items_init
        items = {}
        items_it = OpenSCAP.xccdf_item_get_content raw
        while OpenSCAP.xccdf_item_iterator_has_more items_it
          item_p = OpenSCAP.xccdf_item_iterator_next items_it
          item = OpenSCAP::Xccdf::Item.build item_p
          items.merge! item.sub_items
          items[item.id] = item
          # TODO: iterate through childs
        end
        OpenSCAP.xccdf_item_iterator_free items_it
        items
      end
    end
  end

  attach_function :xccdf_benchmark_import_source, [:pointer], :pointer
  attach_function :xccdf_benchmark_free, [:pointer], :void

  attach_function :xccdf_benchmark_get_profiles, [:pointer], :pointer
  attach_function :xccdf_profile_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_profile_iterator_next, [:pointer], :pointer
  attach_function :xccdf_profile_iterator_free, [:pointer], :void
end
