class ReferalLogProcessor
	module Positions
		TIME = 1
		OLD_CUSTOMER = 2
		ACTION = 3
		NEW_CUSTOMER = 4
	end

	MINIMUM_LOG_LENGTH = 3

	module Actions
		RECOMMENDS = 'recommends'
		ACCEPTS = 'accepts'

		ALL = ['recommends', 'accepts'].freeze
	end

	attr_accessor :referal_log, :customers_involved, :log_details


	def initialize(referal_log)
		@referal_log = referal_log
		@log_details = {}
	end

	def process
		return unless valid?

		process_customer_action
		log_details
	end

	private

	def valid?
		log_valid? && action_valid?
	end 

	def log_valid?
		return true if parsed_referal_log.length() >= MINIMUM_LOG_LENGTH

		logger.error("Invalid log length - #{referal_log}")
		false
	end

	def action_valid?
		return true if Actions::ALL.include?(log_action)

		logger.error("Invalid log action - #{referal_log}")
		false
	end

	def process_customer_action
		if recommend_action?
			log_details[:customer_referee] = old_customer
			log_details[:customer_refered] = new_customer
		else
			log_details[:customer_accepted] = old_customer
		end
	end

	def parsed_referal_log
		@parsed_referal_log ||= referal_log.split(' ')
	end

	def recommend_action?
		log_action == Actions::RECOMMENDS
	end

	def log_action
		@log_action ||= parsed_referal_log[Positions::ACTION]
	end

	def old_customer
		@old_customer ||= parsed_referal_log[Positions::OLD_CUSTOMER]
	end 

	def new_customer
		@new_customer ||= parsed_referal_log[Positions::NEW_CUSTOMER]
	end

	def logger
		@logger ||= Logger.new(STDOUT)
	end
end