# frozen_string_literal: true

# A monkey-patch for Active Record that enables association auto-decoration.
module ActiveDecorator
  module Monkey
    module ActiveRecord
      module Associations
        module Association
          def target
            ActiveDecorator::Decorator.instance.decorate_association(owner, super)
          end
        end

        # @see https://github.com/rails/rails/commit/03855e790de2224519f55382e3c32118be31eeff
        if Rails.version.to_f < 4.1
          module CollectionAssociation
            private
            def first_or_last(*)
              ActiveDecorator::Decorator.instance.decorate_association(owner, super)
            end
          end
        elsif Rails.version.to_f < 5.1
          module CollectionAssociation
            private
            def first_nth_or_last(*)
              ActiveDecorator::Decorator.instance.decorate_association(owner, super)
            end
          end
        end

        module CollectionProxy
          if Rails.version.to_f >= 4.0
            def take(*)
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end
          else
            # To propagate the decorated mark from association to relation
            def scoped
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end

            def find(*)
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end
          end

          if Rails.version.to_f >= 5.1
            def last(*)
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end

            private

            def find_nth_with_limit(*)
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end

            def find_nth_from_last(*)
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end
          end
        end

        module CollectionAssociation
          private

          def build_record(*)
            ActiveDecorator::Decorator.instance.decorate_association(@owner, super)
          end
        end
      end

      module AssociationRelation
        def take(*)
          ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
        end

        if Rails::VERSION::MAJOR <= 4
          protected

          if (Rails::VERSION::MAJOR == 4) && (Rails::VERSION::MINOR == 0)
            def find_first
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end
          end

          def find_last
            ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
          end
        end

        private

        def find_nth_with_limit(*)
          ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
        end

        def find_nth_from_last(*)
          ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
        end
      end
    end
  end
end
