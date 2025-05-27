dofile("$SURVIVAL_DATA/Scripts/game/survival_constants.lua")
dofile "$SURVIVAL_DATA/Scripts/game/survival_shapes.lua"

EncryptorManager = class( nil )

--not sure which one is nessasary so included both
function EncryptorManager.sv_onCreate( self )
end

function EncryptorManager.cl_onCreate( self )
end

function EncryptorManager.sv_SaveBody( self, ShapeBody, PastEncryptions, PastUUID )
    self.PastBody = ShapeBody
    self.PastEncryptions = PastEncryptions
    self.PastUUID = PastUUID
end

function EncryptorManager.sv_DecryptPastBody( self )
    self:sv_updateRestrictions(false, nil, self.PastBody, self.PastEncryptions, self.PastUUID )
end

function EncryptorManager.sv_updateRestrictions( self, encryptionActive, shape, shapeBody, encryptions, UUID )
    local encryptionActive = not encryptionActive

    print("Encryption State: " .. tostring(encryptionActive))

    if shapeBody ~= nil then
        local attachedbodies = shapeBody:getCreationBodies()
        for _, body in ipairs(attachedbodies) do
            if body ~= nil and sm.exists(body) then
                restrictionSwitch = switch {
                    ["destructable"] = function( x ) --[[print( x, encryptionActive )]] body.destructable = encryptionActive end,
                    ["buildable"] = function( x ) --[[print( x, encryptionActive)]] body.buildable = encryptionActive end,
                    ["paintable"] = function( x ) --[[print( x, encryptionActive)]] body.paintable = encryptionActive end,
                    ["connectable"] = function( x ) --[[print( x, encryptionActive)]] body.connectable = encryptionActive end,
                    ["liftable"] = function( x ) --[[print( x, encryptionActive)]] body.liftable = encryptionActive end,
                    ["erasable"] = function( x ) --[[print( x, encryptionActive)]] body.erasable = encryptionActive end,
                    ["usable"] = function( x ) --[[print( x, encryptionActive)]] body.usable = encryptionActive end,
                    default = function( x ) print( x, "is not a valid encryption name.") end
                }	
                for i, encryption in ipairs( encryptions ) do
                    restrictionSwitch:case( encryption )
                end
            end
        end
    end

    if shape ~= nil then
	    --In Charge of Playing Animation
	    local shapeUuid = UUID
	    if shapeUuid == obj_interactive_encryptor_connection then
	        if encryptionActive then
	    		sm.effect.playEffect( "Encryptor - Deactivation", shape.worldPosition, nil, shape.worldRotation )
	    	else
	    		sm.effect.playEffect( "Encryptor - Activation", shape.worldPosition, nil, shape.worldRotation )
	    	end
	    elseif shapeUuid == obj_interactive_encryptor_destruction then
	    	if encryptionActive then
	    		sm.effect.playEffect( "Barrier - Deactivation", shape.worldPosition, nil, shape.worldRotation )
	    	else
			    sm.effect.playEffect( "Barrier - Activation", shape.worldPosition, nil, shape.worldRotation )
		    end
	    end
    end
end