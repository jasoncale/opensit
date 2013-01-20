class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :access_message?, :only => [:show, :destroy]

  # GET /messages
  # Inbox
  def index
    @user = current_user
    @messages = @user.messages_received.newest_first.limit(10)
  end

  # GET /messages/1
  def show
    @user = current_user
    @message = Message.find(params[:id])
    @from_user = User.find(@message.from_user_id)

    # Only mark as read if the recipient is reading
    @message.mark_as_read unless @user.id == @from_user.id
  end

  # GET /messages/new
  def new
    @user = current_user
    @message = Message.new
  end

  # GET /messages/sent
  def sent
    @user = current_user
    @messages = @user.messages_sent.newest_first.limit(10)
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
    @message = Message.find(params[:id])
    @message.destroy

    redirect_to messages_url
  end

  # Is the current user allowed to see this message?
  def access_message?
    @user = current_user
    @message = Message.find(params[:id])

    return true if (@user.id == @message.from_user_id) or (@user.id == @message.to_user_id)
    redirect_to messages_path
  end
end
