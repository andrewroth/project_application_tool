require File.dirname(__FILE__) + '/../test_helper'

class ReferenceTest < Test::Unit::TestCase
  fixtures 'questionnaire_engine/form_elements'
  fixtures :reference_instances
  fixtures :applns

  # Replace this with your real tests.
  def test_truth
    instance_ids = Reference.find(:first).reference_instances.collect &:id
    Reference.find(:first).destroy
    assert ReferenceInstance.find_all_by_id(instance_ids).size == 0
    assert ReferenceInstance.count > 0
  end
end
