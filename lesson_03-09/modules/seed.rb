module Seed
  def create_stations
    10.times { stations << Station.new(rand(10_000..99_999).to_s) }
  end

  def create_routes
    20.times do
      route = Route.new(stations.sample, stations.sample)
      rand(3..7).times { route.add_station(stations.sample) }
      routes << route
    end
  end

  def create_passenger_trains
    10.times do
      train = PassengerTrain.new(rand(100..1000).to_s)
      train.take_route(routes.sample)
      stations.sample.train_arrival(train)
      trains << train
    end
  end

  def create_cargo_trains
    10.times do
      train = CargoTrain.new(rand(100..1000).to_s)
      train.take_route(routes.sample)
      stations.sample.train_arrival(train)
      trains << train
    end
  end

  def create_wagons
    trains.each do |train|
      if train.passenger?
        10.times { train.add_wagon(PassengerWagon.new(rand(10_000..99_999).to_s, rand(10..50))) }
      else
        10.times { train.add_wagon(CargoWagon.new(rand(10_000..99_999).to_s, rand(100..500))) }
      end
    end
  end
end
