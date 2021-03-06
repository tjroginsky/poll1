class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :create, :new, :edit, :update]
  #before_action :logged_in_user

  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.paginate(page: params[:page], :per_page => 10)
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
  end

  # GET /polls/new
  def new
    @poll = Poll.new
    @poll.questions.build.answerchoices.build
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  # POST /polls.json
  def create
    puts "polls_create START"
    @poll = Poll.new(poll_params)
    puts @poll.inspect
    puts @poll.questions.inspect

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
    puts "polls_create END"
  end

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll.destroy
    respond_to do |format|
      format.html { redirect_to polls_url, notice: 'Poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def pvote
    puts "pvote START"
    puts params
    puts params[:poll][:user_id]
    @poll = Poll.find(params[:id])
    if params[:choices]
      params[:choices].each do |key, value| 
        puts "creating userchoice with user_id #{params[:poll][:user_id]} and answerchoice_id #{value}"
        @userchoice = Userchoice.new({"answerchoice_id"=>value, "user_id"=>params[:poll][:user_id]})
        if @userchoice.save
          puts "success!"
          #format.json { render :show, status: :ok, location: @poll }
        end
      end
      redirect_to @poll, notice: 'Thank you for voting!'
    else
      redirect_to @poll, notice: "You didn't select any choices!"
    end
    puts "pvote END"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:poll).permit(:id, :title, :user_id, :questions_attributes => [:id, :text, :_destroy, :answerchoices_attributes => [:id, :content, :_destroy]])
    end
end
