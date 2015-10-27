class Douzieme < Modecalcul

	alias :super_finDePeriodeAcquisition :finDePeriodeAcquisition

	def initialize(formulaire)
		super(formulaire)
	end

	def calculConges

		date_range = @date_debut_acquisition..@date_fin_acquisition
		periode_fin_paiement_conges = @debut_paiement_conges >> 11 
		date_range_conges = @debut_paiement_conges..periode_fin_paiement_conges

		@date_months = date_range.map {|d| Date.new(d.year, d.month) }.uniq
		@date_months.map {|d| d.strftime "%m-%Y" }

		@date_months_conges = date_range_conges.map {|d| Date.new(d.year, d.month) }.uniq
		@date_months_conges.map {|d| d.strftime "%m-%Y" }

		@date_months.each do |month|
			mois_salaire = Mois_salaire.new
			mois_salaire.mois_label = month.strftime('%B %Y')	
			mois_salaire.setTotal
			@tab_mois_salaire.push(mois_salaire)
		end

		@date_months_conges.each do |month|
			mois_salaire = Mois_salaire.new
			mois_salaire.mois_label = month.strftime('%B %Y')
			mois_salaire.conges_paye = @montantConges	
			mois_salaire.setTotal
			@tab_mois_salaire.push(mois_salaire)
		end
	end

	def setMontantConges
		@montantConges = (@baseCalculConges/12.to_f).round(2)
	end

	def finDePeriodeAcquisition

		super_finDePeriodeAcquisition
		@debut_paiement_conges = @date_fin_acquisition >> 1
	end
end