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

  let(:empty_file) do
    Tempfile.new('input1').tap do |f|
      [].each do |log|
        f << log + "\n"
      end

      f.close
    end
  end

  let(:logs) do
    [
      '2018-06-12 09:41 A recommends B',
      '2018-06-14 09:41 B accepts',
      '2018-06-16 09:41 B recommends C',
      '2018-06-17 09:41 C accepts',
      '2018-06-19 09:41 C recommends D',
      '2018-06-23 09:41 B recommends D',
      '2018-06-25 09:41 D accepts'
    ]
  end

  let(:log_details) do
    [
      {
        customer_referee: 'A',
        customer_refered: 'B'
      },
      {
        customer_accepted: 'B'
      },
      {
        customer_referee: 'B',
        customer_refered: 'C'
      },
      {
        customer_accepted: 'C'
      },
      {
        customer_referee: 'C',
        customer_refered: 'D'
      },
      {
        customer_referee: 'B',
        customer_refered: 'D'
      },
      {
        customer_accepted: 'D'
      }
    ]
  end

  let(:scores) do
    { 'A' => 1.75, 'B' => 1.5, 'C' => 1.0 }
  end

  describe '#instance variables' do
    it 'checks referal_logs instance variable' do
      expect(service.referal_logs).to eq(logs)
    end

    it 'checks referal_customers_details instace variable' do
      service.send(:process_referal_logs)

      expect(service.referal_customers_details).to eq(log_details)
    end
  end

  describe '#valid?' do
    it 'checks the referal logs are valid' do
      expect(service.send(:valid?)).to be_truthy
    end

    it 'checks the referal logs are not empty?' do
      service = described_class.new(empty_file)

      expect(service.send(:valid?)).to be_falsey
    end
  end

  describe '#scores' do
    let(:logs) do
      [
        '2018-06-12 09:41 A recommends B',
        '2018-06-14 09:41 B accepts',
        '2018-06-16 09:41 B recommends C',
        '2018-06-17 09:41 C accepts',
        '2018-06-19 09:41 A recommends D',
        '2018-06-23 09:41 B recommends E',
        '2018-06-25 09:41 D accepts',
        '2018-06-25 09:41 E accepts',
        '2018-06-23 09:41 D recommends F'
      ]
    end

    let(:test_file) do
      Tempfile.new('input1').tap do |f|
        logs.each do |log|
          f << log + "\n"
        end

        f.close
      end
    end

    it 'checks the scores for the log' do
      service = described_class.new(test_file)

      expect(service.scores).to eq({ 'A' => 3.0, 'B' => 2.0 })
      expect(service.customers['A'].reference_accepted).to be_truthy
      expect(service.customers['A'].referred_customers).to eq(%w[B D])
      expect(service.customers['B'].reference_accepted).to be_truthy
      expect(service.customers['B'].referred_customers).to eq(%w[C E])
      expect(service.customers['C'].reference_accepted).to be_truthy
      expect(service.customers['E'].reference_accepted).to be_truthy
      expect(service.customers['D'].referred_customers).to eq(['F'])
      expect(service.customers['F'].reference_accepted).to be_falsey
    end
  end
end
