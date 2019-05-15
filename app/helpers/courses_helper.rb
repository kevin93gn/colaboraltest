module CoursesHelper
  def course_completion_check(course_id)
    course = Course.find(course_id)
    if course
      item_count = course.module_items.count
      complete_items = ModuleItemsUsers.where(:course_id => course.id, :user_id => current_user.id, :status => 'true').count
      (item_count == complete_items) ? true:false
    else
      false
    end
  end
end
