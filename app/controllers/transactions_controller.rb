class TransactionsController < ApplicationController
  before_action :authenticate!

  def index
    @transactions = Transaction.where(user_id: current_user.id).order(:date)
    @transactions_buy = Transaction.where('user_id = ? AND satoshi > ?', current_user.id, 0).order(:date)
    @transactions_sell = Transaction.where('user_id = ? AND satoshi < ?', current_user.id, 0).order(:date)
    @buy_data = all_transaction_data(@transactions_buy)
    @sell_data = all_transaction_data(@transactions_sell)
    @chart_data = all_chart_data
    gon.buy_data = @buy_data
    gon.sell_data = @sell_data
    gon.chart_data = @chart_data
  end

  def show
    @transaction = Transaction.find(params[:id])
    if same_user?(@transaction)
      if @transaction.buy?
        @buy_data = select_transaction_data(@transaction)
        gon.buy_data = @buy_data
      else
        @sell_data = select_transaction_data(@transaction)
        gon.sell_data = @sell_data
      end
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
    @transaction.type = @transaction.find_type
    respond_to do |format|
      if @transaction.update_attributes(transaction_params)
        format.html { redirect_to(@transaction, :notice => 'Your transaction was updated.') }
        format.json { respond_with_bip(@transaction) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@transaction) }
      end
    end
  end

  def destroy
    Transaction.find(params[:id]).destroy
    redirect_to transactions_path
  end

  private
  def transaction_params
    params.require(:transaction).permit(:type, :bitcoin, :price_dollar, :date, :fees, :wallet, :trans_hash)
  end
end
