Movement = {}

require "vec3"
require "vec2"

function Movement.MoveTo(Target)
	--[[local Origin = Vec3.New(Engine.ClientData.Origin)
	local D = Origin - Target
	local F = Engine.ViewAngles.Y - math.deg(math.atan(D.Y, D.X)) - 180.0
	local Speed = 255.0
	
	Engine.ForwardSpeed = math.cos(F * math.pi / 180.0) * Speed
	Engine.SideSpeed = math.sin(F * math.pi / 180.0) * Speed]]
	Engine.ForwardSpeed = 255
end

function Movement.Reset()
	Engine.ForwardSpeed = 0
	Engine.SideSpeed = 0
	Engine.UpSpeed = 0
end