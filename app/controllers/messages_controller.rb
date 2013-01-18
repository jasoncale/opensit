class MessagesController < ApplicationController
  before_filter :authenticate_user!

  # GET /messages
  def index
    @user = current_user
    @messages = @user.messages_received.limit(10)
  end

  # GET /messages/1
  def show
    @user = current_user
    @message = Message.find(params[:id])
    @from_user = User.find(@message.from_user_id)
  end

  # GET /messages/new
  def new
    @user = current_user
    @message = Message.new
  end

  # POST /messages
  def create
    @user = current_user
    @message = Message.new(params[:message])
    params[:message][:to_user_id].shift # remove blank
    @message.from_user_id = @user.id

    if @message.send_message(params[:message][:to_user_id])
      redirect_to @message, notice: 'Your message has been sent.' 
    else
      render action: "new"
    end
  end

  # DELETE /messages/1
  def destroy
    @comment = Message.find(params[:id])
    @comment.destroy

    redirect_to comments_url
  end
end
