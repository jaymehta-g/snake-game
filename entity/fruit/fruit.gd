extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_collect)

func _collect(n: Player) -> void:
	SignalBus.fruit.emit()
	position = \
		Vector2(randf(), randf()) * Player.SCREEN_WID
