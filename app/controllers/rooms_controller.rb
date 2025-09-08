class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[ show edit update destroy ]

  def index
    @rooms = Room.all
  end

  def show
  end

  def new
    @room = Room.new
  end

  def edit
  end

  def create
    @room = Room.new(room_params)
    @room.users << current_user
    respond_to do |format|
      if @room.save
        format.turbo_stream { render turbo_stream: turbo_stream.append("rooms", partial: "shared/room", locals: { room: @room }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("room_form", partial: "rooms/form", locals: { room: @room }) }
      end
    end
  end

  def update
    respond_to do |format|
      if @room.update room_params
        format.turbo_stream { render turbo_stream: turbo_stream.replace("room_#{@room.id}", partial: "shared/room", locals: { room: @room }) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  end

  def add_user
    @room = Room.find(params[:room_id])
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @user && !@room.users.include?(@user)
        @room.users << @user
        format.turbo_stream { render turbo_stream: turbo_stream.replace("room_show_#{@room.id}", partial: "rooms/room", locals: { room: @room }) }
      else
        flash.now[:alert] = "User not found or already in the room."
      end
    end
  end

  private
    def set_room
      @room = Room.find(params[:id] || params[:room_id])
    end

    def room_params
      params.expect(room: [ :name ])
    end
end
