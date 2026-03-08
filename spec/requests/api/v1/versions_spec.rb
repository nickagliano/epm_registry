require "rails_helper"

RSpec.describe "Api::V1::Versions", type: :request do
  describe "GET /api/v1/packages/:package_id/versions/:version_number" do
    it "returns the version" do
      package = create(:package, name: "todo")
      create(:version, package: package, version: "0.1.0")

      get "/api/v1/packages/todo/versions/0.1.0"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["version"]).to eq("0.1.0")
    end

    it "returns 404 for unknown package" do
      get "/api/v1/packages/nonexistent/versions/0.1.0"
      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 for unknown version" do
      create(:package, name: "todo")
      get "/api/v1/packages/todo/versions/9.9.9"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /api/v1/packages/:package_id/versions/:version_number/yank" do
    it "yanks the version" do
      package = create(:package, name: "todo")
      create(:version, package: package, version: "0.1.0")

      patch "/api/v1/packages/todo/versions/0.1.0/yank"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["yanked"]).to be true
    end

    it "persists the yank" do
      package = create(:package, name: "todo")
      create(:version, package: package, version: "0.1.0")

      patch "/api/v1/packages/todo/versions/0.1.0/yank"
      expect(package.versions.find_by(version: "0.1.0").yanked).to be true
    end

    it "returns 422 when already yanked" do
      package = create(:package, name: "todo")
      create(:version, package: package, version: "0.1.0", yanked: true)

      patch "/api/v1/packages/todo/versions/0.1.0/yank"
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns 404 for unknown version" do
      create(:package, name: "todo")
      patch "/api/v1/packages/todo/versions/9.9.9/yank"
      expect(response).to have_http_status(:not_found)
    end

    it "excludes yanked version from package listing" do
      package = create(:package, name: "todo")
      create(:version, package: package, version: "0.1.0")

      patch "/api/v1/packages/todo/versions/0.1.0/yank"
      get "/api/v1/packages/todo"
      versions = JSON.parse(response.body)["versions"]
      expect(versions).to be_empty
    end
  end
end
