extends Node

@onready var stream: AudioStreamPlayer2D = $Stream

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
