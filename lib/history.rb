class History

	attr_accessor :registry

	def initialize(config = {})
		@registry = []
	end

	def add(object)
		registry << {time: Time.now, object: object}
		object
	end

	def list
		registry.each_with_index do |entry, index|
			puts "#{index} #{entry[:time]}: #{entry[:object]}"
		end
	end

	def recall(index)
		registry[index]
	end

end