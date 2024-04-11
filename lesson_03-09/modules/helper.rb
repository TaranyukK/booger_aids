module Helper
  def choose_item(collection, item_name)
    puts "Выберите #{item_name}:"
    collection.each_with_index do |item, index|
      puts "#{index}. #{yield(item)}"
    end
    loop do
      answer = answer_i
      return collection[answer] if answer.between?(0, collection.length - 1)

      puts wrong_attribute
    end
  end

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
    '-' * 40
  end

  def bold_delimiter
    '=' * 40
  end
end
