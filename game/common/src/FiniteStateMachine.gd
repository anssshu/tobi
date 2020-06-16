extends Node
class_name FiniteStateMachine

var state = null 
var last_state = null

var states = {}
onready var parent = get_parent()

#-----------------------------------------------------------
func _ready():
	#list of all the player states
	for child in get_children():
		add_state(child.name)
	if states.size()>0:
		call_deferred("set_state",0)
func change_from_any_state():
	return null	

func _state_logic(delta):
	get_child(state).run()
	
func _get_transition(delta):
	var n = change_from_any_state()
	if n == null:
		return get_child(state).change()
	else:
		return n
	
func _enter_state(new_state,old_state):
	get_child(new_state).enter()
	
func _exit_state(old_state,new_state):
	get_child(old_state).exit()

#------------------------------------------------------------------------------
func process(delta):
	if state != null :
		_state_logic(delta)
		var transition = _get_transition(delta)
		
		if transition != null:
			#print(transition)
			set_state(transition)

func add_state(state_name):
	states[state_name] = states.size()
	
func set_state(new_state):
	last_state = state
	state = new_state
	if last_state != null :
		_exit_state(last_state,new_state)
	if state != null:
		_enter_state(new_state,last_state)
		