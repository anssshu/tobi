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









func _on_tito_body_entered(body):
	if body.name == "stone":
		var s = implode.instance()
		s.position = self.position
		body.queue_free()
		get_tree().root.add_child(s)
		self.queue_free()
