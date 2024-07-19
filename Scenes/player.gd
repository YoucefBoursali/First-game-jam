extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 100.0
const JUMP_VELOCITY := -250.0
const ACCEL := 600.0
const FRICTION := 1000.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY	
	if !is_on_floor():
		if Input.is_action_just_released("jump"):
			velocity.y *= 0.4
	var direction := Input.get_axis("left", "right")
	if direction:
		animation_player.play("Walk")
		velocity.x = move_toward(velocity.x, direction * speed, ACCEL * delta)
	else:
		animation_player.play("Idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	var is_in_floor = is_on_floor()
	move_and_slide()
	if is_in_floor and !is_on_floor() and velocity.y >= 0.0:
		coyote_timer.start()
