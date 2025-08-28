require "rails_helper"

RSpec.describe Mage, type: :model do
  describe "attributes" do
    it "has health_points, strength, dexterity, and intelligence attributes" do
      mage = Mage.new
      expect(mage).to respond_to(:health_points)
      expect(mage).to respond_to(:strength)
      expect(mage).to respond_to(:dexterity)
      expect(mage).to respond_to(:intelligence)
    end
  end

  describe "#attack_modifier" do
    it "calculates the attack modifier correctly" do
      mage = Mage.new
      expect(mage.attack_modifier).to eq((5 * 0.2) + (6 * 0.2) + (10 * 1.2))
    end
  end

  describe "#speed_modifier" do
    it "calculates the speed modifier correctly" do
      mage = Mage.new
      expect(mage.speed_modifier).to eq((6 * 0.4) + (5 * 0.1))
    end
  end
end