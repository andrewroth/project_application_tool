module MainHelper
  def link(title, path)
    "<a href='#{path}'>#{title}</a>"
  end

  def view_entire_link(profile_id)
    link 'view entire', "/profiles_viewer/#{profile_id}/entire"
  end

  def view_summary_link(profile_id)
    link 'view summary', "/profiles_viewer/#{profile_id}/summary"
  end

  def edit_always_editable_link(profile_id)
    link 'edit', "/appln/view_always_editable/?profile_id=#{profile_id}"
  end

  def manual_donations_link(motv_code)
    link 'manual donations', "/manual_donations/new?motv_code=#{motv_code}"
  end

  def costing_link(profile_id)
    link 'costing', "/optin_cost_items/index?profile_id=#{profile_id}"
  end

  def travel_link(profile_id)
    link 'travel', "/profile_travel_segments/index?profile_id=#{profile_id}"
  end
  
  def profile_notes_link(profile_id, nn)
    link "notes(#{nn})", "/profile_notes/?profile_id=#{profile_id}"
  end

  def evaluate_link(profile_id, project_id)
    evaluate_with_message 'evaluate', profile_id, project_id
  end

  def continue_evaluate_link(msg, profile_id, project_id)
    evaluate_with_message msg, profile_id, project_id
  end

  def evaluate_with_message(msg, profile_id, project_id)
    link msg, "/processor/evaluate?profile_id=#{profile_id}?project_id=#{project_id}"
  end

  def view_entire_processor_link(profile_id, project_id)
    #link 'view entire', "/processor/view_entire?profile_id=#{profile_id}"
    view_entire_link(profile_id)
  end

  def view_entire_processor_link(profile_id)
    #link 'view entire', "/processor/view_entire?profile_id=#{profile_id}"
    view_entire_link(profile_id)
  end
  
  def withdraw_move_link(id, label = 'move/withdraw..')
     link label, "/profiles/move/#{id}"
  end
  
  def ref(ref) 
    if ref.nil?
      "none"
    elsif ref.status != 'completed' && ref.mail?
      @viewer.can_evaluate? ? "mailing (" + link("input", ref.ref_url) + ")" : "mailing"
    else
      ref.status
    end
  end
  
end
