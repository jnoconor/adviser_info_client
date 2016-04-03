class IARepresentative

	ATTRS = [
		:name, :crd, :last_updated, :current_employers, :qualifications, :registration_history,
		:disclosure_information, :broker_dealer_information
	]

	attr_accessor *ATTRS

	def initialize(info = {})
		ATTRS.each do |attr|
			instance_variable_set("@#{attr}", info[attr])
		end
	end

	def to_s
		"#{crd} #{name}"
	end

end