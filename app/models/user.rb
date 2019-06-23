
class User
    if(ENV['DATABASE_URL'])
        uri = URI.parse(ENV['DATABASE_URL'])
        DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
        DB = PG.connect({:host => "localhost", :port => 5432, :dbname => 'calmlion_api_development'})
    end

    # @x = Bcrypt::Password.new(opts["password"]

    def self.create(opts)
        # p opts
        p ActiveSupport::MessageEncryptor.new(opts["password"])
        results = DB.exec(
            <<-SQL
                INSERT INTO users (username, password, created_on)
                VALUES ( '#{(opts["username"])}', '#{(opts["password"])}', '#{(opts["timeStamp"])}')
                RETURNING user_id, username;
            SQL
        )
        return {
            "user_id" => results.first["user_id"].to_i,
            "username" => results.first["username"]
            # "created"
        }
    end
end
