function new(x, y, height, width, sprite, facing)
  return {
    x = x,
    y = y,
    height = height,
    width = width,
    facing = facing or 270,
    x_spd = 0,
    y_spd = 0,
    sprite = sprite
  }
end


function move(char)
  char.x = char.x + char.x_spd
  char.y = char.y + char.y_spd
end

-- physics functions
function gravity(char)
 if char.y_spd < MAX_GRAVITY
 then
   char.y_spd = char.y_spd + GRAVITY
 end
end

function friction(char)
 char.x_spd = char.x_spd * .83
end

function air_resistance(char)
 char.x_spd = char.x_spd * .97
end

function apply_physics(char)
 gravity(char)
 friction(char)
 air_resistance(char)
end

-- collision
function hitbox(char)
 return
   char.x - char.width,
   char.x + char.width - 1,
   char.y - char.height,
   char.y + char.height - 1
end

-- needs work
function collision(obj1, obj2)
 obj1_left, obj1_right, obj1_top, obj1_bottom = hitbox(obj1)
 obj2_left, obj2_right, obj2_top, obj2_bottom = hitbox(obj2)
 return (
   obj1_left < obj2_right and
   obj1_right > obj2_left and
   obj1_top < obj2_top and
   obj1_bottom > obj2_top
 )
end
