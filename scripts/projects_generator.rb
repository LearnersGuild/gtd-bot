require File.expand_path('../../config/environment', __FILE__)

class ProjectsGenerator < BaseService
  inject :teams_matcher, :asana_client, :parallel_iterator

  API_KEY = ENV.fetch('ASANA_API_KEY')
  WORKSPACE = ENV.fetch('ASANA_WORKSPACE_ID')
  PROJECTS_NUMBER = 100
  TASKS_NUMBER = 3

  def perform
    teams = teams_matcher.perform
    teams.each do |team|
      generate_projects(team)
    end
  end

  private

  def generate_projects(team)
    parallel_iterator.each((1..PROJECTS_NUMBER).to_a) do |n|
      name = "Project_#{n}"
      project = asana_client.create_project(WORKSPACE,
                                            team.asana_id, name: name)
      generate_tasks(project)
      logger.info("#{project.name} created")
    end
  end

  def generate_tasks(project)
    (1..TASKS_NUMBER).to_a.each do |t|
      name = "Task_#{t}_in_#{project.name}"
      asana_client.create_task(WORKSPACE, project.asana_id, name: name)
    end
  end
end
ProjectsGenerator.new.perform
