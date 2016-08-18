class AbilityDecorator
  include CanCan::Ability

  def initialize(user)
    user ||= Spree.user_class.new
    if user.designer? && user.approved?
      can [:admin, :index], :translations
      can :manage, :sales
      can [:admin, :index], :dashboard

      can [:admin, :index, :new, :create], Spree::Product
      can [:admin, :manage], Spree::Product do |product|
        product.is_by_user?(user)
      end

      can [:admin, :create], Spree::StockMovement

      can [:admin, :manage], Spree::Variant do |variant|
        variant.product.is_by_user?(user)
      end

      can [:admin, :new, :create], Spree::Image
      can [:admin, :manage], Spree::Image do |image|
        image.viewable.is_a?(Spree::Variant) && image.viewable.product.is_by_user?(user)
      end

      can [:admin, :manage], Spree::Product::Translation do |product_translation|
        product_id = product_translation.spree_product_id
        Spree::Product.exist?(product_id) && Spree::Product.find(product_id).is_by_user?(user)
      end

      if user.designer_label.present?

        can [:admin, :index, :edit], Spree::Order, Spree::Order.containing_designer(user.designer_label) do |order|
          order.contains_products_from_designer(user.designer_label)
        end

        can [:admin, :update], Spree::Shipment, Spree::Shipment.containing_designer(user.designer_label) do |shipment|
          shipment.contains_products_from_designer(user.designer_label)
        end

        can [:admin, :update], Spree::Price do |price|
          price.variant.product.present? && price.variant.product.designer_label_id == user.designer_label_id
        end

      end

      can [:admin, :edit, :update], Nelou::DesignerLabel, Nelou::DesignerLabel.where(user_id: user.id) do |designer_label|
        designer_label.user_id == user.id
      end

      can [:admin, :edit, :update], Nelou::DesignerLabel::Translation do |designer_label_translation|
        designer_label_id = designer_label_translation.spree_designer_label_id
        Nelou::DesignerLabel.exist?(designer_label_id) && Nelou::DesignerLabel.find(designer_label_id).spree_user_id == user.id
      end

      can [:modify], Spree::OptionType
      can [:modify], Spree::Classification
    end

    can :show, Nelou::DesignerLabel, active: true

    # Remove stock from app
    cannot [:stock], Spree::Product
    cannot :manage, Spree::ProductProperty

    # Disallow editing or deleting of admin and designer roles
    cannot [:update, :destroy], Spree::Role, name: %w(admin designer)
  end
end

# Has to be here, otherwise code reloading will break authorization
Spree::Ability.register_ability(AbilityDecorator)
