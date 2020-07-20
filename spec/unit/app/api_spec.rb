require_relative '../../../app/api'

module ExpenseTracker
  RSpec.describe API do 
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('Ledger') }
    fdescribe 'POST /expenses' do
      context 'when the expense is successfully recorded' do 
        let(:expense) {{ 'some' => 'data' }}
        before do 
          allow(ledger).to receive(:record).with(expense).and_return(RecordResult.new(true, 417, nil))
        end
        it 'returns the expense id' do 
          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'returns response code 200' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq 200
        end
      end
  
      context 'when the expense fails validations' do 
        let(:expense) {{ 'some' => 'data' }}
        before do 
          allow(ledger).to receive(:record).with(expense).and_return(RecordResult.new(false, 417, "Expense incomplete"))
        end
        it 'return an error message' do
          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('error' => 'Expense incomplete')
        end

        it 'response with a 422' do 
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq 422
        end
      end
    end
  end
end