if news.present? && news.job.present?
  json.id news.job.id
  json.title news.job.title
  json.action t( 'action', scope: "#{news.loggable_type.downcase.pluralize unless news.loggable_type.blank?}.#{news.action.try(:downcase)}", default: "#{news.action} #{news.loggable_type}" )
  json.author news.author
  json.pubDate news.created_at
  json.link can?(:update, news.job) ? edit_job_url( id: news.job.id ) : job_url( id: news.job.id )
end