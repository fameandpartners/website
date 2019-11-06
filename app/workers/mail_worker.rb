class MailWorker
    include Sidekiq::Worker
    def perform(subject, body, receiver, send_at = Time.now)
        m = Mailer.notice_mail subject, body, receiver, send_at
        m.deliver
    end
end
    