class_name Player extends KinematicBody2D

enum PlayerState {
	MOVING,
	ROLLING,
	ATTACKING
}

export(float) var roll_speed: float = 125
export(float) var acceleration: float = 500
export(float) var friction: float = 500
export(float) var max_speed: float = 80

onready var _animation_tree: AnimationTree = $AnimationTree
onready var _attack_pivot: Node2D = $AttackPivot
onready var _animation_state = _animation_tree["parameters/playback"]

var _velocity: Vector2 = Vector2.ZERO
var _roll_vector: Vector2 = Vector2.ZERO
var _knockback_vector := Vector2.ZERO
var _state = PlayerState.MOVING

var _attack_radius: float

func _ready() -> void:
	_animation_tree.active = true
	_attack_radius = _attack_pivot.position.y
	pass
	
func _process(delta: float) -> void:
	_check_inputs(delta)
	pass
	
func _physics_process(delta: float) -> void:
	match _state:
		PlayerState.MOVING:
			_handle_move_state(delta)
		PlayerState.ROLLING:
			_handle_roll_state(delta)
		PlayerState.ATTACKING:
			_handle_attack_state(delta)
	pass

func _check_inputs(_delta: float) -> void:
	if (Input.is_action_just_pressed("attack")):
		var vector := _get_mouse_vector()
		_knockback_vector = vector
		_animation_tree["parameters/Attack/blend_position"] = vector
		_state = PlayerState.ATTACKING
	
	if (Input.is_action_just_pressed("roll")):
		_state = PlayerState.ROLLING
	pass

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouse):
		var vector := _get_mouse_vector()
		
		return
	pass

func _handle_move_state(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	
	if (direction == Vector2.ZERO):
		_animation_state.travel("Idle")
		_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		_animation_state.travel("Run")
		_roll_vector = direction
		_velocity = _velocity.move_toward(max_speed * direction, acceleration * delta)
	
	_update_moving_blend(direction)
	_move_player()
	pass

func _handle_roll_state(_delta: float) -> void:
	_animation_state.travel("Roll")
	_velocity = roll_speed * _roll_vector
	_move_player()
	pass

func _handle_attack_state(_delta: float) -> void:
	_animation_state.travel("Attack")
	pass

func _update_moving_blend(direction: Vector2) -> void:
	if (direction == Vector2.ZERO):
		return
	_animation_tree["parameters/Idle/blend_position"] = direction
	_animation_tree["parameters/Roll/blend_position"] = direction
	_animation_tree["parameters/Run/blend_position"] = direction
	pass

func _move_player() -> void:
	_velocity = move_and_slide(_velocity)
	pass

func _get_mouse_vector() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())

func _kill_self() -> void:
	pass

func _reset_state() -> void:
	if (_state == PlayerState.ROLLING):
		_velocity = Vector2.ZERO
	_state = PlayerState.MOVING
	pass
