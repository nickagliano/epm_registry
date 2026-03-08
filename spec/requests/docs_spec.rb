require "rails_helper"

RSpec.describe "Docs", type: :request do
  describe "GET /docs" do
    it "redirects to the what-is-eps page" do
      get "/docs"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("What is EPS?")
    end
  end

  describe "GET /docs/:path" do
    it "renders a concept page" do
      get "/docs/concepts/ports"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Ports")
    end

    it "renders an ADR page" do
      get "/docs/adr/0008-harness-definition"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("ADR-0008")
    end

    it "includes sidebar navigation" do
      get "/docs"
      expect(response.body).to include("What is EPS?")
      expect(response.body).to include("Architecture Decisions")
    end

    it "returns 404 for a nonexistent doc" do
      get "/docs/concepts/does-not-exist"
      expect(response).to have_http_status(:not_found)
    end

    it "blocks path traversal attempts" do
      get "/docs/../../Gemfile"
      expect(response).to have_http_status(:not_found)
    end
  end
end
