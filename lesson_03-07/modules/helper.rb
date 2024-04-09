module Helper
  def show_items(items)
    items.each_with_index { |item, index| puts "#{index + 1}. #{item}" }
  end

  def answer
    gets.chomp
  end

  def answer_i
    gets.to_i
  end

  def wrong_attribute
    'Неверное значение, попробуйте еще раз!'
  end

  def delimiter
    '--------------------------------------'
  end

  def bold_delimiter
    '======================================'
  end
end
