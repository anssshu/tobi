extends KinematicBody2D
#only calculate motion of the kinematic character
var v = Vector2()
var g = Vector2(0,1200)
var walkspeed = 800
var jumpspeed = 600
var accn = 2000
var n = Vector2(0,-1)
var t = Vector2()
var vt = Vector2()
var vn = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(dt):
	
	#print(v)
	v += g*dt
	var is_on_air = not (is_on_floor() or is_on_ceiling() or is_on_wall())
	var is_on_floor = is_on_floor()
	
	
	
	var left = Input.is_action_pressed("ui_left")
	var right =  Input.is_action_pressed("ui_right")
	var jump =  Input.is_action_just_pressed("ui_up")
	
	
	t = n.rotated(PI/2)
	vt = v.dot(t)*t #tangential velocity
	vn = v.dot(n)*n #normal velocity
	
	#move left
	if left and not right  and vt.length()<walkspeed:#move left
		vt += -accn*t*dt
		v = vt+vn
	
	#move right
	if  right and not left and vt.length()<walkspeed:#move right
		vt += accn*t*dt
		v = vt+vn	

	#when stop
	if not (is_on_air or left or right) :
		#make the tangential velocity 0
		#vt = Vector2()
		#v  = vt+vn
		v = Vector2(0,0)
	#jumpl logic
	if is_on_floor() and jump :
		print("jump")
		v.y = -jumpspeed
		
	
	var c = move_and_collide(v*dt)
	if c:
		n = c.normal
		#print(c.collider.name)
		
	##print(is_on_air)
	#v = vt+vn
			
	v = move_and_slide(v,n)

	print(v)
	
	