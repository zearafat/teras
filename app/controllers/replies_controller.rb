class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic

  def new
    @reply = @topic.replies.build
  end

  def create
    @reply = @topic.replies.build(reply_params)
    @reply.user = current_user

    if @reply.save
      redirect_to @topic, notice: 'Reply was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:topic_id])
  end

  def reply_params
    params.require(:reply).permit(:content)
  end
end
