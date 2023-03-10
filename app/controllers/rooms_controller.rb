# frozen_string_literal: true

# class for working with rooms
class RoomsController < ApplicationController
  before_action :set_room, only: %i[show edit update destroy]
  skip_before_action :authenticate_as_admin, only: %i[show book unbook]

  # GET /rooms or /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1 or /rooms/1.json
  def show
    allowed_dates_current_month = RoomsHelper.get_not_booked_dates_in_month(@room, Date.today)
    allowed_dates_next_month = RoomsHelper.get_not_booked_dates_in_month(@room, Date.today.next_month)
    @calendar_data = JSON.generate(RoomsHelper.generate_date_json(allowed_dates_current_month,
                                                                  allowed_dates_next_month))
  end

  def new
    @room = Room.new
    @hotel_id = params[:hotel_id]
  end

  def edit; end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to room_url(@room) }
      else
        format.html { redirect_to new_room_path(errors: @room.errors.full_messages) }
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    updated = update_room(room_params)

    respond_to do |format|
      if updated
        format.html { redirect_to room_url(@room) }
      else
        format.html { redirect_to edit_room_path(errors: @room.errors.full_messages) }
      end
    end
  end

  def update_room(room_params)
    if room_params[:images] == ['']
      @room.update(
        hotel: Hotel.find(room_params[:hotel_id]),
        description: room_params[:description],
        name: room_params[:name],
        cost_per_night: room_params[:cost_per_night]
      )
    else
      @room.update(room_params)
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    Booking.where(room: @room).delete_all
    @room.destroy

    respond_to do |format|
      format.html { redirect_to hotels_path, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def book
    room = Room.find(book_params[:room_id])
    if (@current_user.money - room.cost_per_night).positive?
      book_room(room)
    else
      redirect_to room_path(room, errors: [t(:not_enough_money).to_s])
    end
  end

  def unbook
    booking_id = book_params[:booking_id]
    booking = Booking.find(booking_id)
    if (booking.user == @current_user) || @is_admin
      booking.user.update(money: (@current_user.money + booking.room.cost_per_night))
      booking.user.save
      booking.destroy
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def book_room(room)
    user_booking = Booking.new(room:, user: @current_user, date: book_params[:date])
    if user_booking.valid?
      user_booking.save
      @current_user.update(money: (@current_user.money - room.cost_per_night))
      @current_user.save
      redirect_to user_path(@current_user)
    else
      redirect_to room_path(room, errors: user_booking.errors.full_messages)
    end
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:hotel, :description, :name, :cost, :hotel_id, :cost_per_night, images: [])
  end

  def book_params
    params.permit(:room_id, :date, :booking_id)
  end
end
