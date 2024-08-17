extends Node

var data = ''
var newdata = ''

# change to this when buliding to android:  '/storage/emulated/0/prayerTime'
# change to this when building to windows: 'res://'
var mainDir = 'res://'

var monke = JSON.new()

@onready var childeren = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children()

var thingsported = ''

var eson = Eson.new()

# edit page variables:
@onready var add_mosque_page = $addMosquePage

@onready var mosque_edit_page = $mosqueEditPage
@onready var mosque_name_label = $mosqueEditPage/MarginContainer/VBoxContainer/VBoxContainer/mosqueNameLabel
@onready var arabic_name_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer2/ArabicNameTextEdit
@onready var block_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer3/BlockTextEdit

@onready var lon_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer4/LonTextEdit
@onready var lat_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer4/LatTextEdit

@onready var fajr_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer5/FajrIqamaTextEdit
@onready var dhuhr_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer6/DhuhrIqamaTextEdit
@onready var asr_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer7/AsrIqamaTextEdit
@onready var maghrib_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer8/MaghribIqamaTextEdit
@onready var isha_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer9/IshaIqamaTextEdit

@onready var edit_date_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer10/EditDateTextEdit

@onready var save_button = $mosqueEditPage/MarginContainer/VBoxContainer/saveButton
@onready var back_button = $mosqueEditPage/MarginContainer/VBoxContainer/backButton

@onready var amount_label = $amountLabel

func _ready():
	if FileAccess.file_exists(mainDir + "/mosquePlaces.json"):
		var file = FileAccess.open(mainDir + "/mosquePlaces.json", FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
	elif !FileAccess.file_exists(mainDir + "/mosquePlaces.json"):
		print('not here bro data')
		
	if FileAccess.file_exists(mainDir + "/newMosquePlaces.json"):
		var newFile = FileAccess.open(mainDir + "/newMosquePlaces.json", FileAccess.READ)
		newdata = JSON.parse_string(newFile.get_as_text())
	elif !FileAccess.file_exists(mainDir + "/newMosquePlaces.json"):
		print('not here bro newdata')
		save()
	buttongen()

	amount_label.text = str(newdata.size()) + '/' + str(data.size())
	print(typeof(data))
# this generates the buttons from the json file.
func buttongen():
	for things in data:
		#print(things)
		
		var button = Button.new()
		button.text = str(things) + ' | block:' + str(data[things]['block'])
		button.tooltip_text = str(things) + ' | block:' + str(data[things]['block'])
		#button.add_theme_font_size_override("font_size", 50)
		button.clip_text = true
		button.text_overrun_behavior = 3
		button.mouse_filter = 1
		if things in newdata:
			button.set_self_modulate(Color('00fa95'))

		
		button.pressed.connect(_button_action.bind(things))

		$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.add_child(button)

		childeren = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children()
	


func save():
	
	
	arabic_name_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer2/ArabicNameTextEdit
	block_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer3/BlockTextEdit
	lon_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer4/LonTextEdit
	lat_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer4/LatTextEdit
	fajr_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer5/FajrIqamaTextEdit
	dhuhr_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer6/DhuhrIqamaTextEdit
	asr_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer7/AsrIqamaTextEdit
	maghrib_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer8/MaghribIqamaTextEdit
	isha_iqama_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer9/IshaIqamaTextEdit
	edit_date_text_edit = $mosqueEditPage/MarginContainer/VBoxContainer/HBoxContainer10/EditDateTextEdit

	eson.load_json(mainDir + '/newMosquePlaces.json')
	
	eson.set_value(
		thingsported, 
			{'arabicName': arabic_name_text_edit.text, 
			'block': int(block_text_edit.text), 
			"location": {"lon": float(lon_text_edit.text), "lat": float(lat_text_edit.text)}, 
			"fajrIqama": int(fajr_iqama_text_edit.text),
			"dhuhrIqama": int(dhuhr_iqama_text_edit.text),
			"asrIqama": int(asr_iqama_text_edit.text),
			"maghribIqama": int(maghrib_iqama_text_edit.text),
			"ishaIqama": int(isha_iqama_text_edit.text),
			"editDate": edit_date_text_edit.text
			})
		
	
	eson.save_json(mainDir + '/newMosquePlaces.json')
	

# Mosque Button clicked:
func _button_action(things):
	if things not in newdata:
		print('data: ' + str(data[things]))
		mosque_name_label.text = things
		arabic_name_text_edit.text = data[things]['arabicName']
		
		block_text_edit.text = str(data[things]['block'])
		lon_text_edit.text = str(data[things]['location']['lon'])
		lat_text_edit.text = str(data[things]['location']['lat'])
		fajr_iqama_text_edit.text = str(data[things]['fajrIqama'])
		dhuhr_iqama_text_edit.text = str(data[things]['dhuhrIqama'])
		asr_iqama_text_edit.text = str(data[things]['asrIqama'])
		maghrib_iqama_text_edit.text = str(data[things]['maghribIqama'])
		isha_iqama_text_edit.text = str(data[things]['ishaIqama'])
		edit_date_text_edit.text = data[things]['editDate']
	elif things in newdata:
		print('newdata: ' + str(newdata[things]))
		mosque_name_label.text = things
		arabic_name_text_edit.text = newdata[things]['arabicName']
		
		block_text_edit.text = str(newdata[things]['block'])
		lon_text_edit.text = str(newdata[things]['location']['lon'])
		lat_text_edit.text = str(newdata[things]['location']['lat'])
		fajr_iqama_text_edit.text = str(newdata[things]['fajrIqama'])
		dhuhr_iqama_text_edit.text = str(newdata[things]['dhuhrIqama'])
		asr_iqama_text_edit.text = str(newdata[things]['asrIqama'])
		maghrib_iqama_text_edit.text = str(newdata[things]['maghribIqama'])
		isha_iqama_text_edit.text = str(newdata[things]['ishaIqama'])
		edit_date_text_edit.text = newdata[things]['editDate']
		
	thingsported = things
	
	mosque_edit_page.visible = true

func _on_save_button_pressed():
	save()
	get_tree().reload_current_scene()
	

func _on_back_button_pressed():
	mosque_edit_page.visible = false
	add_mosque_page.visible = false


var matches = []
@onready var text_edit = $MarginContainer/VBoxContainer/TextEdit

# search bar
func _on_text_edit_text_changed():
	var searchbar = text_edit.text
	searchbar = searchbar.to_lower()
	
	print(searchbar)
	if searchbar == '':
		for i in childeren:
			i.show()
		return
	matches.clear()
	for i in childeren:
		if searchbar in i.text.to_lower():
			matches.append(i)
	for i in childeren:
		if i in matches:
			i.show()
		else:
			i.hide()




@onready var add_mosque_name = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer3/AddMosqueName
@onready var add_arabic_name_text_edit = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer2/AddArabicNameTextEdit
@onready var add_block_text_edit = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer5/AddBlockTextEdit
@onready var add_loc_text_edit = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer4/AddLocTextEdit
@onready var add_edit_date_text_edit = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer10/AddEditDateTextEdit
@onready var error_label = $addMosquePage/MarginContainer/VBoxContainer/ErrorLabel


func _on_add_button_pressed():
	
	add_mosque_name = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer3/AddMosqueName
	add_arabic_name_text_edit = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer2/AddArabicNameTextEdit
	add_block_text_edit = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer5/AddBlockTextEdit
	add_loc_text_edit = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer4/AddLocTextEdit
	var locationSplitCoords: PackedStringArray = add_loc_text_edit.text.split(',')
	
	add_edit_date_text_edit = $addMosquePage/MarginContainer/VBoxContainer/HBoxContainer10/AddEditDateTextEdit
#
	
	
	if add_mosque_name.text not in data:
		if locationSplitCoords.size() == 2:
			eson.load_json(mainDir + '/mosquePlaces.json')
			
			eson.set_value(
				add_mosque_name.text, 
					{'arabicName': add_arabic_name_text_edit.text, 
					'block': int(add_block_text_edit.text), 
					"location": {"lon": float(locationSplitCoords[1].replace(" ", "")), "lat": float(locationSplitCoords[0].replace(" ", ""))}, 
					"fajrIqama": 0,
					"dhuhrIqama": 0,
					"asrIqama": 0,
					"maghribIqama": 0,
					"ishaIqama": 0,
					"editDate": add_edit_date_text_edit.text
					})
			
			eson.save_json(mainDir + '/mosquePlaces.json')
			get_tree().reload_current_scene()
		else:
			error_label.text = 'invaild coords, try: Latitude, Longitude'
			print('bro coords wong')
	else:
		error_label.text = 'mosque name is taken'
		print('name in data bro')


func _on_button_pressed():
	add_mosque_page.visible = true
