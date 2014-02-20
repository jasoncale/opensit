class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :access_message?, :only => [:show, :destroy]

  # GET /messages
  # Inbox
  def index
    @user = current_user
    @messages = @user.messages_received.newest_first.limit(10)

    @title = 'Inbox'
    @page_class = 'inbox'
  end

  # GET /messages/1
  def show
    @user = current_user
    @message = Message.find(params[:id])
    @from_user = User.find(@message.from_user_id)

    # Only mark as read if the recipient is reading
    @message.mark_as_read unless @user.id == @from_user.id

    @title = "Message from #{@from_user.display_name}"
    @page_class = "view-message"
  end

  # GET /messages/new
  def new
    @user = current_user
    @message ||= Message.new

    @title = 'New message'
    @page_class = 'new-message'
  end

  # GET /messages/sent
  def sent
    @user = current_user
    @messages = @user.messages_sent.newest_first.limit(10)

    @title = 'Sent items'
    @page_class = 'sent-items'
  end

  # POST /messages
  def create
    @user = current_user

    @message = Message.new(params[:message])
    @message.to_user_id = params[:message][:to_user_id]
    @message.from_user_id = @user.id

    if !@message.valid?
      render action: "new"
    else
      @message.save!
      redirect_to @message, notice: 'Your message has been sent.'
    end
  end

  # DELETE /messages/1
  def destroy
    @user = current_user
    @message = Message.find(params[:id])

    if @user.id == @message.from_user_id
      @message.sender_deleted = true
    else
      @message.receiver_deleted = true
    end

    @message.save
    @message.destroy if @message.sender_deleted && @message.receiver_deleted

    redirect_to messages_url
  end

  # Is the current user allowed to view this message?
  def access_message?
    @user = current_user
    @message = Message.find(params[:id])

    return true if (@user.id == @message.from_user_id) or (@user.id == @message.to_user_id)
    redirect_to messages_path
  end
end
