require "rails_helper"

RSpec.describe Version, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:package) }
  end

  describe "validations" do
    subject { build(:version) }

    it { is_expected.to validate_presence_of(:version) }
    it { is_expected.to validate_presence_of(:git_url) }
    it { is_expected.to validate_presence_of(:commit_sha) }
    it { is_expected.to validate_presence_of(:manifest_hash) }
    it "rejects duplicate version within the same package" do
      package = create(:package)
      create(:version, package: package, version: "1.0.0")
      duplicate = build(:version, package: package, version: "1.0.0")
      expect(duplicate).not_to be_valid
    end

    it "allows the same version string across different packages" do
      create(:version, package: create(:package), version: "1.0.0")
      other = build(:version, package: create(:package), version: "1.0.0")
      expect(other).to be_valid
    end
  end

  describe "defaults" do
    it "is not yanked by default" do
      expect(build(:version).yanked).to be false
    end
  end

  describe ".not_yanked" do
    let(:package) { create(:package) }

    it "excludes yanked versions" do
      active = create(:version, package: package, version: "0.1.0")
      yanked = create(:version, package: package, version: "0.2.0", yanked: true)

      expect(Version.not_yanked).to include(active)
      expect(Version.not_yanked).not_to include(yanked)
    end
  end
end
