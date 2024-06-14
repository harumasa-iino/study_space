def extract_and_calculate_square_roots(number_sequence)
    raise ArgumentError, "Input must be a string of digits" unless number_sequence.is_a?(String) && number_sequence.match?(/^\d+$/)
    raise ArgumentError, "Input must be at least 1000 digits long" if number_sequence.length < 1000
  
    (0..number_sequence.length - 5).each do |i|
      sub_number = number_sequence[i, 5]
      square_root = Math.sqrt(sub_number.to_i)
      puts "The square root of #{sub_number} is #{square_root}"
    end
  end
  
  # 使用例
  number_sequence = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" +
                    "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" +
                    "123456789012345678901234567890123456789789012345678901234567890" +
                    "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
  
  p extract_and_calculate_square_roots(number_sequence)