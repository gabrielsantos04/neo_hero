# frozen_string_literal: true

class Thief < Hero
  def initialize
    @health_points = 15
    @strength = 4
    @dexterity = 10
    @intelligence = 4
  end

  def attack_modifier
    (strength * 0.25) + dexterity + (intelligence * 0.25)
  end

  def speed_modifier
    (dexterity * 0.8)
  end
end
