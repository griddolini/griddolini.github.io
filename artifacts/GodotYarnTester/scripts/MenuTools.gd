extends HBoxContainer

func _ready():
	$LoadButton/FileDialog.set_mode(FileDialog.MODE_OPEN_DIR)
	$LoadButton/FileDialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	pass

func _on_Open_pressed():
	$LoadButton/FileDialog.set_current_dir(OS.get_executable_path())
	$LoadButton/FileDialog.visible = true
	$LoadButton/FileDialog.invalidate()

func _on_ReloadFile_pressed():
	Storyteller.reload_current_yarn()
	pass # Replace with function body.
