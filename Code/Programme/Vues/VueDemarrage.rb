require './Vues/Vue'

#Vue chargée d'effectuer le lien entre le contrôleur et l'utilisateur lors de l'écran de connexion à son profil
class VueDemarrage < Vue
	
	@boutonAjouter
	@boutonConnecter
	@boutonSupprimer
	
	@comboBoxProfil
	@list_store
	
	@label
	
	attr_reader :boutonAjouter, :boutonConnecter, :boutonSupprimer, :comboBoxProfil
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele)
		
		#Cette box contient les deux lignes champs + bouton
		vbox = Gtk::VBox.new(false, 3)
		
		@label = Gtk::Label.new()
		
		#Ligne combobox + bouton connecter
		hbox1 = Gtk::HBox.new(false, 5)
		
		@boutonSupprimer = Gtk::Button.new("Supprimer", false)
		@boutonConnecter = Gtk::Button.new("Connecter", false)
		@boutonConnecter.set_size_request(100, -1)
		
		@list_store = Gtk::ListStore.new(String)
		
		@comboBoxProfil = Gtk::ComboBoxEntry.new(@list_store, 0)
		
		hbox1.pack_start(@boutonSupprimer, false, false, 0)
		hbox1.pack_start(@comboBoxProfil, true, true, 0)
		hbox1.pack_start(@boutonConnecter, false, false, 0)
		
		#Ligne textbox + bouton ajouter
		hbox2 = Gtk::HBox.new(false, 5)
		
		@boutonAjouter = Gtk::Button.new("Ajouter", false)
		
		hbox2.pack_start(@boutonAjouter, true, true, 0)
		
		vbox.pack_start(@label, false, false, 0)
		vbox.pack_start(hbox1, false, false, 0)
		vbox.pack_start(hbox2, false, false, 0)
		
		@window.add(vbox)
		
		actualiser
	end
	
	#Met à jour la comboBox à partir du modèle
	def actualiser
	
		super()
		
		@list_store.clear
		
		profils = @modele.listeProfils
		
		if !profils.empty? then
		
			profils.each{|x|

				iter = @list_store.append
				iter[0] = x
			}
		
			@comboBoxProfil.active = 0
			@boutonSupprimer.sensitive = true
			@boutonConnecter.sensitive = true
		else
		
			@boutonSupprimer.sensitive = false
			@boutonConnecter.sensitive = false
		end
		
		@window.show_all
	end
	
	#Retourne le profil situé dans la comboBox (sélection ou entrée utilisateur)
	def getProfil
	
		return @comboBoxProfil.active_text
	end
	
	#Retourne le profil situé dans la comboBox (sélection ou entrée utilisateur)
	def setProfil(unProfil)
		
		return unless iter = @list_store.iter_first
		
		begin

			if iter[0].eql?(unProfil) then
			
				@comboBoxProfil.set_active_iter(iter)
				return
			end
			
		end while iter.next!
	end
	
	#Écrit un message dans le label de la fenêtre
	def genererMessage(unMessage)
	
		@label.text = unMessage
	end
end
