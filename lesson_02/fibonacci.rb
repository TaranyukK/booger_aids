a, b = 0, 1
fib = []

while a < 100 do
  fib << a
  a, b = b, (a + b)
end

puts fib