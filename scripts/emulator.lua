Emulator = {}

require "buffer"
require "console"

local default = "avsmp"
local emulator = default

function Emulator.Initialize()
	Engine:RegisterCVar("emulator", "client emulator type", { "name" }, 
		function() return { emulator } end, 
		function(Args) emulator = Args[1]:lower() end)
end

function Emulator.GenerateCertificate()
	if emulator == "avsmp" then
		return Emulator.GenerateAVSMP()
	elseif emulator == "steamemu" then
		return Emulator.GenerateSteamEmu()
	elseif emulator == "oldrevemu" then
		return Emulator.GenerateOldRevEmu()
	else
		Engine:WriteLine('Unknown emulator type "' .. emulator .. '"')
		Engine:WriteLine('Switching to default emulator "' .. default .. '"')
		emulator = default
		return Emulator.GenerateCertificate()
	end
end

function Emulator.GenerateAVSMP()
	--[[
	
	  WriteInt32(Result, $14); // Verification
	  WriteInt32(Result, RandomNumber);
	  WriteInt32(Result, RandomNumber);

	  if SteamID = 0 then
		WriteInt32(Result, RandomNumber) // SteamID
	  else
		WriteInt32(Result, (SteamID shl 1) + Byte(Prefix));

	  WriteInt32(Result, $01100001);
	  WriteInt32(Result, RandomNumber);
	  WriteInt32(Result, $0);
	
	]]
	
	local BF = Buffer.New()
	
	BF:WriteLongWord(0x14000000)
	
	BF:WriteLongWord(math.random(1 << 31))
	BF:WriteLongWord(math.random(1 << 31))
	
	BF:WriteLongWord(math.random(1 << 31))
	
	BF:WriteLongWord(0x01100001)
	
	BF:WriteLongWord(math.random(1 << 31))
	
	BF:WriteLongWord(0)
	
	return BF.Memory
end

function Emulator.GenerateSteamEmu()
	--[[
	
	  for I := 1 to 20 do // there all 80 chars can also be #0
		WriteInt32(Result, RandomNumber);

	  WriteInt32(Result, $FFFFFFFF); // Verification

	  if SteamID = 0 then
		WriteInt32(Result, RandomNumber) // SteamID
	  else
	  begin
		if not SteamEmuCompatMode then
		  WriteInt32(Result, SteamID)
		else
		  WriteInt32(Result, (SteamID * 2) + Byte(Prefix) xor $C9710266);
	  end;

	  for I := 1 to 170 do // there all 680 chars can also be #0
		WriteInt32(Result, RandomNumber);
	
	]]
	
	local BF = Buffer.New()
	
	for i = 1, 20 do
		BF:WriteLongWord(math.random(1 << 32)) 
	end
	
	BF:WriteLongWord(0xFFFFFFFF)
	
	BF:WriteLongWord(math.random(1 << 32))
	
	for i = 1, 170 do
		BF:WriteLongWord(math.random(1 << 32)) 
	end

	return BF.Memory
end

function Emulator.GenerateOldRevEmu()
	--[[

	  WriteInt32(Result, $FFFF0000 or (RandomNumber and $FFFF));  // Verification

	  if SteamID = 0 then
		WriteInt32(Result, RandomNumber) // SteamID
	  else
	  begin
		if not SteamEmuCompatMode then
		  WriteInt32(Result, (SteamID) xor $C9710266)
		else
		  WriteInt32(Result, (SteamID * 2) + Byte(Prefix))
	  end;

	  WriteUInt16(Result, RandomNumber);

	]]

	local BF = Buffer.New()
	
	BF:WriteLongWord(0xFFFF0000 | (math.random(1 << 32) & 0xFFFF))
	
	BF:WriteLongWord(math.random(1 << 32))
	
	BF:WriteWord(math.random(1 << 16))

	return BF.Memory
end


































































--[[
function GetRandomHash: LStr;
var
  I: Int32;
begin
  for I := 1 to 32 do
    if Random(2) = 0 then
      WriteUInt8(Result, Ord('0') + Random(9))
    else
      WriteUInt8(Result, Ord('a') + Random(6))
end;

function RandomNumber: Longint;
begin
  Randomize;
  Result := RandomRange(1, MaxInt32);
end;

function CC_AVSMP(SteamID: UInt32 = 0; const Prefix: Boolean = False): LStr;
var
  I: Int32;
begin
  WriteInt32(Result, $14); // Verification
  WriteInt32(Result, RandomNumber);
  WriteInt32(Result, RandomNumber);

  if SteamID = 0 then
    WriteInt32(Result, RandomNumber) // SteamID
  else
    WriteInt32(Result, (SteamID shl 1) + Byte(Prefix));

  WriteInt32(Result, $01100001);
  WriteInt32(Result, RandomNumber);
  WriteInt32(Result, $0);
end;

function CC_SteamEmu(const SteamID: UInt32 = 0; const SteamEmuCompatMode: Boolean = True; const Prefix: Boolean = False): LStr;
var
  I: Int32;
begin
  for I := 1 to 20 do // there all 80 chars can also be #0
    WriteInt32(Result, RandomNumber);

  WriteInt32(Result, $FFFFFFFF); // Verification

  if SteamID = 0 then
    WriteInt32(Result, RandomNumber) // SteamID
  else
  begin
    if not SteamEmuCompatMode then
      WriteInt32(Result, SteamID)
    else
      WriteInt32(Result, (SteamID * 2) + Byte(Prefix) xor $C9710266);
  end;

  for I := 1 to 170 do // there all 680 chars can also be #0
    WriteInt32(Result, RandomNumber);
end;

function GetRandomString: LStr;
var
  L, Len: Int32;
begin
  Len := 6 + Random(9);
  SetLength(Result, Len);

  for L := 0 to Len - 1 do
    if Random(2) = 0 then
      PByte(Cardinal(Result) + L)^ := Ord('A') + Random(26)
    else
      PByte(Cardinal(Result) + L)^ := Ord('0') + Random(10);
end;

function RevHash(const S: PChar): Int32; // so based
asm
  DD $BA08BE0F, $4E67C6A7, $1D74C985, $89574056, $05E6C1D6
  DD $CE01D789, $C108BE0F, $F70102EF, $8540FA31, $5FE875C9
  DW $895E
  DB $D0
end;

function CC_RevEmu: LStr;
var
  HashStr: LStr;
  I1, I2, HashInt: Int32;
begin
  Clear(Result);
  HashStr := GetRandomString;
  HashInt := RevHash(PChar(HashStr));
  WriteInt32(Result, $4A);
  WriteInt32(Result, HashInt);
  WriteInt32(Result, Ord('v') + Ord('e') shl 8 + Ord('r') shl 16);
  WriteInt32(Result, 0);
  WriteInt32(Result, HashInt shl 1);
  WriteInt32(Result, 0);
  WriteBuf(Result, HashStr);

  for I1 := 1 to 28 do
    WriteInt32(Result, 0);

  WriteInt32(Result, 20);
  WriteInt32(Result, 1);
  WriteInt32(Result, 0);
end;

function CC_OldRevEmu(SteamID: UInt32 = 0; SteamEmuCompatMode: Boolean = True; const Prefix: Boolean = False): LStr;
var
  I: Longint;
  NewSID: String;
begin
  WriteInt32(Result, $FFFF0000 or (RandomNumber and $FFFF));  // Verification

  if SteamID = 0 then
    WriteInt32(Result, RandomNumber) // SteamID
  else
  begin
    if not SteamEmuCompatMode then
      WriteInt32(Result, (SteamID) xor $C9710266)
    else
      WriteInt32(Result, (SteamID * 2) + Byte(Prefix))
  end;

  WriteUInt16(Result, RandomNumber);
end;

function GetRandomStringEx: LStr;
var
  L, Len: Int32;
begin
  Len := 4 + Random(12) + 1;
  SetLength(Result, Len);

  for L := 0 to Len - 1 do
    case Random(3) of
      0: PByte(Cardinal(Result) + L)^ := Ord('a') + Random(26);
      1: PByte(Cardinal(Result) + L)^ := Ord('A') + Random(26);
      2: PByte(Cardinal(Result) + L)^ := Ord('0') + Random(10);
    end;
end;

]]