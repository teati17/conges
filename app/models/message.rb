class Message
	include ActiveModel::Model
	attr_accessor  :date_debut_contrat, :date_fin_contrat
	validates :date_debut_contrat, presence: true
end
