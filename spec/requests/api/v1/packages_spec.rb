require "rails_helper"

RSpec.describe "Api::V1::Packages", type: :request do
  describe "GET /api/v1/packages" do
    it "returns an empty array when no packages exist" do
      get "/api/v1/packages"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end

    it "returns all packages sorted by name" do
      create(:package, name: "zzz_package")
      create(:package, name: "aaa_package")

      get "/api/v1/packages"
      names = JSON.parse(response.body).map { |p| p["name"] }
      expect(names).to eq(%w[aaa_package zzz_package])
    end

    it "filters by query string" do
      create(:package, name: "todo", description: "A todo list")
      create(:package, name: "notes", description: "Personal notes")

      get "/api/v1/packages", params: { q: "todo" }
      names = JSON.parse(response.body).map { |p| p["name"] }
      expect(names).to eq(["todo"])
    end

    it "returns expected fields" do
      create(:package, name: "todo")
      get "/api/v1/packages"
      pkg = JSON.parse(response.body).first
      expect(pkg.keys).to include("id", "name", "description", "authors", "license", "repository", "platforms", "created_at", "updated_at")
    end
  end

  describe "GET /api/v1/packages/:id" do
    it "returns the package with versions" do
      package = create(:package, name: "todo")
      create(:version, package: package, version: "0.1.0")

      get "/api/v1/packages/todo"
      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body["name"]).to eq("todo")
      expect(body["versions"].length).to eq(1)
      expect(body["versions"].first["version"]).to eq("0.1.0")
    end

    it "excludes yanked versions" do
      package = create(:package, name: "todo")
      create(:version, package: package, version: "0.1.0")
      create(:version, package: package, version: "0.2.0", yanked: true)

      get "/api/v1/packages/todo"
      versions = JSON.parse(response.body)["versions"].map { |v| v["version"] }
      expect(versions).to eq(["0.1.0"])
    end

    it "returns 404 for unknown package" do
      get "/api/v1/packages/nonexistent"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/packages" do
    let(:payload) do
      {
        name: "new_package",
        description: "A new EPS package",
        license: "MIT",
        repository: "https://github.com/example/new_package",
        authors: [ "someone" ],
        version: "0.1.0",
        git_url: "https://github.com/example/new_package",
        commit_sha: "abc123",
        manifest_hash: "sha256:xyz",
        platforms: [ "aarch64-apple-darwin" ],
        system_deps: {}
      }
    end

    it "creates a new package and version, returns 201" do
      post "/api/v1/packages", params: payload, as: :json
      expect(response).to have_http_status(:created)
      expect(Package.find_by(name: "new_package")).to be_present
    end

    it "returns version fields in the response" do
      post "/api/v1/packages", params: payload, as: :json
      body = JSON.parse(response.body)
      expect(body["version"]).to eq("0.1.0")
      expect(body["commit_sha"]).to eq("abc123")
    end

    it "adds a new version to an existing package" do
      package = create(:package, name: "new_package")
      create(:version, package: package, version: "0.1.0")

      post "/api/v1/packages", params: payload.merge(version: "0.2.0"), as: :json
      expect(response).to have_http_status(:created)
      expect(package.versions.count).to eq(2)
    end

    it "returns 409 when version already exists" do
      package = create(:package, name: "new_package")
      create(:version, package: package, version: "0.1.0")

      post "/api/v1/packages", params: payload, as: :json
      expect(response).to have_http_status(:conflict)
    end

    it "returns 422 when required fields are missing" do
      post "/api/v1/packages", params: { name: "incomplete" }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
