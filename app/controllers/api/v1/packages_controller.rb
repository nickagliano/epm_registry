module Api
  module V1
    class PackagesController < ApplicationController
      skip_forgery_protection

      def index
        packages = Package.by_name.includes(:versions)
        packages = packages.search(params[:q]) if params[:q].present?
        render json: packages.map { |p| package_json(p) }
      end

      def show
        package = Package.find_by!(name: params[:id])
        render json: package_json(package, include_versions: true)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "package not found" }, status: :not_found
      end

      def create
        package = Package.find_or_initialize_by(name: package_params[:name])
        version = package.versions.build(version_params)

        if package.new_record?
          package.assign_attributes(package_params)
        end

        if package.save
          render json: version_json(version), status: :created
        elsif version.errors[:version].include?("has already been taken")
          render json: { error: "version already exists" }, status: :conflict
        else
          render json: { error: (package.errors.full_messages + version.errors.full_messages).uniq }, status: :unprocessable_entity
        end
      end

      private

      def package_params
        params.require(:package).permit(:name, :description, :license, :homepage, :repository, authors: [])
      rescue ActionController::ParameterMissing
        params.permit(:name, :description, :license, :homepage, :repository, authors: [])
      end

      def version_params
        params.permit(:version, :git_url, :commit_sha, :manifest_hash, platforms: [], system_deps: {})
      end

      def package_json(package, include_versions: false)
        json = {
          id: package.id,
          name: package.name,
          description: package.description,
          authors: package.authors,
          license: package.license,
          homepage: package.homepage,
          repository: package.repository,
          platforms: package.versions.not_yanked.flat_map(&:platforms).uniq,
          created_at: package.created_at,
          updated_at: package.updated_at
        }
        json[:versions] = package.versions.not_yanked.map { |v| version_json(v) } if include_versions
        json
      end

      def version_json(version)
        {
          id: version.id,
          package_id: version.package_id,
          version: version.version,
          git_url: version.git_url,
          commit_sha: version.commit_sha,
          manifest_hash: version.manifest_hash,
          yanked: version.yanked,
          platforms: version.platforms,
          system_deps: version.system_deps || {},
          published_at: version.created_at
        }
      end
    end
  end
end
