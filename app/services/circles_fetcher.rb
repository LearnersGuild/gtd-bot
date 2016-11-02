class CirclesFetcher < BaseService
  takes :glass_frog_client

  def perform
    circles = glass_frog_client.circles
    roles_with_details = glass_frog_client.roles

    circles.map do |circle|
      circle.roles = detailed_roles(circle, roles_with_details)
      circle
    end
  end

  private

  def detailed_roles(circle, roles_with_details)
    circle.roles.map do |role|
      role = roles_with_details.detect { |r| r.glass_frog_id == role.glass_frog_id }
      role.glass_frog_circle_name = circle.name
      role
    end
  end
end
