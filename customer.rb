class Customer
	attr_reader :name
	attr_accessor :score, :referred_customers, :reference_accepted

	def initialize(customer_details)
		@name = customer_details[:name]
		@referred_customers = []
		@reference_accepted = false
		@score = 0.0
	end

	def add_referred_customer(name)
		@referred_customers.append(name)
	end

	def reference_accepted!
		@reference_accepted = true
	end
end