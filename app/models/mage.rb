# frozen_string_literal: true

class Mage < Hero
  def initialize
    @health_points = 12
    @strength = 5
    @dexterity = 6
    @intelligence = 10
  end

  def attack_modifier
    (strength * 0.2) + (dexterity * 0.2) + (intelligence * 1.2)
  end

  def speed_modifier
    (dexterity * 0.4) + (strength * 0.1)
  end
end
