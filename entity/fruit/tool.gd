extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(-1024, 1025, 1024):
		for j in range(-1024, 1025, 1024):
			var n: Node2D = preload("res://entity/fruit/individual.tscn") \
				.instantiate()
			n.position = Vector2(i,j)
			add_child(n)
			n.owner = self
	var scn := PackedScene.new()
	scn.pack(self)
	ResourceSaver.save(scn, "res://entity/fruit/fruit2.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
