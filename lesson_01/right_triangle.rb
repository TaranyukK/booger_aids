puts 'Введите первую сторону треугольника:'
a = gets.to_i

puts 'Введите вторую сторону треугольника:'
b = gets.to_i

puts 'Введите третью сторону треугольника:'
c = gets.to_i


sides = [a, b, c]
max_side = sides.max
other_sides = sides - [max_side]

if max_side**2 == other_sides.reduce(0) {|sum, side| sum + side**2}
  puts 'Треугольник прямоугольный'
elsif sides.uniq.length == 2
  puts 'Треугольник равнобедренный'
elsif sides.uniq.length == 1
  puts 'Треугольник равнобедренный и равносторонний'
end
