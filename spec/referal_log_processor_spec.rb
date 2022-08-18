require File.expand_path './spec_helper.rb', __dir__

describe ReferalLogProcessor do
  let(:referal_log) { '2018-06-12 09:41 A recommends B' }
  let(:acceptance_log) { '2018-06-14 09:41 B accepts' }

  let(:refal_log_details) do
    {
      customer_referee: 'A',
      customer_refered: 'B'
    }
  end

  let(:acceptance_log_details) do
    {
      customer_accepted: 'B'
    }
  end

  describe '#valid?' do
    it 'checks the action is valid?' do
      service = described_class.new(referal_log)

      expect(service.send(:valid?)).to be_truthy
    end

    it 'checks if the action iss valid?' do
      referal_log = '2018-06-14 09:41 B accep'
      service = described_class.new(referal_log)

      expect(service.send(:valid?)).to be_falsey
    end

    it 'checks if log length is valid?' do
      referal_log = '2018-06-14 09:41 B'
      service = described_class.new(referal_log)

      expect(service.send(:valid?)).to be_falsey
    end
  end

  describe '#process' do
    it 'checks the refer log of referal' do
      service = described_class.new(referal_log)

      expect(service.process).to eq(refal_log_details)
    end

    it 'checks the refer log of referal acceptance' do
      service = described_class.new(acceptance_log)

      expect(service.process).to eq(acceptance_log_details)
    end
  end
end
