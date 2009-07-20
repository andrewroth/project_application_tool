class AddCrisisInfoEnhancementsToIntranet < ActiveRecord::Migration
  # see http://ccc.clockingit.com/tasks/edit/154979

=begin
  SPEC = {
    Person => [ :person_cell_phone, { :person_local_valid_until => :date } ],
    Emerg => [ { :emerg_health_province_id => :integer },
               :emerg_health_number,
               :emerg_medical_plan_number,
               :emerg_medical_plan_carrier,
               :emerg_doctor_name,
               :emerg_doctor_phone,
               :emerg_dentist_name,
               :emerg_dentist_phone,
               :emerg_blood_type,
               :emerg_rh_factor
    ]
  }
=end

  SPEC = {
    Person => [ :cell_phone, { :local_valid_until => :date } ],
    Emerg => [ { :health_province_id => :integer },
               :health_number,
               :medical_plan_number,
               :medical_plan_carrier,
               :doctor_name,
               :doctor_phone,
               :dentist_name,
               :dentist_phone,
               :blood_type,
               :blood_rh_factor
    ]
  }


  def self.loop_specs
    for table, columns in SPEC
      for column in columns
        if column.class == Symbol
          cn, ct = column, :string
        elsif column.class == Hash
          cn, ct = column.keys.first, column.values.first
        end

        yield table, cn, ct
      end
    end
  end

  def self.up
    loop_specs do |model, cn, ct|
      unless model.column_names.include?(cn.to_s)
        add_column model.table_name, cn, ct

        rm = ReportModel.find_or_create_by_model_s model.to_s.downcase
        rm.report_model_methods.find_or_create_by_method_s cn.to_s
      end
    end
  end

  def self.down
    loop_specs do |model, cn, ct|
      remove_column model.table_name, cn

      rm = ReportModel.find_by_model_s model.to_s.downcase
      if rm
        rm_method = rm.report_model_methods.find_by_method_s cn.to_s
        rm_method.destroy if rm_method
      end
    end
  end
end
