Resources = {}

Resources.Type = {
	Sound = 0,
	Skin = 1,
	Model = 2,
	Decal = 3,
	Generic = 4,
	EventScript = 5,
	World = 6
}

Resources.Flag = {
	FatalIfMissing = 1 << 0,
	WasMissing = 1 << 1,
	Custom = 1 << 2,
	Requested = 1 << 3,
	Precached = 1 << 4,
	Always = 1 << 5,
	Padding = 1 << 6, -- TODO: remove
	Checkfile = 1 << 7
}

function Resources.Find(Type, Index)
	for i = 0, Engine.ResourceCount - 1 do
		local R = Engine:GetResource(i)
		
		if R.Type == Type and R.Index == Index then				
			return R
		end
	end
	
	return nil
end

function Resources.FindSound(Index)
	return Resources.Find(Resources.Type.Sound, Index)
end

function Resources.FindEvent(Index)
	return Resources.Find(Resources.Type.EventScript, Index)
end