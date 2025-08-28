class CharacterController < ApplicationController
  def create
    @character = Character.new(character_params[:name], character_params[:job])
    if @character.errors.empty?
      session[:characters] ||= []
      session[:characters] << @character if @character.errors.empty?

      render json: @character, status: :created
    else
      render json: @character.errors, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    render json: { error: 'Invalid parameters' }, status: :bad_request
  end

  def get_class_list
    list = [Warrior.new.as_json, Mage.new.as_json, Thief.new.as_json].flatten
    render json: list, status: :ok
  end

  def get_characters_list
    render json: characters_list, status: :ok
  end

  def show
    character = characters_list.find { |char| char["id"] == params[:id].to_i }

    if character
      render json: character, status: :ok
    else
      render json: { error: 'Character not found' }, status: :not_found
    end
  end

  def delete_all_characters
    session[:characters] = []
    render json: { message: 'All characters deleted' }, status: :ok
  end

  def combat
    char1 = characters_list.find { |char| char["id"] == params[:char1].to_i }
    char2 = characters_list.find { |char| char["id"] == params[:char2].to_i }

    if char1.nil? || char2.nil?
      render json: { error: 'One or both characters not found' }, status: :not_found
      return
    end

    if char1["alive"] == false
      render json: { error: "#{char1['name']} id dead and cannot fight" }, status: :unprocessable_entity
      return
    end

    if char2["alive"] == false
      render json: { error: "#{char2['name']} id dead and cannot fight" }, status: :unprocessable_entity
      return
    end

    battle(char1.with_indifferent_access, char2.with_indifferent_access)
  end

  private

  def battle(char1, char2)
    @battle_log = ["Battle between #{char1['name']} (#{char1['job']['class_name']}) - #{char1['current_health_points']} HP and #{char2['name']} (#{char2['job']['class_name']}) #{char2['current_health_points']} HP begins!"]
    turn_order = who_goes_first(char1, char2)
    battle_round(turn_order[0], turn_order[1])
  end

  def spell_weapon(class_name)
    case class_name.downcase
    when 'mage'
      Faker::Games::LeagueOfLegends.summoner_spell
    when 'warrior'
      Faker::Games::DnD.melee_weapon
    when 'thief'
      Faker::Games::DnD.ranged_weapon
    else
      'attacks'
    end
  end

  def battle_round(attacker, defender)
    rounds = 1
    while attacker["alive"] && defender["alive"]
      damage = Random.rand(0..attacker["job"]["attack_modifier"])
      defender["current_health_points"] -= damage
      @battle_log << "#{attacker['name']} attacks #{defender['name']} with #{spell_weapon(attacker["job"]["class_name"])} for #{damage} damage. #{defender['name']} has #{[defender['current_health_points'], 0].max} HP remaining."

      if defender["current_health_points"] <= 0
        defender["current_health_points"] = 0
        defender["alive"] = false
        @battle_log << "#{attacker['name']} wins the battle! #{defender['name']} still has #{defender["current_health_points"]} HP remaining."
        break
      end

      if rounds % 2 == 0
        attacker, defender = who_goes_first(attacker, defender)
      else
        attacker, defender = defender, attacker
      end

      rounds += 1
    end

    render json: { battle_log: @battle_log }, status: :ok
  end


  def who_goes_first(char1, char2)
    char1_speed = Random.rand(0..char1["job"]["speed_modifier"])
    char2_speed = Random.rand(0..char2["job"]["speed_modifier"])

    if char1_speed > char2_speed
      @battle_log << "#{char1['name']} #{char1_speed} speed was faster than #{char2['name']} #{char2_speed} speed and will begin this round."
      [char1, char2]
    elsif char2_speed > char1_speed
      @battle_log << "#{char2['name']} #{char2_speed} speed was faster than #{char1['name']} #{char1_speed} speed and will begin this round."
      [char2, char1]
    else
      who_goes_first(char1, char2)
    end
  end

  def characters_list
    session[:characters] ||= []
  end

  def character_params
    params.require(:character).permit(:name, :job)
  end
end