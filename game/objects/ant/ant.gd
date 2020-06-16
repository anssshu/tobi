extends Node2D

export var speed = 2
var active  = false
var implode = preload("res://objects/implode/implode.tscn")
var dir = -1
#forway ray
var fray 

#downard ray
var dray
# Called when the node enters the scene tree for the first time.
func _ready():
	fray = $forward
	dray = $down

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		var fc = fray.is_colliding()
		var dc = dray.is_colliding()
		#print(dc)
		self.position += Vector2(-1*speed*dir,0)
		
		#when forward ray collides
		if fc:
			scale.x*=-1
			dir*=-1
		# whaen downard ray is not colliding
		if not dc :
			scale.x*=-1
			dir*=-1
	else:
		pass


		

func _on_VisibilityEnabler2D_screen_exited():
	active = false


func _on_VisibilityEnabler2D_screen_entered():
	active = true



func _on_ant_body_entered(body):
	# hit by stone
	if body.name == "stone":
		var s = implode.instance()
		s.position = self.position
		body.queue_free()
		get_tree().root.add_child(s)
		self.queue_free()
	#player hit
	if body.name == "player":
		#print("i hit player")
		body.v = Vector2(-400*dir,-400)
