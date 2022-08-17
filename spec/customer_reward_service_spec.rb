require File.expand_path './spec_helper.rb', __dir__

describe CustomerRewardService do
  let(:service) { described_class.new(test_in_file) }

  let(:test_in_file) do
    Tempfile.new('input1').tap do |f|
      logs.each do |log|
        f << log + "\n"
      end

      f.close
    end
  end

  let(:logs) do
    [
      "2018-06-12 09:41 A recommends B",
      "2018-06-14 09:41 B accepts",
      "2018-06-16 09:41 B recommends C",
      "2018-06-17 09:41 C accepts",
      "2018-06-19 09:41 C recommends D",
      "2018-06-23 09:41 B recommends D",
      "2018-06-25 09:41 D accepts"
    ]
  end

  let(:log_details) do
    [
      {
        :customer_referee => "A",
        :customer_refered => "B"
      },
      {
        :customer_accepted => "B"
      },
      {
        :customer_referee => "B",
        :customer_refered => "C"
      },
      {
        :customer_accepted => "C"
      },
      {
        :customer_referee => "C",
        :customer_refered => "D"
      },
      {
        :customer_referee => "B",
        :customer_refered => "D"
      },
      {
        :customer_accepted => "D"
      }
    ]
  end

  let(:scores) do 
    { "A": 1.75, "B": 1.5, "C": 1 }
  end

  describe '#instance variables' do
    it 'checks referal_logs instance variable' do
      expect(service.referal_logs).to eq(logs)
    end

    it 'checks referal_customers_details instace variable' do
      service.send(:process_referal_logs)

      expect(service.referal_customers_details).to eq(log_details)
    end

    it 'check customers instance vaiable' do
      service.scores

      expect(service.scores).to eq()
    end
  end 
end
