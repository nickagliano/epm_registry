class PackagesController < ApplicationController
  def index
    @packages = Package.by_name.includes(:versions)
    @packages = @packages.search(params[:q]) if params[:q].present?
  end

  def show
    @package = Package.includes(:versions).find_by!(name: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to packages_path, alert: "Package not found"
  end
end
