require 'pg'
require 'pry'

class DatabaseAdapter

  class << self

    attr_reader :handle

    def connect(config)
      return NullDatabaseAdapter unless config
      @handle ||= PG.connect(config)
    end

    # insert into table (a,b,c) values ($1,$2,$3)
    def query(query, values)
      handle.exec(query, values)
    end

    def disconnect
      @handle.close
      @handle = nil
    end

  end

end

class NullDatabaseAdapter
  class << self
    def connect
    end

    def query(query, values)
      puts "WARNING: no database configured. Query will not execute."
      puts query + values
      false
    end

    def disconnect
    end
  end
end