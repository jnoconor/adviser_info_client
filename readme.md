# Investor Record Ruby Library
--------------------------------
example usages

# optional config
config = {}

client = AdviserInfo::Client.new(config)

record = client.get_one(id) # gets a single IARep, IAFirm, Broker, or BrokerFirm

client.get(ids) # gets a collection of investor record objects

record.write(filepath, :csv) # writes to provided file path or file path from config

record.save # writes to database if provided in config

client.history # lists all of the objects fetched by the client

