json.extract! timetable, :id, :job_id, :title, :start_at, :start_on, :stop_at, :stop_on, :days, :products, :execute_at, :execute_on, :body, :sortorder, :status
json.restrict timetable.restrict? ? t('true') : t('false')
json.editable can?(:update, timetable)
json.deletable can?(:destroy, timetable)
json.url job_timetable_path(job_id: timetable.job_id, id: timetable.id)