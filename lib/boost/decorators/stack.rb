# frozen_string_literal: true

require "forwardable"

module Boost
  module Decorators
    class Stack < ::Module
      include Decorator
      include Enumerable
      extend Forwardable

      def_delegators :@decorators, :first, :last, :pop, :shift, :index, :size, :length, :empty?, :include?, :delete, :delete_at,
                     :each

      def initialize(decorators = [])
        super()
        @decorators = Array(decorators)
      end

      def reverse!
        @decorators.reverse!
        self
      end

      def reverse
        dup.reverse!
      end

      def push(*decorators)
        @decorators.push(*decorators)
        self
      end
      alias << push

      def unshift(*decorators)
        @decorators.unshift(*decorators)
        self
      end

      def clear
        @decorators.clear
        self
      end

      def [](index)
        case index
        when Integer
          @decorators[index]
        when Range
          self.class.new(@decorators[index])
        when Module
          matches = @decorators.select { |d| index === d }
          matches.empty? ? nil : self.class.new(matches)
        end
      end

      def []=(index, decorator)
        raise ArgumentError, "Index must be an Integer" unless index.is_a?(Integer)

        @decorators[index] = decorator
      end

      def insert(index, *decorators)
        @decorators.insert(index, *decorators)
        self
      end

      def insert_before(target, *decorators)
        idx = index(target)
        idx ? insert(idx, *decorators) : nil
      end

      def insert_after(target, *decorators)
        idx = index(target)
        idx ? insert(idx + 1, *decorators) : nil
      end

      def replace(target, replacement)
        case target
        when Integer
          @decorators[target] = replacement
        when Module
          @decorators.map! { |d| target === d ? replacement : d }
        else
          @decorators.map! { |d| d == target ? replacement : d }
        end
        self
      end

      def decorate(obj, ...)
        super do
          @decorators.each { |d| d.decorate(obj, ...) }
        end
      end
    end
  end
end
