class Anticipation < Modecalcul

	alias :super_finDePeriodeAcquisition :finDePeriodeAcquisition

	def initialize(formulaire)
		super(formulaire)
	end

	def calculConges

		date_range = @debut_paiement_conges..@date_fin_acquisition

		@date_months = date_range.map {|d| Date.new(d.year, d.month) }.uniq
		@date_months.map {|d| d.strftime "%m-%Y" }

		@date_months.each do |month|
			mois_salaire = Mois_salaire.new
			mois_salaire.mois_label = month.strftime('%B %Y')
			mois_salaire.conges_paye = @montantConges
			mois_salaire.setTotal
			@tab_mois_salaire.push(mois_salaire)
		end

		@date_regularisation = @date_fin_acquisition >> 1
		mois_salaire = Mois_salaire.new
		mois_salaire.salaire = 0
		mois_salaire.mois_label = @date_regularisation.strftime('%B %Y')
		mois_salaire.conges_paye = @montantConges + regularisation
		mois_salaire.setTotal
		@tab_mois_salaire.push(mois_salaire)
	end

	def regularisation
		cumulConges = 0
		@tab_mois_salaire.each { |mois_salaire| cumulConges += mois_salaire.conges_paye }
		regularisationConges = @baseCalculConges - cumulConges
	end

	def setMontantConges
		@montantConges = @mois_salaire.salaire/10.to_f
	end

	def finDePeriodeAcquisition
		
		super_finDePeriodeAcquisition
		@debut_paiement_conges = @date_debut_acquisition
	end
end