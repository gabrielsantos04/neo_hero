# frozen_string_literal: true

class Hero
  attr_accessor :health_points, :strength, :dexterity, :intelligence,
              :attack_modifier, :speed_modifier

  def initialize
    @health_points = 0
    @strength = 0
    @dexterity = 0
    @intelligence = 0
  end

  def attack_modifier
    raise NotImplementedError, 'Subclasses must implement the attack_modifier method'
  end

  def speed_modifier
    raise NotImplementedError, 'Subclasses must implement the speed_modifier method'
  end

  def level_up
    raise NotImplementedError, 'Subclasses must implement the level_up method'
  end

  def as_json(options = {})
    super(options).merge({
                           class_name: self.class.name,
                           attack_modifier: attack_modifier,
                           speed_modifier: speed_modifier
                         })
  end
end
