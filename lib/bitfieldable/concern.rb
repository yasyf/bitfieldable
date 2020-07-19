# frozen_string_literal: true

require 'active_support/core_ext'
require 'active_support/concern'

module Bitfieldable
  module Concern
    extend ActiveSupport::Concern

    class_methods do
      def parse_spec(spec)
        spec.each_with_object({}) do |(attr, fields), hsh|
          fields.each_with_index do |field, idx|
            hsh[field] = {
              attribute: attr,
              index: idx,
            }
          end
        end.to_h.with_indifferent_access
      end

      def bitfields(**spec)
        return if spec.blank?
        @bitfields = parse_spec spec
        define_bitfield_methods!
      end

      def bitfield_spec
        instance_variable_defined?(:@bitfields) ? @bitfields : {}
      end

      def bitfield_keys
        bitfield_spec.keys.map(&:to_sym)
      end

      def define_bitfield_methods!
        bitfield_spec.each do |field, spec|
          define_method(field) { read_bitfield(spec) }
          define_method("#{field}?") { read_bitfield(spec) }
          define_method("#{field}!") { write_bitfield(spec, true) }
          define_method("flip_#{field}!") { write_bitfield(spec, !read_bitfield(spec)) }
          define_method("#{field}=") { |value| write_bitfield(spec, value) }
        end
      end
    end

    private

    def read_bitfield(spec)
      value = send(spec[:attribute]) || 0
      value[spec[:index]].positive?
    end

    def write_bitfield(spec, new_value)
      value = send(spec[:attribute]) || 0
      if new_value
        value |= 1 << spec[:index]
      else
        value &= ~(1 << spec[:index])
      end
      send("#{spec[:attribute]}=", value)
      value.positive?
    end
  end
end
