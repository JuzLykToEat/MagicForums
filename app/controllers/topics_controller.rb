class TopicsController < ApplicationController
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topics = Topic.all.order(created_at: :desc)
  end

  def show
    @topic = Topic.find_by(id: params[:id])
  end

  def new
     @topic = Topic.new
     authorize @topic
  end

  def create
    @topic = current_user.topics.build(topic_params)

   if @topic.save
     flash[:success] = "You've created a new topic."
     redirect_to topics_path
   else
     flash[:danger] = @topic.errors.full_messages
     render new_topic_path
   end
  end

  def edit
    @topic = Topic.find_by(id: params[:id])
    authorize @topic
  end

  def update
    @topic = Topic.find_by(id: params[:id])

    if @topic.update(topic_params)
      flash[:success] = "You've updated the topic."
      redirect_to topics_path
    else
      flash[:danger] = @topic.errors.full_messages
      redirect_to edit_topic_path(@topic)
    end
  end

  def destroy
    @topic = Topic.find_by(id: params[:id])
    if @topic.destroy
      flash[:success] = "You've deleted the topic."
      redirect_to topics_path
    else
      flash[:danger] = @topic.errors.full_messages
      redirect_to topic_path(@topic)
    end
  end

  private

    def topic_params
      params.require(:topic).permit(:title, :description)
    end

end
