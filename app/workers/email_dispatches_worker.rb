# frozen_string_literal: true

require 'gibbon'

class EmailDispatchesWorker
  include Sidekiq::Worker

  def perform(email)
    md5_email = Digest::MD5.hexdigest(email)
    gibbon = Gibbon::Request.new(api_key: ENV['ACCESS_KEY_ID'])
    gibbon.lists(ENV['MAILCHIMP_LIST_ID']).members(md5_email.downcase).upsert(body: { email_address: email, status: 'subscribed' })
  end
end
