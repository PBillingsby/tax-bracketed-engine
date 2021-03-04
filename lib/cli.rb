require 'pry'

class CLI
  BRACKETS = [ 
  { percent: 0, maximum_portion: 10000 }, { percent: 0.10, maximum_portion: 20000 }, { percent: 0.20, maximum_portion: 50000 }, { percent: 0.30, maximum_portion: 50001}, { percent: 0.40, maximum_portion: 100001}, { percent: 0.50, maximum_portion: 500000}
]
  def start
    puts " ************************"
    puts "*      - ROOSTIFY -     *"
    puts "*       BRACKETED       *"
    puts "*    TAX CALCULATOR     *"
    puts " ************************"
    puts 'Enter incomes separated by space'
    incomes = STDIN.gets.chomp.split(' ') # Splits input to an array of strings
    send_incomes_to_calculator(incomes)
  end

  def send_incomes_to_calculator(str)
    str.each do |income| # Takes in a comma separated string
      if income.to_i <= 10000 # Handles if income value is less than 10000 threshold
        puts "Tax deducted from $#{income}: $0}"
      else
        calculate_individual_income(income.to_i) # Pass individual incomes to calculator method 
      end
    end
  end
  def calculate_individual_income(income)
    tax = 0
    previous_max_value = 0 # Value set to subtract from hash :maximum_portion 
    hash_index = 0
    while income > BRACKETS[hash_index][:maximum_portion] # Income must always be larger than the hash indexed :maxiumum value
      # Taxes are calculated by adding (max_portion - previous_max_value) multiplying by the corresponding tax percentage
      # Eg -> 
      #   Iteration 1:
      #     Income: 25000
      #     Addition of max_portion - previous_max_value: 10000
      #     Tax bracket percentage: 0
      #     Tax: 0
      #     Hash index: 0
      #   Iteration 2:
      #     Tax: 1000
      #     Hash index: 1
      #     Tax bracket percentage: 0.1
      tax += (BRACKETS[hash_index][:maximum_portion] - previous_max_value) * BRACKETS[hash_index][:percent] 
      previous_max_value = BRACKETS[hash_index][:maximum_portion]
      hash_index += 1
    end
    # At this point income NOT greater than BRACKETS[hash_index][:maximum_portion] as income == 25000 & the current maximum_portion == 50000
    #   Iteration 3:
    #   Tax: 1000
    #   Tax bracket percentage: 0.2
    #   (income - previous_max_value): 5000

    # Reaching the end of the values lifecycle
    # Add last values to tax
    #   Tax: 1000
    #   Incoming tax: 1000
    tax += ((income - previous_max_value) * BRACKETS[hash_index][:percent])
    # Result: 
    #   Tax deducted from $25000: $2000.0
    puts "Tax deducted from $#{income}: $#{tax}"
  end
end