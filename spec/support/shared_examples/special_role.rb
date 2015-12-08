shared_examples_for "SpecialRole" do |role_class, role_name|
  let(:strategy) do
    role_class.new(team, projects_repository, roles_repository)
  end
  let(:team) { TeamObject.new(asana_id: '1111') }
  let(:roles_repository) do
    instance_double('RolesRepository', create_from: true)
  end

  let(:special_project) do
    ProjectObject.new(name: role_name, asana_id: '7777')
  end

  describe '#perform' do
    subject { strategy.perform }

    context "#{role_name} role doesn't exist in Asana" do
      let(:special) { [] }

      it "creates #{role_name} role in Asana" do
        expect(projects_repository).to receive(:create)
        subject
      end

      it "creates #{role_name} role in DB" do
        expect(roles_repository).to receive(:create_from)
        .with(special_project, team)
        subject
      end
    end

    context "#{role_name} role exists in Asana" do
      let(:special) { [special_project] }

      it "doesn't create #{role_name} role" do
        expect(projects_repository).not_to receive(:create)
        subject
      end
    end
  end
end
