extends Control
class_name Main

const FRAMI : String = "https://www.sodexo.fi/ruokalistat/output/weekly_json/108"
const KAMPUS : String = "https://www.sodexo.fi/ruokalistat/output/weekly_json/109"

@export var header : Label 
@export var lista : PackedScene
@export var ruokalista_container : VBoxContainer
@export var haetaan_l : Label
@export var frami_b : Button
@export var kampus_b : Button
@export var lang_b : Button

#var ruokalista : Dictionary
var tänään_on : Dictionary

var viikonpäivät : Array[String] = [
	"Maanantai",
	"Tiistai",
	"Keskiviikko",
	"Torstai",
	"Perjantai",
	"Lauantai",
	"Sunnuntai"
]


func _ready() -> void:
	tänään_on = Time.get_datetime_dict_from_system()
	
	frami_b.button_pressed = true
	
	frami_b.pressed.connect(hae_ja_tee_lista.bind(FRAMI))
	kampus_b.pressed.connect(hae_ja_tee_lista.bind(KAMPUS))
	lang_b.pressed.connect(func() -> void:
		if lang_b.text == "FI":
			Settings.language = "EN"
			lang_b.text = "EN"
		else:
			Settings.language = "FI"
			lang_b.text = "FI"
			
		hae_ja_tee_lista(FRAMI)
			)
	
	hae_ja_tee_lista(FRAMI)


	
func hae_ja_tee_lista(puoli : String) -> void:
	match puoli:
		FRAMI:
			kampus_b.button_pressed = false
		KAMPUS:
			frami_b.button_pressed = false
			
	tyhjää_lista()
	
	haetaan_l.show()
	var ruokalista : Dictionary = await hae_ruokalista(puoli) 
	haetaan_l.hide()
	
	header.text = "Ruokalista %s" % ruokalista.timeperiod
	
	tee_lista(ruokalista)

func tyhjää_lista() -> void:
	for i : Control in get_tree().get_nodes_in_group("Lista"):
		i.queue_free()


func tee_lista(ruokalista : Dictionary) -> void:
	var id : int = 0
	for päivän_lista in ruokalista.mealdates:
		var _ruokalista : Lista = lista.instantiate()

		
		#listan nimi, helpottaa debug
		_ruokalista.add_to_group("Lista")
		_ruokalista.name = päivän_lista.date
		
		# Avataan tämän päivän lista 
		if päivän_lista.date == viikonpäivät[tänään_on.weekday - 1]:
			_ruokalista.setup(päivän_lista, true)
		else:
			_ruokalista.setup(päivän_lista, false)
		
		#lisätään ja siirretään listaa
		ruokalista_container.add_child(_ruokalista)
		ruokalista_container.move_child(_ruokalista, id)

		id += 1
	


var vastaus : Dictionary
func hae_ruokalista(url : String) -> Dictionary:
	var http : HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(
			func(_result : int, _response_code : int, _headers : PackedStringArray, body : PackedByteArray) -> void:
				vastaus = JSON.parse_string(body.get_string_from_utf8())
				)
	http.request(url)
	await http.request_completed
	http.queue_free()
	return vastaus
