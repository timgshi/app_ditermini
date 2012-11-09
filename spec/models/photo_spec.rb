# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  filename   :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  caption    :string(255)      default("")
#

describe Photo do

  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is wrong!
    @photo = Photo.new(filename: "test_photo.jpg", user_id: user.id)
  end

  subject { @photo }

  it { should respond_to(:filename) }
  it { should respond_to(:user_id) }
end
