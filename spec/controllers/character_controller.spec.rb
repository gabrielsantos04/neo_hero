require "rails_helper"

RSpec.describe CharacterController, type: :controller do
  describe "GET #show" do
    context "when character exists" do
      let(:character) { Character.new("Character", "warrior") }

      before do
        allow(controller).to receive(:characters_list).and_return([character.as_json])
      end

      it "returns the character as JSON" do
        get :show, params: { id: character.id }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:id]).to eq(character.id)
        expect(json_response[:job][:class_name]).to eq("Warrior")
        expect(json_response[:job][:health_points]).to eq(20)
        expect(json_response[:job][:strength]).to eq(10)
        expect(json_response[:job][:dexterity]).to eq(5)
        expect(json_response[:job][:intelligence]).to eq(5)
      end
    end

    context "when character does not exist" do
      before do
        allow(controller).to receive(:characters_list).and_return([])
      end

      it "returns a not found error" do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to eq("Character not found")
      end
    end
  end

  describe "GET #get_class_list" do
    let(:expected_result) do
      [
        {
          "health_points": 20,
          "strength": 10,
          "dexterity": 5,
          "intelligence": 5,
          "class_name": "Warrior",
          "attack_modifier": 9.0,
          "speed_modifier": 4.0
        },
        {
          "health_points": 12,
          "strength": 5,
          "dexterity": 6,
          "intelligence": 10,
          "class_name": "Mage",
          "attack_modifier": 14.2,
          "speed_modifier": 2.9000000000000004
        },
        {
          "health_points": 15,
          "strength": 4,
          "dexterity": 10,
          "intelligence": 4,
          "class_name": "Thief",
          "attack_modifier": 12.0,
          "speed_modifier": 8.0
        }
      ]
    end

    it "returns the list of character classes" do
      get :get_class_list
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response).to match_array(expected_result)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          character: { name: "Hero", job: "warrior" }
        }
      end

      it "creates a new character and returns it as JSON" do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:name]).to eq("Hero")
        expect(json_response[:job][:class_name]).to eq("Warrior")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { anyparam: { name: "", job: "unknown" } }
      end

      it "rescue the error" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to eq("Invalid parameters")
      end
    end
  end

  describe "GET #get_characters_list" do
    let(:character1) { Character.new("Character", "warrior") }
    let(:character2) { Character.new("Characterb", "mage") }
    let(:expected_result) do
      [
        {
          "name": "Character",
          "job": {
            "health_points": 20,
            "strength": 10,
            "dexterity": 5,
            "intelligence": 5,
            "class_name": "Warrior",
            "attack_modifier": 9.0,
            "speed_modifier": 4.0
          },
          "id": character1.id,
          "alive": true,
          "errors": {},
          "current_health_points": 20
        },
        {
          "name": "Characterb",
          "job": {
            "health_points": 12,
            "strength": 5,
            "dexterity": 6,
            "intelligence": 10,
            "class_name": "Mage",
            "attack_modifier": 14.2,
            "speed_modifier": 2.9000000000000004
          },
          "id": character2.id,
          "alive": true,
          "errors": {},
          "current_health_points": 12
        }
      ]
    end

    it "returns the list of characters" do
      allow(controller).to receive(:characters_list).and_return([character1.as_json, character2.as_json])

      get :get_characters_list
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response).to match_array(expected_result)
    end
  end

  describe "POST #combat" do
    let(:char1) { Character.new("Heroa", "warrior") }
    let(:char2) { Character.new("Herob", "mage") }
    let(:alive1) { true }
    let(:alive2) { true }

    before do
      allow(controller)
        .to receive(:characters_list).and_return([
                                                   char1.as_json.with_indifferent_access.merge(alive: alive1),
                                                   char2.as_json.with_indifferent_accessbund.merge(alive: alive2)
                                                 ])
    end

    context "when both characters are alive" do
      it "initiates combat and returns battle log" do
        post :combat, params: { char1: char1.id, char2: char2.id }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to have_key(:battle_log)
        expect(json_response[:battle_log].first).to include("Battle between")
      end
    end

    context "when one character is dead" do
      context "char1 is dead" do
        let(:alive1) { false }

        it "returns an error if char1 is dead" do
          post :combat, params: { char1: char1.id, char2: char2.id }
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:error]).to eq("#{char1.name} id dead and cannot fight")
        end
      end

      context "char2 is dead" do
        let(:alive2) { false }

        it "returns an error if char2 is dead" do
          post :combat, params: { char1: char1.id, char2: char2.id }
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:error]).to eq("#{char2.name} id dead and cannot fight")
        end
      end
    end

    context "when one character does not exist" do
      it "returns a not found error" do
        post :combat, params: { char1: 999, char2: char2.id }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to eq("One or both characters not found")
      end
    end
  end
end
