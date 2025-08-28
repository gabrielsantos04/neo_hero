require "rails_helper"

RSpec.describe Warrior, type: :model do
  describe "attributes" do
    it "has health_points, strength, dexterity, and intelligence attributes" do
      warrior = Warrior.new
      expect(warrior).to respond_to(:health_points)
      expect(warrior).to respond_to(:strength)
      expect(warrior).to respond_to(:dexterity)
      expect(warrior).to respond_to(:intelligence)
    end
  end

  describe "#attack_modifier" do
    it "calculates the attack modifier correctly" do
      warrior = Warrior.new
      expect(warrior.attack_modifier).to eq((10 * 0.8) + (5 * 0.2))
    end
  end

  describe "#speed_modifier" do
    it "calculates the speed modifier correctly" do
      warrior = Warrior.new
      expect(warrior.speed_modifier).to eq((5 * 0.6) + (5 * 0.2))
    end
  end
end
