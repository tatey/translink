module Translink
  module DB
    def self.context uri, options = {}
      DataMapper.setup :default, uri
      DataMapper.repository :default do |repository|
        DataMapper.finalize
        repository.adapter.execute <<-SQL
          PRAGMA foreign_keys=ON;
        SQL
        if options[:migrate]
          repository.adapter.execute <<-SQL
            DROP TABLE IF EXISTS "routes";
            CREATE TABLE "routes" (
              "route_id" TEXT NOT NULL PRIMARY KEY UNIQUE,
              "short_name" TEXT NOT NULL,
              "long_name" TEXT NOT NULL,
              "route_type" INTEGER NOT NULL
            );

            DROP TABLE IF EXISTS "trips";
            CREATE TABLE "trips" (
              "trip_id" INTEGER NOT NULL PRIMARY KEY UNIQUE,
              "direction" INTEGER NOT NULL,
              "headsign" TEXT NOT NULL,
              "route_id" TEXT NOT NULL,
              FOREIGN KEY ("route_id") REFERENCES "routes" ("route_id") ON DELETE CASCADE
            );

            CREATE INDEX "index_trips_on_route_id" ON "trips" ("route_id");

            DROP TABLE IF EXISTS "stop_times";
            CREATE TABLE "stop_times" (
              "arrival_time" STRING NOT NULL,
              "stop_sequence" INTEGER NOT NULL,
              "stop_id" TEXT NOT NULL,
              "trip_id" INTEGER NOT NULL,
              PRIMARY KEY ("arrival_time", "stop_id", "trip_id"),
              FOREIGN KEY ("stop_id") REFERENCES "stops" ("stop_id") ON DELETE RESTRICT,
              FOREIGN KEY ("trip_id") REFERENCES "trips" ("trip_id") ON DELETE CASCADE
            );

            DROP TABLE IF EXISTS "stops";
            CREATE TABLE "stops" (
              "stop_id" TEXT NOT NULL PRIMARY KEY UNIQUE,
              "stop_name" TEXT NOT NULL,
              "stop_lat" REAL NOT NULL,
              "stop_lon" REAL NOT NULL
            );
          SQL
        end
        yield if block_given?
      end
    end
  end
end

