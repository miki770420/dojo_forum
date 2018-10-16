namespace :dev do

  # 請先執行 rails dev:fake_user，可以產生 20 個資料完整的 User 紀錄
  # 其他測試用的假資料請依需要自行撰寫
  task fake_user: :environment do

    20.times do |i|

      file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")

      user = User.new(
        name: FFaker::Name::first_name,
        email: "user#{i+1}@example.co",
        password: "12345678",
        description: FFaker::Lorem::sentence(30),
        avatar: file,
        role: "normal",
      )
      user.save!
    end
    
    puts "now you have #{User.count} users"
    
  end

  
  task fake_post: :environment do
    Post.destroy_all

    40.times do |i|

      file = File.open("#{Rails.root}/public/post/post#{i+1}.jpg")

      Post.create!(
      user: User.all.sample,
      title: FFaker::Lorem::phrase,
      image: file,
      privacy: rand(0..2),
      draft: "false",
      published_at: Time.zone.now,
      content: FFaker::Lorem.sentence,
      replied_at: Time.zone.now,
      )
    end
    puts "now you have #{Post.count} posts"
  end

  task fake_category: :environment do
    Category.destroy_all

     category_list = [
      { name: "Tech" },
      { name: "Education" },
      { name: "Love" },
      { name: "Environment" },
      { name: "Economy" },
    ]
    category_list.each do |category|
      Category.create( name: category[:name] )
    end
    puts "#{Category.count}Categories are created!"
  end

  task fake_reply: :environment do
    Reply.destroy_all

    Tweet.all.each do |tweet|
      5.times do |i|
        tweet.replies.create!(
        user: User.all.sample,
        comment: FFaker::BaconIpsum.sentence
        )
      end
    end
    puts "have created fake reply"
    puts "now you have #{Reply.count} replies data"
  end
end