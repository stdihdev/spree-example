class StagingEmailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to.join(', ')} | #{message.subject}"
    message.to = ['nelou@stringify.net']
  end
end

if Rails.env.staging?
  ActionMailer::Base.register_interceptor(StagingEmailInterceptor)
end
