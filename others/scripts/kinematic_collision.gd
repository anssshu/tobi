extends KinematicBody2D
"""
stone is on collision layer 2 and mask 1 and same is player so that each other will no collide 
"""


export  var g = Vector2(0,1650)
export  var v = Vector2(900,-500)
var colliding = false
# Called when the node enters the scene tree for the first time.

func _ready():
	pass


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
	#motion code 
	v+=  g*delta
	var col = move_and_collide(v*delta)
	_process_col(col)


#collision code for the kinematic body	
func on_enter_collision(col):
	print("enter col ")
	
func on_exit_collision(col):
	print("exit col")	
				
func on_stay_collision(col):
	pass


