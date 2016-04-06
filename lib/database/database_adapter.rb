require 'pg'

class DatabaseAdapter

  class << self

    attr_reader :handle

    def connect(config)
      return NullDatabaseAdapter unless config
      host = config[:host]
      port = config[:port]
      user = config[:user]
      password = config[:password]
      @handle ||= PGconnect
    end

    # insert into table (a,b,c) values (?,?,?)
    def query(query, values)
      handle.execute(query, values)
    end

    def disconnect
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
      puts query, values
      false
    end

    def disconnect
    end
  end
end