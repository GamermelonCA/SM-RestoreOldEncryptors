dofile("$SURVIVAL_DATA/Scripts/game/survival_constants.lua")
dofile "$SURVIVAL_DATA/Scripts/game/survival_shapes.lua"

EncryptorManager = class( nil )

--not sure which one is nessasary so included both
function EncryptorManager.sv_onCreate( self )
end

function EncryptorManager.cl_onCreate( self )
end

function EncryptorManager.sv_StartupUpdatePastBody( self, ShapeBody, PastEncryptions, PastUUID )
    self.PastBody = ShapeBody
    self.PastEncryptions = PastEncryptions
    self.PastUUID = PastUUID
end

function EncryptorManager.sv_UpdatePastBody( self, ShapeBody, PastEncryptions, PastUUID )
    if self.EncryptionStatus == false and self.PastBody ~= nil then
        self:sv_updateRestrictionsOnDestroy()
    end
    
    self.PastBody = ShapeBody
    self.PastEncryptions = PastEncryptions
    self.PastUUID = PastUUID
end

function EncryptorManager.sv_updateRestrictionsOnDestroy (self)
    self:sv_updateRestrictions(true, nil, self.PastBody, self.PastEncryptions, self.PastUUID )
end

function EncryptorManager.sv_updateRestrictions( self, encryptionActive, shape, shapeBody, encryptions, UUID )

    self.EncryptionStatus = encryptionActive
    body = shapeBody

    if shapeBody ~= nil and sm.exists(shapeBody) then
        restrictionSwitch = switch {
            ["destructable"] = function( x ) print( x, encryptionActive ) body.destructable = encryptionActive end,
            ["buildable"] = function( x ) print( x, encryptionActive) body.buildable = encryptionActive end,
            ["paintable"] = function( x ) print( x, encryptionActive) body.paintable = encryptionActive end,
            ["connectable"] = function( x ) print( x, encryptionActive) body.connectable = encryptionActive end,
            ["liftable"] = function( x ) print( x, encryptionActive) body.liftable = encryptionActive end,
            ["erasable"] = function( x ) print( x, encryptionActive) body.erasable = encryptionActive end,
            ["usable"] = function( x ) print( x, encryptionActive) body.usable = encryptionActive end,
            default = function( x ) print( x, "is not a valid encryption name.") end
        }	
        for i, encryption in ipairs( encryptions ) do
            restrictionSwitch:case( encryption )
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