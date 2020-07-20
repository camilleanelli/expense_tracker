require_relative '../../app/api'
require 'rack/test'
require 'json'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do 
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      # last_response est une methode de rack test methods
      expect(last_response.status).to eq 200
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed["expense_id"])
    end 
    

    it 'records all the expenses' do
      pending 'not implemented'
      coffee = post_expense({ 
        'payee' => 'Starbuck',
        'amount' => '5.75',
        'date' => '2020-06-09'
      })

      zoo = post_expense({ 
        'payee' => 'zoo',
        'amount' => '45',
        'date' => '2020-06-09'
      })
      get '/expenses/2020-06-09'
      expect(last_response.status).to eq 200
      resultat = JSON.parse(last_response.body)
      expect(resultat).to contain_exactly(coffee, zoo)
    end
   
  end
end