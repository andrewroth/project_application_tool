class FixCrisisInfoModelMethods < ActiveRecord::Migration
  # see http://ccc.clockingit.com/tasks/edit/154979

  ADD = {
    Emerg => [ :health_province_shortDesc, :health_province_longDesc, 
               :extended_medical_plan_number, :extended_medical_plan_carrier
    ],
    Person => [ :title ]
  }

  REMOVE = {
    Emerg => [ :health_province_id, :medical_plan_number, :medical_plan_carrier ]
  }

  def self.loop_specs(spec)
    for table, columns in spec
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
    loop_specs(ADD) do |model, cn, ct|
      rm = ReportModel.find_or_create_by_model_s model.to_s.downcase
      rm.report_model_methods.find_or_create_by_method_s cn.to_s
    end

    loop_specs(REMOVE) do |model, cn, ct|
      rm = ReportModel.find_by_model_s model.to_s.downcase
      if rm
        rm_method = rm.report_model_methods.find_by_method_s cn.to_s
        rm_method.destroy if rm_method
      end
    end
  end

  def self.down
    loop_specs(ADD) do |model, cn, ct|
      rm = ReportModel.find_by_model_s model.to_s.downcase
      if rm
        rm_method = rm.report_model_methods.find_by_method_s cn.to_s
        rm_method.destroy if rm_method
      end
    end

    loop_specs(REMOVE) do |model, cn, ct|
      rm = ReportModel.find_by_model_s model.to_s.downcase
      if rm
        rm_method = rm.report_model_methods.find_by_method_s cn.to_s
        rm_method.destroy if rm_method
      end
    end
  end
end
