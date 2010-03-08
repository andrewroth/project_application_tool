class RolesSweeper < ActionController::Caching::Sweeper
  observe SupportCoach, ProjectStaff, ProjectAdministrator, ProjectDirector

=begin
  def after(controller)
    return if self.controller.nil?
    super
  end
=end

  def after_destroy(role)
    expire role
  end

  def after_save(role)
    expire role
  end

  protected

  def expire(role)
    return unless role.project

    expire_fragment(%r{your_projects.project_id=#{role.project.id}&role=.*&section=Acceptance})
  end
end
