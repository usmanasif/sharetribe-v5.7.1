class MessagesController < ApplicationController
  MessageEntity = MarketplaceService::Conversation::Entity::Message
  PersonEntity = MarketplaceService::Person::Entity

  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_send_a_message")
  end

  before_action EnsureCanAccessPerson.new(:person_id, error_message_key: "layouts.notifications.you_are_not_authorized_to_do_this")

  def create
    unless is_participant?(@current_user, params[:message][:conversation_id])
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_do_this")
      return redirect_to search_path
    end

    message_params = params.require(:message).permit(
      :conversation_id,
      :content
    ).merge(
      sender_id: @current_user.id
    )

    @message = Message.new(message_params)
    if @message.save
      Delayed::Job.enqueue(MessageSentJob.new(@message.id, @current_community.id))
      firebase = Firebase::Client.new('https://vendoradvisor-4df3f.firebaseio.com/')
      firebase.push("sharetribe_beep", {:c_id => @message.conversation_id , :s_id => @message.sender_id } )
      p=Participation.where("conversation_id = #{@message.conversation_id} and person_id != '#{@current_user.id}' ").pluck :person_id
      p.each do |u|
        e = Email.find_by_person_id(u).address
        t = '';
        d = '';
        c = Conversation.find(@message.conversation_id)
        if c.listing_id
          l= Listing.find(c.listing_id)
          t = "Message Received"
          d = "Some activity in #{l.title}"
        else
          t = "Message Received"
          d = "#{@current_user.given_name} sent you a free Message"
        end
        firebase.push("sharetribe", { :count => 1 , :visited => false , :user_id => e , :href => person_inbox_path ,
           :title => t , :description => d } )
      end
    else
      flash[:error] = "reply_cannot_be_empty"
    end

    # TODO This is somewhat copy-paste
    message = MessageEntity[@message].merge({mood: :neutral}).merge(sender: person_entity_with_display_name(PersonEntity.person(@current_user, @current_community.id)))

    respond_to do |format|
      format.html { redirect_to single_conversation_path(:conversation_type => "received", :person_id => @current_user.id, :id => params[:message][:conversation_id]) }
      format.js { render :layout => false, locals: { message: message } }
    end
  end
  
  def get_conversation
    conversation = MarketplaceService::Conversation::Query.conversation_for_person(
      params["c_id"],
      @current_user.id,
      @current_community.id)
    messages = TransactionViewUtils.conversation_messages(conversation[:messages], @current_community.name_display_type)

    render :partial => "conversations/message", :collection => messages.reverse, as: :message_or_action
  end

  def get_message_count
    MarketplaceService::Inbox::Query.notification_count(@current_user.id, @current_community.id)
  end

  private

  def person_entity_with_display_name(person_entity)
    person_display_entity = person_entity.merge(
      display_name: PersonViewUtils.person_entity_display_name(person_entity, @current_community.name_display_type)
    )
  end

  def is_participant?(person, conversation_id)
    Conversation.find(conversation_id).participant?(person)
  end


end

