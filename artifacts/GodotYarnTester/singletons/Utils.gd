extends Node

func _ready():
	pass

# Returns the TYPEOF enum to inform what the string should be cast to
func get_type_from_string(value:String) -> int:
	if value.to_lower() == "true" or value.to_lower() == "false":
		return TYPE_BOOL
	elif value.is_valid_integer():
		return TYPE_INT
	else:
		return TYPE_STRING
	
