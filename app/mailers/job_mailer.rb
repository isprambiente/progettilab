class JobMailer < ApplicationMailer
  def create(job, user, author: :nil, role: nil)
    @job = job
    @author = author
    @user = user
    @role = role
    @url  = edit_job_url(id: job.id)
    subject = "[#{Settings.config.group}] Il nuovo proc/att cod. #{job.code}, ti è stata assegnata"
    subject += " da #{author.label}" unless author.blank?
    mail(to: user.email, subject: subject)  do |format|
      format.html
      format.text
    end
  end

  def delete(job, user, author: :nil, role: nil)
    @job = job
    @author = author
    @user = user
    @role = role
    @url  = edit_job_url(id: job.id)
    subject = "[#{Settings.config.group}] Sei stato rimosso dal proc/att cod. #{job.code}"
    subject += " da #{author.label}" unless author.blank?
    mail(to: user.email, subject: subject)  do |format|
      format.html
      format.text
    end
  end
end