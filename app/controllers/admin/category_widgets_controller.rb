class Admin::CategoryWidgetsController < Admin::ApplicationController
  before_action :set_category_widget, only: [:edit, :update, :destroy , :togglevisible]
  helper_method :apply_redirect

  def togglevisible
    @category_widget.toggle(:visible)
    @category_widget.save
  end
  def change_visible
    val = params[:invisible].presence ? false : true
    CategoryWidget.update_all({visible: val}, {id: params[:category_widget_ids]})
    redirect_to :back
  end

  def sort
    CategoryWidget.sort(params[:category_widget])
    render :nothing => true
  end

  def index
    @category_widgets = CategoryWidget.order(:position)
  end

  def new
    @category_widget = CategoryWidget.new
  end

  def create
    @category_widget = CategoryWidget.new(category_widget_params)
    if @category_widget.save
      notice = "#{CategoryWidget.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @category_widget.update(category_widget_params)
      notice = "#{CategoryWidget.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @category_widget.destroy
    redirect_to [:admin, :category_widgets], notice: "#{CategoryWidget.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @category_widget], notice: notice
      else
        redirect_to [:admin, :category_widgets], notice: notice
      end
    end

    def set_category_widget
      @category_widget = CategoryWidget.find(params[:id])
    end

    def category_widget_params
      params.require(:category_widget).permit(:category_id, :visible, :position)
    end
end