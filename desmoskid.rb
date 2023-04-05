require 'curses'


class Linear

  def initialize(slope, y_intercept)
    @slope = slope
    @y_intercept = y_intercept
  end

  def evaluate(x)
    @slope * x + @y_intercept
  end

end

class Quadratic

  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def evaluate(x)
    @a * x * x + @b * x + @c
  end

end

class Derivative

  def initialize(function, delta=0.01)
    @function = function
    @delta = delta
  end

  def evaluate(x)
    after_y = @function.evaluate(x + @delta)
    before_y = @function.evaluate(x - @delta)
    (after_y - before_y) / (2 * @delta)
  end

end

class GraphKid

  def initialize
    @functions = []
  end

  def render_axes(width, height)
    # Rendering the x-axis
    (0...width).each do |x|
      Curses::setpos(height / 2, x)
      Curses::addch('-')
    end
    # Rendering the y-axis
    (0..height).each do |y|
      Curses::setpos(y, width / 2)
      Curses::addch('|')
    end
    # Drawing origin
    Curses::setpos(height / 2, width / 2)
    Curses::addch('+')
  end

  def render
    height = Curses::lines
    width = Curses::cols
    render_axes(width, height)
    render_functions(width, height)
  end

  def render_functions(width, height)
    @functions.each do |function|
      (-width...width).each do |x|
        y = function.evaluate(x).round
        column = x + width / 2
        row = -y + height / 2
        if 0 <= column && column <= width && 0 <= row && row <= height
          Curses::setpos(row, column)
          Curses::addch('*')
        end
      end
    end
  end

  def add_function(function)
    @functions.push(function)
  end

end

Curses::init_screen
graph = GraphKid.new
f1 = Linear.new(1, 0)

f3 = Quadratic.new(1, 3, 2)
graph.add_function(f1)
graph.add_function(f3)
graph.render
Curses::getch
