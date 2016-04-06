require 'json'
class InvestorRecord

  attr_accessor :db_adapter

  def initialize(info = {}, db_adapter = NullDatabaseAdapter)
    fields.each do |attribute|
      instance_variable_set("@#{attribute}", info[attribute])
    end
    @db_adapter = db_adapter
  end

  def write(file_path, format)
    raise "Define #write in child class"
  end

  def save
    db_adapter.query("INSERT INTO #{table} (#{db_columns}) VALUES (#{db_placeholders})", db_values)
  end

  def write(file_path, format)
    File.open(file_path, "w+") { |f| f.write(self.send("to_#{format}"))}
  end

  def to_csv
    fields.map { |f| send(f) }.join(",")
  end

  def to_json
    JSON.unparse(fields.each_with_object({}) do |field, hash|
      hash[field] = send(field)
    end)
  end

  private

  def fields
    raise "Define #fields in child class"
  end

  def table
    raise "Define #table in child class"
  end

  def db_columns
    fields.map(&:to_s).join(",")
  end

  def db_placeholders
    fields.map { |_| "?" }.join(",")
  end

  def db_values
    fields.map { |f| send(f) }.join(",")
  end

end