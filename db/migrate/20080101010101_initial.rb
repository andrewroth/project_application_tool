class Initial < ActiveRecord::Migration
  def self.up
    unless Answer.table_exists?
      create_table Answer.table_name do |t|
        t.column "question_id", :integer
        t.column "instance_id", :integer
        t.column "answer",      :string,  :limit => 4000
      end
    end
    
    unless Element.table_exists?
      create_table Element.table_name do |t|
        t.column "parent_id",       :integer
        t.column "type",            :string,   :limit => 50
        t.column "text",            :text
        t.column "is_required",     :boolean
        t.column "question_table",  :string,   :limit => 50
        t.column "question_column", :string,   :limit => 50
        t.column "position",        :integer
        t.column "created_at",      :datetime
        t.column "updated_at",      :datetime
        t.column "created_by_id",   :integer
        t.column "updated_by_id",   :integer
        t.column "dependency_id",   :integer
      end
    end
  
    unless PageElement.table_exists?
      create_table PageElement.table_name do |t|
        t.column "page_id",    :integer
        t.column "element_id", :integer
        t.column "position",   :integer
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end
    end
  
    unless Page.table_exists?
      create_table Page.table_name do |t|
        t.column "title",         :string,   :limit => 50
        t.column "url_name",      :string,   :limit => 50
        t.column "created_at",    :datetime
        t.column "updated_at",    :datetime
        t.column "created_by_id", :integer
        t.column "updated_by_id", :integer
      end
    end
  
    unless QuestionOption.table_exists?
      create_table QuestionOption.table_name do |t|
        t.column "question_id", :integer
        t.column "option",      :string,   :limit => 50
        t.column "value",       :string,   :limit => 50
        t.column "position",    :integer
        t.column "created_at",  :datetime
      end
    end
  
    unless QuestionnairePage.table_exists?
      create_table QuestionnairePage.table_name do |t|
        t.column "questionnaire_id", :integer
        t.column "page_id",          :integer
        t.column "position",         :integer
        t.column "created_at",       :datetime
        t.column "updated_at",       :datetime
      end
    end
    
    unless Questionnaire.table_exists?
      create_table "questionnaires" do |t|
        t.column "title",      :string,   :limit => 200
        t.column "type",       :string,   :limit => 50
        t.column "created_at", :datetime
      end
    end
  end
  
  def self.down
    drop_table QuestionnairePage.table_name
    drop_table QuestionOption.table_name
    drop_table Page.table_name
    drop_table PageElement.table_name
    drop_table Element.table_name
    drop_table Answer.table_name
    # It isn't safe to drop the questionnaire table because other apps might use it
  end
end