# frozen_string_literal: true

module Boost
  module Module
    module ClassHooks
      def included(base)
        super
        return unless base.is_a?(Class)

        self_idx = ancestors.index(self)
        included_modules.each_with_index do |m, idx|
          class_included(base) if self_idx == idx && respond_to?(:class_included)
          m.class_included(base) if m.respond_to?(:class_included)
        end
      end

      def prepended(base)
        super
        return unless base.is_a?(Class)

        self_idx = ancestors.index(self)
        included_modules.each_with_index do |m, idx|
          class_prepended(base) if self_idx == idx && respond_to?(:class_prepended)
          m.class_prepended(base) if m.respond_to?(:class_prepended)
        end
      end
    end
  end
end
