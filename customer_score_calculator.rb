class CustomerScoreCalculator

	attr_reader :customers

	def initialize(customers)
		@customers = customers
	end

	def calculate
		customers.each do |customer_name, customer|
			customers[customer_name].score = customer_score(customer, 0, 0.0)
		end
		customers
	end

	private

	def customer_score(customer, level, score)
		return 0.0 if customer.referred_customers.empty?

		customer.referred_customers.each do |customer_name|
			if customers[customer_name].reference_accepted
				score += customer_score(customers[customer_name], level+1, score)
				score += score(level)
			end
		end
		score
	end

	def score(level)
		(1.0/2.0)**level
	end
end