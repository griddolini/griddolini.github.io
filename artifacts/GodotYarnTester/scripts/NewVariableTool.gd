extends HBoxContainer

var variable_list_item = load("res://scenes/VariableContainer.tscn")
const VariableListItem = preload("res://scripts/VariableListItem.gd")

func _ready():
	Storykeeper.connect("variable_added", self, "create_var_listing")
	Storykeeper.connect("variable_updated", self, "update_listing_from_storykeeper")
	Storykeeper.connect("variable_removed", self, "remove_listing")
	for key in Storykeeper._data_dictionary:
		create_var_listing(key, str(Storykeeper.get_variable(key)))

func _on_AddVariable_pressed():
	if not Storykeeper.does_key_exist($NewVarName.text):
		create_var_listing($NewVarName.text, $NewVarVal.text)
		clear_inputs()
	else:
		print("Already exists!")

func create_var_listing(var_name:String, value:String):
	var list_item_instance = variable_list_item.instance()
	list_item_instance as VariableListItem
	# Generic var to be cast to proper type and inserted
	var insertion_value
	# Find out which type of listing we are creating
	if value.to_lower() == "true" or value.to_lower() == "false":
		if value.to_lower() == "true":
			insertion_value = false
		else:
			insertion_value = false
		list_item_instance.initialize_bool(var_name, insertion_value)
	elif value.is_valid_integer():
		insertion_value = int(value)
		list_item_instance.initialize_int(var_name, insertion_value)
	else:
		insertion_value = value
		list_item_instance.initialize_string(var_name, insertion_value)
	
	if !Storykeeper.does_key_exist(var_name):
		Storykeeper.set_variable(var_name, insertion_value)
		list_item_instance.queue_free()
	else:
		get_node("../ScrollContainer/VariableListContainer").add_child(list_item_instance)

func update_listing_from_storykeeper(var_name, var_value):
	for child in get_node("../ScrollContainer/VariableListContainer").get_children():
		if child.var_name == var_name:
			child.update_value(var_value)

func remove_listing():
	pass

# If we press enter here, assume they want to add this variable quickly
func _on_NewVarVal_text_entered(new_text):
	_on_AddVariable_pressed()

func clear_inputs():
	$NewVarName.text = ""
	$NewVarVal.text = ""
	$NewVarName.grab_focus()
