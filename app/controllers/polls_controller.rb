class PollsController < ApplicationController
  before_action :require_login
  before_action :find_poll, only: [:edit, :update, :destroy, :vote]
  before_action :authorized_globaly?, except: [:index, :vote]

  def index
    @polls = Poll.joins("LEFT JOIN (
                          SELECT a.poll_id, a.answ
                          FROM #{Answer.table_name} a
                          WHERE a.user_id = #{User.current.id.to_i}
                         ) a on a.poll_id = #{Poll.table_name}.id
                        ")
               .select("#{Poll.table_name}.*, a.answ")
    get_pagination_polls
  end

  def new
    @poll = Poll.new
    render partial: 'form'
  end

  def create
    @poll = Poll.create(allowed_params)
    if @poll.save
      respond_to do |f|
        f.html { redirect_to polls_url }
        f.js
      end
    else
      index
      render 'index'
    end
  end

  def report
    @polls = User.select('users.*, polls.question as question, polls.id as poll_id, answers.answ as answ')
               .joins('INNER JOIN answers
                          ON users.id = answers.user_id
                       INNER JOIN polls
                          ON answers.poll_id = polls.id')
               .order('polls.id, users.firstname')
    @for_select = @polls.map {|r| [r.question, r.poll_id]}.uniq
  end

  def poll_answers
    if params[:report_polls].present?
      @polls = User.select('users.*, polls.question as question, polls.id as poll_id, answers.answ as answ')
                 .joins('INNER JOIN answers
                            ON users.id = answers.user_id
                         INNER JOIN polls
                            ON answers.poll_id = polls.id')
                 .where("polls.id = #{params[:report_polls]}")
                 .order('polls.id, users.firstname')
    else
      report
    end

    render 'report'
  rescue
    render_404
  end

  def vote
    answ = params[:answ]
    @poll.answer.create(user_id: User.current.id, answ: answ) unless @poll.voted?(User.current.id)

    index
    render 'index'
  rescue
    render_404
  end

  def edit
    render partial: 'form'
  end

  def update
    @poll.update_attributes(allowed_params)

    index
    render 'index'
  end

  def destroy
    @poll.destroy

    respond_to do |f|
      f.html { redirect_to polls_url }
      f.js
    end
  rescue
    render_404
  end

  private
  def find_poll
    @poll = Poll.find(params[:id])
  rescue RsSender::RecordNotFound
    render_404
  end
  def allowed_params
    params.require(:poll).permit(:question)
  end
  def get_pagination_polls
    limit = params[:per_page].to_i == 0 ? 25 : params[:per_page].to_i
    @count = @polls.size
    @paginator = Redmine::Pagination::Paginator.new @count, limit, params[:page] || 1
    @offset = @paginator.offset
    @polls = @polls.limit(limit).offset(@offset)
  end

end
