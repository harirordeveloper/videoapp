class RoomsController < ApplicationController
  
  before_filter :config_opentok,:except => [:index]

	def index
		@rooms = Room.where(:public => true).order("created_at DESC")
		@new_room = Room.new
	end

	def create
		session = @opentok.create_session request.remote_addr
		params[:room][:sessionId] = session.session_id

		@new_room = Room.new(params[:room])

		respond_to do |format|
			if @new_room.save
			format.html { redirect_to("/party/"+@new_room.id.to_s) }
			else
			format.html { render :controller => 'rooms',:action => "index" }
			end
	    end
	end

	def party
		@room = Room.find(params[:id])

		@tok_token = @opentok.generate_token :session_id =>@room.sessionId 
	end

	private
	def config_opentok
		if @opentok.nil?
			@opentok = OpenTok::OpenTokSDK.new "36736992", "671e0c61e293ab35c60eff7faa40a089fa79a452"
		end
	end

end
