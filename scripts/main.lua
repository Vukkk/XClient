require "scripting"
require "emulator"
require "buffer"
require "vec3"
require "vec2"
require "resources"
require "buttons"
require "aim"
require "movement"
require "console"

function Initialize()
	math.randomseed(os.time())
	
	Scripting.Initialize()
	Emulator.Initialize()
	
	Engine:Execute("emulator steamemu")
	Engine:Execute("later 1 'connect 127.0.0.1 27015'")
end

function Finalize()
	
end

function Frame(dTime)
	--Engine:WriteLine(Vec2.New(Engine.ViewAngles):ToString())
	--Engine:WriteLine(Engine.Performance.MemoryUsage >> 20)
end

function Think(dTime)
	Buttons.Reset()
	Movement.Reset()
	
	for i = 0, Engine.EntityCount - 1 do
		local E = Engine:GetEntity(i)
		
		if E.Number ~= Engine.Index + 1 and Engine:IsPlayerIndex(E.Number) then
			local V = Vec3.New(E.Origin)
			
			Aim.LookAt(V)
			Movement.MoveTo(V)
		end
	end
end

function GenerateCertificate()
	return Emulator.GenerateCertificate()
end

function OnEvent(Event)
	local R = Resources.FindEvent(Event.Index)
	
	if R == nil then
		return
	end
	
	Engine:Write("Event: ")
	Engine:WriteLine(R.Name, Console.Color.Blue)
end

function OnSound(Sound)
	local R = Resources.FindSound(Sound.Index)
	
	if R == nil then
		return
	end
	
	local VS = Vec3.New(Sound.Origin)
	local VC = Vec3.New(Engine.ClientData.Origin)
	local D = VS:Distance(VC)
	
	D = math.floor(D)
	
	Engine:Write("Sound: ")
	Engine:Write(R.Name, Console.Color.Cyan)
	Engine:Write(", Distance: ")
	Engine:WriteLine(D, Console.Color.Red)
end

function OnGameMessage(Name, Data)
	local GMSG = Buffer.New()
	
	GMSG:Write(Data)
	GMSG:ToStart()
	
	if Name == "ReqState" then
		Engine:SendCommand("VModEnable 1")
	elseif Name == "SayText" then
		local index = GMSG:ReadByte()
		local message = GMSG:ReadString()
		
		Engine:WriteLine(message) -- this message need to be parsed before print
	end
	
	Engine:Write("Name: ")
	Engine:Write(Name, Console.Color.Green)
	Engine:Write(", Size: ")
	Engine:WriteLine(GMSG.Size, Console.Color.Yellow)
end

--[[
	Exports:
	
	static class Engine
	{
		void Write(string, color)
		void WriteLine(string, color)
		void Execute(string)
		void RegisterCommand(name, description, (args[],) callback())
		void RegisterCVar(name, description, args[], getter(), setter())
	
		int Index
		
		void PressButton(int button)
		void LeaveButton(int button)
		bool IsButtonPressed(int button)
		
		vec2 ViewAngles { get, set }
		
		float ForwardSpeed { get, set }
		float SideSpeed { get, set }
		float UpSpeed { get, set }
		
		int EntityCount { get }
		Entity* GetEntity(int index) 
		
		int ResourceCount { get }
		Resource* GetResource(int index)
		
		void SendCommand(string)
		bool IsPlayerIndex(int)
		
		bool Connected
		
		Channel* Channel { get }
		Traffic* Traffic { get }
		Performance* Performance { get }
	}
	
	class Channel
	{
		int IncomingSequence
		int IncomingAcknowledgement
		int IncomingReliable
		
		int OutgoingSequence
		int OutgoingAcknowledgement
		int OutgoingReliable
	}
	
	class Traffic
	{
		int Incoming
		int Outgoing
		int Total
		
		int IncomingSpeed
		int OutgoingSpeed
		int Speed
		
		int IncomingPackets
		int OutgoingPackets
		int Packets
		
		int IncomingPacketsSpeed
		int OutgoingPacketsSpeed
		int PacketsSpeed
	}
	
	static class Performance
	{
		int Framerate
		float ProcessorUsage
		int MemoryUsage
	}
	
	class Entity
	{
		int EntityType
		
		int Number
		float MsgTime

		int MessageNum
						
		vec3 Origin
		vec3 Angles
				
		int ModelIndex
		int Sequence
		float Frame
		int ColorMap
		int Skin
		int Solid
		int Effects
		float Scale

		int EFlags

		int RenderMode
		int RenderAmt
		// uint8_t	rendercolor[3];
		int RenderFx

		int MoveType
		float AnimTime
		float Framerate
		int Body
		//	uint8_t		controller[4];
		//	uint8_t		blending[4];

		vec3 Velocity

		vec3 MinS
		vec3 MaxS
			
		int AimEnt
		
		int Owner
			
		float Friction
			
		float Gravity
		
		int Team
		int PlayerClass
		int Health
		bool Spectator
		int WeaponModel
		int GaitSequence

		vec3 BaseVelocity

		int UseHull

		int OldButtons

		int OnGround

		int StepLeft

		float FallVelocity

		float FOV
		int WeaponAnim

		vec3 StartPos
		vec3 EndPos

		float ImpactTime
		float StartTime
				
		int IUser1
		int IUser2
		int IUser3
		int IUser4

		float FUser1
		float FUser2
		float FUser3
		float FUser4

		vec3 VUser1
		vec3 VUser2
		vec3 VUser3
		vec3 VUser4
	}
	
	static class ClientData
	{
		vec3 Origin
		vec3 Velocity
			
		int ViewModel
		vec3 PunchAngle
			
		int Flags
		int WaterLevel
		int WaterType
		vec3 ViewOffset
		float Health

		int InDuck

		int TimeStepSound
		int DuckTime
		int SwimTime
		int WaterJumpTime
		
		float MaxSpeed

		float FOV
		int WeaponAnim
		
		int ID
		int AmmoShells
		int AmmoNails
		int AmmoCells
		int AmmoRockets
		float NextAttack
		
		int TFState
		
		int PushMSec
		
		int DeadFlag
		
		string PhysInfo
		
		int IUser1
		int IUser2
		int IUser3
		int IUser4

		float FUser1
		float FUser2
		float FUser3
		float FUser4

		vec3 VUser1
		vec3 VUser2
		vec3 VUser3
		vec3 VUser4
	}
	
	class Sound
	{
		int Index
		int Entity
		int Channel
		int Volume
		int Pitch
		float Attenuation
		int Flags
		vec3 Origin
	}
	
	class Resource
	{
		int Type
		string Name
		int Index
		int Size
		int Flags
	}

	class EventArgs
	{
		int Flags
		int EntityIndex
		vec3 Origin
		vec3 Velocity
		int Ducking
		float FParam1
		float FParam2
		int IParam1
		int IParam2
		int BParam1
		int BParam2
	}

	class Event
	{
		int Index
		int PacketIndex
		int EntityIndex
		float FireTime
		EventArgs* Args
		int Flags	
	}

	
	Calls:
	
	void Initialize()
	void Finalize()
	void Frame(double dTime)
	void Think(double dTime)
	
	byte[] GenerateCertificate()
	
	void OnEvent(Event)
	void OnSound(Sound)
	void OnGameMessage(Name, data)
	
]]