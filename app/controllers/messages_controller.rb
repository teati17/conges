class MessagesController < ApplicationController

  def new
  	@message = Message.new
  end

  def create
  	@message = Message.new(form_params)
  	@mode = (params[:mode_paiement]).to_i

    if @message.valid?
    	case @mode
        when 1
          @conges = Finperiodeacquisition.new(@message)
        when 2
          @conges = Douzieme.new(@message) 
        when 3
          @conges = Anticipation.new(@message)
        else
          @conges = Finperiodeacquisition.new(@message)
      end
      @conges.calcul

    else
      flash[:danger] = "Le formulaire n'est pas valide"
      render :new
    end
  end


  private 

  def form_params
    params.require(:message).permit(:date_debut_contrat,:date_fin_contrat)
  end

end
