Spree::Api::TaxonsController.class_eval do

  def index
    if taxonomy
      @taxons = taxonomy.root.children
    else
      if params[:ids]
        @taxons = Spree::Taxon.includes(:children).joins(:translations).with_locales(I18n.locale).accessible_by(current_ability, :read).where(id: params[:ids].split(','))
      else
        @taxons = Spree::Taxon.includes(:children).joins(:translations).with_locales(I18n.locale).accessible_by(current_ability, :read).order(:parent_id, '"spree_taxon_translations".name ASC').ransack(params[:q]).result
      end
    end

    @taxons = @taxons.page(params[:page]).per(params[:per_page])
    respond_with(@taxons)
  end


end
