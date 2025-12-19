extends Node

@onready var stream: AudioStreamPlayer2D = $Stream
const MENUTHEME = preload("res://assets/bgm/briefing.ogg")
const GAME_THEME = preload("res://assets/bgm/system_daemon.ogg")

var sfx_volume = 1.0
var bgm_volume = 1.0

const SFX_BUS = "SFX"
const BGM_BUS = "BGM"

func _ready() -> void:
	load_volume()
	set_volume(SFX_BUS, sfx_volume)
	set_volume(BGM_BUS, bgm_volume)

func load_volume():
	if SaveSystem.save_data and SaveSystem.save_data.has("sfx_vol"):
		bgm_volume = SaveSystem.save_data["bgm_vol"]
		sfx_volume = SaveSystem.save_data["sfx_vol"]
	else:
		var b_sfx = AudioServer.get_bus_index(SFX_BUS)
		sfx_volume = percent_from_volume(AudioServer.get_bus_volume_db(b_sfx))
		var b_bgm = AudioServer.get_bus_index(BGM_BUS)
		bgm_volume = percent_from_volume(AudioServer.get_bus_volume_db(b_bgm))

func save_volume():
	pass

func stop_bgm():
	stream.stop()

func play_bgm(song):
	if stream.playing == true:
		stop_bgm()
	if song != null and song is AudioStream:
		stream.stream = song
		stream.play()
	else:
		print("Failed to play: " + str(song))

func volume_from_percent(p: float) -> float:
	return lerp(-60.0, 0.0, clamp(p, 0.0, 1.0)) # Check value

func percent_from_volume(db: float) -> float:
	return inverse_lerp(-60.0, 0.0, clamp(db, -60.0, 0.0))

func update_sfx_vol(val):
	sfx_volume = val
	set_volume(SFX_BUS, sfx_volume)

func update_bgm_vol(val):
	bgm_volume = val
	set_volume(BGM_BUS, bgm_volume)

func set_volume(audio_channel, val):
	var bus := AudioServer.get_bus_index(audio_channel)
	AudioServer.set_bus_volume_db(bus, volume_from_percent(val))
