extends CharacterBody2D

class_name Player

@onready var sprite: Sprite2D = $Sprite2D
@onready var light: Sprite2D = $Light
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var speed := 100.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
const JUMP_VELOCITY := -275.0
const ACCEL := 600.0
const FRICTION := 800.0
signal direction_changed(right: bool)

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
		velocity.x = move_toward(velocity.x, direction * speed, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	update_animation()
	var is_in_floor = is_on_floor()
	move_and_slide()
	if is_in_floor and !is_on_floor() and velocity.y >= 0.0:
		coyote_timer.start()

func update_animation() -> void:
	if velocity.length() != 0.0:
		animation_player.play("Walk")
		sprite.flip_h = velocity.x < 0.0
	elif velocity.length() == 0.0:
		animation_player.play("Idle")
	if !is_on_floor():
		animation_player.play("Jump")
	direction_changed.emit(!sprite.flip_h)

