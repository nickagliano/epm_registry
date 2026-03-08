class Rack::Attack
  # Throttle publish attempts by IP — 10 per minute
  throttle("publish/ip", limit: 10, period: 60) do |req|
    req.ip if req.post? && req.path == "/api/v1/packages"
  end

  # Throttle general API requests by IP — 300 per minute
  throttle("api/ip", limit: 300, period: 60) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  # Return 429 JSON instead of the default plain-text response
  self.throttled_responder = lambda do |_req|
    [
      429,
      { "Content-Type" => "application/json" },
      [ { error: "rate limit exceeded — try again later" }.to_json ]
    ]
  end
end
