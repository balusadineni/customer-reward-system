require 'sinatra'
require 'pry'
require 'logger'

require './customer_reward_service'
require './referal_log_processor'
require './customer'
require './file_reader'
require './customer_score_calculator'

get '/' do
  'Hello world!'
end

get '/customer_scores' do
  file = params[:file]
  customer_scores = CustomerRewardService.new(file).scores
  customer_scores.to_json
end
