puts 'Введите первый коэффициент:'
a = gets.to_i

puts 'Введите второй коэффициент:'
b = gets.to_i

puts 'Введите третий коэффициент:'
c = gets.to_i

d = b**2 - 4*a*c

if d < 0
  puts 'Корней нет'
elsif d == 0
  puts "D = #{d}, X = #{-b / 2 * a}"
elsif d > 0
  d_sqrt = Math.sqrt(d)
  puts "D = #{d}, X1 = #{(-b + d_sqrt)/ 2 * a}, X2 = #{(-b - d_sqrt) / 2 * a}"
end
