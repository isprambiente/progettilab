puts "POST SEED"

loreti = User.find_or_create_by(username: 'francesco.loreti', label: 'Loreti Francesco')
loreti.update(admin: true, chief: true, locked_at: nil)
# User.find(5).update(headtest: true)
# User.find(8).update(technic: true)


# j = Job.create chief_id: 2, code: "170001", title: "Misurazione condominio Via K.T.70", job_manager_ids: [loreti.id], version: 1, revision: 0, template: "Template1", body: "", open_at: "2017-02-01", close_at: nil, planned_closure_at: "2017-03-01", consolidated: false, pa_support: false, n_samples: 0, metadata: {"fax"=>"434343434", "cell"=>"3443343434", "tel1"=>"+39 06 332548", "tel2"=>"53231", "email"=>"kiiciro@ms.it", "address"=>"via monte delle capre, 54", "contact"=>"Francesco Loreti", "customer"=>"Condominio", "institutions"=>"Arpa Test", "requirements"=>"", "other_resources"=>"chimico, biologo"}
# s = j.samples.create author_id: 18, type_matrix_id: 557, code: 1700001, accepted_at: '2017-02-13 23:00:00 UTC', report: '', device: "548954", start_at: '2017-02-11 23:00:00 UTC', stop_at: '2017-02-17 23:00:00 UTC', conservation: "", body: ""