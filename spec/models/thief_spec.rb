require "rails_helper"

RSpec.describe Thief, type: :model do
  describe "attributes" do
    it "has health_points, strength, dexterity, and intelligence attributes" do
      thief = Thief.new
      expect(thief).to respond_to(:health_points)
      expect(thief).to respond_to(:strength)
      expect(thief).to respond_to(:dexterity)
      expect(thief).to respond_to(:intelligence)
    end
  end

  describe "#attack_modifier" do
    it "calculates the attack modifier correctly" do
      thief = Thief.new
      expect(thief.attack_modifier).to eq((4 * 0.25) + 10 + (4 * 0.25))
    end
  end

  describe "#speed_modifier" do
    it "calculates the speed modifier correctly" do
      thief = Thief.new
      expect(thief.speed_modifier).to eq(10 * 0.8)
    end
  end
end
