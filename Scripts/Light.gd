extends Sprite2D
@export var facing_right: Vector2
@export var facing_left: Vector2
@onready var player: Player = get_owner()

func _ready() -> void:
	player.direction_changed.connect(_on_changed)


func _on_changed(right: bool) -> void:
	if right:
		position = facing_right
	else:
		position = facing_left
