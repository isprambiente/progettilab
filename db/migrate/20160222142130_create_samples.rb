class CreateSamples < ActiveRecord::Migration[5.2]
  def change
    create_table :samples do |t|
      t.references  :job,               index: true, null: false
      t.references  :type_matrix,       index: true
      t.integer     :code,                           null: false, default: ''
      t.string      :device,            index: true, null: false, default: ''
      t.string      :lab_code,          index: true
      t.string      :client_code,       index: true, null: false, default: ''
      t.float       :lat,               index: true
      t.float       :long,              index: true
      t.integer     :epsg,              index: true, null: false, default: 4326
      t.datetime    :start_at,          index: true
      t.datetime    :stop_at,           index: true
      t.date        :accepted_at,       index: true, null: false, default: -> { 'CURRENT_DATE' }
      t.text        :report
      t.string      :conservation
      t.text        :body
      t.string      :created_by,        index: true, null: false, default: 'System'
      t.string      :updated_by,        index: true, null: false, default: 'System'

      t.timestamps null: false
    end

    add_foreign_key :samples, :jobs, column: :job_id, primary_key: "id", on_delete: :cascade

    add_index :samples, [:job_id, :created_at], order: {job_id: :asc, created_at: :asc}
    add_index :samples, [:code], order: { code: :asc }, unique: true
    add_index :samples, [:lat, :long], order: {job_id: :asc, sample_id: :asc}

    execute "CREATE SEQUENCE samples_code_seq 
        INCREMENT 1
        START 1
        MINVALUE 1
    ;"

    execute "ALTER TABLE samples ALTER COLUMN code SET DEFAULT ( to_char( CURRENT_DATE , 'YY' ) || lpad(nextval('samples_code_seq'::regclass)::text, 5, '0') )::int;"

    execute "CREATE FUNCTION reset_samples_code() RETURNS trigger AS $reset_sequence$
                DECLARE
                    year_old integer := ( SELECT COALESCE( max(date_part('year', created_at)), date_part('year', CURRENT_DATE) ) FROM samples );
                BEGIN
                    IF (year_old < date_part('year', CURRENT_DATE)) THEN
                      ALTER SEQUENCE samples_code_seq RESTART WITH 1;
                    END IF;
                    RETURN NEW;
                END;
            $reset_sequence$ LANGUAGE plpgsql;

            CREATE OR REPLACE FUNCTION add_lab_code() RETURNS trigger AS $add_lab_code$
              BEGIN
                UPDATE samples SET lab_code = ( NEW.code || 
                  CASE
                        WHEN NEW.device = '' THEN ''
                        ELSE '/' || NEW.device
                    END
                ) WHERE id = NEW.id;
                RETURN NEW;
              END;
            $add_lab_code$ LANGUAGE plpgsql;

            CREATE TRIGGER reset_samples_code BEFORE INSERT ON samples
                FOR EACH ROW EXECUTE PROCEDURE reset_samples_code();

            CREATE TRIGGER add_lab_code AFTER INSERT ON samples
                FOR ROW EXECUTE PROCEDURE add_lab_code();"
  end
end
