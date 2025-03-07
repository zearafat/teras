class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] # Require login for most actions
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @topics = Topic.all.order(created_at: :desc)
  end

  def show
    @replies = @topic.replies.order(created_at: :asc)
  end

  def new
    @topic = Topic.new
    @categories = Category.all
  end

  def create
    @topic = current_user.topic.build(topic_params)
    if @topic.save
      redirect @topic, notice: 'Topic was successfully created.'
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @topic.update(topic_params)
      redirect_to @topic, notice: 'Topic was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @topic.destroy
    redirect_to topics_url, notice: 'Topic was successfully deleted.'
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :content, :category_id)
  end

  def authorize_user!
    unless @topic.user == current_user || current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
