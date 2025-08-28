require "rails_helper"

RSpec.describe Hero, type: :model do
  describe "attributes" do
    it "has health_points, strength, dexterity, and intelligence attributes" do
      hero = Hero.new
      expect(hero).to respond_to(:health_points)
      expect(hero).to respond_to(:strength)
      expect(hero).to respond_to(:dexterity)
      expect(hero).to respond_to(:intelligence)
    end
  end

  describe "#attack_modifier" do
    it "raises NotImplementedError" do
      hero = Hero.new
      expect { hero.attack_modifier }.to raise_error(NotImplementedError)
    end
  end

  describe "#speed_modifier" do
    it "raises NotImplementedError" do
      hero = Hero.new
      expect { hero.speed_modifier }.to raise_error(NotImplementedError)
    end
  end

  describe "#level_up" do
    it "raises NotImplementedError" do
      hero = Hero.new
      expect { hero.level_up }.to raise_error(NotImplementedError)
    end
  end

  describe "#as_json" do
    it "includes class_name, attack_modifier, and speed_modifier in the JSON representation" do
      hero = Warrior.new
      json = hero.as_json

      expect(json[:class_name]).to eq("Warrior")
      expect(json[:attack_modifier]).to eq(9)
      expect(json[:speed_modifier]).to eq(4)
    end
  end
end