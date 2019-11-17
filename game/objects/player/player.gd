#-------------------------------------------code for rigid body character-----------------------------------------------------------
extends RigidBody2D

#------------------------------------------declare the class variables--------------------
export var accn = 100
var jump_speed = 1200
var top_speed = 800
var on_ground = false
var not_dusting = true
var stone = preload("res://objects/stone/stone.tscn")
var face = "right"
var state_machine = {
	idle = "idle",
	jump = "jump" ,
	run = "run",
	throw = "throw"
}
var current_state = self.state_machine.idle
var previous_state =  self.state_machine.jump
var timer 
var move = {
	left = Vector2(-1,0),
	right = Vector2(1,0),
	up = Vector2(0,-1),
	down = Vector2(0,1)
}
var final_velocity = Vector2(0,0)
var n = Vector2(0,-1) #initialise the collision normal

#for movement on curve and plane surface


#-------------------------------------------initialize object----------------------
func _ready():
	
	timer = $Timer
	# on_begin_contact
	self.connect("body_entered",self,"on_begin_contact")
#-------------------------------------------------------------------

#-----------------------------------------update object logic on each frame-------------------------------------	
func _integrate_forces(state):
	#print(abs(state.linear_velocity.x))
	# 1 calculate  the collision normal 
	self.calculate_collision_normal(state)
	
	
	# 2  set the ray cast direction		
	$RayCast2D.set("cast_to",-100*self.n)      
	
		
	# 3 determine if the object is on the ground or not
	self.determine_object_on_ground()
	
	
	# 4 calculate player states
	self.calculate_state_transition(state)
	
	# 5 calculate final player movements
	self.calculate_player_movements(state)
	
	# 6 update state logic
	self.update_state_logic()
#---------------------------------------------helper methods -----------------------------------------------------------------------------		
 # calculate  the collision normal 	
func calculate_collision_normal(state):
	if state.get_contact_count()>0 :
		if state.get_contact_collider_object(0).get_class() == "StaticBody2D" :
			self.n = state.get_contact_local_normal(0) #calculate the collision normal
	else:
		self.n = Vector2(0,-1)

#-------------------------------------------------------------------------------------------------------------------------------------
# check whether the object is on the ground or not
func determine_object_on_ground():
	if $RayCast2D.is_colliding():
		self.on_ground = true
		
	else :
		self.on_ground = false

#------------------------------------------------------------------------------------------------------
#calculate state transition
func calculate_state_transition(state):
	var c = current_state
	#throw stone logic
	if Input.is_action_just_pressed("ui_accept"):
		timer.start()
		get_tree().root.add_child(stone.instance())
	if Input.is_action_just_released("ui_accept"):
		timer.stop()
		
		
	#logic for state transition
	if Input.is_action_pressed("ui_left"):
		self.face = "left"
		$sprite.flip_h = true
		$scarf/sprite.flip_h = true
		$scarf.rotation = 0
		$scarf/AnimationPlayer.play("wave")
		$scarf/sprite.position.x = $sprite.position.x + 120
	
	if Input.is_action_pressed("ui_right"):
		self.face = "right"
		$sprite.flip_h = false
		$scarf/sprite.flip_h = false
		$scarf/AnimationPlayer.play("wave")
		$scarf.rotation = 0
		$scarf/sprite.position.x = $sprite.position.x 
	
	if self.on_ground == true   and abs(state.linear_velocity.x) > 0.0:
		self.current_state = self.state_machine.run 
		
	if self.on_ground == false :
		self.current_state = self.state_machine.jump	
		
	if abs(state.linear_velocity.x) < 10 and self.on_ground == true :
		self.current_state = self.state_machine.idle
	if Input.is_action_pressed("ui_accept"):
		self.current_state = self.state_machine.throw	
	#if the current state has changed from the stored value update previous state
	if c!=current_state:
		previous_state = c
		
	#play the dust
	if previous_state == "jump" and self.on_ground and not_dusting :
		not_dusting = false
		$effects/AnimationPlayer.play("dust")
	
#------------------------------------------------------------------------------------------------------------
#calculate player movements
func calculate_player_movements(state):
	var v= state.linear_velocity  # save the linear velocity
	var t = n.rotated(PI/2)
	
	
	if Input.is_action_pressed("ui_left") and abs(t.dot(v))<top_speed :
		final_velocity  =  self.n.rotated(-PI/2)*accn
		state.linear_velocity = state.linear_velocity+final_velocity
		
	if Input.is_action_pressed("ui_right") and abs(t.dot(v))<top_speed :
		final_velocity = self.n.rotated(PI/2)*accn
		state.linear_velocity = state.linear_velocity+final_velocity
		
	if Input.is_action_pressed("ui_down"):
		#self.set_deferred("mode",0)
		pass
		
	if Input.is_action_just_pressed("ui_up") and on_ground:
		final_velocity = move.up*jump_speed
		state.linear_velocity = state.linear_velocity+final_velocity
		
	if Input.is_action_just_pressed("ui_jump")  and on_ground:
		final_velocity = move.up*jump_speed*1.5
		state.linear_velocity = state.linear_velocity+final_velocity

#-----------------------------------------------------------------------------------------------------------------------
#update animation
func update_state_logic():
	
	
	if self.current_state == "idle":
		$AnimationPlayer.play("idle")
	
	if self.current_state == "jump":
		$AnimationPlayer.play("jump")
		not_dusting = true
		
	if self.current_state == "run":
		$AnimationPlayer.play("run")
	if self.current_state == "throw":
		if linear_velocity.length() > 20:
			$AnimationPlayer.play("throw_running")
		else:
			$AnimationPlayer.play("throw")
	
#------------------------------------------------------------------------------------------------------------
#collision code for the player 
func on_begin_contact(obj):
	# if player collides with the chicken
	print("i hit ",obj.name)
	if obj.get("prop") == "chicken":
		obj.set_deferred("mode",0)


#--------------------------------------------------------------------------------------------------------------


#throw timer 
func _on_Timer_timeout():
	print("throw timer is on")
	get_tree().root.add_child(stone.instance())
