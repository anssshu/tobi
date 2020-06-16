extends KinematicBody2D
"""
stone is on collision layer 2 and mask 1 and same is player so that each other will no collide 
"""
class_name  Stone 

var g = Vector2(0,1650)
var v = Vector2(900,-500)
var colliding = false
# Called when the node enters the scene tree for the first time.
func get_class():
	return "Stone"
func _ready():
	$Timer.connect("timeout",self,"timeout")
	$VisibilityNotifier2D.connect("viewport_exited",self,"kill_me")
	$Timer.start()

func kill_me(viewport):
	print("stone:i am out and dead")
	queue_free()
	
func _enter_tree():
	pass
	#var player = get_tree().root.get_node("level1/player")
	#position = player.position+Vector2(-20,-40)
	#if player.face == "left":
		#v.x=-1*v.x
		#v += Vector2(player.linear_velocity.x,0)
	#if player.face == "right":
		#v += Vector2(player.linear_velocity.x,0)
	#print(player.current_state)
		
func timeout():
	#implode_on_col()
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_col(col):
	var c=0
	if col:
		c=1
		on_stay_collision(col)
		
		#dispose_on_col()
	else :
		c=0	
	if c==1 and colliding==false :
		on_enter_collision(col)
		colliding = true
	if c==0 and colliding :
		on_exit_collision(col)
		colliding = false
		
		
func _physics_process(delta):
	#calculate final velocity
	v+=  g*delta
	var col = move_and_collide(v*delta)
	_process_col(col)
#collision with physics body 2d
func implode_on_col():
	var s = preload("res://objects/implode/implode.tscn").instance()
	s.position = self.position
	s.scale = Vector2(0.5,0.5)
	s.modulate = Color(1,0,0,1)
	get_tree().root.add_child(s)
	self.queue_free()

#collision code for the kinematic body	
func on_enter_collision(col):
	#print("enter col ")
	v = v.bounce(col.normal)*0.5
func on_exit_collision(col):
	#print("exit col")	
	pass
				
func on_stay_collision(col):
	pass
	#v = v.bounce(col.normal)*0.5
	#g=Vector2()


