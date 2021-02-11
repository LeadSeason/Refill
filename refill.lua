local r = require("robot")
local sides = require("sides")
local component = require("component")
local inv = component.inventory_controller
local down = sides.down
local PrintLn = true
local loops_done = 0
local last_str = ""

function iop(str)
	io.write(('\b \b'):rep(#last_str))  -- erase old line
	io.write(str)                       -- write new line
	io.flush()
	last_str = str
end

function Left(n)
	if not n then
		r.turnLeft() 
	else
		while (n >= 1) do
			r.turnLeft()
			n = n-1
		end
	end
end

function Right(n)
	if not n then
		r.turnRight() 
	else
		while (n >= 1) do
			r.turnRight()
			n = n-1
		end
	end
end

print("How many cycles? 0 to go infinitely")
Ln = tonumber(io.read())
if Ln == 0 then
	Ln = 2^500 -- I know its not infinet but it will be fine
	PrintLn = false
end

while (Ln >= 1)
do
	if PrintLn then
		iop("loops untill done" .. Ln)
	else
		iop("loops done: " .. loops_done)
	end
	

	local livingrock = 0
	local livingwood = 0
	local wood = 0
	local rock = 0


	-- mapping internal slots
	-- sets items to slots
	local a = 1
	while (a < r.inventorySize() + 1)
	do
		local item = inv.getStackInInternalSlot(a)
		if item then
			--print(item.name)
			if item.name == "minecraft:stone" then
				rock = a
				--print("stone mapped to", a)
			elseif item.name == "minecraft:log" then
				wood = a
				--print("log mapped to", a)
			elseif item.name == "botania:livingrock" then
				livingrock = a
				--print("livingrock mapped to", a)
			elseif item.name == "botania:livingwood" then
				livingwood = a
				--print("livingwood mapped to", a)
			else
				print("slot " .. a .. " contains somethins thas not needed")
			end
		else
			--print("Slot " .. a .. " is empty")
		end
		a = a+1
	end
	
	if rock == 0 and wood == 0 and livingrock == 0 and livingwood == 0 then
		print("Have Stone, logs, livingrock, and livingwood in the inv of the robot")
		os.exit()
	end

	-- check for logs and stone in chest and take if needed
	local a = 1
	while (true)
	do
		local item = inv.getStackInSlot(down, a)
		if item and item.name == "minecraft:stone" then
			r.select(rock)
			inv.suckFromSlot(down, a, 64 - inv.getStackInInternalSlot(rock).size)
		end

		if inv.getStackInInternalSlot(rock).size == 64 then
			break
		end

		if a > inv.getInventorySize(down) then
			print("Not enough Stone in chest")
			os.exit()
		end
		a = a+1
	end

	local a = 1
	while (true)
	do
		local item = inv.getStackInSlot(down, a)
		if item and item.name == "minecraft:log" then
			r.select(wood)
			inv.suckFromSlot(down, a, 64 - inv.getStackInInternalSlot(wood).size)
		end

		if inv.getStackInInternalSlot(wood).size == 64 then
			break
		end

		if a > inv.getInventorySize(down) then
			print("Not enough Logs in chest")
			os.exit()
		end
		a = a+1
	end

	r.select(livingrock)
	r.dropDown(inv.getStackInInternalSlot(livingrock).size - 1)

	r.select(livingwood)
	r.dropDown(inv.getStackInInternalSlot(livingwood).size - 1)

	function Forword(n,replace)
		if not n and not replace then
			r.forward()
		elseif n and not replace then
			while (n >= 1) do
				r.forward()
				n = n-1
			end
		elseif n and replace then
			while (n >= 1)
			do
				r.forward()
				r.select(livingrock)
				if r.compareDown() then
					r.swingDown()
					r.select(rock)
					r.placeDown()
				end

				r.select(livingwood)
				if r.compareDown() then
					r.swingDown()
					r.select(wood)
					r.placeDown()
				end
				n = n-1
			end
		end
	end
	
	Left(2)
	Forword(33,true)
	Left()
	Forword(1,true)
	Left()
	Forword(32,true)
	Right()
	Forword(1,true)
	Right()
	Forword(32,true)
	Left(2)
	Forword(32)
	Left()
	Forword(2)
	Right()
	Forword(1)

	Ln = Ln-1
	loops_done = loops_done + 1
end
