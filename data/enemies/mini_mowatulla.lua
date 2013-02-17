local enemy = ...

-- Mini Mowatulla: a small spider that comes from an egg.
-- This enemy is usually be generated by a bigger one.

enemy:set_life(2)
enemy:set_damage(2)
enemy:set_size(16, 16)
enemy:set_origin(8, 13)
enemy:set_invincible()

local sprite = enemy:create_sprite("enemies/mini_mowatulla")
sprite:set_animation("shell")
local in_shell = true
sol.timer.start(enemy, 1000, function()
  enemy:break_shell()
end)

-- The enemy was stopped for some reason and should restart.
function enemy:on_restarted()

  if in_shell then
    local sprite = self:get_sprite()
    sprite:set_animation("shell")
    local m = sol.movement.create("target")
    m:set_speed(64)
    self:start_movement(m)
  else
    local m = sol.movement.create("path_finding")
    m:set_speed(64)
    self:start_movement(m)
  end
end

-- Starts breaking the shell.
function enemy:break_shell()

  local sprite = self:get_sprite()
  self:stop_movement()
  sprite:set_animation("shell_breaking")
end

--  The animation of the sprite is finished.
function sprite:on_animation_finished(animation)

  -- if the shell was breaking, let the mini mowatulla go
  if animation == "shell_breaking" then
    self:set_animation("walking")
    enemy:snap_to_grid()
    enemy:set_default_attack_consequences()
    in_shell = false
    enemy:restart()
  end
end

