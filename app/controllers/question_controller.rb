class QuestionController < ApiController

  before_action :authenticate

  def fetch_answers
    @questions = Question.includes(:answers, :user).where(private: false).where("title like ?", "%#{params[:q]}%")

    if @questions.empty?
      render status: :ok, :json => { msg: 'no data', result: [] }.to_json
      return
    end


    # query for list of users that have provided answers for @questions
    user_ids = []
    @questions.each do |q|
      q.answers.each { |a| user_ids << a.user_id }
    end
    @users = User.where(id: user_ids)
    user_id_name_map = {}
    @users.each { |u| user_id_name_map[u.id] = u.name}


    result = []
    @questions.each do |q|
      ans_arr = []
      q.answers.each do |a|
        ans_arr << { answer: a.body, provider_id: a.user_id, provider_name: user_id_name_map[a.user_id] }
      end
      result << { question: q.title, answers: ans_arr, asker_id: q.user.id, asker_name: q.user.name }
    end

    render status: :ok, :json => { msg: 'data ok', result: result }.to_json
  end

end
