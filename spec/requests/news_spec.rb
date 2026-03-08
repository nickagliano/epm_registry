require "rails_helper"

RSpec.describe "News", type: :request do
  describe "GET /news" do
    it "renders the news index" do
      get "/news"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("News")
    end

    it "lists posts newest first" do
      get "/news"
      expect(response.body).to include("Hello, World")
    end
  end

  describe "GET /news/:slug" do
    it "renders a post" do
      get "/news/hello-world"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello, World")
      expect(response.body).to include("March")
    end

    it "returns 404 for a nonexistent post" do
      get "/news/does-not-exist"
      expect(response).to have_http_status(:not_found)
    end

    it "blocks invalid slug characters" do
      get "/news/../../Gemfile"
      expect(response).to have_http_status(:not_found)
    end
  end
end
