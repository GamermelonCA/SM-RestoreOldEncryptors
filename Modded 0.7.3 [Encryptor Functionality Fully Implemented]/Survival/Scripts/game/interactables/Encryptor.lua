dofile("$SURVIVAL_DATA/Scripts/util.lua")
dofile"$SURVIVAL_DATA/Scripts/game/survival_survivalobjects.lua"
dofile("$SURVIVAL_DATA/Scripts/game/managers/EncryptorManager.lua")

Encryptor = class()
Encryptor.maxChildCount = 255
Encryptor.maxParentCount = 0
Encryptor.connectionInput = sm.interactable.connectionType.none
Encryptor.connectionOutput = sm.interactable.connectionType.logic

function Encryptor.server_onCreate( self )
	--sm.gui.chatMessage("Create")

	g_encryptorManager:sv_StartupUpdatePastBody( self.body, self.encryptions, self.shape:getShapeUuid() )
	self.encryptions = {}
	if self.data then
		self.encryptions = self.data.encryptions
	end
	
	self.saved = self.storage:load()
	if self.saved == nil then
		self.saved = {}
		self.interactable.active = true
		self.prevActiveState = true
		self.saved.state = true
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
	self:server_updateRestrictions( not self.saved.state )
	
	self.loaded = true
end

function Encryptor.server_onUnload( self )
	self.loaded = false
end

function Encryptor.server_onDestroy( self )
	if self.loaded then
		g_encryptorManager:sv_updateRestrictionsOnDestroy()
			
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
		self.network:sendToServer( "server_switchActiveState", ( not self.interactable.active ) )
	end
end

function Encryptor.server_onFixedUpdate( self, timeStep )
	
	if self.pastBody ~= self.shape:getBody() then
		self.pastBody = self.shape:getBody()
		g_encryptorManager:sv_UpdatePastBody( self.shape:getBody(), self.encryptions, self.shape:getShapeUuid() )
	end
	
	if self.interactable.active ~= self.prevActiveState then
		self.prevActiveState = self.interactable.active
		self:server_updateRestrictions( not self.interactable.active )
		
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
end

function Encryptor.server_switchActiveState( self, requestedState )
	self.interactable.active = requestedState
	self.saved.state = requestedState
	self.storage:save( self.saved )
end

function Encryptor.server_updateRestrictions( self, encryptionActive )
	g_encryptorManager:sv_updateRestrictions( encryptionActive , self.shape, self.shape:getBody(), self.encryptions, self.shape:getShapeUuid() )
end