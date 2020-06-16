extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bird = preload("res://objects/bg_bird/bg_bird.tscn")
var bee = preload("res://objects/bee/bee.tscn")
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect the timerrs
	$bird_timer.connect("timeout",self,"_on_bird_timer_timeout")
	$bee_timer.connect("timeout",self,"_on_bee_timer_timeout")
	
	#start the timer
	$bird_timer.start()
	#$bee_timer.start()
	add_child(bird.instance())
	
func _on_bird_timer_timeout():
	add_child(bird.instance())
	
func spawn_bee():
	var b=bee.instance()
	b.A = rand_range(100,50)
	b.speed = rand_range(5,7)
	b.swing_speed = rand_range(2,5)
	#get player position
	var p = get_tree().root.get_node("ground/player").position
	b.position = Vector2(p.x+800,p.y+rand_range(-400,-100))
	get_node("/root/ground").add_child(b)	
	#get_tree().root.add_child(b)
	#print(get_tree().root.name)
func _on_bee_timer_timeout():
	spawn_bee()

#when player enters the notice board
func _on_start_body_entered(body):
	if body.name == "player":
		spawn_bee()
		$bee_timer.start()
		globals.check_point = body.position
#second check point
func _on_stop_body_entered(body):
	if body.name == "player":
		$bee_timer.stop()
		globals.check_point = body.position
		get_node("/root/ground/CanvasLayer/text_timer").start()