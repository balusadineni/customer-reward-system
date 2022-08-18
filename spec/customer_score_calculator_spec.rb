require File.expand_path './spec_helper.rb', __dir__

describe CustomerScoreCalculator do
  let(:customerA) { Customer.new({ name: 'A' }) }
  let(:customerB) { Customer.new({ name: 'B' }) }
  let(:customerC) { Customer.new({ name: 'C' }) }
  let(:customerD) { Customer.new({ name: 'D' }) }
  let(:customerE) { Customer.new({ name: 'E' }) }
  let(:customerF) { Customer.new({ name: 'F' }) }
  let(:customerG) { Customer.new({ name: 'G' }) }

  let(:customers_level_0) { {} }
  let(:customers_level_1) do
    {
      'A' => customerA,
      'B' => customerB
    }
  end

  let(:customers_level_2) do
    {
      'A' => customerA,
      'B' => customerB,
      'C' => customerC,
      'D' => customerD
    }
  end

  let(:customers_level_3) do
    {
      'A' => customerA,
      'B' => customerB,
      'C' => customerC,
      'D' => customerD,
      'E' => customerE,
      'F' => customerF,
      'G' => customerG
    }
  end

  let(:scores_level_1) { { 'A' => 1.0, 'B' => 0.0 } }
  let(:scores_level_2) { { 'A' => 2.0, 'B' => 2.0, 'C' => 0.0, 'D' => 0.0 } }
  let(:scores_level_3) { { 'A' => 1.75, 'B' => 1.5, 'C' => 0.0, 'D' => 1.0, 'E' => 1.0, 'F' => 0.0, 'G' => 0.0 } }

  describe '#calculate' do
    it 'calculates the scores of the empty customers' do
      service = described_class.new(customers_level_0)

      expect(service.calculate).to eq({})
    end

    it 'calculates the scores of the customer with level 1' do
      customers_level_1['A'].reference_accepted!
      customers_level_1['B'].reference_accepted!
      customers_level_1['A'].add_referred_customer('B')
      service = described_class.new(customers_level_1)
      customers = service.calculate
      scores = {}

      customers.map { |key, _value| scores[key] = customers[key].score }

      expect(scores).to eq(scores_level_1)
    end

    it 'calculates the scores of the customer with level 2' do
      customers_level_2['A'].reference_accepted!
      customers_level_2['B'].reference_accepted!
      customers_level_2['C'].reference_accepted!
      customers_level_2['D'].reference_accepted!
      customers_level_2['A'].add_referred_customer('B')
      customers_level_2['B'].add_referred_customer('C')
      customers_level_2['B'].add_referred_customer('D')

      service = described_class.new(customers_level_2)
      customers = service.calculate
      scores = {}

      customers.map { |key, _value| scores[key] = customers[key].score }

      expect(scores).to eq(scores_level_2)
    end

    it 'calculates the scores of the customer with level 3' do
      customers_level_3['A'].reference_accepted!
      customers_level_3['A'].add_referred_customer('B')
      customers_level_3['B'].reference_accepted!
      customers_level_3['B'].add_referred_customer('C')
      customers_level_3['B'].add_referred_customer('D')
      customers_level_3['D'].reference_accepted!
      customers_level_3['E'].reference_accepted!
      customers_level_3['E'].add_referred_customer('F')
      customers_level_3['F'].reference_accepted!
      customers_level_3['D'].add_referred_customer('G')
      customers_level_3['G'].reference_accepted!

      service = described_class.new(customers_level_3)
      customers = service.calculate
      scores = {}

      customers.map { |key, _value| scores[key] = customers[key].score }

      expect(scores).to eq(scores_level_3)
    end
  end
end
