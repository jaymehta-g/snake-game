extends Node2D

@export var fail_scn: PackedScene
@export var game_scn: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.gameover.connect(_on_fail)

func clear_children():
	for n in get_children():
		n.queue_free()

func _on_fail() -> void:
	clear_children()
	add_child(fail_scn.instantiate())
