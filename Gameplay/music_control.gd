extends Node2D


# Called when the node enters the scene tree for the first time.
const volume_objetive:int = 0
func _ready() -> void:
	_on_audio_stream_player_finished()

func _process(delta: float) -> void:
	$AudioStreamPlayer.volume_db = lerpf($AudioStreamPlayer.volume_db, volume_objetive, delta)
var music:AudioStream = preload("res://Freesound/791237__kontraamusic__punk-hyperpop-music.ogg") #[preload("res://Freesound/791237__kontraamusic__punk-hyperpop-music.ogg"), preload("res://Freesound/788481__kontraamusic__neon-hiphop-instrumental.ogg")] 
func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.volume_db = -40
	$AudioStreamPlayer.stream = music
	$AudioStreamPlayer.play()
	$"../Camera2D/AnimCameraRithm".play("RESET")
	$"../Camera2D/AnimCameraRithm".play("Loop")
