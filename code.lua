Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "Unseen_sfx", function(self, ...)
    self.checkunseensfx = UnseenSFX:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
    self:add_updator("UnseenSFX_Updater", callback(self.checkunseensfx, self.checkunseensfx, "update"))
end)

function HUDManager:UnseenActivator(target_time)
    self.checkunseensfx:UnseenTimeEnabled(target_time)
end

UnseenSFX = UnseenSFX or class()

-- Assets Path
UnseenSFX._sndpath = ModPath .. "assets/ogg/"
 

function UnseenSFX:init(hud)
    self._t = 0
    self._UnseenLast = -1

    if not blt.xaudio.issetup() then
        blt.xaudio.setup()
    end

    self._unseen = false
    self._src = XAudio.Source:new()

    -- Sound list
    self._sound = {
        [1] = {
            sfx = UnseenSFX._sndpath .. "activated.ogg",
        },
        [-1] = {
            sfx = UnseenSFX._sndpath .. "disabled.ogg",
        }
    }

    blt.xaudio.listener:setposition(0, 0, 0)
    blt.xaudio.listener:setorientation(1, 0, 0,  0, 1, 0)

end

function UnseenSFX:update(t, dt)
    self._t = t
    if self._unseen == true and self._UnseenLast <= t then
        self._unseen = false
        self:PlaySound()
    end
end

function UnseenSFX:UnseenTimeEnabled(target_time)
    self._UnseenLast = target_time + self._t
    self._unseen = true
    self:PlaySound()
end

function UnseenSFX:PlaySound()
    if not blt.xaudio.issetup() then
        blt.xaudio.setup()
    end
    buffer = nil

    if self._unseen == true then
        buffer = XAudio.Buffer:new(self._sound[1].sfx)
    else 
        buffer = XAudio.Buffer:new(self._sound[-1].sfx)
    end

    if buffer ~= nil then    
        self._src = XAudio.UnitSource:new(XAudio.PLAYER,buffer)
        if self._src ~= nil then
            if not self._src:get_state()==XAudio.Source.PLAYING then
                self._src:stop()
            end
            self._src:play()
        end
    end
end

