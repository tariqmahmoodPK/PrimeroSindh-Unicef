namespace :remove_child_name_filed do
  desc 'remove_child_name_filed'
  task remove_child_name_filed: :environment do
    Field.find_by(name: 'child_s_name').destroy

    name_of_user =  Field.find_by(name: 'name_of_user')
    name_of_user.update!(
      editable: true,
      disabled: false
    )

    case_goal =  Field.find_by(name: 'case_goal')
    case_goal.update!(
      editable: true,
      disabled: false
    )
  end
end
