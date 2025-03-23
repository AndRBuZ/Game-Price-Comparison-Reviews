require 'rails_helper'

RSpec.describe OauthAccount, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
  end
end
