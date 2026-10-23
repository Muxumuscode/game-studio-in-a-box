extends SceneTree
# PURPOSE: Parse-check every .gd script in the project in ONE Godot run, with the project's
#          autoloads (your autoloads) registered — unlike `--check-only --script <file>`,
#          which compiles each file alone and wrongly reports "Identifier not found: EventBus".
#          Called by tools/check.sh and tools/check.ps1. Exit code 0 = all scripts compile.
# EMITS: none
# DEPENDS ON: none

const SKIP_DIRS: PackedStringArray = [".godot", "addons", ".claude"]


func _initialize() -> void:
	var paths: PackedStringArray = []
	_collect("res://", paths)
	var failed: PackedStringArray = []
	var self_path: String = get_script().resource_path
	for path in paths:
		if path == self_path:
			continue  # already compiled (it's running); reloading the running script crashes Godot
		var script: Script = load(path)
		if script == null or not script.can_instantiate():
			failed.append(path)
	for path in failed:
		print("PARSE FAILED: ", path)
	print("Parsed %d scripts, %d failed." % [paths.size(), failed.size()])
	quit(1 if failed.size() > 0 else 0)


func _collect(dir_path: String, out: PackedStringArray) -> void:
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return
	for sub in dir.get_directories():
		if sub not in SKIP_DIRS:
			_collect(dir_path.path_join(sub), out)
	for file in dir.get_files():
		if file.ends_with(".gd"):
			out.append(dir_path.path_join(file))
