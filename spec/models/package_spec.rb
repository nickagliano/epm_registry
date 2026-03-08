require "rails_helper"

RSpec.describe Package, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:versions).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:package) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:license) }
    it { is_expected.to validate_presence_of(:repository) }
    it { is_expected.to validate_uniqueness_of(:name) }

    it "accepts valid names" do
      expect(build(:package, name: "my_package")).to be_valid
      expect(build(:package, name: "todo")).to be_valid
      expect(build(:package, name: "epm_registry2")).to be_valid
    end

    it "rejects names starting with a digit" do
      expect(build(:package, name: "1bad")).not_to be_valid
    end

    it "rejects names with hyphens" do
      expect(build(:package, name: "bad-name")).not_to be_valid
    end

    it "rejects uppercase names" do
      expect(build(:package, name: "BadName")).not_to be_valid
    end
  end

  describe ".search" do
    let!(:todo) { create(:package, name: "todo", description: "A minimal todo list harness") }
    let!(:notes) { create(:package, name: "notes", description: "Personal notes harness") }

    it "matches on name" do
      expect(Package.search("todo")).to include(todo)
      expect(Package.search("todo")).not_to include(notes)
    end

    it "matches on description" do
      expect(Package.search("notes")).to include(notes)
    end

    it "is case insensitive" do
      expect(Package.search("TODO")).to include(todo)
    end
  end
end
