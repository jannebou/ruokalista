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
@export var scroll : ScrollContainer

var tänään_on : Dictionary
var valittu_puoli : String
static var language : String = "FI"

var ruokalista : Dictionary

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
			language = "EN"
			lang_b.text = "EN"
		else:
			language = "FI"
			lang_b.text = "FI"
			
		lang_b.release_focus()
		if ruokalista.is_empty():
			hae_ja_tee_lista(valittu_puoli)
		else:
			tyhjää_lista()
			tee_lista()
			)
			
	hae_ja_tee_lista(FRAMI)



## Haetaan data ja tehdään lista
func hae_ja_tee_lista(puoli : String) -> void:
	
	match puoli:
		FRAMI:
			frami_b.grab_focus()
			kampus_b.button_pressed = false
			valittu_puoli = FRAMI
		KAMPUS:
			kampus_b.grab_focus()
			frami_b.button_pressed = false
			valittu_puoli = KAMPUS
	
	
	tyhjää_lista()
	
	ruokalista = await hae_ruokalista(puoli) 
	
	# ruokalistan headeriin päivämäärä 
	header.text = "Ruokalista %s" % ruokalista.timeperiod
	
	tee_lista()
	
	
## tyhjätään lista
var auki_oleva_lista : String = ""
func tyhjää_lista() -> void:
	auki_oleva_lista = ""
	for i : Lista in get_tree().get_nodes_in_group("Lista"):
		if i.lista_auki:
			auki_oleva_lista = i.päivä
		i.queue_free()


func alusta_lista() -> Lista:
	var l : Lista = lista.instantiate()
	l.add_to_group("Lista")
	l.close_other.connect(sulje_listat)
	return l

## rakennetaan ruokalista
func tee_lista() -> void:
	var id : int = 0
	
	for päivän_lista in ruokalista.mealdates:
		
		var _ruokalista : Lista = alusta_lista()
		
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
	
	
## Suljetaan muut kuin auki jäävä lista§
func sulje_listat(auki_jäävä : String) -> void:
	for list : Lista in get_tree().get_nodes_in_group("Lista"):
		if list.päivä == auki_jäävä:
			await get_tree().physics_frame
			scroll.ensure_control_visible(list)
		else:	
			list.muuta_ruokalistan_näkyvyys(0)
	
## haetaan ruokalista sodexon palvelimelta
var vastaus : Dictionary
func hae_ruokalista(url : String) -> Dictionary:
	haetaan_l.show()
	var http : HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(
			func(_result : int, _response_code : int, _headers : PackedStringArray, body : PackedByteArray) -> void:
				vastaus = JSON.parse_string(body.get_string_from_utf8())
				)
	http.request(url)
	await http.request_completed
	http.queue_free()
	haetaan_l.hide()
	return vastaus
