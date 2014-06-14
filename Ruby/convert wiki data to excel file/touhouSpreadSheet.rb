
#============================================#
#  Voltorn touhou.wikia screen scrapper      #
#  how to use: (windows)                     #
#    Command line: ruby touhouSpreadSheet.rb #
#                                            #
#============================================#

require 'axlsx'    #gem install axlsx - for xls file
require 'nokogiri' #gem install nokogiri
require 'open-uri' #build-in

I_want_to_make_xls_file_with_this = true

NameListAry = [
#Main Characters
"Reimu_Hakurei",
"Marisa_Kirisame",
#Highly_Responsive_to_Prayers
"Shingyoku",
"YuugenMagan",
"Mima",
"Elis",
"Kikuri",
"Konngara",
"Sariel",
#Story_of_Eastern_Wonderland
"Genjii",
"Rika",
"Meira",
#Phantasmagoria_of_Dim._Dream
"Ellen",
"Kotohime",
"Kana_Anaberal",
"Rikako_Asakura",
"Chiyuri_Kitashirakawa",
"Yumemi_Okazaki",
"Ruukoto",
#Lotus_Land_Story
"Orange",
"Kurumi",
"Elly",
"Yuuka",
"Mugetsu",
"Gengetsu",
#Mystic_Square
"Sara",
"Louise",
"Alice",
"Yuki",
"Mai",
"Yumeko",
"Shinki",
#The_Embodiment_of_Scarlet_Devil
"Rumia",
"Daiyousei",
"Cirno",
"Hong_Meirin",
"Koakuma",
"Patchouli_Knowledge",
"Sakuya_Izayoi",
"Remilia_Scarlet",
"Flandre_Scarlet",
"Rin_Satsuki",
#Perfect_Cherry_Blossom
"Letty_Whiterock",
"Chen",
"Alice_Margatroid",
"Lily_White",
#"Prismriver_Sisters",
"Lunasa_Prismriver",
"Merlin_Prismriver",
"Lyrica_Prismriver",
"Youmu_Konpaku",
"Yuyuko_Saigyouji",
"Ran_Yakumo",
"Yukari_Yakumo",
#Immaterial_and_Missing_Power
"Suika_Ibuki",
#Imperishable_Night
"Wriggle_Nightbug",
"Mystia_Lorelei",
"Keine_Kamishirasawa",
"Tewi_Inaba",
"Reisen_Udongein_Inaba",
"Eirin_Yagokoro",
"Kaguya_Houraisan",
"Fujiwara_no_Mokou",
#Phantasmagoria_of_Flower_View
"Aya_Shameimaru",
"Medicine_Melancholy",
"Yuka_Kazami",
"Komachi_Onozuka",
"Shikieiki_Yamaxanadu",
#Mountain_of_Faith
"Shizuha_Aki",
"Minoriko_Aki",
"Hina_Kagiyama",
"Nitori_Kawashiro",
"Momiji_Inubashiri",
"Sanae_Kochiya",
"Kanako_Yasaka",
"Suwako_Moriya",
#Scarlet_Weather_Rhapsody
"Iku_Nagae",
"Tenshi_Hinanawi",
#Subterranean_Animism
"Kisume",
"Yamame_Kurodani",
"Parsee_Mizuhashi",
"Yuugi_Hoshiguma",
"Satori_Komeiji",
"Rin_Kaenbyou",
"Utsuho_Reiuji",
"Koishi_Komeiji",
#Undefined_Fantastic_Object
"Nazrin",
"Kogasa_Tatara",
"Ichirin_Kumoi",
"Unzan",
"Minamitsu_Murasa",
"Shou_Toramaru",
"Byakuren_Hijiri",
"Nue_Houjuu",
#Touhou_Hisotensoku
"Unnamed_Giant_Catfish",
#Double_Spoiler
"Hatate_Himekaidou",
#Fairy_Wars
"Sunny_Milk",
"Luna_Child",
"Star_Sapphire",
#Ten_Desires
"Kyouko_Kasodani",
"Yoshika_Miyako",
"Seiga_Kaku",
"Soga_no_Tojiko",
"Mononobe_no_Futo",
"Toyosatomimi_no_Miko",
"Mamizou_Futatsuiwa",
#Hopeless_Masquerade
"Hata_no_Kokoro",
#Double_Dealing_Character
"Wakasagihime",
"Sekibanki",
"Kagerou_Imaizumi",
"Benben_Tsukumo",
"Yatsuhashi_Tsukumo",
"Seija_Kijin",
"Shinmyoumaru_Sukuna",
"Raiko_Horikawa",
#Other_Characters
"Rinnosuke_Morichika",
"Tokiko",
"Renko_Usami",
"Maribel_Han", #Maribel_Hearn or Maribel_Han
"Hieda_no_Akyu",
"Shanghai",
"Hourai",
"Reisen",
"Watatsuki_no_Toyohime",
"Watatsuki_no_Yorihime",
"Kasen_Ibara",
"Kosuzu_Motoori"
]

GameListAry = [
"1", 
"2", 
"3", 
"4", 
"5", 
"6", 
"7", 
"7.5", 
"8", 
"9", 
"9.5", 
"10", 
"10.5", 
"11", 
"12", 
"12.3", 
"12.5", 
"12.8", 
"13", 
"13.5", 
"14", 
"14.3"
]

NameListHash = Hash.new
for i in NameListAry do NameListHash[i] = nil end
GameListHash = Hash.new
for i in GameListAry do GameListHash[i] = nil end

DuplicateNote = {
	"Lunasa_Prismriver" => 0,
	"Merlin_Prismriver" => 1,
	"Lyrica_Prismriver" => 2,
	"Sunny_Milk"        => 0,
	"Luna_Child"        => 1,
	"Star_Sapphire"     => 2
}

def separateIntoLines string
	unless string.nil?
	  counter = 0
	  string = string.chars.map do |char|
	    output_char = char
	    case char
	    when '('; output_char = "\n(" if counter == 0; counter += 1
	    when ')'; counter -= 1
	    when ','; output_char = "\n" if counter == 0
	    when ';'; output_char = "\n"
	    when '.'; output_char = "\n"
	    end
	    output_char
	  end.join
	  counter = nil
	  string.gsub! "\n ", "\n"
	end
  string
end

def proofreadName wb, name, string
	string
end

def proofreadSpecies wb, name, string
	return "N/A" if string == "Unknown"
	string
end

def proofreadAbilities wb, name, string
	return "N/A" if string == "Unknown"
	return string.lines.map(&:chomp)[DuplicateNote[name]].partition(': ').last if DuplicateNote.include? name
	return separateIntoLines string unless string.nil?
	string
end

def proofreadAge wb, name, string
	if string.match /\D+/
		if string == "Unknown"
			age  = "N/A"
			note = "N/A"
		else
			age  = string.gsub(',', '')[/\d+/]
			note = separateIntoLines string
		end
	else		
		age  = string
		note = "N/A"
	end
	age = "N/A" if age.nil?
	[age, note]
end

def proofreadOccupation wb, name, string
	return string.lines.map(&:chomp)[DuplicateNote[name]].partition(': ').last if DuplicateNote.include? name
	return "N/A" if string == "Unknown"
	return "N/A" if name == "Kisume"
	return separateIntoLines string unless string.nil?
	string
end

def proofreadLocation wb, name, string
	return "N/A" if string == "Unknown"
	return "Forest of Magic"                         if name == "Marisa_Kirisame"
	return "An island in Lake of Blood"              if name == "Kurumi"
	return "Forest near Human Village"               if name == "Mystia_Lorelei"
	return "Bamboo Forest of The Lost"               if name == "Fujiwara_no_Mokou"
	return "Sanzu River\nHell"                       if name == "Komachi_Onozuka"
	return "Muenzuka\nTemple of Myouren on occasion" if name == "Nazrin"
	string
end

def proofreadDescription wb, name, string
	string
end

def proofreadRelationships wb, name, string
	nameListDup = Hash.new
	for 

	string
end

def proofreadAppearances wb, name, string
	string
end

def proofreadTitles wb, name, string
	string
end

class ScreenScrapper

	attr_accessor :document
	attr_accessor :table
	attr_accessor :rows

	def initialize address
		self.document = Nokogiri::HTML(open(address))
		self.table = self.document.xpath("//table[@class='infobox']")[0]
		self.rows = self.table.css("tr")
	end

	def find string
		for i in 0...self.rows.length do
			if self.rows[i].css("td").length > 1
				if self.rows[i].css("td")[0].text.strip == string
					return self.rows[i].css("td")[1].text.strip
				end
			end if self.rows[i].css("td")
		end
		return "N/A"
	end

	def findInside string
		for i in 0...self.rows.length do
			if self.rows[i].css("table").length == 1
				if self.rows[i].css("td")[0].css("font").text.strip == string
					return self.rows[i].css("td")[0].css("tr")[1].text.strip
				end if self.rows[i].css("td")[0].css("font")
			end if self.rows[i].css("table")
		end
		return "N/A"
	end

end

excelFile = Axlsx::Package.new

excelFile.workbook.add_worksheet(:name => "..."          ) { |sheet| sheet.add_row ["Name", 
	                                                                                  "Species",
	                                                                                  "Abilities", 
	                                                                                  "Age",
	                                                                                  "Age Note", 
	                                                                                  "Occupation", 
	                                                                                  "Location"], :widths => [21, 28, 73, 5, 70, 30, 50] }
excelFile.workbook.add_worksheet(:name => "Description"  ) { |sheet| sheet.add_row  ["Name"] | GameListAry | ["Misc."] }
excelFile.workbook.add_worksheet(:name => "Relationships") { |sheet| sheet.add_row  ["Name"] | NameListAry.map {|i| i.gsub /_/, ' '} | ["Misc."] }
excelFile.workbook.add_worksheet(:name => "Appearances"  ) { |sheet| sheet.add_row  ["Name"] | GameListAry | ["Misc."] }
excelFile.workbook.add_worksheet(:name => "Titles"       ) { |sheet| sheet.add_row  ["Name"] | GameListAry | ["Misc."] }

for i in 0...NameListAry.length do

	page = ScreenScrapper.new "http://touhou.wikia.com/wiki/#{NameListAry[i]}"

	name          = NameListAry[i].gsub /_/, ' '
	species       = page.find       "Species"
	abilities     = page.find       "Abilities"
	age           = page.find       "Age"
	occupation    = page.find       "Occupation"
	location      = page.find       "Location"
	description   = page.findInside "Description"
	relationships = page.findInside "Relationships"
	appearances   = page.findInside "Appearances"
	titles        = page.findInside "Titles"

	#Proofreading
	name          = proofreadName          excelFile.workbook, NameListAry[i], name
	species       = proofreadSpecies       excelFile.workbook, NameListAry[i], species
	abilities     = proofreadAbilities     excelFile.workbook, NameListAry[i], abilities
	age, ageNote  = proofreadAge           excelFile.workbook, NameListAry[i], age
	occupation    = proofreadOccupation    excelFile.workbook, NameListAry[i], occupation
	location      = proofreadLocation      excelFile.workbook, NameListAry[i], location
	description   = proofreadDescription   excelFile.workbook, NameListAry[i], description
	relationships = proofreadRelationships excelFile.workbook, NameListAry[i], relationships
	appearances   = proofreadAppearances   excelFile.workbook, NameListAry[i], appearances
	titles        = proofreadTitles        excelFile.workbook, NameListAry[i], titles

	excelFile.workbook.sheet_by_name("..."          ).add_row [name, 
	                                                           species, 
	                                                           abilities,
	                                                           age,
	                                                           ageNote, 
	                                                           occupation, 
	                                                           location], :widths => [21, 28, 73, 5, 70, 30, 50]

	excelFile.workbook.sheet_by_name("Description"  ).add_row [name, description  ]
	excelFile.workbook.sheet_by_name("Relationships").add_row [name, relationships]
	excelFile.workbook.sheet_by_name("Appearances"  ).add_row [name, appearances  ]
	excelFile.workbook.sheet_by_name("Titles"       ).add_row [name, titles       ]

	p name
	p abilities
	p age
	p ageNote
	p occupation
	p location
	p description
	p relationships
	p appearances
	p titles

end

#Pane / Freeze / Frozen The Column and Row Headers
for i in ["...", "Description", "Relationships", "Appearances", "Titles"] do
	excelFile.workbook.sheet_by_name(i).sheet_view.pane do |pane|
		pane.top_left_cell = "B2"
		pane.state = :frozen_split
		pane.y_split = 1
		pane.x_split = 1
		pane.active_pane = :bottom_right
	end
end

excelFile.use_shared_strings = true
excelFile.serialize('touhouSpreadSheet.xlsx') if I_want_to_make_xls_file_with_this