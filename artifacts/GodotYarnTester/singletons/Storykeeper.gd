extends Node

"""
The Storykeeper records all the variables used in your yarn files.
Anything checked or set in yarn will use the data_dictionary member.
Anything seeking to modify this data must use accessor methods.
"""

# Signal changes in the Storykeeper
signal variable_added
signal variable_updated
signal variable_removed

# The data dictionary is where yarn looks for and saves all variables
# The exception to this are special variables such as "visited"
var _data_dictionary = {
	}

func _ready():
	pass

func does_key_exist(key:String) -> bool:
	if _data_dictionary.has(key):
		return true
	else:
		return false

func get_variable(entry_name:String):
	return _data_dictionary[entry_name]

func set_variable(entry_name:String, entry_value):
	if !does_key_exist(entry_name):
		_data_dictionary[entry_name] = entry_value
		emit_signal("variable_added", str(entry_name), str(entry_value))
	else:
		_data_dictionary[entry_name] = entry_value
		emit_signal("variable_updated", str(entry_name), entry_value)

func remove_variable(entry_name:String):
	if does_key_exist(entry_name):
		_data_dictionary.erase(entry_name)
		emit_signal("variable_removed", entry_name)
