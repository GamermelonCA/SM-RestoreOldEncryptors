dofile("$SURVIVAL_DATA/Scripts/util.lua")
dofile"$SURVIVAL_DATA/Scripts/game/survival_survivalobjects.lua"
dofile("$SURVIVAL_DATA/Scripts/game/managers/EncryptorManager.lua")

Encryptor = class()
Encryptor.maxChildCount = 255
Encryptor.maxParentCount = 2
Encryptor.connectionInput = sm.interactable.connectionType.logic + sm.interactable.connectionType.electricity
Encryptor.connectionOutput = sm.interactable.connectionType.logic

function Encryptor.server_onCreate( self )

	g_encryptorManager:sv_SaveBody( self.body, self.encryptions, self.shape:getShapeUuid() )

	self.encryptions = {}
	if self.data then
		self.encryptions = self.data.encryptions
	end
	
	self.saved = self.storage:load()
	if self.saved == nil then
		self.saved = {}
		self.interactable.active = false
		self.prevActiveState = false
		self.saved.state = false
		self.saved.params = self.params
		self.storage:save( self.saved )
	else
		self.interactable.active = self.saved.state
		self.prevActiveState = self.saved.state

		if self.saved.params == nil then
			self.saved.params = self.params
			self.storage:save( self.saved )
		end
	end

	self.interactable.active = self.saved.state

	if self.saved.params then
		self.Warehouse = true
	else
		self.Warehouse = false
	end

	self.DrainCounter = 0

	g_encryptorManager:sv_updateRestrictions( self.saved.state , nil, self.shape:getBody(), self.encryptions, self.shape:getShapeUuid() )

	self.loaded = true
end

function Encryptor.server_onUnload( self )
	self.loaded = false
end

function Encryptor.server_onDestroy( self )
	if self.loaded then
		g_encryptorManager:sv_DecryptPastBody()
			
		-- If the encryptor was loaded as part of a warehouse then it will sync the encryption state to all floors
		if self.saved.params then
			local restrictions = {}
			for i, encryption in ipairs( self.encryptions ) do
				restrictions[encryption] = { name = encryption, state = true }
			end
			
			local params = { warehouseIndex = self.saved.params.warehouseIndex, restrictions = restrictions }
			sm.event.sendToGame( "sv_e_setWarehouseRestrictions", params )
		end

		self.loaded = false
	end
end

function Encryptor.client_onInteract( self, character, state )
	if state == true then
		self.network:sendToServer( "server_HandelInteraction" )
	end
end

function Encryptor.server_HandelInteraction( self )
	
	local logicInteractable, _ = self:getInputs()
	self:CheckForRequirements()
	
	if not logicInteractable and self.RequirementsMet then
		self:server_switchActiveState ( not self.interactable.active )
	elseif logicInteractable then
		self.network:sendToClients("client_ShowMessage", "Controlled by another interactable")
	end
end

function Encryptor.server_onFixedUpdate( self, timeStep )

	if self.pastBody ~= self.shape:getBody() then
		self.pastBody = self.shape:getBody()
		g_encryptorManager:sv_DecryptPastBody()
		g_encryptorManager:sv_SaveBody( self.shape:getBody(), self.encryptions, self.shape:getShapeUuid() )
	end
	
	if self.interactable.active ~= self.prevActiveState and self.loaded then
		self.prevActiveState = self.interactable.active
		g_encryptorManager:sv_updateRestrictions( self.interactable.active , self.shape, self.shape:getBody(), self.encryptions, self.shape:getShapeUuid() )
		
		-- If the encryptor was loaded as part of a warehouse then it will sync the encryption state to all floors
		if self.saved.params then
			local restrictions = {}
			for i, encryption in ipairs( self.encryptions ) do
				restrictions[encryption] = { name = encryption, state = not self.interactable.active }
			end
			
			local params = { warehouseIndex = self.saved.params.warehouseIndex, restrictions = restrictions }
			sm.event.sendToGame( "sv_e_setWarehouseRestrictions", params )
		end
	end

	local logicInteractable, _ = self:getInputs()
	if logicInteractable then
		local LogicIsActive = logicInteractable:isActive()
		if self.LastLogicState ~= LogicIsActive then
			self.LastLogicState = LogicIsActive
			if LogicIsActive then
				self:CheckForRequirements()
			end
		end

		if LogicIsActive ~= self.interactable.active and self.RequirementsMet then
			self:server_switchActiveState( LogicIsActive )
		end
	end
	
	local _, BattInteractable = self:getInputs()
	if self.interactable.active and BattInteractable ~= nil then
		if not BattInteractable:isEmpty() and self.RequirementsMet then
			self.DrainCounter = self.DrainCounter + timeStep

			if self.DrainCounter > 5 then
				self.DrainCounter = 0
				sm.container.beginTransaction()
				sm.container.spend( BattInteractable, obj_consumable_battery, 1 )
				sm.container.endTransaction()
				self:CheckForRequirements()
			end

		elseif BattInteractable:isEmpty() then
			self:server_switchActiveState( false )
		end
	end

end

function Encryptor.CheckForRequirements( self )
	if self.loaded then
		local _, BattInteractable = self:getInputs()
		if self.Warehouse then
			self.RequirementsMet = true
		elseif not self.Warehouse and BattInteractable == nil then
			self.network:sendToClients("client_ShowMessage", "No battery container connected")
			self.RequirementsMet = false
		elseif not self.Warehouse and BattInteractable ~= nil then	
			if not self.Warehouse and BattInteractable:isEmpty() then
				self.network:sendToClients("client_ShowMessage", "Out of energy")
				self.RequirementsMet = false
			elseif not self.Warehouse and not BattInteractable:isEmpty() then
				self.RequirementsMet = true
			end
		end
	end
end

function Encryptor.server_switchActiveState( self, requestedState )
	self.interactable.active = requestedState
	self.saved.state = requestedState
	self.storage:save( self.saved )
end

function Encryptor.client_ShowMessage( self, text )
	sm.gui.displayAlertText( text )
end

--Stolen From MountedPotatoGun
function Encryptor.client_getAvailableParentConnectionCount( self, connectionType )
	if bit.band( connectionType, sm.interactable.connectionType.logic ) ~= 0 then
		return 1 - #self.interactable:getParents( sm.interactable.connectionType.logic )
	end
	if bit.band( connectionType, sm.interactable.connectionType.electricity ) ~= 0 then
		return 1 - #self.interactable:getParents( sm.interactable.connectionType.electricity )
	end
	return 0
end
--also Stolen
function Encryptor.getInputs( self )
	local logicInteractable = nil
	local BattInteractable = nil
	local parents = self.interactable:getParents()
	if parents[2] then
		if parents[2]:hasOutputType( sm.interactable.connectionType.logic ) then
			logicInteractable = parents[2]
		elseif parents[2]:hasOutputType( sm.interactable.connectionType.electricity ) then
			BattInteractable = parents[2]:getContainer( 0 )
		end
	end
	if parents[1] then
		if parents[1]:hasOutputType( sm.interactable.connectionType.logic ) then
			logicInteractable = parents[1]
		elseif parents[1]:hasOutputType( sm.interactable.connectionType.electricity ) then
			BattInteractable = parents[1]:getContainer( 0 )
		end
	end

	return logicInteractable, BattInteractable
end