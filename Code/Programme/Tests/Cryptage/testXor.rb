#encoding: UTF-8

$fichierBDD = "bdd.sqlite"

def xorerBdd(crypter)
    
	pass = "L3SPI2014isTheBestPromotion"
	
	tabPass = pass.split(//)
	
	#On crypte
	if crypter then
	
		entree = File.open($fichierBDD, "r")
		sortie = File.open($fichierBDD+".enc", "w")
	
	#On décrypte
	else
	
		sortie = File.open($fichierBDD, "w")
		entree = File.open($fichierBDD+".enc", "r")
	end
	
	i = 0
	entree.each_byte{|b|
		
		caractereEncodeur = tabPass[i]
		xored = b ^ caractereEncodeur.ord
		sortie.print(xored.chr)
		i += 1
		
		i = 0 if i.eql?(tabPass.size - 1)
	}
	
	entree.close
	sortie.close
end

xorerBdd(false)
