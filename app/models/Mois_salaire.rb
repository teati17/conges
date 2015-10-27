class Mois_salaire

	attr_accessor :mois_label, :conges_paye, :salaire
	attr_reader :total

	def initialize
		@salaire = 600
		@conges_paye = 0
	end

	def setTotal
		@total = @salaire + @conges_paye
	end

end