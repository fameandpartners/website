namespace "db" do
  namespace "populate" do
    desc "do all the blog populate tasks"
    task blog: :environment do
      Rake::Task["db:populate:blog:categories"].execute
      Rake::Task["db:populate:blog:posts"].execute
    end

    namespace "blog" do
      desc "populate blog cateries"
      task categories: :environment do
      end

      desc "fullfill existing categries with some lorem ipsum posts"
      task posts: :environment do
      end
    end
  end
end
