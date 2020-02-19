extends HBoxContainer

var var_name

var int_value
var bool_value
var string_value

func initialize_bool(name:String, val:bool):
	var_name = name
	$VariableName.text = var_name
	if val == true:
		_on_BoolValue_pressed(false)
	$BoolValue.visible = true
	bool_value = val

func initialize_string(name:String, val:String):
	var_name = name
	$VariableName.text = var_name
	$VariableName.text = name
	$StringValue.visible = true
	$StringValue.text = val
	string_value = val

func initialize_int(name:String, val:int):
	var_name = name
	$VariableName.text = var_name
	$IntValue.visible = true
	$IntValue.value = val
	int_value = val

# Just a visual to show you need to hit enter to save value
func _on_VariableValue_text_changed(new_text):
	$StringValue.modulate = Color.orange
	
# Called after pressing enter to update a string value
func _on_VariableValue_text_entered(new_text):
	$StringValue.modulate = Color.cyan
	string_value = $StringValue.text
	Storykeeper.set_variable(var_name, string_value)

# Controller used for integer variables
func _on_SpinBox_value_changed(value, fromUi=false):
	int_value = value
	if fromUi:
		Storykeeper.set_variable(var_name, int_value)

# Controller used if this is a bool item
func _on_BoolValue_pressed(setval=true):
	if bool_value == true:
		$BoolValue/TrueLabel.visible = false
		$BoolValue/FalseLabel.visible = true
		bool_value = false
	else:
		$BoolValue/TrueLabel.visible = true
		$BoolValue/FalseLabel.visible = false
		bool_value = true
	# Either way, update the storyteller
	if setval:
		Storykeeper.set_variable(var_name, bool_value)

func update_value(newval):
	print("Attempted UI update of " + var_name + " to value " + str(newval))
	print(typeof(newval))
	if typeof(newval) == TYPE_INT:
		int_value = newval
		$IntValue.value = newval
	elif typeof(newval) == TYPE_BOOL:
		if bool_value != newval:
			_on_BoolValue_pressed(false)
	else:
		$StringValue.modulate = Color.cyan
		string_value = newval

func _on_QuickVariableKill_pressed():
	Storykeeper.remove_variable(var_name)
	queue_free()
