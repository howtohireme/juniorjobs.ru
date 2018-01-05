require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should validate_presence_of :email }

  describe 'try to create subscription with invalid email' do
    let(:subscription_invalid) { build(:guest_subscription, email: 'qwerty') }
    it 'show is invalid error' do
      subscription_invalid.valid?
      expect(subscription_invalid.errors[:email]).to include I18n.t('activerecord.errors.models.subscription.attributes.email.invalid')
    end
  end
  
  describe 'try to create subscription with blank email' do
    let(:subscription_blank) { build(:guest_subscription, email: '') }
    it "show can't be blank error" do
      subscription_blank.valid?
      expect(subscription_blank.errors[:email]).to include I18n.t('activerecord.errors.models.subscription.attributes.email.blank')
    end
  end

  describe 'try to create subscription with already taken email' do
    let!(:subscription) { create(:guest_subscription, email: 'mail@mail.com') }  
    let(:duplicate_subscription) { build(:guest_subscription, email: 'mail@mail.com') }
    it 'show already taken error' do
      duplicate_subscription.valid?
      expect(duplicate_subscription.errors[:email]).to include I18n.t('activerecord.errors.models.subscription.attributes.email.taken')
    end
  end

  describe 'registered user can to subscribe and unsubscribe' do
    let!(:subscription) { create(:user_subscription, email: 'mail@mail.com') }
    
    it "user subscribe" do
      subscription.valid?
      expect(subscription.user_id).to_not eq nil
    end

    it "user unsubscribe" do
      subscription.destroy
      expect(Subscription.first).to eq nil
    end
  end

  describe 'create subscription with right email' do
    subject { build(:guest_subscription) }
    it { is_expected.to be_valid }
  end
end