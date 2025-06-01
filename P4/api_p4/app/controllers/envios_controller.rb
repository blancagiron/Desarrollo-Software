class EnviosController < ApplicationController
  before_action :set_envio, only: [:show, :update, :destroy]

  # GET /envios
  def index
    @envios = Envio.all
    render json: @envios
  end

  # GET /envios/1
  def show
    render json: @envio
  end

  # POST /envios
  def create
    @envio = Envio.new(envio_params)

    if @envio.save
      render json: @envio, status: :created
    else
      render json: @envio.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /envios/1
  def update
    if @envio.update(envio_params)
      render json: @envio
    else
      render json: @envio.errors, status: :unprocessable_entity
    end
  end

  # DELETE /envios/1
  def destroy
    @envio.destroy
    head :no_content
  end

  def reset
    Envio.delete_all
    render json: { message: 'Reset done' }, status: :ok
  end

  private

  def set_envio
    @envio = Envio.find(params[:id])
  end

  def envio_params
    params.require(:envio).permit(:direccion, :estado, :tipo, sillas: {})
  end
end
