class CourseModulesController < ApplicationController

  before_filter :admin_only

  def new
    @course_module = CourseModule.new
    @course_module.course_id = params[:course_id]
  end

  def create
    @course_module = CourseModule.new
    @course_module.course_id = params[:course_id]
    @course_module.name = params[:course_module][:name]

    course_modules = CourseModule.where(:course_id => @course_module.course_id).order('position ASC')

    course_modules.count > 0 ? @course_module.position = course_modules.last.position + 1 : @course_module.position = 1

    if @course_module.save
      redirect_to module_edit_path(:id => @course_module.id, :course_id => @course_module.course_id)
    else
      render :action => 'new'
    end
  end

  def edit
    @course_module = CourseModule.find(params[:id])
    if @course_module.nil?
      redirect_to root_path
    end
  end

  def update
    @course_module = CourseModule.find(params[:course_module][:id])
    @course_module.update_attribute(:name , params[:course_module][:name])
    render :action => 'edit'
  end

  def up
    course_module = CourseModule.find(params[:id])
    if course_module and course_module.position != 1
      next_course_module = CourseModule.where(:course_id => course_module.course_id, :position => course_module.position - 1).first
      if next_course_module
          course_module.update_attribute(:position, course_module.position - 1)
          next_course_module.update_attribute(:position, course_module.position + 1)
      end
      redirect_to course_edit_path(:id => course_module.course_id)
    else
      redirect_to courses_admin_list_path
    end
  end

  def down
    course_module = CourseModule.find(params[:id])
    if course_module and !course_module.last?
      prev_course_module = CourseModule.where(:course_id => course_module.course_id, :position => course_module.position + 1).first
      if prev_course_module
        course_module.update_attribute(:position, course_module.position + 1)
        prev_course_module.update_attribute(:position, course_module.position - 1)
      end
      redirect_to course_edit_path(:id => course_module.course_id)
    else
      redirect_to courses_admin_list_path
    end
  end

  def delete
    course_module = CourseModule.find(params[:id])
    if course_module
      item = ModuleItem.where(:course_module_id => course_module.id)
      item.each do |i|
        user_advance = ModuleItemsUsers.where(:module_item_id => i.id).first
        if user_advance
          user_advance.destroy
        end
        i.remove_data!
        i.destroy
      end
      course_module.destroy
      redirect_to course_edit_path(:id => course_module.course_id)
    else
      redirect_to courses_admin_list_path
    end
  end


end
