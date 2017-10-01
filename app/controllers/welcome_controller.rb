class WelcomeController < ApplicationController
  def index
    @questions_count = Question.count
    @answers_count = Answer.count
    @users_count = User.count
    @tenants = Tenant.all
  end
end
