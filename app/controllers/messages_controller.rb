class MessagesController < ApplicationController
  def index
    limit = 30
    err, chat = find_or_create_chat
    if err
      return render json: {errors: chat.errors}, status: :bad_request
    end
    messages =
        chat
            .messages
            .try {|messages| params[:id] ? messages.where("id < ?", params[:id]) : messages}
            .limit(limit)
            .order(id: :desc)
            .reverse
    render json: {messages: messages}
  end

  def create
    @message = Message.new(message_params)
    err, chat = find_or_create_chat
    if err
      return render json: {errors: chat.errors}, status: :bad_request
    end
    @message.chat = chat
    unless @message.save
      return render json: {errors: @message.errors}, status: :bad_request
    end
  end

  def read
    err, chat = find_or_create_chat
    if err
      return render json: {errors: chat.errors}, status: :bad_request
    end
    me = chat.me(current_user.id)
    me.update(unread_count: 0)
  end

  private

  def find_or_create_chat
    opponent = find_or_create_user(chat_params[:recipient_external_key])
    chat = ChatUser
               .where(user: [
                   current_user,
                   opponent
               ])
               .select(:chat_id)
               .group(:chat_id)
               .having("count(*) = 2")
               .try {|el| el[0]}
               .try(:chat)

    if chat.blank?
      chat = Chat.new(
          chat_users: [
              ChatUser.new(
                  user: current_user
              ),
              ChatUser.new(
                  user: opponent,
              ),
          ]
      )
      result = chat.save
      unless result
        return [true, chat]
      end
    end
    [false, chat]
  end

  def chat_params
    params.require(:chat).permit(:recipient_external_key)
  end

  def message_params
    params
        .require(:message)
        .permit(:body)
        .try {|hash| hash.merge(user: current_user)}
  end

end
