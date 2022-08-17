require 'pry'

class CustomerRewardService
	module CustomerTypes
		CUSTOMER_REFEREE = :customer_referee
		CUSTOMER_REFERED = :customer_refered
		CUSTOMER_ACCEPTED = :customer_accepted	
	end

	attr_reader :referal_logs
	attr_accessor :referal_customers_details, :customers

	def initialize(file)
		@referal_logs = FileReader.new(file).content
		@referal_customers_details = []
		@customers = { }
	end

	def scores
		return unless valid?

		process_referal_logs
		add_customers_involved
		calculate_customers_score
		customers_scores
	end


	private 

	def valid?
		!referal_logs.empty?
	end

	def process_referal_logs
		referal_logs.map do |referal_log|
			referal_log_details = ReferalLogProcessor.new(referal_log).process

			referal_customers_details.append(referal_log_details)
		end
	end

	def add_customers_involved
		referal_customers_details.map do |referal_customer_details|
			add_customer_referee(referal_customer_details[CustomerTypes::CUSTOMER_REFEREE])
			add_customer_refered(
				referal_customer_details[CustomerTypes::CUSTOMER_REFEREE], 
				referal_customer_details[CustomerTypes::CUSTOMER_REFERED]
			)
			make_customer_accepted(referal_customer_details[CustomerTypes::CUSTOMER_REFERED])
		end
	end

	def calculate_customers_score
		CustomerScoreCalculator.new(customers).calculate
	end

	def customers_scores
		customer_scores = { }

		customers.each do |customer_name, customer|
			next if customer.score <= 0.0

			customer_scores[customer_name] = customer.score			
		end
		customer_scores
	end

	def add_customer_referee(customer_name)
		return if customer_name.nil? || !customers[customer_name].nil?

		customers[customer_name] = Customer.new({name: customer_name})
		customers[customer_name].reference_accepted!
	end

	def add_customer_refered(referee_name, customer_name)
		return if referee_name.nil? || customer_name.nil? || !customers[customer_name].nil?

		customers[customer_name] = Customer.new({name: customer_name})
		customers[referee_name].add_referred_customer(customer_name)
	end

	def make_customer_accepted(customer_name)
		return if customers[customer_name].nil?

		customers[customer_name].reference_accepted!
	end
end