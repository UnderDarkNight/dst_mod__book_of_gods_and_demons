SoundEmitter.PlaySound_test_bogd_old = SoundEmitter.PlaySound
SoundEmitter.PlaySound = function(self, sound_addr, name, volume, ...)
	-- local inst = self:GetEntity()
    print(sound_addr)
	self:PlaySound_test_bogd_old(sound_addr, name, volume, ...)
end


SoundEmitter.PlaySoundWithParams_test_bogd_old = SoundEmitter.PlaySoundWithParams
SoundEmitter.PlaySoundWithParams = function(self,sound_addr,...)
    print(sound_addr)
    self:PlaySoundWithParams_test_bogd_old(sound_addr,...)
end