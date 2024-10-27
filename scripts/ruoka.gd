extends MarginContainer
class_name Ruoka

@export var title_l : Label
@export var ruoka_l : Label 
@export var dietti_l : Label
@export var hinta_l : Label


func aseta_data(ruoka_nimi : String, hinta : String, allergeenit : String, title : String) -> void:
	ruoka_l.text = ruoka_nimi
	hinta_l.text = hinta
	title_l.text = title
	dietti_l.text = allergeenit
	
