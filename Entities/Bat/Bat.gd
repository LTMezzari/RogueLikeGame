class_name Bat extends KinematicBody2D

enum BatState {
	IDLE,
	WANDER,
	CHASE,
	DEAD,
}

export(float) var invincibility: float = .3 setget _set_invincibility
export(int) var damage: int = 1 setget _set_damage

export(float) var accelation: float = 300
export(float) var max_speed: float = 50
export(float) var friction: float = 200
export(float) var knockback_force: float = 100
export(float) var knockback_friction: float = 200
export(float) var soft_collision_space: float = 400
export(float) var wander_max_timer: float = 3
export(float) var wander_min_timer: float = 1

onready var _flying_bat: AnimatedSprite = $Flying
onready var _wander_controller: WanderController = $WanderController
onready var _player_detection: PlayerDetectionZone = $PlayerDetectionZone
onready var _hurtbox: Hurtbox = $Hurtbox
onready var _hitbox: Hitbox = $Hitbox

var _knockback: Vector2 = Vector2.ZERO
var _velocity: Vector2 = Vector2.ZERO
var _state = BatState.WANDER

func _ready() -> void:
	_wander_controller.wander_time = wander_max_timer
	_update_invinsibility()
	_update_damage()
	pass

func _physics_process(delta: float) -> void:
	if (_knockback != Vector2.ZERO):
		_handle_knockback(delta)
		return
	
	match _state:
		BatState.IDLE:
			_handle_idle_state(delta)
		BatState.WANDER:
			_handle_wander_state(delta)
		BatState.CHASE:
			_handle_chase_state(delta)
	pass

func _set_invincibility(value: float) -> void:
	var new_value := max(0, value)
	invincibility = new_value
	_update_invinsibility()
	pass

func _set_damage(value: int) -> void:
	var new_value := int(max(0, value))
	damage = new_value
	_update_invinsibility()
	pass

func _handle_idle_state(delta: float) -> void:
	_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	_move(delta)
	pass

func _handle_wander_state(delta: float) -> void:
	var target := _wander_controller.target_position
	_move_towards_target(delta, target)
	
	if (global_position.distance_to(target) <= .9):
		_reset_state()
		return
	pass

func _handle_chase_state(delta: float) -> void:
	var target := _player_detection.player
	_move_towards_target(delta, target.global_position)
	pass

func _handle_knockback(delta: float) -> void:
	_knockback = _knockback.move_toward(Vector2.ZERO, delta * knockback_friction)
	_knockback = move_and_slide(_knockback)
	pass

func _move_towards_target(delta: float, target: Vector2) -> void:
	if (target == null):
		_state = BatState.IDLE
		return
	
	var direction := global_position.direction_to(target)
	_velocity = _velocity.move_toward(direction * max_speed, accelation * delta)
	_move(delta)
	pass

func _move(_delta: float) -> void:
	_velocity = move_and_slide(_velocity)
	_flying_bat.flip_h = _velocity.x < 0
	pass

func _update_invinsibility() -> void:
	if (_hurtbox == null):
		return
	_hurtbox.invincibility_time = invincibility
	pass

func _update_damage() -> void:
	if (_hitbox == null):
		return
	_hitbox.damage = damage
	pass

func _pick_random_state(state_list: Array = [BatState.IDLE, BatState.WANDER]) -> Object:
	state_list.shuffle()
	return state_list.pop_front()
	pass

func _reset_state() -> void:
	if (_state == BatState.DEAD || _wander_controller == null):
		return
	_state = _pick_random_state()
	_wander_controller.wander_time = rand_range(wander_min_timer, wander_max_timer)
	pass

func _kill_self() -> void:
	queue_free()
	pass

func _on_target_changed(_old_target: Vector2, _new_target: Vector2) -> void:
	if (_state == BatState.CHASE):
		return
	_reset_state()
	pass

func _on_player_found() -> void:
	_state = BatState.CHASE
	pass
