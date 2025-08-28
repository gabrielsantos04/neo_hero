# frozen_string_literal: true

class Warrior < Hero
  def initialize
    @health_points = 20
    @strength = 10
    @dexterity = 5
    @intelligence = 5
  end

  def attack_modifier
    (strength * 0.8) + (dexterity * 0.2)
  end

  def speed_modifier
    (dexterity * 0.6) + (intelligence * 0.2)
  end
end
