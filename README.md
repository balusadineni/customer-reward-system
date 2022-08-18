# customer-reward-system

This is a basic web application for calculating reward score of customers for their referals

Table of Contents
=================
* [Documentation](#documentation)
* [Setting up development environment](#setting-up-development-environment)
  * [Prerequisites](#prerequisites)
* [Running the application](#running-the-application)
* [Running tests](#running-tests)
* [Thought Process](#thought-process)

## Documentation

* This API has one GET method - `/scores`
* `/scores` - This accepts a file and returns scores for customers in the company.

Sample input file
```
2018-06-12 09:41 A recommends B
2018-06-14 09:41 B accepts
2018-06-16 09:41 B recommends C
2018-06-17 09:41 C accepts
2018-06-19 09:41 C recommends D
2018-06-23 09:41 B recommends D
2018-06-25 09:41 D accepts
```
The output for this case would be:
```
{
    "A": 1.75,
    "B": 1.5,
    "C": 1
}
```

## Setting up development environment

### Prerequisites

* This app is using `ruby 2.7.6`
* Install **ruby 2.7.6**: `rbenv install 2.7.6`
* Run `bundle install` to install the gems

## Running the application

* Run `ruby customer_reward_system.rb` - This will start a HTTP server on the port 4567
* Run the following curl command to get the scores with input file in same directory
```
curl -XGET -H "Content-type: application/json" 'http://localhost:4567/scores?file=input1'
```

## Running tests

* Run `bundle exec rspec spec`

## Thought Process

* As I am processing the referal logs I decided to create an independant service.
* `CustomerRewardService` is the main service where all orchestration happens.
* Moved referal log reading and defining to `ReferalLogProcessor`.
* Moved score calculation logic to `CustomerRewardCalculator`.
* `Customer` is the class node for customer information.
* Created a hash data structure `customers` for maintaing the log file content which is also efficient for score calculation.

Customer data Structure above input.
```
{
	'A' => Customer({
		'name' => 'A',
		'score' => 0.0,
		'reference_accepted' => True,
		'referred_customers' => ['B']
	}),

	'B' => Customer({
		'name' => 'B',
		'score' => 0.0,
		'reference_accepted' => True,
		'referred_customers' => ['C']
	}),

	'C' => Customer({
		'name' => 'C',
		'score' => 0.0,
		'reference_accepted' => True,
		'referred_customers' => ['D']
	}),

	'D' => Customer({
		'name' => 'D',
		'score' => 0.0,
		'reference_accepted' => True,
		'referred_customers' => []
	})
}
```