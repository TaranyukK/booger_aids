alphabet = [*('a'..'z')]
vowels = {}

alphabet.each_with_index { |k, v| vowels[k] = v + 1 if 'aeiou'.include?(k) }

puts vowels
