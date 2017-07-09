Aim = {}

require "vec3"
require "vec2"

function Aim.LookAt(Target)
	local Origin = Vec3.New(Engine.ClientData.Origin)	
	
	local D = Origin - Target
	
	Engine.ViewAngles = 
	{ 
		math.deg(math.atan(D.Z, math.sqrt(D.X * D.X + D.Y * D.Y))),
		math.deg(math.atan(D.Y, D.X)) - 180.0
	}
end