extends RigidBody2D

var colliding 
# Called when the node enters the scene tree for the first time.
func _ready():
	colliding = false
	
func _process_collision(state):
	var other
	var c = 0
	if state.get_contact_count()>0 :
		c = 1
		other = state.get_contact_collider_object(0)
		on_stay_collision(other)
		
		#var n = state.get_contact_local_normal(0) #calculate the collision normal
	else:
		c = 0
	if c==1 and colliding==false :
		on_enter_collision(other)
		colliding = true
	if c==0 and colliding :
		on_exit_collision(other)
		colliding = false

	
func _integrate_forces(state):
	_process_collision(state)
		
		

#collision code for the kinematic body	
func on_enter_collision(other):
	#print("enter col with ",other )
	pass
	
func on_exit_collision(other):
	#print("exit col",other)	
	pass
func on_stay_collision(other):
	pass


