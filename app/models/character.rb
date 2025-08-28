# frozen_string_literal: true

class Character
  attr_accessor :name, :job, :id, :alive, :current_health_points

  VALID_JOBS = %w[mage warrior thief].freeze

  def initialize(name, job)
    @name = name
    @job = job
    @id = Random.rand(1..1_000_000)
    @alive = true
    setup_character
  end

  def errors
    @errors ||= {}
  end

  private

  def setup_character
    @errors = {}
    errors[:job] = 'is not valid' unless VALID_JOBS.include?(job.downcase)
    errors[:name_blank] = "can't be blank" if name.nil? || name.empty?
    errors[:name_long] = 'is too long (maximum is 15 characters)' if name && name.length > 15
    errors[:name_characters] = 'can only contain letters and underscores' unless name && name =~ /\A[a-zA-Z_]+\z/

    return if errors.any?

    @job = Object.const_get(job.capitalize).new
    @current_health_points = @job.health_points
  end
end
