class Finperiodeacquisition < Modecalcul

	alias :super_finDePeriodeAcquisition :finDePeriodeAcquisition

	def initialize(formulaire)
		super(formulaire)
	end

	#
	def calculConges

		date_range = @date_debut_acquisition..@date_fin_acquisition
		@date_months = date_range.map {|d| Date.new(d.year, d.month) }.uniq
		@date_months.map {|d| d.strftime "%m-%Y" }

		@date_debut_acquisition_temp = @date_debut_acquisition

		@date_months.each do |current_month|
			mois_salaire = Mois_salaire.new
			mois_salaire.mois_label = current_month.strftime('%B %Y')
			#Chaque mois de Mai ou à la fin du contrat, les congés sont payés	
			if current_month.month == 5 || current_month == @date_fin_acquisition
				calculBaseConges(@date_debut_acquisition_temp,current_month)
				mois_salaire.conges_paye = @montantConges 
				@date_debut_acquisition_temp = current_month >> 1
			end
			mois_salaire.setTotal
			@tab_mois_salaire.push(mois_salaire)
		end
	end

	def setMontantConges
		@montantConges = @baseCalculConges
	end

	#Calcul du montant total des congés sur la période allant de date_debut_acquisition à date_fin_acquisition
	def calculBaseConges(date_debut_acquisition,date_fin_acquisition)
		periode = (date_fin_acquisition.year*12 + date_fin_acquisition.month) - (date_debut_acquisition.year*12 + date_debut_acquisition.month) + 1
		base1 = (periode * @mois_salaire.salaire)/10.to_f
		base2 = periode *2.5*@indemnite_jour_conge
		@baseCalculConges = base1 > base2 ? base1 : base2
		setMontantConges
	end

	#Si la date de fin de contrat est renseignée alors la date de fin d'acquisition des congés est initialisée avec
	# sinon mois de Mai de l'année courant ou suivante 
	def finDePeriodeAcquisition
		
		if @formulaire.date_fin_contrat.blank? 
			super_finDePeriodeAcquisition
		else 
			@date_fin_acquisition = Date.strptime(@formulaire.date_fin_contrat,'%m-%Y')
		end
	end

end