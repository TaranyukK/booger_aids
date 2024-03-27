puts 'Введите день:'
day = gets.to_i

puts 'Введите число месяца:'
month = gets.to_i

puts 'Введите год:'
year = gets.to_i
is_leap = (year % 4).zero? && (year % 100) != 0 || (year % 400).zero?

days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
days[1] = 29 if is_leap

puts "Это #{days[0...month-1].sum + day} день в году"