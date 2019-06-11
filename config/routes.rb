Rails.application.routes.draw do


  resources :contacts
  get 'evaluation/index'

  get 'evaluation/new'

  get 'evaluation/edit'

  get 'pages/files'
  get 'pages/about_alma'

  get 'coaching_activity/new'

  get 'coaching_activity/index'

  get 'coaching_activity/edit'

  get 'home/redirect'

  default_url_options :host => 'elearning.colaboral.com'

  resources :user_imports

  get 'courses/index'

  root  "home#redirect"

  devise_for :users
  post 'users/registration/' => 'users#create_external', :as => :public_register

  scope "/admin" do
    resources :users
  end

  get 'home' => 'home#no_courses', :as => :no_courses
  get 'admin' => 'home#admin', :as => :admin

  get 'courses' => 'courses#index', :as => :courses
  get 'courses/all' => 'courses#all', :as => :all_courses
  get 'courses/finished' => 'courses#finished', :as => :finished_courses

  get 'courses/:id' => 'courses#show', :as => :course
  get 'courses/:course_id/item/:item_id' => 'module_items#show', :as => :module_item
  get 'courses/:course_id/item/:item_position' => 'module_items#show', :as => :module_item_by_position
  get 'courses/:course_id/item/:item_id/forum' => 'module_items#forum', :as => :forum
  get 'courses/:course_id/calendar/' => 'courses#calendar', :as => :course_calendar
  get 'courses/:course_id/activity_detail/:activity_id' => 'courses#activity_detail', :as => :activity_detail
  get 'courses/:course_id/grades/' => 'grades#show', :as => :grades

  get 'coaching/(:coaching_id)' => 'coachings#index', :as => :coachings
  get 'coaching/:coaching_id/goals' => 'goals#show', :as => :coaching_goals
  get 'coaching/:coaching_id/sessions' => 'sessions#sessions_coachee', :as => :coaching_sessions
  get 'coaching/:coaching_id/sessions/:id' => 'sessions#show', :as => :coaching_session

  get 'coaching/:coaching_id/coaching_activities' => 'coaching_activity#sessions_coachee', :as => :coachee_coaching_activities
  get 'coaching/:coaching_id/coaching_activities/:id' => 'coaching_activity#show', :as => :coaching_activity


  get 'coaching/:coaching_id/news/:id' => 'coaching_news#show', :as => :show_coaching_news
  get 'coaching/:coaching_id/news' => 'coaching_news#coachee_news', :as => :coaching_news

  get 'coaching/:coaching_id/job_offers/:id' => 'job_offers#show', :as => :show_job_offer
  get 'coaching/:coaching_id/job_offers' => 'job_offers#index', :as => :job_offers
  get 'coaching/:coachee_id/job_offers/:id/view' => 'job_offers#view_offer', :as => :view_job_offer


  get 'courses/:course_id/evaluation/' => 'evaluation#show', :as => :evaluation
  get 'evaluation/:id' => 'evaluation#send_evaluation', :as => :deliver_evaluation
  post'evaluation/:id' => 'evaluation#send_evaluation'

  get 'evaluation/evaluate/select_user/:course_id/' => 'evaluation#select_user_for_evaluation', :as => :select_user_for_evaluation

  put 'evaluation/evaluate/select_user_redirection/:course_id/' => 'evaluation#select_user_for_evaluation_redirection', :as => :select_user_for_evaluation_redirection

  get 'evaluation/sent/:id' => 'evaluation#evaluation_sent', :as => :evaluation_sent
  get 'evaluation/evaluate/:id' => 'evaluation#evaluate', :as => :evaluate
  put 'evaluation/evaluate/:id' => 'evaluation#save_evaluation'


  get 'module_items/change_status/:module_item_id/' => 'module_items#change_status', :as => :module_item_user_change_status
  put 'module_items/upload_evaluation/:module_item_id/' => 'module_items#upload_file', :as => :module_item_user_upload_file

  get 'chat' => 'chat#index', :as => :chat
  get 'Descargas' => 'pages#files', :as => :download_files

  #administration

  get 'admin/users'        => 'users#index', :as => :user_list
  put 'admin/search_user'        => 'users#index', :as => :user_list_search

  put 'admin/new_user' => 'users#create', :as => :create_user
  get 'admin/new_user' => 'users#new', :as => :admin_new_user
  put 'admin/user_edit/:id  ' => 'users#update', :as => :update_user
  get 'admin/user_edit/:id' => 'users#edit', :as => :admin_edit_user
  get 'admin/import_users' => 'users#import', :as => :import_users
  put 'admin/import_users' => 'users#create_import'
  get 'admin/user_delete/:id' => 'users#delete', :as => :delete_user


  get 'admin/courses' => 'courses#courses_admin', :as => :courses_admin_list

  put 'admin/courses/new' => 'courses#create'
  get 'admin/courses/new' => 'courses#new', :as => :new_course

  put 'admin/courses/edit' => 'courses#update'
  get 'admin/courses/edit' => 'courses#edit', :as => :course_edit
  get 'admin/courses/delete/:id' => 'courses#delete', :as => :course_delete
  get 'admin/courses/members/:id' => 'courses#members', :as => :members

  post 'admin/courses/new_subscription/:id' => 'courses#update_members', :as => :new_subscription
  get 'admin/courses/add_members/:id' => 'courses#add_members', :as => :create_subscriptions
  put 'admin/courses/add_members/:id' => 'courses#add_members', :as => :create_subscriptions_search

  post 'admin/courses/remove_subscription/:id' => 'courses#remove_members', :as => :remove_subscription


  put 'admin/courses/:course_id/module/new' => 'course_modules#create'
  get 'admin/courses/:course_id/module/new' => 'course_modules#new', :as => :new_module
  put 'admin/courses/:course_id/module/edit/:id' => 'course_modules#update'
  get 'admin/courses/:course_id/module/edit/:id' => 'course_modules#edit', :as => :module_edit
  get 'admin/courses/:course_id/module/up/:id' => 'course_modules#up', :as => :module_position_up
  get 'admin/courses/:course_id/module/down/:id'=> 'course_modules#down', :as => :module_position_down
  get 'admin/courses/:course_id/module/delete/:id'=> 'course_modules#delete', :as => :module_delete

  put 'admin/courses/:course_id/module/:course_module_id/item/new' => 'module_items#create'
  get 'admin/courses/:course_id/module/:course_module_id/item/new' => 'module_items#new', :as => :new_item
  put 'admin/courses/:course_id/module/:course_module_id/item/edit/:id' => 'module_items#update'
  get 'admin/courses/:course_id/module/:course_module_id/item/edit/:id' => 'module_items#edit', :as => :item_edit

  get 'admin/courses/:course_id/module/:course_module_id/item/up/:id' => 'module_items#up', :as => :item_position_up
  get 'admin/courses/:course_id/module/:course_module_id/item/down/:id'=> 'module_items#down', :as => :item_position_down
  get 'admin/courses/:course_id/module/:course_module_id/item/delete/:id'=> 'module_items#delete', :as => :item_delete
  get 'admin/courses/module/item/delete_file/:id' => 'module_items#delete_file', :as => :delete_file_item

  get 'admin/courses/:course_id/activities' => 'courses#activities', :as => :activities
  get 'admin/courses/:course_id/new_activity' => 'courses#new_activity', :as => :new_activity
  put 'admin/courses/:course_id/new_activity' => 'courses#create_activity'
  get 'admin/courses/:course_id/edit_activity/:id' => 'courses#edit_activity', :as => :edit_activity
  put 'admin/courses/:course_id/edit_activity/:id' => 'courses#update_activity'
  get 'admin/activity/delete_activity/:id' => 'courses#delete_activity', :as => :delete_activity


  get 'admin/courses/:course_id/evaluations' => 'course_evaluations#index', :as => :course_evaluations
  get 'admin/courses/:course_id/evaluations/new' => 'course_evaluations#new', :as => :new_course_evaluation
  put 'admin/courses/:course_id/evaluations/new' => 'course_evaluations#create'
  get 'admin/courses/:course_id/evaluations/edit/:id' => 'course_evaluations#edit', :as => :edit_course_evaluation
  put 'admin/courses/:course_id/evaluations/edit/:id' => 'course_evaluations#update'
  get 'admin/courses/:course_id/evaluations/delete/:id' => 'course_evaluations#delete', :as => :delete_course_evaluation
  get 'admin/:course_id/import_grades/:id' => 'course_evaluations#import_grades', :as => :import_grades
  put 'admin/:course_id/import_grades/:id' => 'course_evaluations#create_import_grades'



  get 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades' => 'grades#index', :as => :course_evaluations_grades


  get 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/:id/alternative_evaluate' => 'grades#alternative_evaluate', :as => :alternative_evaluation
  put 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/:id/alternative_evaluate' => 'grades#save_alternative_evaluation'

  get 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/:id/file_evaluate' => 'grades#evaluate_file', :as => :file_evaluation
  put 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/:id/file_evaluate' => 'grades#save_file_evaluation'

  get 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/new' => 'grades#new', :as => :new_grade
  put 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/new' => 'grades#create'
  get 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/edit/:id' => 'grades#edit', :as => :edit_grade
  put 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/edit/:id' => 'grades#update'
  get 'admin/courses/:course_id/evaluations/:course_evaluation_id/grades/delete/:id' => 'grades#delete', :as => :delete_grade


  get 'admin/coaching' => 'coachings#coaching_admin', :as => :coaching_admin
  get 'admin/coaching/new' => 'coachings#new', :as => :new_coaching
  put 'admin/coaching/new' => 'coachings#create'
  get 'admin/coaching/edit' => 'coachings#edit', :as => :edit_coaching
  put 'admin/coaching/edit' => 'coachings#update'

  get 'admin/coaching/:coaching_id/coachees' => 'coachings#coachees', :as => :coachees
  get 'admin/coaching/:id/coachees/:coachee_id/pdi' => 'coachings#pdi', :as => :coaching_pdi
  put 'admin/coaching/:id/coachees/:coachee_id/pdi' => 'coachings#update_pdi'

  get 'admin/coaching/:coaching_id/coachees/add' => 'coachings#add_coachees', :as => :add_coachees
  post 'admin/coaching/:coaching_id/coachees/update_coachees' => 'coachings#update_coachees' , :as => :update_coachees

  put 'admin/coaching/:coaching_id/coachees/add' => 'coachings#add_coachees', :as => :add_coachees_search

  get 'admin/coaching/:id/coachees/delete' => 'coachings#delete', :as => :delete_coaching

  post 'admin/coaching/:coaching_id/coachees/remove' => 'coachings#remove_coachee', :as => :remove_coachee

  get 'admin/coaching/:coaching_id/graph/:coachee_id' => 'coachings#graph', :as => :coaching_graph
  put 'admin/coaching/:coaching_id/graph/:coachee_id' => 'coachings#update_graph'

  get 'admin/coaching/:coaching_id/sessions' => 'sessions#index', :as => :sessions
  get 'admin/coaching/:coaching_id/sessions/new' => 'sessions#new', :as => :new_session
  get 'admin/coaching/:coaching_id/sessions/:coachee_id' => 'sessions#index', :as => :sessions_coachee

  put 'admin/coaching/:coaching_id/sessions/new' => 'sessions#create'
  get 'admin/coaching/:coaching_id/sessions/edit/:id' => 'sessions#edit', :as => :edit_session
  put 'admin/coaching/:coaching_id/sessions/edit/:id' => 'sessions#update'
  get 'admin/coaching/:coaching_id/sessions/delete/:id' => 'sessions#delete', :as => :delete_session

  get 'admin/coaching/:coaching_id/coaching_activity' => 'coaching_activity#index', :as => :coaching_activities
  get 'admin/coaching/:coaching_id/coaching_activity/new' => 'coaching_activity#new', :as => :new_coaching_activity
  get 'admin/coaching/:coaching_id/coaching_activity/:coachee_id' => 'coaching_activity#index', :as => :coaching_activity_coachee

  put 'admin/coaching/:coaching_id/coaching_activity/new' => 'coaching_activity#create'
  get 'admin/coaching/:coaching_id/coaching_activity/edit/:id' => 'coaching_activity#edit', :as => :edit_coaching_activity
  put 'admin/coaching/:coaching_id/coaching_activity/edit/:id' => 'coaching_activity#update'
  get 'admin/coaching/:coaching_id/coaching_activity/delete/:id' => 'coaching_activity#delete', :as => :delete_coaching_activity

  get 'admin/coaching/:coaching_id/goals' => 'goals#index', :as => :goals
  get 'admin/coaching/:coaching_id/goals/new' => 'goals#new', :as => :new_goal
  put 'admin/coaching/:coaching_id/goals/new' => 'goals#create'
  get 'admin/coaching/:coaching_id/goals/edit/:id' => 'goals#edit', :as => :edit_goal
  put 'admin/coaching/:coaching_id/goals/edit/:id' => 'goals#update'
  get 'admin/coaching/goals/delete/:id' => 'goals#delete', :as => :delete_goal

  get 'admin/coaching/:coaching_id/goals/coachee/:coachee_id' => 'goals#coachee_goals', :as => :coachee_goals

  get 'admin/coaching/:coaching_id/news' => 'coaching_news#index', :as => :news
  get 'admin/coaching/:coaching_id/news/new' => 'coaching_news#new', :as => :new_news
  put 'admin/coaching/:coaching_id/news/new' => 'coaching_news#create'
  get 'admin/coaching/:coaching_id/news/edit/:id' => 'coaching_news#edit', :as => :edit_news
  put 'admin/coaching/:coaching_id/news/edit/:id' => 'coaching_news#update'
  get 'admin/coaching/:coaching_id/news/delete/:id' => 'coaching_news#delete', :as => :delete_news

  get 'admin/coaching/:coaching_id/goals_report' => 'reports#goals', :as => :goals_report

  post 'admin/coaching/:coaching_id/goals/update_coachee_goals/:coachee_id' => 'goals#update_coachee_goals', :as => :update_coachee_goals

  # Job Offers

  get 'admin/coaching/:coaching_id/job_offers/user_id/(:user_id)' => 'job_offers#admin', :as => :job_offers_admin
  get 'admin/coaching/:coaching_id/job_offers/new/user_id/(:user_id)' => 'job_offers#new', :as => :new_job_offer
  get 'admin/coaching/:coaching_id/job_offers/import/user_id/(:user_id)' => 'job_offers#import', :as => :import_job_offers
  post 'admin/coaching/:coaching_id/job_offers/import/user_id/(:user_id)' => 'job_offers#create_import'
  put 'admin/coaching/:coaching_id/job_offers/new/user_id/(:user_id)' => 'job_offers#create'
  get 'admin/coaching/:coaching_id/job_offers/edit/:id' => 'job_offers#edit', :as => :edit_job_offer
  put 'admin/coaching/:coaching_id/job_offers/edit/:id' => 'job_offers#update'
  get 'admin/coaching/:coaching_id/job_offers/delete/:id' => 'job_offers#delete', :as => :delete_job_offer
  get 'admin/coaching/:coaching_id/job_offers/:id/change' => 'job_offers#change_status', :as => :job_offer_status_change
  #Contacts


  get 'admin/coaching/:coachee_id/contacts/' => 'contacts#admin', :as => :contacts_admin
  get 'admin/coaching/:coachee_id/contacts/:id/change' => 'contacts#change_status', :as => :contact_status_change
  get 'admin/coaching/:coachee_id/contacts/new/user_id/(:user_id)' => 'contacts#new', :as => :new_contact_network
  get 'admin/coaching/:coachee_id/contacts/import/user_id/(:user_id)' => 'contacts#import', :as => :import_contacts
  post 'admin/coaching/:coachee_id/contacts/import/user_id/(:user_id)' => 'contacts#create_import'
  

  # Communication

  get 'admin/communication' => 'communication#index', :as => :communication

  get 'admin/communication/all_users' => 'communication#all_users', :as => :communication_all_users
  put 'admin/communication/all_users' => 'communication#send_all_user_mail'

  get 'admin/communication/courses/:course_id' => 'communication#courses', :as => :communication_courses
  put 'admin/communication/courses/:course_id' => 'communication#send_course_mail'

  get 'admin/communication/coaching/:coaching_id' => 'communication#coaching', :as => :communication_coaching
  put 'admin/communication/coaching/:coaching_id' => 'communication#send_coaching_mail'

  get 'admin/communication/teachers' => 'communication#teachers', :as => :communication_teacher
  put 'admin/communication/teachers' => 'communication#send_teacher_mail'

  get 'admin/communication/users/:user_id' => 'communication#users', :as => :communication_users
  put 'admin/communication/users/:user_id' => 'communication#send_user_mail'

  get 'admin/communication/confirmation' => 'communication#confirmation', :as => :communication_confirmation

  get 'admin/questionnaire/new/:course_id' => 'questionnaire#new', :as => :new_questionnaire
  put 'admin/questionnaire/new/:course_id' => 'questionnaire#update'

  get 'admin/questionnaire/question/new/:questionnaire_id' => 'questionnaire#new_question', :as => :new_question
  put 'admin/questionnaire/question/new/:questionnaire_id' => 'questionnaire#create_question'

  get 'admin/questionnaire/question/edit/:question_id' => 'questionnaire#edit_question', :as => :edit_question
  put 'admin/questionnaire/question/edit/:question_id' => 'questionnaire#update_question'

  get 'admin/questionnaire/question/delete/:question_id' => 'questionnaire#delete_question', :as => :delete_question


  get 'admin/reports/course/:course_id' => 'reports#course', :as => :course_report
  get 'admin/reports/course/:course_id/user_advance/:user_id' => 'reports#user_advance', :as => :user_advance_report
  get 'admin/reports/user_advance/:course_id' => 'reports#select_user_advance', :as => :select_user_advance_report
  put 'admin/reports/user_advance/:course_id' => 'reports#select_user_advance_redirection'

  get 'admin/course/:course_id/evaluations/:evaluation_id/questionnaire/' => 'course_evaluation_questionnaire#show', :as => :course_evaluation_questionnaire
  put 'admin/course/:course_id/evaluations/:evaluation_id/questionnaire/update' => 'course_evaluation_questionnaire#update', :as => :course_evaluation_questionnaire_update

  get 'admin/course/:course_id/evaluations/:evaluation_id/questionnaire/question/new' => 'course_evaluation_questionnaire#new_question', :as => :course_evaluation_new_question
  put 'admin/course/:course_id/evaluations/:evaluation_id/questionnaire/question/new' => 'course_evaluation_questionnaire#create_question'
  get 'admin/course/:course_id/evaluations/:evaluation_id/questionnaire/question/edit/:question_id' => 'course_evaluation_questionnaire#edit_question', :as => :course_evaluation_edit_question
  put 'admin/course/:course_id/evaluations/:evaluation_id/questionnaire/question/edit/:question_id' => 'course_evaluation_questionnaire#update_question'

  get 'courses/:course_id/course_evaluation/:module_item_id' => 'course_evaluation_questionnaire#evaluate', :as => :course_user_evaluation
  post 'courses/:course_id/course_evaluation/:module_item_id' => 'course_evaluation_questionnaire#send_evaluation', :as => :deliver_course_evaluation
  get 'courses/:course_id/course_evaluation/:module_item_id/evaluation_sent' => 'course_evaluation_questionnaire#evaluation_sent', :as => :course_evaluation_sent


end
