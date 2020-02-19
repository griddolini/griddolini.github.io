extends "res://singletons/GodotYarnImporter.gd"

"""
The Storyteller controls the flow of a yarn file and allows interacting with it.
Storyteller controls all conditional actions and variable modifications on its own.

To use Storyteller, you only need to do 3 things.

1) Subscribe to the signals:
	dialogue_spoken ( speaker string , text string)
	choices_presented ( array of options )
	custom_command_fired ( instruction , arguments )
	(optional) dialogue_started, dialogue_ended, parse_error signals

2) Present a Yarn File
	Call spin_yarn(filename, starting_node_name) to begin

3) Call do_next() when ready to fire the next signal
	call do_next(response_marker) to respond to the choices given
"""

var action_queue = []
var options_stack = []
var has_signaled_end = true

# Used to detect how many "if" statements deep we are
# 0 means function as normal
# 1 or more means no more action_queue until we get to the correct endif
var failed_if_depth = 0

# This is a list of ints marking at which depth are we in an "else" statement
# Once we reach the matching endif, the else toggle is also removed
var else_was_set = 0

# Generally required signals for regular use
signal dialogue_started
signal dialogue_spoken
signal choices_presented
signal custom_command_fired
signal dialogue_ended

# Debug signals for testing
signal parse_error
signal if_statement_pass
signal if_statement_fail
signal set_variable #TODO

func _ready():
	pass
	
# Call this function to fire the next signal in the yarn file. Can also supply a response to options given
func do_next(response = ""):
	if response != "":
		self.yarn_unravel(response)
		do_next()
	elif !action_queue.empty():
		if has_signaled_end:
			has_signaled_end = false
			emit_signal("dialogue_started")
		var next_action = action_queue.pop_back()
		print("Actions: " + next_action["action"] + " " + str(action_queue.size()))
		match (next_action["action"]):
			"dialogue_spoken":
				emit_signal("dialogue_spoken", next_action["speaker"], next_action["text"])
			"choices_presented":
				emit_signal("choices_presented", next_action["options_stack"])
			"custom_command_fired":
				emit_signal("custom_command_fired", next_action["command"], next_action["arguments"])
	else:
		# The dialogue has ended
		if !has_signaled_end:
			emit_signal("dialogue_ended")
			has_signaled_end = true

# OVERRIDE METHODS
# Parsed a standard line, add it to the action queue
func say(speaker, text):
	if failed_if_depth == 0:
		if text == "":
			return
		var new_queue_entry = {}
		new_queue_entry["action"] = "dialogue_spoken"
		new_queue_entry["speaker"] = speaker.strip_edges()
		new_queue_entry["text"] = text.strip_edges()
		action_queue.push_front(new_queue_entry)

# Parsed a choice, add it to the options list
func choice(text, marker):
	if failed_if_depth == 0:
		# If there is no choice text, this is an automatic goto marker
		if text == "NaN":
			options_stack.clear()
			self.yarn_unravel(marker)
		else:
			var option_entry = {}
			option_entry["text"] = text.strip_edges()
			option_entry["marker"] = marker.strip_edges()
			options_stack.append(option_entry)

# End of choices / file, add them to the action queue
func commit_choices():
	if !options_stack.empty():
		var new_queue_entry = {}
		new_queue_entry["action"] = "choices_presented"
		new_queue_entry["options_stack"] = options_stack.duplicate()
		action_queue.push_front(new_queue_entry)
		options_stack.clear()

# Parsed a command, handle any custom logic
func logic(instruction):
	# PARSE THE COMMAND
	var cmd_parts = instruction.strip_edges().split(" ")
	match cmd_parts[0]:
		"if":
			if cmd_parts.size() < 3:
				send_parse_error("IF STATEMENT INCORRECT")
				return
			# We only need to compute this if we aren't within a failed if already
			if failed_if_depth == 0:
				var final_decision
				var if_subject_name = cmd_parts[1]
				var if_subject = cmd_parts[1]
				var if_value = cmd_parts[cmd_parts.size() - 1]
				var if_operator = cmd_parts[2]
				var negate
				# First check if this value has ever been set
				if !Storykeeper.does_key_exist(if_subject):
					# If the value hasn't been set, create it at the default value
					var newtype = Utils.get_type_from_string(if_value)
					match newtype:
						TYPE_BOOL:
							Storykeeper.set_variable(if_subject, false)
							if_subject = false
						TYPE_INT:
							Storykeeper.set_variable(if_subject, 0)
							if_subject = 0
						TYPE_STRING:
							Storykeeper.set_variable(if_subject, "")
							if_subject = ""
				else: # Otherwise the if_subject is now the real value to compare
					if_subject = Storykeeper.get_variable(if_subject)
				
				# Check if there is a "not" statement, if so set a negate flag
				if cmd_parts[cmd_parts.size() - 2] == "not":
					negate = true
				else:
					negate = false
				
				# Bool or String conditional
				if if_operator == "is":
					# Check if we do a boolean test
					if if_value.to_lower() == "true":
						if_value = true
					elif if_value.to_lower() == "false":
						if_value = false
					final_decision = true if if_subject == if_value else false
				# Integer conditional
				else: 
					match(if_operator):
						"=":
							final_decision = true if int(if_subject) == int(if_value) else false
						"<":
							final_decision = true if int(if_subject) < int(if_value) else false
						">":
							final_decision = true if int(if_subject) > int(if_value) else false
						"<=":
							final_decision = true if int(if_subject) <= int(if_value) else false
						">=":
							final_decision = true if int(if_subject) >= int(if_value) else false
						"!=":
							final_decision = true if int(if_subject) != int(if_value) else false
				if negate:
					final_decision = !final_decision
				if final_decision == true:
					emit_signal("if_statement_pass", if_subject_name, if_subject, if_operator, str(if_value))
					conditional_passed()
				if final_decision == false:
					emit_signal("if_statement_fail", if_subject_name, if_subject, if_operator, str(if_value))
					conditional_failed()
			else:
				# Since we are inside a failed if statement, fail by default
				conditional_failed()
		"set":
			if failed_if_depth == 0:
				var set_subject = cmd_parts[1]
				var set_value = cmd_parts[2]
				var do_addition = false
				var do_subtraction = false
				
				# Before checking/changing the variable type, check for + or -
				if set_value.find("+") != -1:
					do_addition = true
					set_value.erase(set_value.find("+"), 1)
				elif set_value.find("-") != -1:
					do_subtraction = true
					set_value.erase(set_value.find("-"), 1)
				
				var get_type = Utils.get_type_from_string(set_value)
				match get_type:
					TYPE_BOOL: # BOOL
						if set_value.to_lower() == "true":
							set_value = true
						else:
							set_value = false
					TYPE_INT: # INT
						set_value = int(set_value)
					TYPE_STRING: # STRING / OTHER
						set_value = str(set_value)
				
				# Handle relative variable
				if (do_addition or do_subtraction):
					# Initialize to 0 in case the key doesn't exist
					var current_val = 0
					if Storykeeper.does_key_exist(set_subject):
						current_val = Storykeeper.get_variable(set_subject)
					if do_addition:
						Storykeeper.set_variable(set_subject, current_val + set_value)
					else:
						Storykeeper.set_variable(set_subject, current_val - set_value)
				# Otherwise just set it
				else:
					Storykeeper.set_variable(set_subject, set_value)
		"else":
			if failed_if_depth == 0:
				conditional_failed()
			else:
				if else_was_set > 0:
					else_was_set -= 1
				if failed_if_depth > 0:
					failed_if_depth -= 1
				else_was_set += 1
		"endif":
			conditional_passed()
		_:
			if failed_if_depth == 0:
				var new_queue_entry = {}
				new_queue_entry["action"] = "custom_command_fired"
				new_queue_entry["command"] = cmd_parts[0]
				# All other parts of a custom command are optional arguments
				print(cmd_parts)
				cmd_parts.remove(0)
				new_queue_entry["arguments"] = cmd_parts
				action_queue.push_front(new_queue_entry)

func conditional_passed():
	if else_was_set > 0:
		else_was_set -= 1
	elif failed_if_depth > 0:
		failed_if_depth -= 1

func conditional_failed():
	failed_if_depth += 1

# called for each node name
func yarn_custom_logic(to):
	pass

# called for each node name (after)
func yarn_custom_logic_after(to):
	commit_choices()

func yarn_text_variables(text):
	return text

func send_parse_error(text):
	emit_signal("parse_error", text)

func reload_current_yarn():
	if(current_yarn_file != ""):
		end_dialogue()
		spin_yarn(current_yarn_file)
		do_next()

func end_dialogue():
	action_queue.clear()
	emit_signal("dialogue_ended")
	has_signaled_end = true
