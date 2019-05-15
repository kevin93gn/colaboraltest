class ModuleItemsController < ApplicationController

  before_filter :admin_only, only: [:new, :create, :edit, :update, :up, :down]

  include ModuleItemsHelper

  def show
    @item = ModuleItem.find(params[:item_id])
    unless @item.nil?
      @module_item_user = ModuleItemsUsers.where(:user_id => current_user.id, :module_item_id => @item.id).first
      if @module_item_user.nil?
        @module_item_user = ModuleItemsUsers.new
        @module_item_user.user_id = current_user.id
        @module_item_user.module_item_id = @item.id
        @module_item_user.course_id = @item.course_id
        @module_item_user.status = true
        @module_item_user.visits = 0
        @module_item_user.save
      end
      @course = Course.find(@item.course_id)
      @teacher = User.find(@course.teacher_id)
      @module_item_user = ModuleItemsUsers.where(:user_id => current_user.id, :module_item_id => @item.id).first
      @prev_item = ModuleItem.where(:course_module_id => @item.course_module_id, :position => (@item.position - 1)).first
      @next_item = ModuleItem.where(:course_module_id => @item.course_module_id, :position => (@item.position + 1)).first
      @evaluation = CourseEvaluation.where(:module_item_id => @item.id).first
      unless @evaluation.nil?
        @questionnaire = CourseEvaluationQuestionnaire.where(:evaluation_id => @evaluation.id).first
      end
      if @module_item_user.visits.nil?
        @module_item_user.visits = 0
      end
      views = @module_item_user.visits + 1
      @module_item_user.update_attributes!(:visits => views)

      @evaluation = CourseEvaluation.find_by_module_item_id(@item.id)

    end
  end

  def forum
    @item = ModuleItem.find(params[:item_id])
    unless @item.nil?
        @course = Course.find(@item.course_id)
        @teacher = User.find(@course.teacher_id)
      end
  end

  def change_status
    module_item_id = params[:module_item_id]
    module_item_user = ModuleItemsUsers.where(:user_id => current_user.id, :module_item_id => module_item_id).first
    item = ModuleItem.find(module_item_id)
    unless item.nil?
        if module_item_user.status
          module_item_user.update_attribute(:status, false)
        else
          module_item_user.update_attribute(:status, true)
        end
        views = module_item_user.visits - 1
        module_item_user.update_attributes!(:visits => views)
      redirect_to module_item_path(:course_id => item.course_id, :item_id => item.id)
    else
      redirect_to root_path
    end
  end

  def upload_file
    module_item_id = params[:module_item_id]
    module_item_user = ModuleItemsUsers.where(:user_id => current_user.id, :module_item_id => module_item_id).first
    evaluation = CourseEvaluation.where(:module_item_id => module_item_id).first
    item = ModuleItem.find(module_item_id)
    unless params[:module_items_users].nil?
      file = params[:module_items_users][:evaluation_file]
    end
    unless item.nil? or file.nil?
      module_item_user.update_attributes(:evaluation_file => file, :sent => true)
      @grade = Grade.new
      @grade.course_id = evaluation.course_id
      @grade.course_evaluation_id = evaluation.id
      @grade.grade = 0
      @grade.user_id = current_user.id
      @grade.save!
    end
    redirect_to module_item_path(:course_id => item.course_id, :item_id => item.id)

  end

  def new
    @module_item = ModuleItem.new
    @module_item.course_module_id = params[:course_module_id]
    @module_item.course_id = params[:course_id]
  end

  def create
=begin
    @module_item = ModuleItem.new
    @module_item.title = params[:module_item][:title]


    @module_item.text = params[:module_item][:text]
    @module_item.time_in_mins = params[:module_item][:time_in_mins]
    @module_item.media_type = params[:module_item][:media_type]
    @module_item.media_url = params[:module_item][:media_url]
=end
    params.permit!
    @module_item = ModuleItem.new(params[:module_item])
    @module_item.course_id = params[:course_id]
    @module_item.course_module_id = params[:course_module_id]

    @module_item.disqus_identifier = "#{@module_item.id}"

    items = ModuleItem.where(:course_id => @module_item.course_id, :course_module_id => @module_item.course_module_id).order('position ASC')
    items.count > 0 ? @module_item.position = items.last.position + 1 : @module_item.position = 1

    if @module_item.save
      @module_item.update_attribute(:disqus_identifier, "#{@module_item.id}#{@module_item.created_at.to_formatted_s(:number)}")
      redirect_to module_edit_path(:course_id => @module_item.course_id, :id => @module_item.course_module_id)
    else
      render :action => 'new'
    end
  end

  def edit
    @item = ModuleItem.find(params[:id])
    unless @item.nil?
      @item.course_id = params[:course_id]
      @item.course_module_id = params[:course_module_id]
    else
      redirect_to root_path
    end

  end

  def update
    @item = ModuleItem.find(params[:id])
    params.permit!
    @item.update_attributes(params[:module_item])
    render :action => 'edit'
  end

  def up
    item = ModuleItem.find(params[:id])
    if item and item.position != 1
      next_item = ModuleItem.where(:course_id => item.course_id, :course_module_id => item.course_module_id, :position => item.position - 1).first
      if next_item
        item.update_attribute(:position, item.position - 1)
        next_item.update_attribute(:position, item.position + 1)
      end
      redirect_to module_edit_path(:id => item.course_module_id,  :course_id => item.course_id)
    else
      redirect_to courses_admin_list_path
    end
  end

  def down
    item = ModuleItem.find(params[:id])
    if item and !item.last?
      next_item = ModuleItem.where(:course_id => item.course_id, :course_module_id => item.course_module_id, :position => item.position + 1).first
      if next_item
        item.update_attribute(:position, item.position + 1)
        next_item.update_attribute(:position, item.position - 1)
      end
      redirect_to module_edit_path(:id => item.course_module_id,  :course_id => item.course_id)
    else
      redirect_to courses_admin_list_path
    end
  end

  def delete
    item = ModuleItem.find(params[:id])
    if item
      user_advance = ModuleItemsUsers.where(:module_item_id => item.id).first
      if user_advance
        user_advance.destroy
      end
      item.remove_data!
      item.destroy
      redirect_to module_edit_path(:id => item.course_module_id,  :course_id => item.course_id)
    else
      redirect_to courses_admin_list_path
    end
  end

  def delete_file
    item = ModuleItem.find(params[:id])
    item.remove_data!
    item.update_attributes(:data => nil, :data_title => nil, :data_description => nil)
    redirect_to item_edit_path(:id => item.id, :course_id => item.course_id, :course_module_id => item.course_module_id)
  end


end
