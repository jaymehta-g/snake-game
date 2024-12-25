class_name Player
extends CharacterBody2D

@export var snake_scn: PackedScene
@export var turn_speed := 90.0
@export var move_speed := 400.0
@export var history_delay := 0.1

const SCREEN_WID := 1024.0

var history: Array[Vector2]
var history_idx := 0
const HISTORY_LEN := 1000

var angle := 0.0 # radians

@onready var history_timer: Timer = $HistoryTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var snake: Node2D = $Snake
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	for i in range(HISTORY_LEN):
		history.append(Vector2.ZERO)
	history_timer.timeout.connect(_record_position)
	history_timer.wait_time = history_delay
	
	SignalBus.fruit.connect(_on_fruit)
	
	for i in range(3):
		var n := snake_scn.instantiate()
		n.steps_behind = i + 1
		snake.add_child(n)

func _process(delta: float) -> void:
	var input := Input.get_axis("ui_left", "ui_right")
	angle += deg_to_rad(turn_speed * input * delta)
	sprite.rotation = angle
	camera.rotation = angle
	position += Vector2.UP.rotated(angle) * move_speed * delta
	position.x = fposmod(position.x, SCREEN_WID)
	position.y = fposmod(position.y, SCREEN_WID)
	for n: SnakePart in snake.get_children():
		var posa = get_history(n.steps_behind - 1)
		var posb = get_history(n.steps_behind)
		# this weird solution to lerp across edges works somehow?
		var posdiff = posa - posb
		if posdiff.x > 500:
			posb.x += SCREEN_WID
		if posdiff.x < -500:
			posa.x += SCREEN_WID
		if posdiff.y > 500:
			posb.y += SCREEN_WID
		if posdiff.y < -500:
			posa.y += SCREEN_WID
		n.position = lerp(posa, posb, history_timer.time_left/history_timer.wait_time)
		n.top_level = true

func get_history(steps_ago: int) -> Vector2:
	return history[posmod(history_idx - steps_ago, HISTORY_LEN)]

func _record_position() -> void:
	history_idx += 1
	history_idx = posmod(history_idx, HISTORY_LEN)
	history[history_idx] = position

func _on_fruit() -> void:
	for i in range(3):
		for n: SnakePart in snake.get_children():
			n.steps_behind += 1
		var n := snake_scn.instantiate()
		n.steps_behind = 1
		snake.add_child(n)
		await get_tree().create_timer(0.3).timeout
