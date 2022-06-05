# frozen_string_literal: true

# Locations CRUD API
class Api::V2::LocationsController < ApplicationApiController
  include Api::V2::Concerns::Pagination
  include Api::V2::Concerns::Import

  def index
    authorize! :index, Location
    filters = locations_filters(params.permit(disabled: {}))
    filtered_locations = Location.list(filters, params.merge(order_by: order_by))
    @total = filtered_locations.size
    @locations = filtered_locations.paginate(pagination)
    @with_hierarchy = params[:hierarchy] == 'true'
  end

  def create
    authorize!(:create, Location) && validate_json!(field_schema, location_params)
    @location = Location.new_with_properties(location_params)
    @location.save!
    status = params[:data][:id].present? ? 204 : 200
    render :create, status: status
  end

  def show
    authorize! :show, Location
    @location = Location.find(params[:id])
  end

  def update
    authorize!(:update, Location) && validate_json!(field_schema, location_params)
    @location = Location.find(params[:id])
    @location.update_properties(location_params)
    @location.save!
    render 'show'
  end

  def destroy
    authorize! :enable_disable_record, Location
    @location = Location.find(params[:id])
    @location.destroy!
  end

  def update_bulk
    authorize! :update, Location
    @locations = Location.update_in_batches(location_bulk_params)
    @total = @locations.size
    render :index
  end

  def location_district
    @districts = Location.pluck_location_districts
  end

  def per
    @per ||= (params[:per]&.to_i || 100)
  end
  
  def location_town
    if params[:location_code].present?
      @towns = Location.get_location_towns(params[:location_code])
    else
      @towns = Location.get_location_all_towns
    end
  end

  protected

  def locations_filters(params)
    return if params.blank?

    { disabled: params[:disabled].values }
  end

  def location_params
    @location_params ||= params.require(:data).permit(Location.permitted_api_params)
  end

  def location_bulk_params
    params.permit(data: Location.permitted_api_params).require(:data)
  end

  def order_by
    Location::ORDER_BY_FIELD_MAP[params[:order_by]&.to_sym] || params[:order_by]
  end

  def importer
    Importers::CsvHxlLocationImporter
  end

  def field_schema
    Location::LOCATION_FIELDS_SCHEMA
  end
end
