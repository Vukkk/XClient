Vec3 = {}
Vec3.__index = Vec3

function Vec3.New(X, Y, Z)
	if type(X) == "table" then
		return setmetatable({ X = X[1] or 0, Y = X[2] or 0, Z = X[3] or 0 }, Vec3)
	else
		return setmetatable({ X = X or 0, Y = Y or 0, Z = Z or 0 }, Vec3)
	end
end

function Vec3.__eq(A, B)
	return A.X == B.X and A.Y == B.Y and A.Z == B.Z
end

function Vec3.__add(A, B)
	return Vec3.New(A.X + B.X, A.Y + B.Y, A.Z + B.Z)
end

function Vec3.__sub(A, B)
	return Vec3.New(A.X - B.X, A.Y - B.Y, A.Z - B.Z)
end

function Vec3.__mul(A, B)
	return Vec3.New(A.X * B.X, A.Y * B.Y, A.Z * B.Z)
end

function Vec3.__div(A, B)
	return Vec3.New(A.X / B.X, A.Y / B.Y, A.Z / B.Z)
end

function Vec3.__tostring(A)
	return "X: " .. A.X .. ", Y: " .. A.Y .. ", Z: " .. A.Z
end

function Vec3:DotProduct(A)
	return (self.X * A.X) + (self.Y * A.Y) + (self.Z * A.Z)
end

function Vec3:Length()
	return math.sqrt(self:DotProduct(self))
end

function Vec3:Distance(A)
	return math.abs((A - self):Length())
end

function Vec3:ToString()
	return tostring(self) 
end

function Vec3:ToArray()
	return self.X, self.Y, self.Z
end