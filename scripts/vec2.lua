Vec2 = {}
Vec2.__index = Vec2

function Vec2.New(X, Y)
	if type(X) == "table" then
		return setmetatable({ X = X[1] or 0, Y = X[2] or 0 }, Vec2)
	else
		return setmetatable({ X = X or 0, Y = Y or 0 }, Vec2)
	end
end

function Vec2.__eq(A, B)
	return A.X == B.X and A.Y == B.Y
end

function Vec2.__add(A, B)
	return Vec2.New(A.X + B.X, A.Y + B.Y)
end

function Vec2.__sub(A, B)
	return Vec2.New(A.X - B.X, A.Y - B.Y)
end

function Vec2.__mul(A, B)
	return Vec2.New(A.X * B.X, A.Y * B.Y)
end

function Vec2.__div(A, B)
	return Vec2.New(A.X / B.X, A.Y / B.Y)
end

function Vec2.__tostring(A)
	return "X: " .. A.X .. ", Y: " .. A.Y
end

function Vec2:DotProduct(A)
	return (self.X * A.X) + (self.Y * A.Y)
end

function Vec2:Length()
	return math.sqrt(self:DotProduct(self))
end

function Vec2:Distance(A)
	return math.abs((A - self):Length())
end

function Vec2:ToString()
	return tostring(self) 
end

function Vec2:ToArray()
	return self.X, self.Y
end