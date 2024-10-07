require 'csv'
require 'matplotlib/pyplot'
@x = 0
@y = 0

@v0x = 30
@v0y = 15

@t = 0
##dqkdwqk
#puts @v0y+(9.82/60)
File.open("test.csv", "w") do |f|
  while @y > -100

    @t += 0.001
    puts @y
    @x = @v0x*@t
    @y = @v0y*@t - ((9.82*(@t**2))/2)

    f.puts("#{@x}, #{@y}")
  end
end

plt = Matplotlib::Pyplot

coords = CSV.read("test.csv")

p coords

xs = []
ys = []

plt.plot(xs, ys)
plt.show()
