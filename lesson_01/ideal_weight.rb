puts 'Введите ваше имя:'
name = gets.chomp

puts 'Введите ваш рост:'
height = gets.to_i

perfect_weight = (height - 110) * 1.15

puts perfect_weight > 0 ? "#{name}, ваш идеальный вес: #{perfect_weight}" : 'Ваш вес уже оптимальный!'
