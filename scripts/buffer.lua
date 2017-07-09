require "console"

Buffer = {}
Buffer.__index = Buffer

function Buffer.New()
	return setmetatable(
		{ 
			Memory = { }, 
			Size = 0, 
			Position = 1
		}, Buffer)
end

function Buffer:ToStart()
	self.Position = 1
end

-- UInt8

function Buffer:WriteByte(value)
	self.Size = self.Size + 1
	self.Position = self.Position + 1
	table.insert(self.Memory, self.Position - 1, value & 0xFF)
end

function Buffer:ReadByte()
	self.Position = self.Position + 1
	return self.Memory[self.Position - 1]
end

-- Int8

function Buffer:WriteInt8(value)
	self:WriteByte(value + (1 << 7))
end

function Buffer:ReadInt8()
	return self:ReadByte() - (1 << 7)
end

-- UInt16

function Buffer:WriteWord(value)
	local a = math.modf(value / (1 << 8)) 
	local b = value - a * (1 << 8)
	
	self:WriteByte(a)
	self:WriteByte(b)
end

function Buffer:ReadWord()
	local a = self:ReadByte()
	local b = self:ReadByte()
	
	return a * (1 << 8) + b
end

-- Int16

function Buffer:WriteShort(value)
	self:WriteWord(value + (1 << 15))
end

function Buffer:ReadShort()
	return self:ReadWord() - (1 << 15)
end

-- UInt32

function Buffer:WriteLongWord(value)
	local a = math.modf(value / (1 << 24)) value = value - a * (1 << 24)
	local b = math.modf(value / (1 << 16)) value = value - b * (1 << 16)
	local c = math.modf(value / (1 << 8)) value = value - c * (1 << 8)
	local d = value

	self:WriteByte(a)
	self:WriteByte(b)
	self:WriteByte(c)
	self:WriteByte(d)
end

function Buffer:ReadLongWord()
	local a = self:ReadByte()
	local b = self:ReadByte()
	local c = self:ReadByte()
	local d = self:ReadByte()
	
	return a * (1 << 24) + b * (1 << 16) + c * (1 << 8) + d
end

-- Int32

function Buffer:WriteLong(value)
	self:WriteLongWord(value + (1 << 31))
end

function Buffer:ReadLong()
	return self:ReadLongWord() - (1 << 31)
end

-- Float

function Buffer:WriteFloat(f)
	local neg = f < 0
	
	f = math.abs(f)

	-- Extract significant digits and exponent
	
	local e = 0
	
	if (f >= 1) then
		while f >= 1 do
			f = f / 10
			e = e + 1
		end
	else
		while f < 0.1 do
			f = f * 10
			e = e - 1
		end
	end

	-- Discard digits
	
	local s = tonumber(string.sub(f, 3, 9))

	-- Negate if the original number was negative
	
	if (neg) then 
		s = -s 
	end

	-- Convert to unsigned
	
	s = s + 8388608

	-- Send significant digits as 3 byte number

	local a = math.modf(s / (1 << 16)) s = s - a * (1 << 16)
	local b = math.modf(s / (1 << 8)) s = s - b * (1 << 8)
	local c = s

	self:WriteByte(a)
	self:WriteByte(b)
	self:WriteByte(c)

	-- Send exponent
	
	self:WriteInt8(e) 
end

function Buffer:ReadFloat()
	local a = self:ReadByte() 
	local b = self:ReadByte() 
	local c = self:ReadByte() 
	local e = self:ReadInt8()

	local s = a * 65536 + b * 256 + c - 8388608

	if s > 0 then
		return tonumber("0." .. s) * 10^e
	else
		return tonumber("-0." .. math.abs(s)) * 10^e
	end
end

-- Char

function Buffer:WriteChar(value)
	self:WriteByte(string.byte(value))
end

function Buffer:ReadChar()
	return string.char(self:ReadByte())
end

-- String


function Buffer:WriteString(value)
	for i = 1, #value do
		self:WriteByte(string.byte(value, i))
	end
	
	self:WriteByte(0)
end

function Buffer:ReadString()
	local result = ""
	
	while true do
		local b = self:ReadByte()
		
		if b == 0 then
			break
		end
		
		result = result .. string.char(b)
	end
	
	return result
end

-- Byte Array

function Buffer:Write(Data)
	for i = 1, #Data do
		self:WriteByte(Data[i])
	end
end

-- 

function Buffer.Test()
	MSG = Buffer.New()
	
	MSG:WriteLong(-42)
	MSG:WriteString("fuckme")
	MSG:WriteString("kekkek")
	MSG:WriteWord(65432)
	MSG:WriteFloat(42.1337)
	
	MSG:ToStart()
	
	Engine:WriteLine(MSG:ReadLong())
	Engine:WriteLine(MSG:ReadString())
	Engine:WriteLine(MSG:ReadString())
	Engine:WriteLine(MSG:ReadWord())
	Engine:WriteLine(MSG:ReadFloat())
end