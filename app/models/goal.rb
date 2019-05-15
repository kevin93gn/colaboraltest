class Goal < ActiveRecord::Base

  has_many :coachee_goals
  belongs_to :coaching

  validates_presence_of :name, :percentage
#  validate :max_value_for_percentage


  def max_value_for_percentage
    @goals = Goal.where(:coaching_id => self.coaching_id, :is_global => true)
    @max_value = 0
    unless self.percentage.nil?
      if self.id.nil?
        @goals.each do |g|
          @max_value = g.percentage + @max_value
        end
      else
        @goals.each do |g|
          unless g.id == self.id
            @max_value = g.percentage + @max_value
          end
        end
      end
        @max_value = 100 - @max_value
        if @max_value < self.percentage
          errors.add(:percentage, "El porcentaje no puede sobrepasar 100% sumando todas las metas, el valor maximo para el campo es #{@max_value}%")
        end
    end
  end
end
