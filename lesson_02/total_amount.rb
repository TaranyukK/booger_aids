cart = {}

loop do
  puts 'Введите название товара:'
  item = gets.chomp
  break if item == 'стоп'

  puts 'Введите цену за единицу:'
  price = gets.to_f

  puts 'Введите количество товара:'
  amount = gets.to_f

  cart[item] = { price: price, amount: amount, total_price: price * amount }
end

puts cart.inspect
puts 'Ваша корзина:'
cart.each do |k, v|
  puts "#{k} - цена: #{v[:price]}, кол-во: #{v[:amount]}, сумма: #{v[:total_price]}"
end

puts 'ИТОГО:'
puts cart.reduce(0) { |sum, (_, item)| sum + item[:total_price] }