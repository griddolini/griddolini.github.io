extends Tree

export (NodePath) var title_label
var title_label_node

var yarn_file_image = preload("res://images/import_small.png")

func _ready():
	title_label_node = get_node(title_label)
	set_column_expand(0,1)
	set_column_expand(1,0)
	print(OS.get_executable_path())
	dir_contents(ProjectSettings.globalize_path("res://"))
	pass

func dir_contents(path, root = null):
	# If this is the first item, create as root
	if root == null:
		self.clear()
		root = self.create_item()
		root.set_text(0, str(path).substr(str(path).find_last("/"), 20))
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				if file_name != "." and file_name != "..":
					# Create tree item as a directory
					var dir_item = self.create_item(root)
					dir_item.set_text(0, file_name.to_upper())
					dir_item.collapsed = true
					#dir_item.set_custom_bg_color(0, Color.black, false)
					dir_contents(path + "/" + file_name, dir_item)
			else:
				if str(file_name).find("yarn.txt", 0) != -1:
					# Create the yarn file tree item
					var file_item = self.create_item(root)
					file_item.get_property_list()
					file_item.set_text(0, file_name)
					file_item.set_tooltip(0, path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _on_FileDialog_dir_selected(dir):
	dir_contents(dir)

func _on_Tree_item_activated():
	title_label_node.text = get_selected().get_text(0)
	print("Try loading yarn file: " + get_selected().get_tooltip(0))
	Storyteller.end_dialogue()
	Storyteller.spin_yarn(get_selected().get_tooltip(0))
	Storyteller.do_next()
	pass # Replace with function body.
