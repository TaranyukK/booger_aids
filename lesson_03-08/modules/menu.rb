module Menu
  include Constant

  private

  def all_trains
    loop do
      show_items(TRAINS_MENU)
      case answer_i
      when 1
        create_train
      when 2
        trains_configure(choose_train)
      when 3
        break
      else
        puts wrong_attribute
      end
    end
  end

  def trains_configure(train)
    loop do
      show_items(TRAINS_CONFIGURE_MENU)
      case answer_i
      when 1
        show_wagons(train)
      when 2
        wagon_configure(choose_wagon(train))
      when 3
        add_wagon_to_train(train)
      when 4
        remove_wagon_from_train(train)
      when 5
        add_route_to_train(train)
      when 6
        train.move_next
      when 7
        train.move_prev
      when 8
        break
      else
        puts wrong_attribute
      end
    end
  end

  def routes_and_stations
    loop do
      show_items(ROUTES_AND_STATIONS_MENU)
      case answer_i
      when 1
        create_station
      when 2
        create_route
      when 3
        add_station_to_route
      when 4
        remove_station_from_route
      when 5
        show_stations_and_routes
      when 6
        break
      else
        puts wrong_attribute
      end
    end
  end

  def wagon_configure(wagon)
    loop do
      puts "1. #{WAGON_CONFIGURE_MENU.first[wagon.type]}"
      puts "2. #{WAGON_CONFIGURE_MENU.last}"
      case answer_i
      when 1
        if wagon.passenger?
          wagon.take_seat
        else
          puts 'Введите объем'
          wagon.fill_space(answer_i)
        end
      when 2
        break
      else
        puts wrong_attribute
      end
    end
  end
end
