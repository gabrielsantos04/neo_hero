require "rails_helper"

RSpec.describe Character, type: :model do
  describe "attributes" do
    it "has health_points, strength, dexterity, and intelligence attributes" do
      character = Character.new("Character", "warrior")
      expect(character).to respond_to(:name)
      expect(character).to respond_to(:id)
      expect(character).to respond_to(:alive)
      expect(character).to respond_to(:current_health_points)
    end
  end

  describe "initialization" do
    context "when initialized as a warrior" do
      it "initializes with default values" do
        character = Character.new("Character", "warrior")
        expect(character.job.strength).to eq(10)
        expect(character.job.dexterity).to eq(5)
        expect(character.job.intelligence).to eq(5)
        expect(character.alive).to be true
        expect(character.current_health_points).to eq(20)
        expect(character.job).to be_a(Warrior)
      end
    end

    context "when initialized as a mage" do
      it "initializes with mage attributes" do
        character = Character.new("Character", "mage")
        expect(character.job.strength).to eq(5)
        expect(character.job.dexterity).to eq(6)
        expect(character.job.intelligence).to eq(10)
        expect(character.current_health_points).to eq(12)
        expect(character.job).to be_a(Mage)
      end
    end

    context "when initialized as a thief" do
      it "initializes with thief attributes" do
        character = Character.new("Character", "thief")
        expect(character.job.strength).to eq(4)
        expect(character.job.dexterity).to eq(10)
        expect(character.job.intelligence).to eq(4)
        expect(character.current_health_points).to eq(15)
        expect(character.job).to be_a(Thief)
      end
    end

    context "when initialized with an invalid job type" do
      it "add error job" do
        character = Character.new("Character", "invalid_job")

        expect(character.errors).not_to be_empty
        expect(character.errors).to eq({:job=>"is not valid"})
      end
    end

    context "when initialized without a name" do
      it "add error name_blank" do
        character = Character.new("", "warrior")

        expect(character.errors).not_to be_empty
        expect(character.errors[:name_blank]).to eq("can't be blank")
      end
    end

    context "when initialized with a name longer than 20 characters" do
      it "add error name_long" do
        character = Character.new("a" * 21, "warrior")

        expect(character.errors).not_to be_empty
        expect(character.errors[:name_long]).to eq("is too long (maximum is 15 characters)")
      end
    end

    context "when initialized with a name containing invalid characters" do
      it "add error name_characters" do
        character = Character.new("Invalid Name!", "warrior")

        expect(character.errors).not_to be_empty
        expect(character.errors[:name_characters]).to eq("can only contain letters and underscores")
      end
    end
  end
end
