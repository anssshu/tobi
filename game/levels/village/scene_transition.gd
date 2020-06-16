extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	#play start animation
	$start.show()
	$start/AnimationPlayer.seek(0)
	$start/AnimationPlayer.play("start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#restart same level with check point data
func _on_AnimationPlayer_animation_finished(anim_name):
	$end/AnimationPlayer.seek(0.0,true)
	get_tree().paused = false
	globals.health = 1
	get_tree().reload_current_scene()
	#var player = get_node("/root/ground/player")
	#player.position = globals.check_point
	#player.show()
	#player.velocity = Vector2()
	#player.current_state = "jump"
