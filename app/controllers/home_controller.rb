class HomeController < ApplicationController
  def redirect
    if current_user.user?
      coachings = Coaching.joins('RIGHT JOIN coachees ON coachees.coaching_id = coachings.id')
                      .where(:publish => true, :coachees => {:user_id => current_user.id})
                      .any?
      courses = Course.joins('RIGHT JOIN subscriptions ON subscriptions.course_id = courses.id')
                    .where(:publish => true, :subscriptions => {:user_id => current_user.id})
                    .any?
      all_subscribed_courses = Course.where(:all_subscribed => true).any?
      external_user_courses = Course.where(:external_users_subscribed => true).any?

      if coachings
        redirect_to coachings_path
    elsif courses or (all_subscribed_courses and !current_user.external_user?) or (external_user_courses and current_user.external_user?)
      redirect_to courses_index_path
      else
        redirect_to no_courses_path
      end
    elsif current_user.coach?
      redirect_to coaching_admin_path
    elsif current_user.teacher?
      redirect_to courses_admin_list_path
    elsif current_user.admin?
      redirect_to admin_path
    end
  end

  def no_courses

  end

  def admin

  end

end
