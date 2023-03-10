require 'rails_helper'

RSpec.describe Hotel, type: :model do

    describe 'test hotel' do
        context 'when valid data' do
            it "should write to db correct record" do
                prew_hotel = Hotel.find_by(name: "testhotel")
                prew_hotel&.destroy
                file = Rails.root.join('spec', 'support', 'assets', 'images','hotels' , '370564672.jpg')
                image = ActiveStorage::Blob.create_and_upload!( 
                    io: File.open(file, 'rb'),  
                    filename: '370564672.jpg',  
                    content_type: 'image/jpg'
                ).signed_id
                new_hotel = Hotel.create(
                    location: "testlocation", 
                    name: "testhotel",
                    description: "some description for hotel",
                    image: image
                )
                new_hotel_search = Hotel.find_by(name: "testhotel")
                expect(new_hotel_search).to eq(new_hotel)
            end
        end
        context 'when invalid data' do
            it "should not write to db incorrect data" do
                prew_hotel = Hotel.find_by(name: "test")
                prew_hotel&.destroy
                file = Rails.root.join('spec', 'support', 'assets', 'images','hotels' , '370564672.jpg')
                image = ActiveStorage::Blob.create_and_upload!( 
                    io: File.open(file, 'rb'),  
                    filename: '370564672.jpg',  
                    content_type: 'image/jpg'
                ).signed_id
                new_hotel = Hotel.create(
                    location: "tes", 
                    name: "tes",
                    description: "some description"

                )
                expect(new_hotel.valid?).to eq(false)
                expect(new_hotel.errors.full_messages.length).to eq(4)
            end
            it "should not write to db empty data" do
                prew_hotel = Hotel.find_by(name: "test")
                prew_hotel&.destroy

                new_hotel = Hotel.create(
                )
                expect(new_hotel.valid?).to eq(false)
                expect(new_hotel.errors.full_messages.length).to eq(7)
            end
        end
    end
end
