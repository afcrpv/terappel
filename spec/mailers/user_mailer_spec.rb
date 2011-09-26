require "spec_helper"

describe UserMailer do
  describe "reset_password_email" do
    let(:user) { Factory(:user, :reset_password_token => "anything") }
    let(:mail) { UserMailer.reset_password_email(user) }

    it "sends user password reset url" do
      mail.subject.should eq(I18n.t('sessions.password_resets.mail_subject'))
      mail.to.should eq([user.email])
      mail.from.should eq(["notifications@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(edit_password_reset_path(user.reset_password_token))
    end
  end
end
