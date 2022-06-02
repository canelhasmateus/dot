SetCurrentProcessVolume(volume) ; volume can be number 0 — 100 or "mute" or "unmute"
{
   static MMDeviceEnumerator      := "{BCDE0395-E52F-467C-8E3D-C4579291692E}"
        , IID_IMMDeviceEnumerator := "{A95664D2-9614-4F35-A746-DE8DB63617E6}"
        , IID_IAudioClient        := "{1cb9ad4c-dbfa-4c32-b178-c2f568a703b2}"
        , IID_ISimpleAudioVolume  := "{87ce5498-68d6-44e5-9215-6da47ef883d8}"
        , eRender := 0, eMultimedia := 1, CLSCTX_ALL := 0x17
        , _ := OnExit( Func("SetCurrentProcessVolume").Bind(100) )
        
   IMMDeviceEnumerator := ComObjCreate(MMDeviceEnumerator, IID_IMMDeviceEnumerator)
   ; IMMDeviceEnumerator::GetDefaultAudioEndpoint
   DllCall(NumGet(NumGet(IMMDeviceEnumerator + 0) + A_PtrSize*4), "Ptr", IMMDeviceEnumerator, "UInt", eRender, "UInt", eMultimedia, "PtrP", IMMDevice)
   ObjRelease(IMMDeviceEnumerator)

   VarSetCapacity(GUID, 16)
   DllCall("Ole32\CLSIDFromString", "Str", IID_IAudioClient, "Ptr", &GUID)
   ; IMMDevice::Activate
   DllCall(NumGet(NumGet(IMMDevice + 0) + A_PtrSize*3), "Ptr", IMMDevice, "Ptr", &GUID, "UInt", CLSCTX_ALL, "Ptr", 0, "PtrP", IAudioClient)
   ObjRelease(IMMDevice)
   
   ; IAudioClient::GetMixFormat
   DllCall(NumGet(NumGet(IAudioClient + 0) + A_PtrSize*8), "Ptr", IAudioClient, "UIntP", pFormat)
   ; IAudioClient::Initialize
   DllCall(NumGet(NumGet(IAudioClient + 0) + A_PtrSize*3), "Ptr", IAudioClient, "UInt", 0, "UInt", 0, "UInt64", 0, "UInt64", 0, "Ptr", pFormat, "Ptr", 0)
   DllCall("Ole32\CLSIDFromString", "Str", IID_ISimpleAudioVolume, "Ptr", &GUID)
   ; IAudioClient::GetService
   DllCall(NumGet(NumGet(IAudioClient + 0) + A_PtrSize*14), "Ptr", IAudioClient, "Ptr", &GUID, "PtrP", ISimpleAudioVolume)
   ObjRelease(IAudioClient)
   if (volume + 0 != "")
      ; ISimpleAudioVolume::SetMasterVolume
      DllCall(NumGet(NumGet(ISimpleAudioVolume + 0) + A_PtrSize*3), "Ptr", ISimpleAudioVolume, "Float", volume/100, "Ptr", 0)
   else
      ; ISimpleAudioVolume::SetMute
      DllCall(NumGet(NumGet(ISimpleAudioVolume + 0) + A_PtrSize*5), "Ptr", ISimpleAudioVolume, "UInt", volume = "mute" ? true : false, "Ptr", 0)
   ObjRelease(ISimpleAudioVolume)
}

SoundChirp( volume := 50) {
	SetCurrentProcessVolume(volume)
	SoundPlay, %A_ScriptDir%\blob\chirp.wav 
}

