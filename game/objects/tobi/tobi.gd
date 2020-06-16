extends KinematicBody2D

#stop on slopes
const STOP_SPEED = 64

#velocity
var v = Vector2()
#gavitational constant
var g = Vector2(0,1200)

#various motion 
const jump_height = 200
const jump_time = .4


const run_speed = 500
var jump_speed = -500
const accn = 1000
const air_speed = 500
var dir

#player input controls
var left
var right
var up
var down
var attack
var jump

#player facing direction
var face = "right"

#player places
var on_ground
var on_wall

#get the state_machine node
onready var fsm = $state_machine
var jump_timer = 0

onready var implode = preload("res://objects/implode/implode.tscn")
onready var stone = preload("res://objects/stone/stone.tscn")
onready var throw_timer = $Timer
onready var anim = $AnimationPlayer
func _ready():
	#add exceptions for raycast2Ds
	add_exceptions()
	#position = globals.check_point
	#set gravity as per jump time and height
	g.y = 2*jump_height/pow(jump_time,2)
	jump_speed = g.y*jump_time
	
	#connect the throw timer
	throw_timer.connect("timeout",self,"throw_stone")
	
	#set position
	#position = globals.check_point
func _physics_process(delta):
	#globals.check_point = position
	if self.v.x < 0 :
		self.face = "left"
	elif self.v.x > 0:
		self.face = "right"
	else:
		pass
	
	var sx = abs($sprite.scale.x)
	if face == "left":
		$sprite.scale.x = -sx
	if face == "right":
		$sprite.scale.x = sx
	#start the jump timer
	jump_timer+=delta
	if jump_timer > 5:
		jump_timer = 0
	#determine player on ground or not
	on_ground = check_player_on_ground()

	#determine player on wall or not
	on_wall = check_player_on_left_wall() or check_player_on_right_wall()
	
	#process the inputs
	process_input()
	
	#apply gravity
	apply_gravity(delta)
	
	#run the state_machine
	fsm.process(delta)
	
	#display player state
	display_state()
	
	#apply the velocity and move the kinematic player
	apply_velocity(delta)
#---------------------functions applied in every  state ---------------------------------------------------	
func apply_gravity(dt):
	v += g*dt	
	on_ground = is_on_floor()
#---------------------------------------------------------------------------------------------------------	
func apply_velocity(dt):
	#player moves only when not dead
	if fsm.state != fsm.states.die:
		v = move_and_slide(v,Vector2.UP,STOP_SPEED)
#----------------------------------------------------------------------------------------------------------
func process_input():
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	attack = Input.is_action_pressed("ui_accept")
	jump = Input.is_action_just_pressed("ui_up")
	
#-------------------------------------------helper functions-------------------------------------------------------	
#animation played after player death
func play_end_animation():
	var anim = get_node("/root/scene/ui/scene_transition/end/AnimationPlayer")
	anim.seek(0)
	anim.play("become_dark")
#function called after player dies
func die():
	if globals.life > 0:
		globals.life -= 1
	var s = implode.instance()
	s.position = self.position
	#s.scale = Vector2(0.5,0.5)
	#s.modulate = Color(1,0,0,1)
	get_tree().root.add_child(s)
	hide()
	#stop throw timer
	#make the screen dark after player dies
	if globals.life != 0:
		play_end_animation()
# throw stones when activated	
func throw_stone():
	var s = stone.instance()
	s.position = self.position+Vector2(-20,-100)
	#s.get_node("sprite").modulate = Color(0,0,0,1)
	if self.face == "left":
		s.v.x=-1*s.v.x
		s.v += Vector2(self.v.x,0)
	elif self.face == "right":
		s.v += Vector2(self.v.x,0)
	get_tree().root.add_child(s)
#add exceptions for raycast2Ds
func add_exceptions():
	#ground rays exceptions
	for ray in $ground_rays.get_children():
		ray.add_exception(self)
	#left_wall rays exception
	for ray in $left_rays.get_children():
		ray.add_exception(self)
	#right wall rays exception
	for ray in $right_rays.get_children():
		ray.add_exception(self)		
#check player on ground
func check_player_on_ground():
	var rays = $ground_rays
	for ray in rays.get_children():
		if ray.is_colliding():
			return true
	return false
	
func check_player_on_left_wall():
	var rays = $left_rays
	for ray in rays.get_children():
		if ray.is_colliding():
			return true	
	return false
	
func check_player_on_right_wall():
	var rays = $right_rays
	for ray in rays.get_children():
		if ray.is_colliding():
			return true	
	return false
	
#check player on wall
func display_state():
	var ss = fsm.states.keys()
	if fsm.state != null:
		var text = ss[fsm.state]
		$Label.text = text