class Admin::FiltersController < Admin::ApplicationController
  before_action :authorize_catalog_filter

  def sort
    Filter.sort(params[:filter])
    render :nothing => true
  end

  def index
    load_filters
  end

  def new
    build_filter
  end

  def create
    build_filter
    save_filter || render(:new)
  end

  def edit
    load_filter
    @filter_catalogue_brand_link_type_categories = @filter.catalogue_brand_link_type_categories
    build_filter
  end

  def update
    load_filter
    build_filter
    check_property_changed
    save_filter || render(:edit)
  end

  def destroy
    load_filter
    @filter.destroy
    redirect_to [:admin, :filters]
  end

private

  def load_filters
    @filters ||= filter_scope.to_a
  end

  def load_filter
    @filter ||= filter_scope.find(params[:id])
  end

  def filter_scope
    # TODO: make policy_scope work
    # policy_scope(Filter).all.order(:position)
    Filter.where(tenant_id: Tenant.current_id).order(:position)
  end

  def build_filter
    @filter ||= filter_scope.build
    @filter.attributes = filter_params
  end

  def check_property_changed
    @filter.update_attribute(:measurement_units, nil) if @filter.changed.include? 'property_id'
  end

  def save_filter
    apply_redirect if @filter.save
  end

  def apply_redirect(notice = '')
    if params[:apply].present?
      redirect_to [:edit, :admin, @filter], notice: notice
    else
      redirect_to [:admin, :filters], notice: notice
    end
  end

  def authorize_catalog_filter
    authorize :catalog_filter, :user_has_rights?
  end

  def filter_params
    return {} if params[:filter].blank?
    params.require(:filter).permit(:title, :property_id, :widget, :position, { :measurement_units => []})
  end
end
