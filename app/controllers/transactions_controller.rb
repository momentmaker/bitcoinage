class TransactionsController < ApplicationController
  before_action :authenticate!, except: [:index]
  def index
    @transactions = Transaction.order(updated_at: :desc)
    @chart_data = get_chart_data
    gon.chart_data = @chart_data
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)
    # binding.pry
    if @transaction.save
      redirect_to @transaction, notice: 'Your transaction has been submitted.'
    else
      render 'new'
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
    # @answers = Answer.find(:all)
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update(transaction_params)
      redirect_to @transaction
    else
      render :edit
    end
  end

  def destroy
    transaction.find(params[:id]).destroy
    redirect_to @transaction
  end

  def search
    query = "%#{params[:query]}%"
    @transactions = Transaction
      .where('title like ? or description like ?',
             query, query)
  end

  private
  def transaction_params
    params.require(:transaction).permit(:bitcoin, :price_dollar, :date, :fees, :wallet, :trans_hash)
  end

end
