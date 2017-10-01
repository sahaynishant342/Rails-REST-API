class WelcomeController < ApplicationController
  def index
    @questions_count = Question.count
    @answers_count = Answer.count
    @users_count = User.count
    @tenants = Tenant.all
  end

  def fetch_api_count
    if params[:id].nil?
      render status: :ok, :json => { :api_count => -1 }.to_json
      return
    end
    tenant = Tenant.find_by_id params[:id].to_i
    if tenant.nil?
      render status: :ok, :json => { :api_count => -1 }.to_json
      return
    end
    render status: :ok, :json => { :api_count => tenant.api_count }.to_json
  end
end
