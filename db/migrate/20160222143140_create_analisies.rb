class CreateAnalisies < ActiveRecord::Migration[5.2]
  def change
    create_table :analisies do |t|
      t.references :sample,                   index: true
      t.references :analisy_type,             index: true
      t.integer    :code,                                  null: false
      t.integer    :revision,                 index: true, null: false, default: 0
      t.datetime   :reference_at,             index: true
      t.string     :method
      t.text       :body
      
      t.timestamps null: false
    end

    add_foreign_key :analisies, :samples, column: :sample_id, primary_key: "id", on_delete: :cascade
    add_foreign_key :analisies, :analisy_types, column: :analisy_type_id, primary_key: "id", on_delete: :cascade

    add_index :analisies, [:sample_id, :analisy_type_id], order: { sample_id: :asc, analisy_type_id: :asc}
    add_index :analisies, [:code], order: { code: :asc }, unique: true


    execute "CREATE SEQUENCE analisies_code_seq 
        INCREMENT 1
        START 1
        MINVALUE 1
    ;"

    execute "ALTER TABLE analisies ALTER COLUMN code SET DEFAULT ( to_char( CURRENT_DATE , 'YY' ) || lpad(nextval('analisies_code_seq'::regclass)::text, 5, '0') )::int;"

    execute "CREATE FUNCTION reset_analisies_code() RETURNS trigger AS $reset_sequence$
                DECLARE
                    year_old integer := ( SELECT COALESCE( max(date_part('year', created_at)), date_part('year', CURRENT_DATE) ) FROM analisies );
                BEGIN
                    IF (year_old < date_part('year', CURRENT_DATE)) THEN
                      ALTER SEQUENCE analisies_code_seq RESTART WITH 1;
                    END IF;
                    RETURN NEW;
                END;
            $reset_sequence$ LANGUAGE plpgsql;

            CREATE TRIGGER reset_analisies_code BEFORE INSERT ON analisies
                FOR EACH ROW EXECUTE PROCEDURE reset_analisies_code();"
  end
end
