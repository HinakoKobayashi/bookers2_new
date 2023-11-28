# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザーを作成
15.times do |n|
  name = "ユーザー#{n + 1}"
  email = "user#{n + 1}@user.com"

  # 同じ名前またはメールアドレスのユーザーが存在しない場合にのみ作成
  unless User.exists?(name: name, email: email)
    User.create!(
      name: name,
      introduction: "#{name}です。よろしくお願いします。",
      email: email,
      password: "123456",
      profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/no_image.jpg")), filename: "no_image.jpg")
    )
  end
end

User.all.each do |user|
  rand(1..5).times do
    user.books.create!(
      user_id: user.id,
      title: "タイトル#{rand(1..100)}",
      body: 'テキストテキストテキストテキスト'
    )
  end
end

# フォロー関係を作成
User.all.each do |user|
  # ユーザーが他のユーザーをフォローする例
  random_user_to_follow = User.where.not(id: user.id).sample
  user.follow(random_user_to_follow)
end