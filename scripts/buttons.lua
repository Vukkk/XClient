Buttons = {}
	
Buttons.Type = {
	Attack = 1 << 0,
	Jump = 1 << 1,
	Duck = 1 << 2,
	Forward = 1 << 3,
	Back = 1 << 4,
	Use = 1 << 5,
	Cancel = 1 << 6,
	Left = 1 << 7,
	Right = 1 << 8,
	MoveLeft = 1 << 9,
	MoveRight = 1 << 10,
	Attack2 = 1 << 11,
	Run = 1 << 12,
	Reload = 1 << 13,
	Alt1 = 1 << 14,
	Score = 1 << 15
}
	
function Buttons.PrimaryAttack()
	Engine:PressButton(Buttons.Type.Attack)
end

local WasPrimaryAttack = false

function Buttons.FastPrimaryAttack()
	if not WasPrimaryAttack then
		Buttons.PrimaryAttack()
		WasPrimaryAttack = true
	else
		WasPrimaryAttack = false
	end	
end

local WasSecondaryAttack = false

function Buttons.FastSecondaryAttack()
	if not WasSecondaryAttack then
		Buttons.SecondaryAttack()
		WasSecondaryAttack = true
	else
		WasSecondaryAttack = false
	end	
end

function Buttons.SecondaryAttack()
	Engine:PressButton(Buttons.Type.Attack2)
end

function Buttons.Duck()
	Engine:PressButton(Buttons.Type.Duck)
end

function Buttons.Jump()
	Engine:PressButton(Buttons.Type.Jump)
end

function Buttons.Use()
	Engine:PressButton(Buttons.Type.Use)
end

function Buttons.Reset() -- TODO: recode with cycle 'for'
	Engine:LeaveButton(Buttons.Type.Attack)
	Engine:LeaveButton(Buttons.Type.Jump)
	Engine:LeaveButton(Buttons.Type.Duck)
	Engine:LeaveButton(Buttons.Type.Forward)
	Engine:LeaveButton(Buttons.Type.Back)
	Engine:LeaveButton(Buttons.Type.Use)
	Engine:LeaveButton(Buttons.Type.Cancel)
	Engine:LeaveButton(Buttons.Type.Left)
	Engine:LeaveButton(Buttons.Type.Right)
	Engine:LeaveButton(Buttons.Type.MoveLeft)
	Engine:LeaveButton(Buttons.Type.MoveRight)
	Engine:LeaveButton(Buttons.Type.Attack2)
	Engine:LeaveButton(Buttons.Type.Run)
	Engine:LeaveButton(Buttons.Type.Reload)
	Engine:LeaveButton(Buttons.Type.Alt1)
	Engine:LeaveButton(Buttons.Type.Score)
end