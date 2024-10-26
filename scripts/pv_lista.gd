extends VBoxContainer
class_name Lista

@export var header_b : Button
@export var lisätiedot_b : Button

@export var visibility_list : Array[Control]

@export var pääruoka_l : Label
@export var pääruoka_diet_l : Label
@export var vegaani_l : Label
@export var vegaani_diet_l : Label
@export var keitto_l : Label
@export var keitto_diet_l : Label
@export var patonki_l : Label
@export var patonki_diet_l : Label
@export var jälkiruoka_l : Label
@export var jälkiruoka_diet_l : Label
@export var lisätieto_l : RichTextLabel
@export var hinta_l : Label

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
	
	hinta_l.text = lista.courses["2"].price
	
	lisätiedot = lista
	
	match Main.language:
		"FI":
			if lista.courses.has("1"):
				vegaani_l.set_text(lista.courses["1"].title_fi)
				if lista.courses["1"].dietcodes != "":
					vegaani_diet_l.show()
					vegaani_diet_l.text = lista.courses["1"].dietcodes
				
				
			if lista.courses.has("2"):
				pääruoka_l.set_text(lista.courses["2"].title_fi)
				if lista.courses["2"].dietcodes != "":
					pääruoka_diet_l.show()
					pääruoka_diet_l.text = lista.courses["2"].dietcodes
				

			if lista.courses.has("3"):
				keitto_l.set_text(lista.courses["3"].title_fi)
				if lista.courses["3"].dietcodes != "":
					keitto_diet_l.show()
					keitto_diet_l.text = lista.courses["3"].dietcodes
			
			if lista.courses.has("4"):
				patonki_l.set_text(lista.courses["4"].title_fi)
				if lista.courses["4"].dietcodes != "":
					patonki_diet_l.show()
					patonki_diet_l.text = lista.courses["4"].dietcodes
				
			if lista.courses.has("5"):
				jälkiruoka_l.set_text(lista.courses["5"].title_fi)
				if lista.courses["5"].dietcodes != "":
					jälkiruoka_diet_l.show()
					jälkiruoka_diet_l.text = lista.courses["5"].dietcodes
			
			# jos listasta löytyy "6", on kampus valittuna
			if lista.courses.has("6"):
				patonki_l.set_text(lista.courses["5"].title_fi)
				if lista.courses["5"].dietcodes != "":
					patonki_diet_l.show()
					patonki_diet_l.text = lista.courses["5"].dietcodes
					
				jälkiruoka_l.set_text(lista.courses["6"].title_fi)
				if lista.courses["6"].dietcodes != "":
					jälkiruoka_diet_l.show()
					jälkiruoka_diet_l.text = lista.courses["6"].dietcodes
					
		"EN":
			if lista.courses.has("1"):
				vegaani_l.set_text(lista.courses["1"].title_en)
			if lista.courses["1"].dietcodes != "":
					vegaani_diet_l.show()
					vegaani_diet_l.text = lista.courses["1"].dietcodes
				
				
			if lista.courses.has("2"):
				pääruoka_l.set_text(lista.courses["2"].title_en)
				if lista.courses["2"].dietcodes != "":
					pääruoka_diet_l.show()
					pääruoka_diet_l.text = lista.courses["2"].dietcodes
				

			if lista.courses.has("3"):
				keitto_l.set_text(lista.courses["3"].title_en)
				if lista.courses["3"].dietcodes != "":
					keitto_diet_l.show()
					keitto_diet_l.text = lista.courses["3"].dietcodes
			
			if lista.courses.has("4"):
				patonki_l.set_text(lista.courses["4"].title_en)
				if lista.courses["4"].dietcodes != "":
					patonki_diet_l.show()
					patonki_diet_l.text = lista.courses["4"].dietcodes
				
			if lista.courses.has("5"):
				jälkiruoka_l.set_text(lista.courses["5"].title_en)
				if lista.courses["5"].dietcodes != "":
					jälkiruoka_diet_l.show()
					jälkiruoka_diet_l.text = lista.courses["5"].dietcodes
			
			# jos listasta löytyy "6", on kampus valittuna
			if lista.courses.has("6"):
				patonki_l.set_text(lista.courses["5"].title_en)
				if lista.courses["5"].dietcodes != "":
					patonki_diet_l.show()
					patonki_diet_l.text = lista.courses["5"].dietcodes
					
				jälkiruoka_l.set_text(lista.courses["6"].title_en)
				if lista.courses["6"].dietcodes != "":
					jälkiruoka_diet_l.show()
					jälkiruoka_diet_l.text = lista.courses["6"].dietcodes

	if open:
		muuta_ruokalistan_näkyvyys()
	
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
