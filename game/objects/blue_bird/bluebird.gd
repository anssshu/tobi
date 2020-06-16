extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
var v = Vector2()
var implode = preload("res://objects/implode/implode.tscn")
func _ready():
	v.y = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position+=v


func attack():
	#get player posiotion 
	var p = get_tree().root.get_node("jungle/jungle_map/player").position
	var dir = (p-position).normalized()
	v = dir*6
	var angle = dir.angle()+PI
	if v.x > 0:
		scale.y = -1*abs(scale.y)
	if v.x < 0 :
		scale.y = abs(1*scale.y)
	rotation = angle
	print(angle)
func _on_bluebird_body_entered(body):
	
	#s.scale = Vector2(0.5,0.5)
	#s.modulate = Color(1,0,0,1)
	#if bird hit by a stone
	#print(body.get_class())
	if body.name == "stone":
		var s = implode.instance()
		s.position = self.position
		body.queue_free()
		get_tree().root.add_child(s)
		self.queue_free()


func _on_Timer_timeout():
	rotation = 0
	$AnimationPlayer.play("fly")
	attack()
	$Timer.stop()
	#pass # Replace with function body.


func _on_VisibilityEnabler2D_screen_entered():
	$Timer.start()


func _on_VisibilityEnabler2D_screen_exited():
	queue_free()
