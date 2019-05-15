module GoalsHelper

  def create_coachee_goals(coaching_id, coachee_id)
    @goals = Goal.where(:coaching_id => coaching_id, :is_global => true)
    @goals.each do |g|
      CoacheeGoal.create(:user_id => coachee_id, :goal_id => g.id, :coaching_id => coaching_id, :completed => false)
    end
  end

  def coachee_max_value_for_percentage(coaching_id, coachee_id, goal_id)
    @goals = Goal.where("coaching_id = #{coaching_id} AND (is_global = true OR user_id = #{coachee_id})")
    @max_value = 0
      @goals.each do |g|
        unless g.id ==  goal_id
          @max_value = g.percentage + @max_value
        end
      end
      @max_value = 100 - @max_value
    end
end
