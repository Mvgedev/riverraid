extends Node

const SAVE_FILE = "user://RRGlobal.save"
var save_data = null

func _ready() -> void:
	load_savefile()
	if save_data:
		BgmPlayer.bgm_volume = save_data["bgm_vol"]
		BgmPlayer.sfx_volume = save_data["sfx_vol"]
		ScoreSystem.high_score = save_data["hi_score"]

func save_savefile():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var data = {"hi_score": ScoreSystem.high_score, "sfx_vol": BgmPlayer.sfx_volume, "bgm_vol": BgmPlayer.bgm_volume}
	file.store_string(JSON.stringify(data))
	file.close()
	pass

func load_savefile():
	if not FileAccess.file_exists(SAVE_FILE):
		return
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) == TYPE_DICTIONARY:
		save_data = data
