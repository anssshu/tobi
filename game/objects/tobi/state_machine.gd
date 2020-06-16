extends FiniteStateMachine

# code for state transition from any state

func change_from_any_state():
	if globals.health == 0 and self.state != self.states.die:
		return self.states.die
	return null