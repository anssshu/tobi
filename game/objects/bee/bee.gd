extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
export var speed = 5
export var swing_speed = 2
var t = 0
var motion = Vector2()
var p0 = Vector2()
export var A = 100
var implode = preload("res://objects/implode/implode.tscn")
var player
func _ready():
	#initional positioning of bee
	p0 = position
	player = get_tree().root.get_node("scene/player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	#increase the time
	t+=dt
	if t > 100:
		t=0
	motion.x  = -speed
	position.y = p0.y+A*(1 + sin(swing_speed*t))
	position += motion
	# kill the bee at out of screen
	if self:
		if position.x < (player.position.x-600):
			queue_free()
#collision code for the bee
func _on_bee_body_entered(body):
	if body.name == "player":
		body.v = Vector2(-300,-300)
		
		if globals.health > 0:
			globals.health -= 1
		
	if body.name == "stone":
		var s = implode.instance()
		s.position = self.position
		body.queue_free()
		get_tree().root.add_child(s)
		self.queue_free()
