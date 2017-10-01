require 'rails_helper'

RSpec.describe "AnswerApis", type: :request do

  describe "GET /question/fetch_answers" do

    # TODO: create test data in before :all block and do cleanup later
    before :each do
      require 'ffaker'
      @tenant = Tenant.create!(name: 'Consumer')
      users = []
      5.times { users << User.create!(name: FFaker::Name.name) }
      10.times do
        q = Question.create!(title: FFaker::HipsterIpsum.sentence, private: FFaker::Boolean.random, user: users.sample)
        (1 + rand(2)).times { q.answers.create(body: FFaker::HipsterIpsum.sentence, user: users.sample) }
      end
      @num_of_non_private_questions = Question.where(private: false).count
      @query_term = FFaker::Lorem.word
      @num_of_non_private_matching_questions = Question.where(private: false).where("title LIKE ?", "%#{@query_term}%").count
    end

    it "returns 401 HTTP status and appropriate message when there is no API key" do
      get '/question/fetch_answers'
      expect(response).to have_http_status(401)
      data = JSON.load response.body
      expect(data['msg']).to eq('no api key')
    end

    it "returns 401 HTTP status and appropriate message when there is an invalid API key" do
      get '/question/fetch_answers', nil, { 'X-Api-Key' => @tenant.api_key + 'AAAA' }
      expect(response).to have_http_status(401)
      data = JSON.load response.body
      expect(data['msg']).to eq('invalid api key')
    end

    it "returns 200 HTTP status and data for all questions" do
      get '/question/fetch_answers', nil, { 'X-Api-Key' => @tenant.api_key }
      expect(response).to have_http_status(200)
      data = JSON.load response.body
      expect(data['result'].count).to eq(@num_of_non_private_questions)
    end

    it "returns 200 HTTP status and data for all matching questions" do
      get '/question/fetch_answers', { :q => @query_term }, { 'X-Api-Key' => @tenant.api_key }
      expect(response).to have_http_status(200)
      data = JSON.load response.body
      expect(data['result'].count).to eq(@num_of_non_private_matching_questions)
    end

  end

end
