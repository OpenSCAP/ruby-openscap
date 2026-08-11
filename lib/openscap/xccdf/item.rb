# frozen_string_literal: true

require 'openscap/exceptions'
require 'openscap/text'
require 'openscap/xccdf/group'
require 'openscap/xccdf/rule'
require 'openscap/xccdf/reference'

module OpenSCAP
  module Xccdf
    class Item
      def self.build(t)
        raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} with #{t}" \
          unless t.is_a?(FFI::Pointer)

        # This is Abstract base class that enables you to build its child
        case OpenSCAP.xccdf_item_get_type t
        when :group
          OpenSCAP::Xccdf::Group.new t
        when :rule
          OpenSCAP::Xccdf::Rule.new t
        else
          raise OpenSCAP::OpenSCAPError, "Unknown #{self.class.name} type: #{OpenSCAP.xccdf_item_get_type t}"
        end
      end

      def initialize(t)
        if instance_of?(OpenSCAP::Xccdf::Item)
          raise OpenSCAP::OpenSCAPError, "Cannot initialize #{self.class.name} abstract base class."
        end

        @raw = t
      end

      def id
        OpenSCAP.xccdf_item_get_id @raw
      end

      def title(prefered_lang = nil)
        textlist = OpenSCAP::TextList.new(OpenSCAP.xccdf_item_get_title(@raw))
        title = textlist.plaintext(prefered_lang)
        textlist.destroy
        title
      end

      def description(prefered_lang = nil)
        textlist = OpenSCAP::TextList.new(OpenSCAP.xccdf_item_get_description(@raw))
        description = textlist.plaintext(prefered_lang)
        textlist.destroy
        description
      end

      def rationale(prefered_lang = nil)
        textlist = OpenSCAP::TextList.new(OpenSCAP.xccdf_item_get_rationale(@raw))
        rationale = textlist.plaintext(prefered_lang)
        textlist.destroy
        rationale
      end

      def references
        refs = []
        refs_it = OpenSCAP.xccdf_item_get_references(@raw)
        while OpenSCAP.oscap_reference_iterator_has_more refs_it
          ref = OpenSCAP::Xccdf::Reference.new(OpenSCAP.oscap_reference_iterator_next(refs_it))
          refs << ref
        end
        OpenSCAP.oscap_reference_iterator_free refs_it
        refs
      end

      def sub_items
        @sub_items ||= sub_items_init
      end

      def destroy
        OpenSCAP.xccdf_item_free @raw
        @raw = nil
      end

      private

      def sub_items_init
        collect = {}
        items_it = OpenSCAP.xccdf_item_get_content @raw
        while OpenSCAP.xccdf_item_iterator_has_more items_it
          item_p = OpenSCAP.xccdf_item_iterator_next items_it
          item = OpenSCAP::Xccdf::Item.build item_p
          collect.merge! item.sub_items
          collect[item.id] = item
        end
        OpenSCAP.xccdf_item_iterator_free items_it
        collect
      end
    end
  end

  attach_function :xccdf_item_get_id, [:pointer], :string
  attach_function :xccdf_item_get_content, [:pointer], :pointer
  attach_function :xccdf_item_free, [:pointer], :void
  attach_function :xccdf_item_get_title, [:pointer], :pointer
  attach_function :xccdf_item_get_description, [:pointer], :pointer
  attach_function :xccdf_item_get_rationale, [:pointer], :pointer

  XccdfItemType = enum(:benchmark, 0x0100,
                       :profile, 0x0200,
                       :result, 0x0400,
                       :rule, 0x1000,
                       :group, 0x2000,
                       :value, 0x4000)
  attach_function :xccdf_item_get_type, [:pointer], XccdfItemType

  attach_function :xccdf_item_iterator_has_more, [:pointer], :bool
  attach_function :xccdf_item_iterator_next, [:pointer], :pointer
  attach_function :xccdf_item_iterator_free, [:pointer], :void

  attach_function :xccdf_item_get_references, [:pointer], :pointer
  attach_function :oscap_reference_iterator_has_more, [:pointer], :bool
  attach_function :oscap_reference_iterator_next, [:pointer], :pointer
  attach_function :oscap_reference_iterator_free, [:pointer], :void
end
