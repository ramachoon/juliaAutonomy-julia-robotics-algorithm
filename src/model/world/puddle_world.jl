# module for defining world coordinate system
# puddle can be put

using Plots
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/warp_robot/warp_robot.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/agent/agent.jl"))

mutable struct PuddleWorld
  x_min
  x_max
  y_min
  y_max
  objects
  delta_time
  end_time
  is_test
  save_path
  puddles
  robots
  goals

  # init
  function PuddleWorld(x_min::Float64, x_max::Float64,
                       y_min::Float64, y_max::Float64;
                       delta_time=0.1, end_time=30,
                       is_test=false, save_path=nothing)
    self = new()
    self.x_min = x_min
    self.x_max = x_max
    self.y_min = y_min
    self.y_max = y_max
    self.objects = []
    self.delta_time = delta_time
    self.end_time = end_time
    self.is_test = is_test
    self.save_path = save_path
    self.puddles = []
    self.robots = []
    self.goals = []
    return self
  end
end

function append(self::PuddleWorld, obj)
  push!(self.objects, obj)
  
  if typeof(obj) == Puddle
    push!(self.puddles, obj)
  end

  if typeof(obj) == DifferentialWheeledRobot || typeof(obj) == WarpRobot
    push!(self.robots, obj)
  end

  if typeof(obj) == Goal
    push!(self.goals, obj)
  end
end

function puddle_depth(self::PuddleWorld, pose)
  if length(self.puddles) > 0  
    return sum([p.depth*inside(p, pose)  for p in self.puddles])
  else
    return 0.0
  end
end

function one_step(self::PuddleWorld, delta_time)
  plot([], [], aspect_ratio=true, xlabel="X", ylabel="Y",
       xlims=(self.x_min, self.x_max), ylims=(self.y_min, self.y_max),
       legend=false)
  
  for r in self.robots
    if typeof(r.agent) != Agent
      r.agent.puddle_depth = puddle_depth(self, r.pose)
      for g in self.goals
        if inside(g, r.pose)
          r.agent.in_goal = true
          r.agent.final_value = g.value
        end
      end
    end
  end
  
  for obj in self.objects
    draw!(obj)
  end

  annotate!(-3.5, 4.5, "t = $(delta_time)", "black")
end

function draw(self::PuddleWorld) 
  if self.is_test
    for t in 0:self.delta_time:10
      one_step(self, t)
    end
  else
    anime = @animate for t in 0:self.delta_time:self.end_time
      one_step(self, t)
    end
    gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], self.save_path))
  end
end