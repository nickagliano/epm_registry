FactoryBot.define do
  factory :version do
    association :package
    sequence(:version) { |n| "0.#{n}.0" }
    git_url { "https://github.com/example/#{package.name}" }
    commit_sha { SecureRandom.hex(20) }
    manifest_hash { "sha256:#{SecureRandom.hex(32)}" }
    platforms { [ "aarch64-apple-darwin" ] }
    system_deps { {} }
    yanked { false }
  end
end
