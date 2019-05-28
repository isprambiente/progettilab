class TimetableMailer < ApplicationMailer
  def expired(job)
    @job = job
    @url  = job_timetables_url(job_id: job.id)
    subject = "[#{Settings.config.group}] Il proc/att cod. #{job.code}, è scaduta"
    job.job_managers.each do |manager|
      @manager = manager
      mail(to: manager.email, subject: subject)  do |format|
        format.html
        format.text
      end
    end
  end
end
