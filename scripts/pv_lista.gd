extends VBoxContainer
class_name Lista

@export var header_b : Button
@export var lisätiedot_b : Button

@export var visibility_list : Array[Control]

@export var pääruoka_l : Label
@export var vegaani_l : Label
@export var keitto_l : Label
@export var patonki_l : Label
@export var jälkiruoka_l : Label
@export var lisätieto_l : RichTextLabel

var lisätiedot : Dictionary

func _ready() -> void:
	muuta_ruokalistan_näkyvyys()
		
	header_b.pressed.connect(muuta_ruokalistan_näkyvyys)
	
	lisätiedot_b.pressed.connect(näytä_lisätiedot)

func setup(lista : Dictionary, open : bool) -> void:
	#TODO onko frami vai kampus
	#header_b.text = "%s \n %s" %  [lista.date, lista.courses["2"].price]
	header_b.text = "%s"  %  lista.date
	
	lisätiedot = lista
	
	match Settings.language:
		"FI":
			if lista.courses.has("1"):
				vegaani_l.set_text(lista.courses["1"].title_fi)
				
			if lista.courses.has("2"):
				pääruoka_l.set_text(lista.courses["2"].title_fi)

			if lista.courses.has("3"):
				keitto_l.set_text(lista.courses["3"].title_fi)
			
			if lista.courses.has("4"):
				patonki_l.set_text(lista.courses["4"].title_fi)
				
			if lista.courses.has("5"):
				jälkiruoka_l.set_text(lista.courses["5"].title_fi)
			
				

		"EN":
			if lista.courses.has("1"):
				vegaani_l.set_text(lista.courses["1"].title_en)
				
			if lista.courses.has("2"):
				pääruoka_l.set_text(lista.courses["2"].title_en)

			if lista.courses.has("3"):
				keitto_l.set_text(lista.courses["3"].title_en)
				
			if lista.courses.has("4"):
				patonki_l.set_text(lista.courses["4"].title_en)
				
			if lista.courses.has("5"):
				jälkiruoka_l.set_text(lista.courses["5"].title_en)
			
	if open:
		muuta_ruokalistan_näkyvyys()
	
func näytä_lisätiedot() -> void:
	if lisätieto_l.text != "":
		lisätieto_l.text = ""
	else:
		for i in lisätiedot.courses:
			if lisätiedot.courses[i].additionalDietInfo.has("allergens"):
				lisätieto_l.text += "[b]"+lisätiedot.courses[i].title_fi+"[/b]" + "\n"
				lisätieto_l.text += lisätiedot.courses[i].additionalDietInfo.allergens+"\n"



	
func muuta_ruokalistan_näkyvyys() -> void:
	if header_b.is_inside_tree():
		header_b.release_focus()
		
	for i : Control in visibility_list:
		i.visible = !i.visible
	
