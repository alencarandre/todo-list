# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def create_lists(user)
  (1..10).each do |n|
    list_name = "List #{n} of #{user.name}"
    List.where(user: user, name: list_name)
        .first_or_create!(name: list_name,
                          access_type: :shared)
  end
end

fernando =
  User.where(email: "me@fernando.com")
      .first_or_create!(name: 'Fernando',
                        password: "123456",
                        password_confirmation: "123456")

amanda =
  User.where(email: "me@amanda.com")
      .first_or_create!(name: 'Amanda',
                        password: "123456",
                        password_confirmation: "123456")

create_lists(fernando)
create_lists(amanda)
