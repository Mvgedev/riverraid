extends Node

const SAVE_FILE = "user://RRGlobal.save"
var save_data = null

func _ready() -> void:
	load_savefile()

func save_savefile():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
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
