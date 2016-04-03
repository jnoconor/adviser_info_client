class InvestorRecord

  def initialize(info = {})
    fields.each do |attribute|
      instance_variable_set("@#{attribute}", info[attribute])
    end
  end

  private

  def fields
    raise "Define #fields in child class"
  end

end