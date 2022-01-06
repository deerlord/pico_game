MAX_GRAVITY = 4
GRAVITY = .8
DEBUG = {}

function _init()
  player = new(10, 40, 8, 6)
  enemy = new(20, 17, 8, 6)
  player.y_spd = -4
end

function _update()
  move(player)
  apply_physics(player)
end

function _draw()
  cls()
  draw_hitbox(player, 8)
  draw_hitbox(enemy, 10)
end

function draw_hitbox(char, color)
  left, right, top, bottom = hitbox(char)
  coords = {{left, top}, {left, bottom}, {right, top}, {right, bottom}}
  for i=1,#coords
  do
    pset(coords[i][1], coords[i][2], color)
  end
end


function sign(number)
  if number > 0
  then
    return 1
   else if number < 0
   then
     return -1
    end
    return 0
end


function new(x, y, height, width, facing)
  return {
    x = x,
    y = y,
    height = max(1, flr(height/2)),
    width = max(1, flr(width/2)),
    facing = facing or 270,
    x_spd = 0,
    y_spd = 0
  }
end

function vector(char)
  hyp = sqrt(char.x_spd*char.x_spd + char.y_spd*char.y_spd)
  return char.x_spd / hyp, char.y_spd / hyp
end

function move(char)
  char.x = char.x + char.x_spd
  char.y = char.y + char.y_spd
end

-- physics functions
function gravity(char)
  if char.y_spd < MAX_GRAVITY
  then
    char.y_spd = min(MAX_GRAVITY, char.y_spd + GRAVITY)
  end
end

function floor_friction(char)
  char.x_spd = char.x_spd * .83
end

function wall_friction(char)
  char.y_spd = char.y_spd * .5
end

function air_resistance(char)
  char.x_spd = char.x_spd * .97
end

function apply_physics(char)
  floor_friction(char)
  wall_friction(char)
  gravity(char)
  air_resistance(char)
end

-- collision
function hitbox(char)
  return
    char.x - char.width,
    char.x + max(char.width - 1, 0),
    char.y - char.height,
    char.y + max(char.height - 1, 0)
end

function collision(obj1, obj2)
   obj1_left, obj1_right, obj1_top, obj1_bottom = hitbox(obj1)
   obj2_left, obj2_right, obj2_top, obj2_bottom = hitbox(obj2)
   return (
     obj1_left <= obj2_right and
     obj1_right >= obj2_left and
     obj1_top <= obj2_bottom and
     obj1_bottom >= obj2_top
   )
end

function decollide(char, checker, check_against)
  x_sign = sign(char.x_spd)
  y_sign = sign(char.y_spd)
  if x_sign == 1
  then
    x_comp = max
  else
  then
    x_comp = min
  end
  if y_sign == 1
  then
    y_comp = max
  else
  then
    y_comp = min
  end
  while checker(char, check_against)
  do
    char.x_spd = char.x_spd - x_comp(x_sign, 0)
    char.y_spd = char.y_spd - y_comp(y_sign, 0)
  end
end