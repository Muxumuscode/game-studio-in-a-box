extends Node2D
# PURPOSE: Placeholder scene that proves the tools work. Delete it once a real scene exists.
# EMITS: none
# DEPENDS ON: none


func _ready() -> void:
	var label := Label.new()
	label.text = "Hello. tools/check and tools/playtest work."
	label.position = Vector2(24, 24)
	add_child(label)
