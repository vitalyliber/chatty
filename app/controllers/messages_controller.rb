class MessagesController < ApplicationController
  def index
    render json: {messages: chat.messages}
  end

  def create
    message = Message.new(message_params)
    message.chat = chat
    if message.save
      render json: {message: message}
    else
      render json: {errors: message.errors}, status: :bad_request
    end
  end

  private

  def chat
    chat = ChatUser
               .where(external_key: [
                   chat_params[:sender_external_key],
                   chat_params[:recipient_external_key]
               ])
               .select(:chat_id)
               .group(:chat_id)
               .having("count(*) = 2")
               .try {|el| el[0]}
               .try(:chat)

    if chat.blank?
      chat = Chat.new(
          chat_users: [
              ChatUser.new(external_key: chat_params[:sender_external_key]),
              ChatUser.new(external_key: chat_params[:recipient_external_key]),
          ]
      )
      chat.save!
    end
    chat
  end

  def chat_params
    params.require(:chat).permit(:sender_external_key, :recipient_external_key)
  end

  def message_params
    params
        .require(:message)
        .permit(:body)
        .try {|hash| hash.merge(external_key: chat_params[:sender_external_key])}
  end

end
