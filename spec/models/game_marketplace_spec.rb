require 'rails_helper'

RSpec.describe GameMarketplace, type: :model do
  it { should belong_to(:game) }
  it { should belong_to(:marketplace) }
end
