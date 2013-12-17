class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  #
  def index
    # @members = Member.order(:last_name).load
    @members = Member.all
    respond_to do |format|
      format.html
      format.json { render json: MembersDatatable.new(view_context) }
      format.csv { send_data Member.to_csv }
      format.xls
    end
  end

  #
  def show
  end

  #
  def new
    @member = Member.new
  end

  #
  def edit
  end

  #
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: "Member was succussfully created." }
        format.json { render action: :show, status: :unprocessable_entity }
      else
        format.html { render action: :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  #
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: "Member was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  #
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url }
      format.json { head :no_content }
    end
  end

  #
  def import
    Member.import(params[:file])
    redirect_to members_path, notice: "Members imported!"
  end

  private

    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(
        :first_name, :middle_name, :last_name, :suffix, :occupation,
        :member_number, :address, :address_2, :city, :state, :zip, :country,
        :email, :phone, :phone_wk, :employer, :activity_code, :expiration_date,
        :longitude, :latitude, :senate_district_no, :senate_name, :senate_phone,
        :rep_district_no, :rep_name, :rep_phone
      )
    end
end
