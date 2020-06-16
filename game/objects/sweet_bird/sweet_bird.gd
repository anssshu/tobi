extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
var v = Vector2()
var vx
var vy
var anim
var hit
var hit_by_wall 
var state = "fly"
var last_state = "fly"
#var implode = preload("res://objects/implode/implode.tscn")
func _ready():
	v.y = 0
	anim = $AnimationPlayer
	#vision = $fwd
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	#birds horizontal velocity for accend and descend
	vx = rand_range(-10,10)
	# birds vertical velocity
	vy = rand_range(-10,-5)
	hit = $down.is_colliding()
	hit_by_wall = $fwd.is_colliding()
	if $top.is_colliding():
		v.y *= -1
	if hit_by_wall :
		v.x *= -1
	#when in air move down if v=0
	if not hit and v.length() == 0:
		v.y = 5
		anim.play("fly")
		
		$sprite.rotation = 0
	if v.x>0:
		scale.x = -1
	if v.x<0:
		scale.x = 1
	position += v
	"""
	if hit :
		last_state = state
		state = "fly"
	else:
		last_state = state
		state = "eat"

	if state == "eat" and last_state != "eat":
		anim.play("eat")
	if state == "fly" and last_state != "fly":
		anim.play("fly")
	"""

		
	

func _on_VisibilityEnabler2D_screen_entered():
	pass # Replace with function body.#


func _on_VisibilityEnabler2D_screen_exited():
	if v.y != 0:
		v.y = rand_range(5,2)
		v.x = 0



func _on_sweet_bird_body_entered(body):
	print(body.name)
	if body.name == "stone":
		anim.play("fly")
		
		$sprite.rotation = 0
		v = Vector2(vx,vy)
		anim.playback_speed = 1.0+v.length()*.5
		
	if body.name == "player":
		$sprite.rotation = 0
		anim.play("fly")
		v = Vector2(vx,vy)	
		anim.playback_speed = 1.0+v.length()*.5
	if (body.name != "player" and body.name != "stone") and  hit:
		v = Vector2()
		anim.play("eat")
		anim.playback_speed = 1.0+v.length()*.5
func _on_sweet_bird_area_entered(area):
	print(area.get_class())
	if area.get_class() == "enemy":
		anim.play("fly")
		$sprite.rotation = 0
		v = Vector2(vx,vy)
		anim.playback_speed = 1.0+v.length()*.5
