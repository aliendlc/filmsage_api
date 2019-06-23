class Photo
    if(ENV['DATABASE_URL'])
        uri = URI.parse(ENV['DATABASE_URL'])
        DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
        DB = PG.connect({:host => "localhost", :port => 5432, :dbname => 'calmlion_api_development'})
    end


    def self.create(opts)
        results = DB.exec(
            <<-SQL
                INSERT INTO photos (type, iso, film, aperture, shutter, latitude, longitude, date, camera, description)
                VALUES ( '#{(opts["type"])}', '#{(opts["iso"])}', '#{(opts["film"])}', '#{(opts["aperture"])}', '#{(opts["shutter"])}', #{(opts["latitude"])}, #{(opts["longitude"])}, '#{(opts["date"])}', '#{(opts["camera"])}', '#{(opts["description"])}')
                RETURNING type, iso, film, aperture, shutter, latitude, longitude, date, camera, description;
            SQL
        )
        return {
            "type" => results.first["type"],
            "iso" => results.first["iso"],
            "film" => results.first["film"],
            "aperture" => results.first["aperture"],
            "shutter" => results.first["shutter"],
            "latitude" => results.first["latitude"].to_i,
            "longitude" => results.first["longitude"].to_i,
            "date" => results.first["date"],
            "camera" => results.first["camera"],
            "description" => results.first["description"]
        }
    end
    def self.all
        results = DB.exec(
            <<-SQL
            SELECT
              * FROM photos;
            SQL
        )

        return results.map do |result|
            {
              "type" => result["type"],
              "iso" => result["iso"],
              "film" => result["film"],
              "aperture" => result["aperture"],
              "shutter" => result["shutter"],
              "latitude" => result["latitude"].to_i,
              "longitude" => result["longitude"].to_i,
              "date" => result["date"],
              "camera" => result["camera"],
              "description" => result["description"],
              "photo_id" => result["photo_id"].to_i,
              "photo_url" => result["photo_url"]
            }
        end
    end
    def self.update(opts, id)
        results = DB.exec(
            <<-SQL
                UPDATE photos
                SET type='#{opts["type"]}', iso='#{opts["iso"]}', film='#{opts["film"]}', aperture='#{opts["aperture"]}', shutter='#{opts["shutter"]}',
                  camera='#{opts["camera"]}',
                  description='#{opts["description"]}',
                  photo_url='#{opts["photo_url"]}'
                WHERE photo_id=#{id}
                RETURNING type, iso, film, aperture, shutter, latitude, longitude, date, camera, description, photo_id, photo_url;
            SQL
        )
        return {
          "type" => results.first["type"],
          "iso" => results.first["iso"],
          "film" => results.first["film"],
          "aperture" => results.first["aperture"],
          "shutter" => results.first["shutter"],
          "latitude" => results.first["latitude"].to_i,
          "longitude" => results.first["longitude"].to_i,
          "date" => results.first["date"],
          "camera" => results.first["camera"],
          "description" => results.first["description"],
          "photo_id" => results.first["photo_id"],
          "photo_url" => results.first["photo_url"]

        }
    end
    def self.delete(id)
        results = DB.exec("DELETE FROM photos WHERE photo_id=#{id};")
        return { "deleted" => true }
    end
end
