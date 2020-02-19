extends HBoxContainer

""" 
This conversation box serves as an example of how to interact with the Storyteller.
"""

onready var dialogue_label = $ConvoContainer/ConvoPanel/ConvoText
export (PackedScene) var option_button

# Cached node references
onready var n_option_container : GridContainer = $OptionsBG/MarginContainer/OptionContainer
onready var n_conversation_textbox : RichTextLabel = $ConvoContainer/ConvoPanel/ConvoText
onready var n_animator : AnimationPlayer = $DialogueControlsAnimator
onready var n_command_popup : AcceptDialog = $ConvoContainer/ConvoPanel/CustomCommandPopup

var waiting_for_choice_submit = false

func _process(delta):
	if Input.is_action_just_pressed("progress_conversation") and !Storyteller.has_signaled_end:
		if !waiting_for_choice_submit:
			n_animator.play("Static")
			Storyteller.do_next()

func _ready():
	Storyteller.connect("dialogue_spoken", self, "write_line")
	Storyteller.connect("choices_presented", self, "write_choices")
	Storyteller.connect("custom_command_fired", self, "do_command")
	Storyteller.connect("dialogue_ended", self, "end_convo")

func write_line(speaker, text):
	n_conversation_textbox.bbcode_text = ""
	n_animator.play("BlinkingIndicator")
	if speaker != "":
		n_conversation_textbox.bbcode_text = "[b]" + speaker + "[/b]\n"
	n_conversation_textbox.bbcode_text += text
	pass

func write_choices(option_stack):
	print(option_stack)
	waiting_for_choice_submit = true
	n_animator.play("ChooseAnswer")
	for child in n_option_container.get_children():
		child.queue_free()
	for option in option_stack:
		var instanced_button : Button = option_button.instance()
		instanced_button.text = option["text"]
		n_option_container.add_child(instanced_button)
		instanced_button.connect("pressed", self, "_chose_option", [option["marker"]])

func do_command(instruction):
	n_command_popup.dialog_text = "Fired a custom command: " + instruction
	n_command_popup.visible = true
	pass 
	
func end_convo():
	waiting_for_choice_submit = false
	n_conversation_textbox.bbcode_text = ""
	n_animator.play("Static")
	for child in n_option_container.get_children():
		child.queue_free()

func _chose_option(marker):
	for child in n_option_container.get_children():
		child.queue_free()
	waiting_for_choice_submit = false
	n_conversation_textbox.bbcode_text = ""
	Storyteller.do_next(marker)
