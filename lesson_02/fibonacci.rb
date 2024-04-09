a = 0
b = 1
fib = []

while a < 100
  fib << a
  a, b = b, (a + b)
end

puts fib
