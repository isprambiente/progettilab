json.DT_RowId "tr_#{report.id}"
json.id report.id
json.code report.code
json.type report.report_type
json.issued_on report.issued_on

json.readable can?(:read, report)
json.editable false
json.deletable can?(:destroy, report)
json.creable false
json.valid? report.valid?
json.url job_report_url(job_id: report.job.id, id: report.id)