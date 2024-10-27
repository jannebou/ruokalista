extends VBoxContainer
class_name Lista

@export var header_b : Button
@export var lisätiedot_b : Button
@export var container : VBoxContainer
@export var lisätieto_l : RichTextLabel
@export var visibility_list : Array[Control]

var _ruoka : PackedScene = preload("res://scenet/ruoka.tscn")
var lisätiedot : Dictionary
var lista_auki : bool = true
var päivä : String

signal close_other()

func _ready() -> void:
	muuta_ruokalistan_näkyvyys()
		
	header_b.pressed.connect(
		func():
			muuta_ruokalistan_näkyvyys()
			close_other.emit(lisätiedot.date))
	
	lisätiedot_b.pressed.connect(näytä_lisätiedot)

func setup(lista : Dictionary, open : bool) -> void:
	päivä = lista.date
	header_b.text = "%s"  %  lista.date
	lisätiedot = lista
	
	kirjaa()
	
	if open:
		muuta_ruokalistan_näkyvyys()


func kirjaa() -> void:
	for course : String in lisätiedot.courses:
		var ruoka : Ruoka = _ruoka.instantiate()
		var category : String = ""
		var title : String = ""
		var diet : String = ""
		var hinta : String = ""
		var kieli : String = ""
		
		match Main.language:
			"FI":
				kieli = "title_fi"
			"EN":
				kieli = "title_en"
		
		title = lisätiedot.courses[course][kieli]
		hinta = lisätiedot.courses[course].price
		
		if lisätiedot.courses[course].has("category"):
			category = lisätiedot.courses[course].category
			
		if lisätiedot.courses[course].has("dietcodes"):
			diet = lisätiedot.courses[course].dietcodes

		container.add_child(ruoka)

		ruoka.aseta_data(title, hinta, diet, category)


func näytä_lisätiedot() -> void:
	if lisätieto_l.text != "":
		lisätieto_l.text = ""
	else:
		for i in lisätiedot.courses:
			if lisätiedot.courses[i].additionalDietInfo.has("allergens"):
				lisätieto_l.text += "[b]%s[/b]%s" % [lisätiedot.courses[i].title_fi, "\n"] 
				lisätieto_l.text += "	%s%s" %[lisätiedot.courses[i].additionalDietInfo.allergens, "\n"]


func muuta_ruokalistan_näkyvyys(s : int = -1) -> void:
	if header_b.is_inside_tree():
		header_b.release_focus()
	match s:
		-1: # TOGGLE
			for i : Control in visibility_list:
				i.visible = !i.visible
			lista_auki = !lista_auki
			
		0: # FALSE
			for i : Control in visibility_list:
				i.visible = false
			lista_auki = false
			
		1: # TRUE
			for i : Control in visibility_list:
				i.visible = true
			lista_auki = true
