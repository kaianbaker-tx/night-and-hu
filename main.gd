extends Node2D

# This runs one time when the game starts.
func _ready() -> void:
	print("Hello! The game is running.")


# This runs about 60 times every second.
func _process(_delta: float) -> void:
	pass
