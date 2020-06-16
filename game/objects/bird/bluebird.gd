extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
var motion = Vector2()
var implode = preload("res://objects/implode/implode.tscn")
func _ready():
	motion.y = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.






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
