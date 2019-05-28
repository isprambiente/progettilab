json.extract! job, :id, :code, :title, :job_type, :pa_support, :metadata, :body, :open_at, :planned_closure_at, :close_at, :consolidated, :open_on, :planned_closure_on, :close_on
json.status job.get_status
json.managers job.job_managers.present? ? job.job_managers.pluck(:label).join(', ') : ''
json.customer job.customer.present? ? job.customer : ''
json.timetables job.timetables do |t|
  json.id t.id
  # json.partial! 'timetables/timetable', collection: job.timetables, as: :timetable
end
json.samples job.samples do |t|
  json.id t.id
  # json.partial! 'samples/sample', collection: job.samples, as: :sample
end
json.analisies job.analisies do |t|
  json.id t.id
  # json.partial! 'analisies/analisy', collection: job.analisies, as: :analisy
end
json.reports job.reports.issued do |t|
  json.id t.id
  # json.partial! 'analisies/analisy', collection: job.analisies, as: :analisy
end
json.readable can?(:read, job)
json.editable can?(:update, job)
json.openable can?(:reopen, job)
json.printable can?(:print, job)
json.deletable can?(:destroy, job)
json.url job_path(job)
json.timetables_url job_timetables_path(job_id: job.id)
json.samples_url job_samples_path(job_id: job.id)
json.analisies_url job_analisies_path(job_id: job.id)