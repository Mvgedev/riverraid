extends Node

@onready var bgm_stream: AudioStreamPlayer2D = $Stream

func stop_bgm():
	bgm_stream.stop()

func play_bgm(song):
	if bgm_stream.playing == true:
		stop_bgm()
	if song != null and song is AudioStream:
		bgm_stream.stream = song
		bgm_stream.play()
	else:
		print("Failed to play: " + str(song))
