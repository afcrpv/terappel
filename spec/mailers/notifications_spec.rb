require 'rails_helper'

RSpec.describe Notifications, type: :mailer do
  describe 'signup' do
    let!(:user) { create(:user) }
    let(:mail) { Notifications.signup(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Signup')
      expect(mail.to).to eq([ENV['ADMIN_EMAIL']])
      expect(mail.from).to eq(['noreply@terappel.fr'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/nouvel utilisateur/)
    end
  end
end
