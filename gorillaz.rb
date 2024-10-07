require 'gosu'

class House
  def initialize(x, houses, game)
    @xsize = 1920/houses
    @x = (@xsize*x)
    @ysize = rand(300..600)
    if x == 1
      Player.new(1, @x, 1080-(@ysize)-128, game)
    elsif x == (houses - 2)
      Player.new(2, @x+48, 1080-(@ysize)-128, game)
    end 
  end

  def draw()
    Gosu.draw_rect(@x, 1080-(@ysize), @xsize, @ysize, 0xff_ffff00, z = 1, mode = :default)# ⇒ void
  end

  def getX()
    return @x
  end
  def getY()
    return (1080-(@ysize))
  end
  def getXsize()
    return @xsize
  end
  def getYsize()
    return @ysize
  end
end

class Player

  def initialize(playerInt, xPos, yPos, game)
    puts "creating player"
    @playerInt = playerInt
    @x = xPos
    @y = yPos

    @image = Gosu::Image.new("./media/img/playerIdle.png")

    game.appendPlayer(self)
  end

  def update()

  end

  def x()
    return @x
  end

  def y()
    return @y
  end

  def xSize()
    return @image.width
  end

  def ySize()
    return @image.height
  end

  def draw()
    @image.draw(@x, @y, 10)
  end

end


class Objekt
  def initialize(angle, velocity, x, y)
    @image = Gosu::Image.new("./media/img/ball.png")

    @angle = angle * (Math::PI/180)
    @velocity = velocity.to_f

    @t = 0.0

    @startX = x
    @startY = y
    @x = 200
    @y = 200
    @v0x = @velocity * Math.cos(@angle)
    @v0y = @velocity * Math.sin(@angle)
    @vy = @v0y
  end

  def update()
    @t += 0.1

    #puts @v0y+(9.82/60)

    @x = @v0x*@t
    @y = -@v0y*@t + ((9.82*(@t**2))/2)
    #puts @x
  end

  def collision(x, y, xsize, ysize)
    if ((@x + @image.width >= x) && (@x <= x + xsize)) && ((@y + @image.height >= y) && (@y <= y + ysize))
      puts "COLLIDED"
      return true
    end
  end
  #def collision(x, y, xsize, ysize)
  #  if ((@x >= x) && (@x <= x + xsize) && (@y <= y))
  #    puts "COLLIDED"
  #    return true
  #  end
  #end
  def collided()
    puts "COLLIDED"
    @x = 99999999
    @y = 99999999
  end

  def draw()
    @image.draw(@x + @startX, @y + @startY, 10)
  end
end

class Game < Gosu::Window
  def initialize()

    super(1920, 1080)
    self.caption = "Bounce"

    @gettingVelocity = true
    @gettingAngle = false

    @players = []
    @objekt = []
    @input = ""
    @velocityInput = ""
    @angleInput = ""

    @currentPlayer = 1

    @houses = []
    i = 0
    houses=rand(8..12)
    until i == houses
      @houses.append(House.new(i,houses, self))
      i += 1
    end

    @font = Gosu::Font.new(50)

    @gravityAccel = 9.82
  end

  def update()

    @objekt.each {|objekt| objekt.update}
    
    @houses.each do |house|
      @objekt.each {|objekt| @objekt.delete(objekt) if objekt.collision(house.getX, house.getY, house.getXsize, house.getYsize) == true}
    end

    if @currentPlayer == 1
      if @objekt.each {|objekt| objekt.collision(@players[1].x, @players[1].y, @players[1].xSize, @players[1].ySize)} == true
        p "you win!"
      end
    elsif @currentPlayer == 2
      if @objekt.each {|objekt| objekt.collision(@players[0].x, @players[0].y, @players[0].xSize, @players[0].ySize)} == true
        p "you win!"
      end
    end

    if @gettingVelocity
      @velocityInput = @input
    elsif @gettingAngle
      @angleInput = @input
    end

    if @velocityInput.length > 3
      @velocityInput.slice!(3)
    elsif @angleInput.length > 2
      @angleInput.slice!(3)
    end
  end

  def draw()
    #input(1)
    @font.draw_text("Velocity: #{@velocityInput}", 10, 10, 3, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw_text("Angle: #{@angleInput}", 10, 50, 3, 1.0, 1.0, Gosu::Color::YELLOW)

    @objekt.each {|objekt| objekt.draw}
    @houses.each {|house| house.draw}
    @players.each {|player| player.draw}
  end

  def appendPlayer(obj)
    @players.append(obj)
  end

  def button_down(id)
    if id == Gosu::KB_0
      @input += "0"
    elsif id == Gosu::KB_1
      @input += "1"
    elsif id == Gosu::KB_2
      @input += "2"
    elsif id == Gosu::KB_3
      @input += "3"
    elsif id == Gosu::KB_4
      @input += "4"
    elsif id == Gosu::KB_5
      @input += "5"
    elsif id == Gosu::KB_6
      @input += "6"
    elsif id == Gosu::KB_7
      @input += "7"
    elsif id == Gosu::KB_8
      @input += "8"
    elsif id == Gosu::KB_9
      @input += "9"
    elsif id == Gosu::KB_RETURN
      if @gettingVelocity
        @input = ""
        @gettingVelocity = false
        @gettingAngle = true
      elsif @gettingAngle
        @input = ""
        @gettingAngle = false
        if @currentPlayer == 1
          @objekt.append(Objekt.new(@angleInput.to_i, @velocityInput.to_i, @players[0].x, @players[0].y))
          @currentPlayer = 2
        elsif @currentPlayer == 2
          @objekt.append(Objekt.new(-@angleInput.to_i, -@velocityInput.to_i, @players[1].x, @players[1].y))
          @currentPlayer = 1
        end
        @velocityInput = ""
        @angleInput = ""
        @gettingVelocity = true
      end
    elsif id == Gosu::KbBackspace
      @input.chop!
      puts @input
    else
      super
    end
  end

end

game = Game.new
game.show