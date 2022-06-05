namespace :add_new_users do
  desc 'Add new users'
  task add_users: :environment do
    user_group = [UserGroup.find_by_name("Quetta")]
    location = Location.find_by('name_i18n @> ?', {en: "Country 1::Province 1::District 1"}.to_json).location_code

    User.create_or_update!(
      user_name: 'asajjad',
      password: 'abcd1234',
      password_confirmation: 'abcd1234',
      full_name: 'Ahmed Sajjad',
      email: 'Ahm@gmail.com',
      disabled: 'false',
      agency_id: Agency.find_by(agency_code: 'A2').id,
      role_id: Role.find_by_name('Referral').id,
      user_groups: user_group,
      locale: Primero::Application::LOCALE_ENGLISH,
      location: location
    )

    User.create_or_update!(
      user_name: 'bali',
      password: 'abcd1234',
      password_confirmation: 'abcd1234',
      full_name: 'Babar Ali',
      email: 'Bab@gmail.com',
      disabled: 'false',
      agency_id: Agency.find_by(agency_code: 'A3').id,
      role_id: Role.find_by_name('Referral').id,
      user_groups: user_group,
      locale: Primero::Application::LOCALE_ENGLISH,
      location: location
    )

    User.create_or_update!(
      user_name: 'zhaider',
      password: 'abcd1234',
      password_confirmation: 'abcd1234',
      full_name: 'Zara Haider',
      email: 'Zar@gmail.com',
      disabled: 'false',
      agency_id: Agency.find_by(agency_code: 'A12').id,
      role_id: Role.find_by_name('CP Manager').id,
      user_groups: user_group,
      locale: Primero::Application::LOCALE_ENGLISH,
      location: location
    )

    User.create_or_update!(
      user_name: 'famir',
      password: 'abcd1234',
      password_confirmation: 'abcd1234',
      full_name: 'Fatima Amir',
      email: 'Fat@gmail.com',
      disabled: 'false',
      agency_id: Agency.find_by(agency_code: 'A12').id,
      role_id: Role.find_by_name('CPI In-charge').id,
      user_groups: user_group,
      locale: Primero::Application::LOCALE_ENGLISH,
      location: location
    )

    User.create_or_update!(
      user_name: 'aabid',
      password: 'abcd1234',
      password_confirmation: 'abcd1234',
      full_name: 'Ali Abid',
      email: 'Ali@gmail.com',
      disabled: 'false',
      agency_id: Agency.find_by(agency_code: 'A12').id,
      role_id: Role.find_by_name('CPHO').id,
      user_groups: user_group,
      locale: Primero::Application::LOCALE_ENGLISH,
      location: location
    )

    User.create_or_update!(
      user_name: 'mhassan',
      password: 'abcd1234',
      password_confirmation: 'abcd1234',
      full_name: 'Mushtaq Hassan',
      email: 'Mus@gmail.com',
      disabled: 'false',
      agency_id: Agency.find_by(agency_code: 'A12').id,
      role_id: Role.find_by_name('System Admin').id,
      user_groups: user_group,
      locale: Primero::Application::LOCALE_ENGLISH,
      location: location
    )
  end
end
