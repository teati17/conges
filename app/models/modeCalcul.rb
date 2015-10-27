require 'Date'

class Modecalcul

	attr_reader :tab_mois_salaire

	def initialize(form)
		@formulaire = form
		@indemnite_jour_conge = 25
		@montantConges = 0
		@mois_salaire =  Mois_salaire.new
		@date_debut_acquisition = Date.strptime(@formulaire.date_debut_contrat,'%m-%Y')
		@tab_mois_salaire = []
	end

	#Design pattern : template method
	def calcul
		finDePeriodeAcquisition
		maxBaseConges
		setMontantConges
		calculConges
	end

	#Calcul le maximum entre =
	#- 10% des salaires versés sur la période
	#- prix unitaire d'un jour de congé x nombre de congés acquis
	def maxBaseConges
		periode = (@date_fin_acquisition.year*12 + @date_fin_acquisition.month) - (@date_debut_acquisition.year*12 + @date_debut_acquisition.month) + 1
		base1 = (periode * @mois_salaire.salaire)/10.to_f
		base2 = periode *2.5*@indemnite_jour_conge
		@baseCalculConges = base1 > base2 ? base1 : base2
	end

	#Détermine la date de fin de période d'acquisition 
	#Si le mois de Mai n'est pas passé alors la date de fin d'acquisition est initialisée à la même année
	#sinon au mois de Mai de l'année prochaine
	def finDePeriodeAcquisition
		if @date_debut_acquisition.month < 5
			@date_fin_acquisition = Date.strptime('05-' + (@date_debut_acquisition.year).to_s,'%m-%Y')
		else
			@date_fin_acquisition = Date.strptime('05-' + (@date_debut_acquisition.year+1).to_s,'%m-%Y')
		end
	end

end