require "rails_helper"

RSpec.describe "Packages (web UI)", type: :request do
  describe "GET /" do
    it "renders the package index" do
      get "/"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("EPM Registry")
    end

    it "lists packages by name" do
      create(:package, name: "todo", description: "A todo list")
      get "/"
      expect(response.body).to include("todo")
      expect(response.body).to include("A todo list")
    end

    it "filters by search query" do
      create(:package, name: "todo")
      create(:package, name: "notes")
      get "/", params: { q: "todo" }
      expect(response.body).to include("todo")
      expect(response.body).not_to include("notes")
    end
  end

  describe "GET /packages/:name" do
    it "renders the package detail page" do
      package = create(:package, name: "todo", description: "A todo list")
      create(:version, package: package, version: "0.1.0")
      get "/packages/todo"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("todo")
      expect(response.body).to include("0.1.0")
    end

    it "redirects to index for an unknown package" do
      get "/packages/nonexistent"
      expect(response).to redirect_to(packages_path)
    end
  end
end
