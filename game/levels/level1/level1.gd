extends Node

var musicPlayer = AudioStreamPlayer.new()
var bg_music = preload("res://assets/sounds/snow.ogg")
func _ready():
	
	musicPlayer.stream = bg_music
	self.add_child(musicPlayer)
	if globals.mute == false :
		musicPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
