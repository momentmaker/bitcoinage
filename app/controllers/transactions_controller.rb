class TransactionsController < ApplicationController
  before_action :authenticate!
  def index
    @transactions = Transaction.where(user_id: current_user.id)
    @chart_data = all_chart_data
    gon.chart_data = @chart_data
  end

  def show
    @transaction = Transaction.find(params[:id])
    if same_user?(@transaction)
      @chart_data = select_chart_data(@transaction)
      gon.chart_data = @chart_data
    else
      redirect_to root_path, alert: 'This transaction is not yours!'
    end
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)
    if @transaction.save
      redirect_to transaction_path(@transaction), notice: 'Your transaction has been submitted.'
    else
      render 'new'
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update(transaction_params)
      redirect_to transactions_path
    else
      render :edit
    end
  end

  def destroy
    Transaction.find(params[:id]).destroy
    redirect_to transactions_path
  end

  def search
    query = "%#{params[:query]}%"
    @transactions = Transaction
      .where('title like ? or description like ?',
             query, query)
  end

  private
  def transaction_params
    params.require(:transaction).permit(:type, :bitcoin, :price_dollar, :date, :fees, :wallet, :trans_hash)
  end
end
