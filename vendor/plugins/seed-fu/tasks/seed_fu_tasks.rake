namespace :db do
  desc <<-EOS
    Loads seed data for the current environment. It will look for
    ruby seed files in <RAILS_ROOT>/db/fixtures/ and 
    <RAILS_ROOT>/db/fixtures/<RAILS_ENV>/.

    By default it will load any ruby files found. You can filter the files
    loaded by passing in the SEED environment variable with a comma-delimited
    list of patterns to include. Any files not matching the pattern will
    not be loaded.
    
    You can also change the directory where seed files are looked for
    with the FIXTURE_PATH environment variable. 
    
    Examples:
      # default, to load all seed files for the current environment
      rake db:seed
      
      # to load seed files matching orders or customers
      rake db:seed SEED=orders,customers
      
      # to load files from RAILS_ROOT/features/fixtures
      rake db:seed FIXTURE_PATH=features/fixtures 
  EOS
  task :seed => :environment do
    fixture_path = ENV["FIXTURE_PATH"] ? ENV["FIXTURE_PATH"] : "db/fixtures"

    global_seed_files = Dir[File.join(RAILS_ROOT, fixture_path, '*.rb')].sort
    env_specific_seed_files = Dir[File.join(RAILS_ROOT, fixture_path, RAILS_ENV, '*.rb')].sort
    potential_seed_files = (global_seed_files + env_specific_seed_files).uniq
    
    if ENV["SEED"]
      filter = ENV["SEED"].gsub(/,/, "|")
      potential_seed_files.reject!{ |file| true unless file =~ /#{filter}/ }
      puts "\n == Filtering seed files against regexp: #{filter}"
    end

    potential_seed_files.each do |file|
      pretty_name = file.sub("#{RAILS_ROOT}/", "")
      puts "\n== Seed from #{pretty_name} " + ("=" * (60 - (17 + File.split(file).last.length)))
      load file
    end
  end

  namespace :seed do
    desc <<-EOS
  dumps all values in the database for a given model in to a seed file
  
  model=<modelname>
  seed=<path to output file> or standard out if no seed= given
  constraints=<cn1,cn2,...> will output Model.seed(:c1, :c2, ...) do ...
  columns=<cl1,cl2,...> or output all columns if not given

    EOS
    task :dump => :environment do
      model = ENV['model'].constantize
      model_varname = model.name.underscore.downcase
      columns = ENV['columns'] ? ENV['columns'].split(',') : model.column_names
      constraints = ENV['constraints'].split(',').collect{|c| ":#{c}"}.join(', ')

      output = ENV['seed'] ? File.open(ENV['seed'], 'w') : STDOUT

      seeds = model.all.collect{ |row|
"#{model.name}.seed(#{constraints}) do \|#{model_varname}\|
#{columns.collect { |col|
  val = row.send(col)
  val_s = case val.class.name
          when String.name
            "'#{val}'"
          when NilClass.name
            'nil'
          else
            val
          end

"  #{model_varname}.#{col} = #{val_s}"
}.join("\n")}
end"
      }

      output.puts seeds.join("\n\n")
    end
  end
end
