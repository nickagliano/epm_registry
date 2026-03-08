module Api
  module V1
    class VersionsController < ApplicationController
      skip_forgery_protection

      def show
        package = Package.find_by!(name: params[:package_id])
        version = package.versions.find_by!(version: params[:version_number])
        render json: version_json(version)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "not found" }, status: :not_found
      end

      def yank
        package = Package.find_by!(name: params[:package_id])
        version = package.versions.find_by!(version: params[:version_number])

        if version.yanked?
          render json: { error: "already yanked" }, status: :unprocessable_entity
        else
          version.update!(yanked: true)
          render json: version_json(version)
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "not found" }, status: :not_found
      end

      private

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
