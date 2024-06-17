def extract_and_calculate_square_roots(number_sequence)  
    (0..number_sequence.length - 5).each do |i|
      sub_number = number_sequence[i, 5]
      square_root = Math.sqrt(sub_number.to_i)
      puts "The square root of #{sub_number} is #{square_root}"
    end
  end
  
  number_sequence = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789340"
  
  p extract_and_calculate_square_roots(number_sequence)